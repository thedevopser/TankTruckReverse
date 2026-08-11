# Changelog

All notable changes to this project are documented here.

## [1.2.1] - 2026-08-11

### Changed
- Updated for World of Warcraft 12.1.0 (`## Interface: 120100`).

## [1.2.0] - 2026-07-24

### Added
- Options panel (native WoW Settings UI): open with `/ttr config` or via
  Escape → Options → AddOns → TankTruckReverse. Toggle the addon and pick the
  sound played on backpedal, with an instant preview on selection.
- Sound choice: several bundled sounds — truck beep (default), a real duck
  quack, a real car horn, an 8-bit blip, and a sonar ping. The selection is
  saved in `TankTruckReverseDB.sound`. The repeat interval follows the chosen
  sound so longer clips don't overlap.
- Sound registry lives in `Core/Sounds.lua`; adding a sound is one table entry
  plus an `.ogg` in `Media/`. Sounds are (re)producible via `tools/gen-sounds.sh`.

### Credits
- Sounds now use royalty-free samples (CC0 / CC BY-SA) plus synthesized ones —
  full list, sources and licenses in [`Media/CREDITS.md`](Media/CREDITS.md).
  Notably the duck is by **Ganesh Mohan T** (CC BY-SA 4.0, Wikimedia Commons)
  and the car horn is CC0 (Freesound #461679).

## [1.1.0] - 2026-07-24

### Changed
- The beep is now much more audible over combat noise. It plays on the `Master`
  sound channel instead of `SFX`, so it is no longer buried under combat sound
  effects or dimmed by the "Sound Effects" volume slider.
- Regenerated `Media/backup_beep.ogg` as a band-limited square wave (1250 Hz
  fundamental + 3rd/5th harmonics), normalized louder — closer to a real backup
  alarm (SAE J994) and cuts through the mix, unlike the previous pure sine.

## [1.0.0] - 2026-07-23

### Added
- Initial release.
- Plays a truck-reversing beep (`Media/backup_beep.ogg`) when the player
  backpedals in combat while in a tank specialization.
- Backpedal detection hooks the game's `MoveBackwardStart` / `MoveBackwardStop`
  movement functions via `hooksecurefunc` (the MOVEBACKWARD keybind). This works
  in combat and in instanced content, and never fires on strafing or moving
  forward.
- Beep repeats every ~0.7 s while backward is held.
- Trigger rule (enabled + backpedaling + in combat + tank) is a pure,
  unit-tested function in `Core/Trigger.lua`.
- Slash commands: `/ttr` (toggle), `/ttr test`, `/ttr debug`.
