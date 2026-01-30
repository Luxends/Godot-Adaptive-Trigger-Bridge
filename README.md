This project implements a bridge for DualSense Adaptive Triggers, connecting the Godot Game Engine with John "Nielk1" Klein's TriggerEffectGenerator.cs(https://gist.github.com/Nielk1/6d54cc2c00d2201ccb8c2720ad7538db).

### Real-World Implementation
The file `AdaptiveTriggerDemo.gd`(./AdaptiveTriggerDemo.gd) demonstrates a production-ready usage pattern, including **software hysteresis** to filter haptic noise and **state-check optimization** to reduce USB bus traffic.

See the demo script in action GIF below:

![0130](https://github.com/user-attachments/assets/93c1d3ce-5fa1-4981-8acd-563dfd3f7d36)
