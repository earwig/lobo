;; lobo: Logo Bolo
;; (c) Ben Kurtovic, 2011
;;
;; Logo Bolo is a re-envisioning of the classic tank game by Stuart Cheshire in NetLogo.
;;

;; ============
;; Declarations
;; ============

__includes [
  "bullet.nls"
  "player.nls"
  "tank.nls"
]

globals [
  last-tick-time
  max-fps
  mouse-was-down?
  player
  player-accelerate-for
]

;; ===========================
;; Button-initiated procedures
;; ===========================

to setup
  clear-all
  no-display
  setup-defaults
  ask patches [
    set pcolor (random 3) - 5 + green
  ]
  spawn-player
  render
  set last-tick-time timer
end

to go
  ask player [
    do-player-logic
  ]
  ask tanks [
    do-tank-logic
  ]
  ask bullets [
    do-bullet-logic
  ]
  render
  keep-time
end

;; ================
;; Other procedures
;; ================

to setup-defaults
  set-patch-size 30
  resize-world -8 8 -8 8
  set max-fps 30
  set mouse-was-down? false
  set player-accelerate-for 0
end

to render
  display
  no-display
end

to keep-time
  let time-since-last-tick timer - last-tick-time
  let wait-time (1 / max-fps) - time-since-last-tick
  wait wait-time
  tick
  set last-tick-time timer
end
@#$#@#$#@
GRAPHICS-WINDOW
475
10
995
551
8
8
30.0
1
10
1
1
1
0
1
1
1
-8
8
-8
8
0
0
1
ticks

BUTTON
66
100
161
133
New Game
setup
NIL
1
T
OBSERVER
NIL
R
NIL
NIL

BUTTON
313
99
407
132
Play Game
go
T
1
T
OBSERVER
NIL
G
NIL
NIL

MONITOR
297
382
410
427
Player Speed
[speed] of player
8
1
11

BUTTON
108
176
285
252
FIRE!
player-fire
NIL
1
T
OBSERVER
NIL
F
NIL
NIL

MONITOR
296
433
410
478
Player Accel Time
player-accelerate-for
5
1
11

@#$#@#$#@
WHAT IS IT?
-----------
This section could give a general understanding of what the model is trying to show or explain.


HOW IT WORKS
------------
This section could explain what rules the agents use to create the overall behavior of the model.


HOW TO USE IT
-------------
This section could explain how to use the model, including a description of each of the items in the interface tab.


THINGS TO NOTICE
----------------
This section could give some ideas of things for the user to notice while running the model.


THINGS TO TRY
-------------
This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.


EXTENDING THE MODEL
-------------------
This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.


NETLOGO FEATURES
----------------
This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.


RELATED MODELS
--------------
This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.


CREDITS AND REFERENCES
----------------------
This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

bullet
true
5
Rectangle -16777216 true false 135 30 165 90
Rectangle -1 true false 135 90 165 150
Rectangle -1 true false 135 150 165 210
Polygon -16777216 true false 135 30 150 0 165 30 135 30
Rectangle -16777216 true false 120 270 120 270
Rectangle -2674135 true false 135 210 165 270
Rectangle -16777216 true false 120 270 180 300
Polygon -7500403 true false 195 210 165 150 165 210 195 210
Rectangle -7500403 true false 165 210 195 268
Rectangle -7500403 true false 105 210 135 268
Polygon -7500403 true false 105 210 135 150 135 210 105 210

tank
true
1
Rectangle -7500403 true false 78 85 116 103
Polygon -7500403 true false 105 270 210 271 210 105 180 105 180 135 120 135 120 105 90 105 89 270
Polygon -2674135 true true 120 105 120 105 90 105 90 180 120 180 120 195 180 195 180 180 210 180 210 105 180 105 180 105 165 105 165 135 135 135 135 105 120 105
Polygon -1 true false 135 15 135 150 165 150 165 15
Polygon -1 true false 67 105 67 255 97 255 97 105
Polygon -1 true false 202 105 202 255 232 255 232 105
Rectangle -7500403 true false 184 85 222 103

@#$#@#$#@
NetLogo 4.1.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
