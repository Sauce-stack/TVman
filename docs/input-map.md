# Input map

Every action is bound on **keyboard and mouse** and on **gamepad**, and `project.godot` is the
source of truth. Explanations live here, never as comments in the `[input]` block — the editor
strips them.

## Look

Mouse look is **not** an action: mouse motion has no InputMap event. It is read as
`InputEventMouseMotion.relative` in `_unhandled_input`, scaled by the mouse sensitivity setting.
The right stick uses four actions, `look_left`, `look_right`, `look_up`, `look_down`, scaled by the
stick sensitivity setting. Invert Y applies to both.

## Actions

_None yet. Each action added to `project.godot` gets a row here and an entry in
`tools/verify_project_config.gd`._

| Action | Keyboard and mouse | Gamepad | Notes |
|---|---|---|---|
