# Scoundrel for Playdate

This is an implementation of [Scoundrel][scoundrel] by Zach Gage and Kurt Bieg
for the [Playdate][playdate]. It largely serves as a basic demonstration of the
engine I used to build [Spilled Mushrooms][spilled-mushrooms], but it's largely
not a thorough or robust example of all the functionality provided by it.

Engine features include:
* Asset caching example: [`src/assets/sound.lua`][sound.lua]
* Font / text caching example: [`src/assets/text.lua`][text.lua]
* Very minimal class / object implementation: [`src/engine/object.lua`][object.lua]
* Asset preloader: [`src/engine/load.lua`][load.lua]
* Robust stack-based scene / state management system: [`src/engine/states.lua`][states.lua]
* Playdate system callback maps to the state system: [`src/engine/system.lua`][system.lua]

And examples of some functionality used by the game:

* Title scene with background preloading: [`src/states/title.lua`][title.lua]
* Fade out transition scene, with preload finalizing: [`src/states/transition.lua`][transition.lua]
* Gameplay scene with input handling: [`src/states/play.lua`][play.lua]
* Isolated game logic that fires events back to the gameplay scene: [`src/game.lua`][game.lua]
* Basic save/load functionality: [`src/save.lua`][save.lua]

[game.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/game.lua
[load.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/engine/load.lua
[object.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/engine/object.lua
[play.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/states/play.lua
[save.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/save.lua
[sound.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/assets/sound.lua
[states.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/engine/states.lua
[system.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/engine/system.lua
[text.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/assets/text.lua
[title.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/states/title.lua
[transition.lua]: https://github.com/scizzorz/scoundrel.pd/blob/main/src/states/transition.lua

The game does very little in the way of teaching the rules of the game, so I
recommend reading the original ruleset [here][scoundrel]. Spades and clubs are
represented by the skull suit, while diamonds are represented by the shield
suit. When playing, each direction on the D-pad maps to playing a card on the
table, with B mapping to the "run" action. The current implementation does not
yet support the "fist" rule for combat.

The latest version can always be downloaded from the [releases][releases] page.
In this example, the four separate releases should be identical; in a more
robust implementation, each can be differentiated based on release platform.
The suffixes correspond to `b`eta, `d`emo, `c`atalog, and `i`tch.

All code and images are, to the best of my knowledge, produced by me. Sound
effects are made by choosh for Spilled Mushrooms and repurposed here.

This code and all assets are explicitly and intentionally unlicensed.

[donsol]: https://wiki.xxiivv.com/site/donsol.html
[playdate]: https://play.date/
[releases]: https://github.com/scizzorz/scoundrel.pd/releases
[scoundrel]: http://stfj.net/art/2011/Scoundrel.pdf
[spilled-mushrooms]: https://play.date/games/spilled-mushrooms/
