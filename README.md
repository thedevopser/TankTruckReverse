# TankTruckReverse

A tiny, single-purpose World of Warcraft addon: it plays a **truck-reversing
beep** when a **tank backpedals in combat**. That's it — no options window, no
frills.

## How it works

- It hooks the game's own movement functions (`MoveBackwardStart` /
  `MoveBackwardStop`) via `hooksecurefunc`, so it knows **exactly** when the
  backward-movement key is pressed — no guesswork, no position math.
- The beep only plays when **all** of these are true: addon enabled, you're
  **backpedaling**, you're **in combat**, and you're in a **tank
  specialization**. It repeats every ~0.7 s while you hold backward.
- Because it observes the movement function (not the keyboard or your position),
  it works **in combat and inside dungeons/raids** — and strafing or running
  forward never trigger it.

> Note: detection follows the **MOVEBACKWARD keybind** (default `S`). If you
> reverse via click-to-move instead of the key, there's nothing to hook.

## Commands

| Command | Effect |
| --- | --- |
| `/ttr` | Toggle the beep on/off |
| `/ttr test` | Play the beep once |
| `/ttr debug` | Print when backpedal start/stop is detected |

## Building

```bash
make test                      # runs the Busted unit test in Docker
git tag v1.0.0 && make zip     # -> versions/TankTruckReverse-v1.0.0.zip
```

## License

MIT — see [LICENSE](LICENSE). The bundled beep (`Media/backup_beep.ogg`) is a
synthetic tone generated for this addon.
