# TankTruckReverse

A tiny, single-purpose World of Warcraft addon: it plays a **reversing sound**
when a **tank backpedals in combat**. You can pick which sound plays from a small
options panel.

## How it works

- It hooks the game's own movement functions (`MoveBackwardStart` /
  `MoveBackwardStop`) via `hooksecurefunc`, so it knows **exactly** when the
  backward-movement key is pressed — no guesswork, no position math.
- The sound only plays when **all** of these are true: addon enabled, you're
  **backpedaling**, you're **in combat**, and you're in a **tank
  specialization**. It repeats while you hold backward (the interval follows the
  chosen sound).
- Because it observes the movement function (not the keyboard or your position),
  it works **in combat and inside dungeons/raids** — and strafing or running
  forward never trigger it.

> Note: detection follows the **MOVEBACKWARD keybind** (default `S`). If you
> reverse via click-to-move instead of the key, there's nothing to hook.

## Sounds

Pick the reversing sound in **Escape → Options → AddOns → TankTruckReverse**
(or `/ttr config`). Bundled sounds:

| Sound | Description |
| --- | --- |
| Bip camion | The default truck backup beep |
| Coin coin | A duck quack |
| Klaxon | A car horn |
| Bip 8-bit | A retro arcade blip |
| Sonar | A submarine ping |

Adding a sound is one line in `Core/Sounds.lua` plus a `.ogg` in `Media/`.
Sources and licenses for the bundled sounds are in
[`Media/CREDITS.md`](Media/CREDITS.md).

## Commands

| Command | Effect |
| --- | --- |
| `/ttr` | Toggle the addon on/off |
| `/ttr config` | Open the options panel (enable + sound choice) |
| `/ttr test` | Play the current sound once |
| `/ttr debug` | Print when backpedal start/stop is detected |

## Building

```bash
make test                      # runs the Busted unit tests in Docker
tools/gen-sounds.sh            # (re)generate the synthesized sounds
git tag v1.0.0 && make zip     # -> versions/TankTruckReverse-v1.0.0.zip
```

## License

MIT — see [LICENSE](LICENSE). Bundled sounds keep their own licenses (CC0 /
CC BY-SA / synthesized) — see [`Media/CREDITS.md`](Media/CREDITS.md).
