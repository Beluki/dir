
## About

dir is a small, elegant puzzle game written in Lua, using the excellent
[Love2D][] framework. I wrote it as a birthday gift for a friend.

It's also my attempt at designing a game that appeals to both casual and
hardcore audiences, without relying on quick reflexes or time limits.

Here are two screenshots:

![Screenshot1](https://raw.github.com/Beluki/dir/master/Screenshot/Screenshot1.png)

And a feature list:

* Original mechanics that still feel familiar to match-3 game players.

* Highly replayable. Each game usually lasts between 5 and 15 minutes.

* Easy to play, hard to master gameplay, with finely tuned scoring
  and ranking systems. Can you get the grandmaster rank?

* All the graphics are vector-based and the game is resolution-independent.
  It looks great on a tiny handheld screen and on a 4k screen, without scaling
  or stretching pixels. It also adapts itself to almost any aspect ratio. Both
  windowed (resizable) and full screen modes are supported. Switching between
  both is instant.

* Three color themes.

## Installation

On Linux and Mac systems, install Love2D 0.9.2+, clone this repository and run:

    $ love Source

On Windows, get the latest zip from the [Releases][] tab. It includes both x86
and x86-64 executables.

System requirements are very low. It should run without problems on any computer
with OpenGL support. Even the integrated graphics card on my laptop (Intel 965
Express) runs it at 90+ FPS (full screen), using 32 mb of ram and 5% CPU.

The game is portable. It does not read or write to files outside it's folder or
to the Windows registry. To uninstall, just delete the folder.

## How to play

As you can see from the screenshots above, the game takes place on a 5x5 grid
which contains tiles of different colors.

* Use the mouse to move a tile in any of the four cardinal directions. The
  mouse buttons move left or right while the mousewheel moves up or down.

* When the tile stops, any adyacent tile of the same color will count as a
  match. All the matching tiles will grow, the combo score increase and
  you can move again.

* The first move that doesn't match any tiles will cause all the previously
  matched tiles to disappear, grant the current combo score and add new tiles
  to the grid in random positions.

You lose when the grid is completely filled with tiles.

The game is infinite (in the same sense as Tetris is). The goal is to make
a score as high as possible and, eventually, to reach the grandmaster rank.

As with all puzzle games, the game may seem very hard at first. Don't worry,
you'll likely develop new strategies as you play.

## Status

dir is basically finished. It has no known bugs and all the important
stuff is implemented.

I may still add small things here or there (e.g. more keyboard shortcuts
or a game over animation), but the gameplay and the scoring/ranking systems
won't change.

## License

Like all my hobby projects, this is Free Software. See the [Documentation][]
folder for more information. No warranty though.

[Documentation]: https://github.com/Beluki/dir/tree/master/Documentation
[Releases]: https://github.com/Beluki/dir/releases

[Love2D]: https://love2d.org

