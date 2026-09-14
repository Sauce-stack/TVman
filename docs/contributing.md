# Contributing

## Setup

1. GitHub Desktop → **File → Clone repository → URL** → `https://github.com/Purple-Sigil/TVman`.
2. Open `project.godot` with Godot 4.7.2 standard.

The first open reimports every asset. `.godot/` is generated and ignored.

## Commits

Conventional Commits, **subject line only** — no body, no co-author trailer. In GitHub Desktop,
fill the *Summary* field and leave *Description* empty.

Types: `feat`, `fix`, `chore`, `docs`, `ci`, `refactor`, `perf`, `art`. `art:` exists so asset-only
commits are easy to filter out of a changelog.

```
feat: add the over-the-shoulder camera rig
fix: stop the spring arm from snapping through thin walls
art: replace the player capsule with the rigged mesh
```

## Branches

`type/short-description` — `feat/shoulder-swap`, `fix/aim-parallax`, `ci/pin-godot`. In GitHub
Desktop: **Current branch → New branch**, always from an up-to-date `main`.

## Pull requests

Always, even solo, even for a typo. In GitHub Desktop: **Push origin**, then **Create Pull Request**.
Title in Conventional Commit form. The body carries what, why, a test plan, and **a clip for
anything that changes how the game feels**.

**Never commit directly to `main`.** Squash merge on green.

## The Godot-specific rules

- **`.tscn` and `.tres` are text but they merge terribly.** Node order shifts and sub-resource IDs
  churn. **One branch owns a scene at a time.** Resolve a conflict by taking one side wholesale and
  redoing the other change in the editor — never by hand-editing the conflict markers.
- Keep scenes small and composed. A huge scene is a merge hazard as much as an architecture smell.
- **`*.import` files are committed.** `.godot/` never is. There is no `.import/` folder in Godot 4.
- `project.godot` and `export_presets.cfg` are marked `-merge` in `.gitattributes`, so git raises a
  conflict instead of silently producing a valid-looking but semantically wrong file.
- **Git LFS must be active before the commit that adds a binary asset.** The patterns are already in
  `.gitattributes`; retrofitting LFS rewrites history and invalidates every clone.

## Documentation duty — the trigger table

| Change | Update in the same PR |
|---|---|
| Any balance value | `docs/game-design.md` **and** the `.tres` |
| New weapon, attack, enemy behaviour | `docs/game-design.md` |
| New autoload, component, `Resource` class, physics layer | `docs/architecture.md` |
| New or renamed input action | `docs/input-map.md` **and** `project.godot` |
| A style or naming rule | `docs/conventions.md` |
| Anything under `scripts/`, `scenes/`, `data/` or `assets/` | `CHANGELOG.md`, under `## [Unreleased]` — **enforced by CI**, or the label `no changelog` |
| A milestone completed or re-scoped | `docs/roadmap.md` and the `README.md` status |
| An open question **closed** | new ADR in `docs/decisions/` |

## Definition of done

```
- [ ] Static types everywhere, explicit return types
- [ ] Project starts with no errors and no warnings in the Godot output
- [ ] tools/verify_project_config.gd passes
- [ ] No debug prints, no debug actions in a release build
- [ ] A new guard was run once with the thing it guards broken, and failed
- [ ] Docs updated per the trigger table above
```
