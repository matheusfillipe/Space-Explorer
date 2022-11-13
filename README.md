[![Cloudflare Pages](https://img.shields.io/endpoint?url=https://cloudflare-pages-badges.mattf.workers.dev//?projectName=space-explorer)](https://space-explorer.pages.dev/)

# Gravity simulation demo

Proof of concept newtonian gravity simulator using godot's physics engine. You can control a little ship in a 2D simulation.
![image](https://user-images.githubusercontent.com/24435787/155859663-9145b4fb-49c1-41d9-9a1e-4bbebc2ec8ba.png)
![image](https://user-images.githubusercontent.com/24435787/155859681-13d97b31-9d1f-4b55-a5a5-474d9369fe64.png)
![image](https://user-images.githubusercontent.com/24435787/155859795-79f86775-3103-4981-804f-ea1106b0a4c9.png)
![Screenshot_20220227_033734](https://user-images.githubusercontent.com/24435787/155871498-7950d316-cb8d-46c0-a153-5ff0935ef996.png)

Live demo at: https://space-explorer.pages.dev/

The desktop version looks much prettier though due to lossy texture compression required to run this on the web.

## Playing

#### Ship controls

* Left/Right arrow to spin the ship
* Up/Down to accelerate and decelerate
* You can control the simulation speed, display vectors paths with the controls on the HUD
* Spacebar pause
* backspace resets the level

You can use the numbers (not numpad ones) to set the simulation speed.

#### Camera controls

* Numpad arrows to detach from the ship and move the camera around: 2 6 4 8
* '+' to zoom in
* '-' to zoom out
* = resets zoom
* 0 Goes back to the tracked object
* '/' to track back to the player

You can also control the camera with mouse dragging and scroll wheel for zooming.

By hovering on stars you can see their information and if you click you will start tracking them.

## TODO

- [ ] Find a better way to slow down the simulation
- [ ] Fix body colisions instead of orbiting
- [ ] Fix paralax background when zooming out
- [x] Add animations for flames
- [x] Control camera with mouse
- [x] Add refuel
- [ ] Add levels!

## FUTURE IDEAS

- [ ] godot gravity sim - 10 [0/3]
  - [ ] giant stars have a life to explode or not
  - [ ] Fuel consuming ballistics (explode stars and get random fuel proportional to their mass?) ??
  - [ ] Start menu [0/3]
    - [ ] Sandbox level [0/3]
      - [ ] right click to add start
      - [ ] Little star props menu
      - [ ] Show vectors while editing
    - [ ] Random generated level [0/1]
      - [ ] ??
    - [ ] Build win and linux releases

