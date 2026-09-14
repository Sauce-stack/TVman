# Conventions

## Language

English everywhere in the repository: code, identifiers, comments, commit messages, docs.

## File naming — and the conflict with the global rule

The global `~/.claude/CLAUDE.md` says *"Files/folders: `kebab-case` for all languages."*
**Inside this repository that rule is overridden for engine files**, because Godot's `res://`
filesystem is case-sensitive even when Windows and macOS are not.

| Zone | Convention |
|---|---|
| Anything Godot loads — `scenes/`, `scripts/`, `assets/`, `data/`, `addons/` | `snake_case` files and folders |
| Node names in `.tscn`, `class_name`, custom Resource types | `PascalCase` |
| Everything else — `docs/`, `tools/`, `.github/` | `kebab-case`; GitHub's own files keep `UPPER_SNAKE` |

See [ADR 0002](decisions/0002-godot-file-naming.md).

## Identifiers

`snake_case` for files, variables, functions and signals · `PascalCase` for classes and node names ·
`UPPER_SNAKE_CASE` for constants and enum members · a `_leading_underscore` for private ·
`StringName` (`&"idle"`) for identifiers compared every frame.

## Script member order

`@tool` → `class_name` → `extends` → docstring → `signal` → `enum` → `const` → `@export` →
public vars → private vars → `@onready` → `_init` → `_enter_tree` → `_ready` →
`_process` / `_physics_process` → `_input` / `_unhandled_input` → public methods →
private methods → inner classes.

## Static typing

Everywhere, no exceptions. Every variable, every parameter, every return type including `-> void`.
`:=` inference only when the right-hand side is an unambiguous literal or a typed call. No untyped
collections.

## Signals

Named as a past-tense fact — `enemy_died`, never `kill_enemy` and never `on_enemy_died`. Handlers
are `_on_<emitter>_<signal>`. Connect in code with `signal.connect(callable)`.

## `class_name`

On every `Resource` subclass and every type used as an `@export` hint or a type annotation. Not on
one-off scene scripts.

## Scenes and nodes

One responsibility per scene. A scene past roughly ten direct children or a script past roughly 250
lines gets split. Never reach up the tree, and never reach across it. A node's own children are
resolved with `@onready`.

## Comments

**Default zero comments.** A comment carries a *why* that is genuinely non-obvious, in one line.
The exception is a `##` docstring on a `Resource` class, because it shows up in the inspector.

## Magic numbers

None. Gameplay constants live in `.tres` under `data/`; engineering constants are `const` at the
top of the file.

## Localisation

Every player-facing string goes through `tr()` with a `UI_` / `HUD_` / `ITEM_` key prefix from day
one, even while only English exists.

## Formatting

Tabs, per Godot's official style. `gdformat` is the arbiter and CI enforces it.
