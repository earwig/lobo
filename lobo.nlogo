;; lobo: Logo Bolo
;; (c) Ben Kurtovic, 2011
;;
;; Logo Bolo is a re-envisioning of the classic tank game by Stuart Cheshire in NetLogo.
;;

__includes [
  "bullet.nls"
  "player.nls"
  "tank.nls"
]

extensions [
  sound
  table
]

globals [
  last-tick-time
  max-fps
  mouse-was-down?
  player
  player-deaths
  player-has-target?
  player-kills
  player-target-xcor
  player-target-ycor
  sounds
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
  spawn-tank 0 ask tank 1 [ setxy -6 0 ]
  spawn-tank 1 ask tank 2 [ setxy  6 0 ]
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
  show-crosshair
  render
  keep-time
end

;; ================
;; Other procedures
;; ================

to debug [action msg]
  ; Comment this and remove the output box
  ; to turn off debugging info:
  output-print (word (round timer) ": " action ": " msg)
end

to setup-defaults
  set-patch-size 30
  resize-world -8 8 -8 8
  set max-fps 30
  set mouse-was-down? false
  set player-deaths 0
  set player-has-target? false
  set player-kills 0
  set player-target-xcor 0
  set player-target-ycor 0
  make-sounds-table
end

to make-sounds-table
  set sounds table:make
  table:put sounds "fire"        "Hand Clap"
  table:put sounds "shot player" "Acoustic Snare"
  table:put sounds "shot ally"   "Acoustic Snare"
  table:put sounds "shot enemy"  "Acoustic Snare"
  table:put sounds "kill player" "Electric Snare"
  table:put sounds "kill ally"   "Electric Snare"
  table:put sounds "kill enemy"  "Electric Snare"
end

to show-crosshair
  clear-drawing
  if mouse-inside? [
    ask patch mouse-xcor mouse-ycor [
      draw-border white 1
    ]
  ]
  if player-has-target? [
    ask patch player-target-xcor player-target-ycor [
      draw-border white 2
    ]
  ]
end

to draw-border [b-color b-thickness]
  sprout 1 [
    set color b-color
    set pen-size b-thickness
    set heading 0
    fd 0.5
    pd
    rt 90
    fd 0.5
    repeat 3 [
      rt 90
      fd 1
    ]
    rt 90
    fd 0.5
    die
  ]
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

to play-sound [name]
  if enable-sound? [
    let dist distancexy ([xcor] of player) ([ycor] of player)
    let volume 127 - (dist * 4)
    if volume > 0 [
      sound:play-drum (table:get sounds name) volume
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
452
10
972
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
frames

BUTTON
43
100
138
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
290
99
384
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
269
290
389
339
Player Speed
[speed] of player
8
1
12

BUTTON
109
172
230
224
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
270
350
389
399
Player Has Target?
player-has-target?
5
1
12

OUTPUT
998
30
1375
521
12

MONITOR
55
290
149
339
Player Deaths
player-deaths
17
1
12

MONITOR
55
350
148
399
Player Kills
player-kills
17
1
12

MONITOR
160
290
261
339
Player Ammo
[ammunition] of player
17
1
12

MONITOR
160
350
260
399
Player Armor
[armor] of player
17
1
12

SWITCH
264
179
394
212
enable-sound?
enable-sound?
0
1
-1000

MONITOR
272
411
390
460
Player Target
word \"(\" player-target-xcor \", \" player-target-ycor \")\"
10
1
12

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
Polygon -2674135 true true 120 105 90 105 90 180 120 180 120 195 180 195 180 180 210 180 210 105 180 105 165 105 165 135 135 135 135 105 120 105
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
