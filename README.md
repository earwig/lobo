__lobo__: _Logo Bolo_
(c) Ben Kurtovic, 2011

__Lobo__ is Logo Bolo: a re-envisioning of the classic tank game by Stuart
Cheshire in NetLogo. Below you will find a short tutorial on how to play, some
known bugs and limitations, and credits.

TUTORIAL
--------

In Lobo, you control a tank and attempt to gain strategic control of the map by
posessing all of the refueling bases, while simultaneously using your bullets
and automated "pillboxes" as defensive or offensive weapons.

You move your tank, which is black, by clicking anywhere on the playing field –
you'll drive to that square and stop once you've reached it. If you change your
mind and want to stop immediately, double-click anywhere on the map or
press "C" (cancel order). The color of the tile represents the type of ground,
which determines how fast you drive over it. You drive the fastest on road,
which is black; light green grass gives you a medium speed; dark green forest
makes you move slowest.

When you start, you'll have a bit of ammunition and full armor. Fire your gun
straight by pressing "F", lowering your ammo count by one. Getting shot by
another tank or a pillbox will lower your armor count by one, and if that
reaches zero, you'll die and respawn randomly. (Both of these counts are
displayed on the top-left of the screen.)

The map contains a few bases, which look like yellow squares. At the start of
the game, they are gray (neutral) and any tank can claim one by driving over
it. If you own a particular base, stopping over it will refuel your tank with
ammo and armor. An base you don't own won't refuel you, but you can repeatedly
shoot at it to weaken it, then drive over it to "capture" it.

The map also contains a few pillboxes, or "pills", which look like gray circles
with colored rectanges sticking out of them. Pills will automatically shoot at
their nearest target within range, and they have infinite ammo, but not
infinite armor. Destroy an enemy pill (red) and pick it up by driving over it,
then place it below you, anywhere on the map, with "P". It'll be green, and
will shoot at your enemies instead of you!

You win the game by controlling all refueling bases on the map and then
destroying your rival tanks – tanks that don't control any bases don't respawn!

ADVANCED TIPS
-------------

* Refueling bases have limited reserves of armor and ammo, which regenerate
slowly over time. In particular, shooting at a base lowers its armor reserves,
and it is "destroyed" when its armor count reaches zero. Therefore, trying to
refuel yourself on a recently captured base might not help that much!

* At the start of the game, try your hardest to ignore the enemy tanks and
pills and go straight for bases – controlling bases is the most important
strategic element, after all.

* To protect your bases from enemy attack, try placing pillboxes directly
adjacent to them.

* Pillboxes have "anger" – they'll shoot faster if you shoot at them, but
they'll calm down over time. In other words, it might not be the best idea to
take down an entire pillbox in one go, but hurt it and then come back later.

* Consider shooting your own pillboxes if an enemy is nearby – you'll "anger"
it, and it will shoot at your opponent faster! Also, don't hesitate to destroy
your own pills completely and re-place them in a better location, or even in
the same location with full health if they were damaged beforehand.

BUGS / LIMITATIONS
------------------

In the original Bolo, the map takes up many screen widths and is scrollable
with the tank at the center. "follow" by itself wouldn't work, because NetLogo
does not allow objects off-screen. I spent a while trying to figure this out,
at one point essentially rewriting the rendering engine and using a table of
"actual" patch coordinates that was translated into "virtual" patch coordinates
each frame – not only was this very slow, but it was very overcomplicated and I
wasn't able to do everything I had wanted. Instead, the map was made one screen
size.

In the original Bolo, patches are not merely colors - they have patterns on
them (grass has little green lines, forests are spotted, roads have white
stripes). This was not possible in NetLogo because patches can only have a
single color.

Time was also a limiting factor: I had planned a lot of additional features
found in the original Bolo, like a nicer GUI for showing armor and ammunition,
water as a ground-type (which drowns your tank), allies and multiple enemies
(grr!), a nicer game-over screen, and a much, much smarter AI. These were
skipped so more work could be spent on general polishing and testing.

CREDITS / MISC
--------------

* Stuart Cheshire for the original Bolo game. Some graphics used in this
project (tanks, pillboxes, and bases) were heavily based on old sprites taken
from Bolo.

* My dad for introducing me to Bolo many years ago, and for helping me simplify
the original Bolo game into something possible with NetLogo.

* Josh Hofing for advice on implementing certain features and positive
encouragement.

* Chain Algorithm - I wrote the entire AI routine in less than an hour
immediately before the project was due (ha!), and I don't think it would be
possible if I hadn't been listening to your music on loop the entire time.
Really gets your blood pumping, y'know? Yeah.

This project is available on [GitHub](https://github.com/earwig/lobo). I used
it for syncing code between my netbook and my desktop when working on the
project away from home.
