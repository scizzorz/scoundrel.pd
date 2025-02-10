# Scoundrel for Playdate

This is an implementation of [Scoundrel][scoundrel] by Zach Gage and Kurt Bieg
for the [Playdate][playdate]. It largely serves as a basic demonstration of the
engine I used to build [Spilled Mushrooms][spilled-mushrooms], but it's largely
not a thorough or robust example of all the functionality provided by it.

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
