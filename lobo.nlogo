;; lobo: Logo Bolo
;; (c) Ben Kurtovic, 2011-2012
;;
;; Logo Bolo is a re-envisioning of the classic tank game by Stuart Cheshire in NetLogo.
;;

__includes [
  "base.nls"
  "bullet.nls"
  "explosion.nls"
  "pillbox.nls"
  "player.nls"
  "tank.nls"
]

extensions [
  sound
  table
]

globals [
  last-sound-time
  last-tick-time
  max-fps
  mouse-was-down?
  sound-stopped?
  stop-game
  sounds
]

patches-own [
  ground-type
  ground-friction
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
  ask patch -3 0 [
    spawn-player 270
  ]
  ask patch 2 0 [
    spawn-tank 1 90
  ]
  show-hud
  render
end

to go
  set stop-game false
  do-player-logic
  ask tanks [
    do-tank-logic
  ]
  ask pillboxes [
    do-pill-logic
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
  if stop-game != false [
    clear-drawing
    clear-turtles
    clear-patches
    ask patch 0 2 [
      set plabel first stop-game
    ]
    ask patch 0 0 [
      set plabel last stop-game
    ]
    render
    stop
  ]
  show-crosshairs
  show-hud
  stop-old-sounds
  render
  keep-time
end

;; ================
;; Other procedures
;; ================

to startup
  setup
end

to debug [agent action msg]
  ; Comment this to turn off debugging info:
  print (word (round timer) ": " agent ": " action " (" msg ")")
end

to setup-defaults
  set-patch-size 20
  resize-world -17 17 -12 12
  set last-sound-time timer
  set last-tick-time timer
  set map-file "lobo-default-map.png"
  set max-fps 30
  set mouse-was-down? false
  set sound-stopped? true
  set stop-game false
  set player-deaths 0
  set player-has-target? false
  set player-kills 0
  set player-target-xcor 0
  set player-target-ycor 0
end

to make-sounds-table
  set sounds table:make
  table:put sounds "fire"   "Hand Clap"
  table:put sounds "kill"   "Electric Snare"
  table:put sounds "noammo" "Cowbell"
  table:put sounds "pickup" "Hi Bongo"
  table:put sounds "shot"   "Acoustic Snare"
  table:put sounds "place"  "Vibraslap"
  table:put sounds "nopill" "Cowbell"
  table:put sounds "spawn"  "Open Hi Conga"
end

to load-map
  import-pcolors-rgb map-file
  ask patches [
    ifelse pcolor = [0 0 0] [
      set pcolor black
      set ground-type "road"
      set ground-friction 1.15
    ] [
      ifelse pcolor = [0 128 0] [
        set pcolor lime - 4
        set ground-type "forest"
        set ground-friction 0.5
      ] [
        ifelse pcolor = [0 255 0] [
          set pcolor lime - 2
          set ground-type "grass"
          set ground-friction 0.75
        ] [
          ifelse pcolor = [255 255 0] [
            set pcolor black
            set ground-type "road"
            set ground-friction 1.15
            spawn-base
          ] [
            ifelse pcolor = [255 0 0] [
              set pcolor lime - 4
              set ground-type "forest"
              set ground-friction 0.5
              spawn-pillbox
            ] [
              debug (word "(" pxcor ", " pycor ")") "PATCH-LOAD-FAILURE" (word "unknown color: " pcolor)
              set pcolor red
            ]
          ]
        ]
      ]
    ]
  ]
end

to show-crosshairs
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

to show-hud
  let player-armor 0
  let player-ammo 0
  let num-pills 0

  if player != nobody [
    set player-armor [armor] of player
    set player-ammo [ammunition] of player
    set num-pills [number-of-pills] of player
  ]

  ask patch (min-pxcor + 4) max-pycor [
    set plabel (word "Armor: " player-armor)
  ]
  ask patch (min-pxcor + 12) max-pycor [
    set plabel (word "Ammo: " player-ammo)
  ]
  ask patch (max-pxcor - 1) max-pycor [
    set plabel (word "Pillboxes: " num-pills)
  ]
  ask patch (max-pxcor - 1) (min-pycor + 2) [
    set plabel (word "Deaths: " player-deaths)
  ]
  ask patch (max-pxcor - 1) (min-pycor + 1) [
    set plabel (word "Kills: " player-kills)
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

to stop-old-sounds
  ; NetLogo sometimes plays sounds for longer than we want
  ; i.e., it doesn't know how to properly stop long sounds:
  let time-since-last-sound timer - last-sound-time
  if time-since-last-sound > 2 and not sound-stopped? [
    debug -1 "SOUND-STOP" (word round time-since-last-sound " seconds since last")
    sound:stop-music
    set sound-stopped? true
  ]
end

to play-sound [name]
  if enable-sound? [
    let dist 0
    if player != nobody [
      set dist distancexy ([xcor] of player) ([ycor] of player)
    ]
    let volume 100 - (dist * 4)
    if volume > 0 [
      sound:play-drum (table:get sounds name) volume
      set last-sound-time timer
      set sound-stopped? false
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
254
10
964
541
17
12
20.0
1
14
1
1
1
0
0
0
1
-17
17
-12
12
0
0
1
frames

BUTTON
20
231
115
264
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
130
231
224
264
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

BUTTON
22
296
225
343
Fire!
player-fire
NIL
1
T
OBSERVER
NIL
F
NIL
NIL

SWITCH
50
97
186
130
enable-sound?
enable-sound?
0
1
-1000

BUTTON
23
396
226
429
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

TEXTBOX
16
14
303
53
LoBo: Logo Bolo
28
0.0
1

TEXTBOX
41
53
304
87
a game by Ben Kurtovic
14
0.0
1

TEXTBOX
19
75
241
93
---------------------------------
11
0.0
1

TEXTBOX
22
273
263
301
---------------------------------
11
0.0
1

BUTTON
23
353
226
386
Place Pill
player-place-pill
NIL
1
T
OBSERVER
NIL
P
NIL
NIL

INPUTBOX
23
137
219
197
map-file
lobo-default-map.png
1
0
String

TEXTBOX
22
207
257
225
---------------------------------
11
0.0
1

@#$#@#$#@
LOBO
----

Lobo is Logo Bolo: a re-envisioning of the classic tank game by Stuart Cheshire in NetLogo. Below you will find a short tutorial on how to play, some known bugs and limitations, and credits.

TUTORIAL
--------

In Lobo, you control a tank and attempt to gain strategic control of the map by posessing all of the refueling bases, while simultaneously using your bullets and automated "pillboxes" as defensive or offensive weapons.

You move your tank, which is black, by clicking anywhere on the playing field Ð you'll drive to that square and stop once you've reached it. If you change your mind and want to stop immediately, double-click anywhere on the map or press "C" (cancel order). The color of the tile represents the type of ground, which determines how fast you drive over it. You drive the fastest on road, which is black; light green grass gives you a medium speed; dark green forest makes you move slowest.

When you start, you'll have a bit of ammunition and full armor. Fire your gun straight by pressing "F", lowering your ammo count by one. Getting shot by another tank or a pillbox will lower your armor count by one, and if that reaches zero, you'll die and respawn randomly. (Both of these counts are displayed on the top-left of the screen.)

The map contains a few bases, which look like yellow squares. At the start of the game, they are gray (neutral) and any tank can claim one by driving over it. If you own a particular base, stopping over it will refuel your tank with ammo and armor. An base you don't own won't refuel you, but you can repeatedly shoot at it to weaken it, then drive over it to "capture" it.

The map also contains a few pillboxes, or "pills", which look like gray circles with colored rectanges sticking out of them. Pills will automatically shoot at their nearest target within range, and they have infinite ammo, but not infinite armor. Destroy an enemy pill (red) and pick it up by driving over it, then place it below you, anywhere on the map, with "P". It'll be green, and will shoot at your enemies instead of you!

You win the game by controlling all refueling bases on the map and then destroying your rival tanks Ð tanks that don't control any bases don't respawn!

ADVANCED TIPS
-------------
* Refueling bases have limited reserves of armor and ammo, which regenerate slowly over time. In particular, shooting at a base lowers its armor reserves, and it is "destroyed" when its armor count reaches zero. Therefore, trying to refuel yourself on a recently captured base might not help that much!

* At the start of the game, try your hardest to ignore the enemy tanks and pills and go straight for bases Ð controlling bases is the most important strategic element, after all.

* To protect your bases from enemy attack, try placing pillboxes directly adjacent to them.

* Pillboxes have "anger" Ð they'll shoot faster if you shoot at them, but they'll calm down over time. In other words, it might not be the best idea to take down an entire pillbox in one go, but hurt it and then come back later.

* Consider shooting your own pillboxes if an enemy is nearby Ð you'll "anger" it, and it will shoot at your opponent faster! Also, don't hesitate to destroy your own pills completely and re-place them in a better location, or even in the same location with full health if they were damaged beforehand.

BUGS / LIMITATIONS
------------------

In the original Bolo, the map takes up many screen widths and is scrollable with the tank at the center. "follow" by itself wouldn't work, because NetLogo does not allow objects off-screen. I spent a while trying to figure this out, at one point essentially rewriting the rendering engine and using a table of "actual" patch coordinates that was translated into "virtual" patch coordinates each frame Ð not only was this very slow, but it was very overcomplicated and I wasn't able to do everything I had wanted. Instead, the map was made one screen size.

In the original Bolo, patches are not merely colors - they have patterns on them (grass has little green lines, forests are spotted, roads have white stripes). This was not possible in NetLogo because patches can only have a single color.

Time was also a limiting factor: I had planned a lot of additional features found in the original Bolo, like a nicer GUI for showing armor and ammunition, water as a ground-type (which drowns your tank), allies and multiple enemies (grr!), a nicer game-over screen, and a much, much smarter AI. These were skipped so more work could be spent on general polishing and testing.

CREDITS / MISC
--------------

* Stuart Cheshire for the original Bolo game. Some graphics used in this project (tanks, pillboxes, and bases) were heavily based on old sprites taken from Bolo.

* My dad for introducing me to Bolo many years ago, and for helping me simplify the original Bolo game into something possible with NetLogo.

* Josh Hofing for advice on implementing certain features and emotional support.

This project is available on GitHub at https://github.com/earwig/lobo. I used it for syncing code between my netbook and my desktop when working on the project away from home.

Ñ Ben Kurtovic
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

explosion-large
false
0
Circle -6459832 true false 2 2 297
Circle -2674135 true false 30 30 240
Circle -955883 true false 60 60 180
Circle -1184463 true false 90 90 120

explosion-med
false
0
Circle -2674135 true false 0 0 300
Circle -955883 true false 45 45 210
Circle -1184463 true false 90 90 120

explosion-small
false
0
Circle -2674135 true false 2 2 295
Circle -955883 true false 75 75 148

pillbox-alive-1
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 47 42 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182
Polygon -16777216 true false 116 185 101 216 116 235 127 214
Polygon -16777216 true false 154 67 188 61 218 99 192 86 178 144 179 86 158 66
Polygon -16777216 true false 221 118 236 158 231 191 243 157
Polygon -16777216 true false 105 120 135 90 150 120 123 146 110 181 97 157 112 105
Polygon -16777216 true false 116 97 80 101 73 121 61 127 64 152 62 196 81 194 75 154 85 125 95 100
Polygon -16777216 true false 152 224 182 234 212 216 230 196 211 202 191 218 187 206 160 223
Polygon -16777216 true false 86 78 118 58 154 60 169 52 146 71 126 68 97 87 71 93 86 78
Polygon -16777216 true false 218 107 248 139 245 184 230 192 224 154 225 126 214 109
Polygon -16777216 true false 75 90 120 60 195 60 227 123 232 177 202 178 198 105 156 74 84 99 57 133 73 83
Polygon -16777216 true false 77 147 124 213 176 210 222 179 167 171 137 191 105 141 67 117
Polygon -16777216 true false 76 196 135 244 191 237 226 206 174 209 110 220 82 179 74 198
Polygon -16777216 true false 101 67 154 52 175 134 135 94 92 95
Polygon -16777216 true false 79 168 170 162 172 139 135 151 72 153
Polygon -16777216 true false 207 80 249 119 166 172 160 128 208 83

pillbox-alive-2
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 47 42 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182
Polygon -16777216 true false 116 185 101 216 116 235 127 214
Polygon -16777216 true false 154 67 188 61 218 99 192 86 178 144 179 86 158 66
Polygon -16777216 true false 221 118 236 158 231 191 243 157
Polygon -16777216 true false 105 120 135 90 150 120 123 146 110 181 97 157 112 105
Polygon -16777216 true false 116 97 80 101 73 121 61 127 64 152 62 196 81 194 75 154 85 125 95 100
Polygon -16777216 true false 152 224 182 234 212 216 230 196 211 202 191 218 187 206 160 223
Polygon -16777216 true false 86 78 118 58 154 60 169 52 146 71 126 68 97 87 71 93 86 78
Polygon -16777216 true false 218 107 248 139 245 184 230 192 224 154 225 126 214 109
Polygon -16777216 true false 75 90 120 60 195 60 227 123 232 177 202 178 198 105 156 74 84 99 57 133 73 83
Polygon -16777216 true false 77 147 124 213 176 210 222 179 167 171 137 191 105 141 67 117
Polygon -16777216 true false 76 196 135 244 191 237 226 206 174 209 110 220 82 179 74 198

pillbox-alive-3
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 47 42 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182
Polygon -16777216 true false 116 185 101 216 116 235 127 214
Polygon -16777216 true false 154 67 188 61 218 99 192 86 178 144 179 86 158 66
Polygon -16777216 true false 221 118 236 158 231 191 243 157
Polygon -16777216 true false 105 120 135 90 150 120 123 146 110 181 97 157 112 105
Polygon -16777216 true false 116 97 80 101 73 121 61 127 64 152 62 196 81 194 75 154 85 125 95 100
Polygon -16777216 true false 152 224 182 234 212 216 230 196 211 202 191 218 187 206 160 223
Polygon -16777216 true false 86 78 118 58 154 60 169 52 146 71 126 68 97 87 71 93 86 78
Polygon -16777216 true false 218 107 248 139 245 184 230 192 224 154 225 126 214 109

pillbox-alive-4
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 47 42 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182
Polygon -16777216 true false 116 185 101 216 116 235 127 214
Polygon -16777216 true false 154 67 188 61 218 99 192 86 178 144 179 86 158 66
Polygon -16777216 true false 221 118 236 158 231 191 243 157
Polygon -16777216 true false 105 120 135 90 150 120 123 146 110 181 97 157 112 105
Polygon -16777216 true false 116 97 80 101 73 121 61 127 64 152 62 196 81 194 75 154 85 125 95 100

pillbox-alive-5
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 45 45 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182
Polygon -16777216 true false 116 185 101 216 116 235 127 214
Polygon -16777216 true false 154 67 188 61 218 99 192 86 178 144 179 86 158 66

pillbox-alive-6
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 45 45 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95
Polygon -16777216 true false 203 122 218 185 193 205 150 235 138 219 149 221 176 201 203 188 183 173 200 157 187 128 198 109
Polygon -16777216 true false 116 183 126 216 143 210 129 207 123 182

pillbox-alive-7
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 45 45 210
Polygon -16777216 true false 117 90 87 136 100 198 102 149 111 121 145 95 129 78 122 95

pillbox-alive-8
false
1
Polygon -2674135 true true 270 240 270 270 240 270 180 210 210 180 270 240
Rectangle -2674135 true true 225 135 300 165
Rectangle -2674135 true true 135 0 165 75
Rectangle -2674135 true true 0 135 75 165
Rectangle -2674135 true true 135 225 165 300
Polygon -2674135 true true 240 30 270 30 270 60 210 120 180 90 240 30
Polygon -2674135 true true 30 60 30 30 60 30 120 90 90 120 30 60
Polygon -2674135 true true 60 270 30 270 30 240 90 180 120 210 60 270
Circle -7500403 true false 45 45 210

pillbox-dead
false
1
Polygon -7500403 true false 240 30 270 30 270 60 240 90 210 60 240 30
Rectangle -7500403 true false 135 0 165 45
Rectangle -7500403 true false 0 135 45 165
Rectangle -7500403 true false 135 255 165 300
Rectangle -7500403 true false 255 135 300 165
Polygon -7500403 true false 30 60 30 30 60 30 90 60 60 90 30 60
Polygon -7500403 true false 60 270 30 270 30 240 60 210 90 240 60 270
Polygon -7500403 true false 270 240 270 270 240 270 210 240 240 210 270 240
Polygon -2674135 true true 195 165 210 180 210 210 180 210 165 195
Polygon -2674135 true true 165 105 180 90 210 90 210 120 195 135
Polygon -2674135 true true 105 135 90 120 90 90 120 90 135 105
Polygon -2674135 true true 135 195 120 210 90 210 90 180 105 165

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
