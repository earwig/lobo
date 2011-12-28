;; lobo: Logo Bolo
;; (c) Ben Kurtovic, 2011
;;
;; Logo Bolo is a re-envisioning of the classic tank game by Stuart Cheshire in NetLogo.
;;

__includes [
  "base.nls"
  "bullet.nls"
  "explosion.nls"
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
  sounds
]

;; ===========================
;; Button-initiated procedures
;; ===========================

to setup
  clear-all
  no-display
  setup-defaults
  make-sounds-table
  make-explosions-table
  load-map
  spawn-player 0 0 0
  spawn-tank 0 -6 0 90
  spawn-tank 1 6 0 270
  ;spawn-base -3 -7
  spawn-base 0 -7
  ;spawn-base 3 -7
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
  ask bases [
    do-base-logic
  ]
  ask bullets [
    do-bullet-logic
  ]
  ask explosions [
    keep-exploding
  ]
  show-crosshair
  render
  keep-time
end

to player-fire
  ask player [
    fire
  ]
end

to player-cancel-order
  ask player [
    cancel-order
  ]
end

;; ================
;; Other procedures
;; ================

to debug [agent action msg]
  ; Comment this and remove the output box
  ; to turn off debugging info:
  output-print (word (round timer) ": " agent ": " action " (" msg ")")
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
  set tank-max-ammo 24
  set tank-max-armor 8
  set base-max-ammo 50
  set base-max-armor 20
end

to make-sounds-table
  set sounds table:make
  table:put sounds "fire"   "Hand Clap"
  table:put sounds "noammo" "Cowbell"
  table:put sounds "shot"   "Acoustic Snare"
  table:put sounds "kill"   "Electric Snare"
end

to load-map
  ask patches [
    set pcolor (random 3) - 5 + green
  ]
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
1012
10
1500
557
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

BUTTON
109
235
230
268
Cancel Order
player-cancel-order
NIL
1
T
OBSERVER
NIL
C
NIL
NIL

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

base
false
0
Rectangle -1184463 true false 60 240 120 255
Rectangle -1184463 true false 120 225 180 240
Rectangle -1184463 true false 180 240 240 255
Polygon -1184463 true false 45 240 30 240 30 270 60 270 60 255 45 255
Polygon -7500403 true true 195 210 195 225 225 225 225 195 210 195 210 210
Polygon -1184463 true false 60 45 60 30 30 30 30 60 45 60 45 45
Polygon -1184463 true false 240 255 240 270 270 270 270 240 255 240 255 255
Rectangle -1184463 true false 45 60 60 120
Rectangle -1184463 true false 180 45 240 60
Rectangle -1184463 true false 240 180 255 240
Rectangle -1184463 true false 60 120 75 180
Rectangle -1184463 true false 120 60 180 75
Rectangle -1184463 true false 225 120 240 180
Rectangle -1184463 true false 45 180 60 240
Rectangle -1184463 true false 60 45 120 60
Rectangle -1184463 true false 240 60 255 120
Rectangle -1184463 true false 135 135 165 165
Rectangle -1184463 true false 165 120 180 135
Rectangle -1184463 true false 120 120 135 135
Rectangle -1184463 true false 120 165 135 180
Rectangle -1184463 true false 165 165 180 180
Rectangle -7500403 true true 195 105 210 195
Polygon -1184463 true false 255 60 270 60 270 30 240 30 240 45 255 45
Rectangle -7500403 true true 105 90 195 105
Rectangle -7500403 true true 90 105 105 195
Rectangle -7500403 true true 105 195 195 210
Polygon -7500403 true true 210 105 225 105 225 75 195 75 195 90 210 90
Polygon -7500403 true true 105 90 105 75 75 75 75 105 90 105 90 90
Polygon -7500403 true true 90 195 75 195 75 225 105 225 105 210 90 210

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

explosion-decay
false
0
Circle -2674135 true false 2 2 295
Circle -955883 true false 75 75 148

explosion-kill
false
0
Circle -6459832 true false 2 2 297
Circle -2674135 true false 30 30 240
Circle -955883 true false 60 60 180
Circle -1184463 true false 90 90 120

explosion-shot
false
0
Circle -2674135 true false 0 0 300
Circle -955883 true false 45 45 210
Circle -1184463 true false 90 90 120

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
