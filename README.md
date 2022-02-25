# Gravity simulation demo

Proof of concept newtonian gravity simulator using godot's physics engine. You can control a little ship in a 2D simulation.
![img1](https://user-images.githubusercontent.com/24435787/155674374-ced450c9-13d0-45a7-98cf-1d51231ee382.png)
![img2](https://user-images.githubusercontent.com/24435787/155674388-53656ad4-1e96-46a6-bfb4-630eabc696d9.png)
![img3](https://user-images.githubusercontent.com/24435787/155674393-6b748d9a-dabe-42db-976e-f075c693a521.png)


## Playing

#### Ship controls

* Left/Right arrow to spin the ship
* Up/Down to accelerate and decelerate
* You can control the simulation speed, display vectors paths with the controls on the HUD
* backspace resets the level

#### Camera controls

* Numpad arrows to detach frmo the ship and move the camera around: 2 6 4 8
* '+' to zoom in
* '-' to zoom out
* = resets zoom
* 5 Goes back to the ship


## TODO

- [ ] Find a better way to slow down the simulation
- [ ] Fix body colisions instead of orbiting
- [ ] Fix paralax background fading and weirdness
- [ ] Add animations for jets
