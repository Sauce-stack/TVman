# TVman

Godot 4.7.2 · GDScript · 3D · Forward+ · Jolt Physics · Windows + macOS · itch.io, then Steam.

Third-person combat game with an over-the-shoulder camera. Nothing about the design is settled
beyond that sentence — `docs/game-design.md` is where it gets written down.

Repository: `github.com/Purple-Sigil/TVman` (public). The account's display name is *Sauce-stack*;
its login, and the one every URL uses, is **Purple-Sigil**.

## Hard rules

- **GDScript only. Never add C#.** Do not create `.csproj`, `.sln` or `.cs` files, and never add a
  `[dotnet]` block to `project.godot`. See `docs/decisions/0001-gdscript-over-csharp.md`.
- **Never commit `.godot/`.** It is generated cache and it also holds `export_credentials.cfg` —
  real signing secrets.
- **The per-asset `*.import` sidecars ARE committed.** They carry resource UIDs.
- **Balance numbers have exactly one home:** `docs/game-design.md` and, once they exist, the `.tres`
  files in `data/`. Never copy a number into another document.
- **`project.godot` is rewritten by the editor** on almost every save and strips anything it did not
  write. Never put explanatory comments in the `[input]` block — they live in `docs/input-map.md`.
- Do not create `.tscn` scenes or gameplay `.gd` scripts unless the task explicitly asks.

## File naming — this overrides the global kebab-case rule

**Godot's `res://` filesystem is case-sensitive even when Windows and macOS are not**, so a casing
mistake only surfaces after export, on someone else's machine.

| Zone | Convention | Example |
|---|---|---|
| Anything Godot loads — `scenes/`, `scripts/`, `assets/`, `data/`, `addons/` | `snake_case` files and folders | `scripts/camera/shoulder_camera.gd` |
| Node names in `.tscn`, `class_name`, custom Resource types | `PascalCase` | `ShoulderCamera` |
| Everything else — `docs/`, `tools/`, `.github/` | `kebab-case` (GitHub's own files keep `UPPER_SNAKE`) | `docs/input-map.md` |

This is a decision, not drift. See `docs/decisions/0002-godot-file-naming.md`.

## GDScript style

- **Tabs** for indentation — official Godot style, and what `gdformat` emits.
- **Static typing everywhere**, including explicit `-> void`. Typed arrays, never a bare `Array`.
- Member order: `@tool`, `class_name`, `extends`, docstring, `signal`, `enum`, `const`, `@export`,
  public vars, private vars, `@onready`, `_init`, `_ready`, `_process`/`_physics_process`,
  `_input`/`_unhandled_input`, public methods, private methods.
- Signals are named as a past-tense fact — `enemy_died`, never `on_enemy_death`. Handlers are
  `_on_<emitter>_<signal>`. Connect in code, not in the editor.
- Composition over inheritance. Behaviour is assembled from components that do not know who owns
  them.
- Tunable numbers belong in a `Resource` under `data/`, never hardcoded in a script.

## Architecture notes that are easy to get wrong

- **The camera looks, and aim follows the camera.** This is the opposite of Fight Island's fixed
  camera, so do not port its "no camera look" rule. Mouse look reads `InputEventMouseMotion.relative`
  in `_unhandled_input` — **mouse motion cannot be an InputMap action**, only the stick's look axes
  can. Sensitivity and invert Y are real settings here.
- **The camera must not clip through walls.** Use a `SpringArm3D` (or an equivalent shape cast)
  against the `world` layer, never `camera_collision` on actors.
- **Shots resolve from the camera, not the muzzle.** Ray from the screen centre to find the aim
  point, then from the muzzle to that point. A ray from the muzzle alone misses what the crosshair
  shows whenever the shoulder offset parallaxes against near geometry.
- Physics layers are named in `project.godot` — reference them through a constants script, never as
  raw integers.
- Hit registration runs on the physics frame, never on interpolated visual transforms.
- **Never `ResourceLoader.load()` anything from `user://`.** A `.tres` can carry a script path, and
  that is arbitrary code execution on a file the player can edit. Saves are JSON.

## Git

- Branches `type/short-description`. Conventional Commits, **subject line only** — no body, no
  co-author trailer. CI rejects a trailer.
- Always a pull request. Never commit to `main` directly, not even for a typo.
- **One branch owns a `.tscn` at a time.** Resolve a scene conflict by taking one side wholesale and
  redoing the other change in the editor, never by hand-editing markers.
- Binary assets must be LFS-tracked before the commit that adds them.

## Local environment (Windows)

- Godot **4.7.2 standard** is not on PATH. Use the `_console` build for anything headless — the GUI
  build detaches and prints nothing to PowerShell:
  `C:\Users\Suste\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`
- `git` is not on PATH either. GitHub Desktop bundles one:
  `C:\Users\Suste\AppData\Local\GitHubDesktop\app-<version>\resources\app\git\cmd\git.exe`.
  `gh` is not installed; pull requests are opened from GitHub Desktop.
- **Never write source files with PowerShell `Set-Content`** — it mangles UTF-8 (em-dashes).
- **CI is the only source of shippable binaries.** Never treat a local export as a release.

## Commands

```powershell
$GODOT = "C:\Users\Suste\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe"

& $GODOT --headless --path . --import                                   # import and validate
& $GODOT --headless --path . --script tools/verify_project_config.gd    # layers and settings
```

`gdformat` and `gdlint` (`pip install "gdtoolkit>=4.3,<5"`) are enforced by CI.
