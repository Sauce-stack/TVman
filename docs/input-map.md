# Input map

Every action is bound on **keyboard and mouse** and on **gamepad**, and `project.godot` is the
source of truth. Explanations live here, never as comments in the `[input]` block — the editor
strips them.

What each action *does* is [game-design.md](game-design.md)'s. This file is which button, and why.

## Look

Mouse look is **not** an action: mouse motion has no InputMap event. It is read as
`InputEventMouseMotion.relative` in `_unhandled_input`, scaled by the mouse sensitivity setting.
The right stick uses four actions, `look_left`, `look_right`, `look_up`, `look_down`, scaled by the
stick sensitivity setting. Invert Y applies to both.

## Gamepad layout

**Planned — none of these is in `project.godot` yet.** The keyboard column is still to design. An
action that lands in `project.godot` gets its row in **Actions** below and a line in
`tools/verify_project_config.gd`.

| Xbox | Action | Base use |
|---|---|---|
| Left stick | `move_*` | Walk to run, by how far it is pushed |
| L3 | `sprint` | Sprint |
| Right stick | `look_*` | Camera |
| R3 | `crouch` | Crouch |
| A | `jump` | Jump, double jump |
| B | `dodge` | Dodge with no direction, roll with one |
| X | `attack_light` | Light attack |
| Y | `attack_heavy` | Heavy attack |
| LB | `draw` | Tap: draw or sheathe. Hold, sheathed: draw stance |
| RB | `plug` | Plug or unplug the cable |
| LT | `aim` | Hold: aim and guard. Every press opens with a parry window |
| RT | `grab` | Grab, then throw. With LT: throw or recall the katana |
| D-pad up | `tv` | Tap: TV on or off. Hold: flash |
| D-pad left | `shoulder_swap` | Swap the camera's shoulder |
| Menu | `pause` | Pause |
| D-pad right, D-pad down, View | — | Free |

## Decisions behind the layout

- **Chords, not extra buttons.** LT + RT and LT + RB are read as "RT or RB while `aim` is held", not
  as actions of their own. The right triggers are *what TVman projects*: RT the katana, RB the plug.
- **The parry fires on the press of LT.** A tap detected on release would cost the parry its whole
  point. Holding simply carries on into guard and aim.
- **LB's draw happens on release.** Holding it is the stance, so a tap cannot be told from a hold
  until the button comes up. Drawing happens outside a fight, where that delay is invisible.
- **D-pad up tap versus hold** has the same shape, for the same reason.
- **X + Y together** is a separate reading from X then Y, so the explosive attack never collides
  with the XY… strings.

## Actions

_None in `project.godot` yet._

| Action | Keyboard and mouse | Gamepad | Notes |
|---|---|---|---|
