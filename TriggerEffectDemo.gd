extends Node

@onready var rich_text_label_right: RichTextLabel = $RichTextLabelRight
var Custom_Weapon: Callable

# State Management variables
var is_machine_active: bool = false
var _last_sent_state: int = -1 

func _ready() -> void:
	# Pre-configure the "Weapon" effect (resistance) for reuse
	Custom_Weapon = Trigger.Weapon.bind(2, 3, 8)
	
	# Apply initial state on start
	_apply_effect(false) 

func _process(delta: float) -> void:
	# Map input strength from 0.0-1.0 to 0-8 range for DualSense
	var strength = Input.get_action_strength("l2") * 8
	rich_text_label_right.text = str(strength)

	# --- HYSTERESIS IMPLEMENTATION ---
	# We use a safety gap (buffer) between activation (>= 3) and deactivation (<= 2).
	# Why? When the "Machine" effect activates, the trigger physically vibrates.
	# Without this 1-unit buffer, the vibration itself could shake the player's finger
	# just enough to drop the value below the threshold, causing rapid flickering 
	# between states (flapping) and unstable hardware behavior.
	if not is_machine_active and strength >= 3:
		is_machine_active = true
	elif is_machine_active and strength <= 2:
		is_machine_active = false

	# --- PERFORMANCE OPTIMIZATION ---
	# Convert bool to int for state tracking (0: Weapon, 1: Machine)
	var current_target_state = 1 if is_machine_active else 0
	
	# Only send data to the USB controller if the state has ACTUALLY changed.
	# Sending HID commands every frame (60fps) is redundant and can clog the I/O bus.
	if _last_sent_state != current_target_state:
		_apply_effect(is_machine_active)
		_last_sent_state = current_target_state

func _apply_effect(machine_mode: bool) -> void:
	if machine_mode:
		# Apply machine gun recoil effect (vibration)
		# startPosition ∈ [0, 8], endPosition ∈ [startPosition, 9], amplitudeA, amplitudeB ∈ [0, 7], frequency ∈ [1, 16]  it’s recommended not to exceed 16 too much for frequency.
		Trigger.Machine("l", 1, 9, 7, 7, 5, 0)
		print("DEBUG: DualSense Mode Switched -> MACHINE")
	else:
		# Revert to standard weapon resistance
		Custom_Weapon.call("l")
		print("DEBUG: DualSense Mode Switched -> WEAPON")
