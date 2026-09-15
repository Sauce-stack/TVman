# 0003 — glTF `.glb` as the engine-facing source, not direct `.blend` import

**Status:** Accepted
**Date:** 2026-09-15

## Context

The first working files — a `.blend`, an `.fbx` export and their textures — had been placed under
`assets/Player/TVman/`. Godot imports everything inside the project, and it imports a `.blend` by
launching Blender, which needs a configured Blender path on every machine that reimports, CI
included. The folder names also broke the `snake_case` rule for anything under `res://`.

## Decision

- Working files live in **`art-source/`**, which carries a `.gdignore` and is tracked by Git LFS.
- The engine loads **one `.glb` per character** from `assets/characters/<name>/`, holding the mesh,
  the rig and every clip.

## Consequences

- CI and the release path depend on nothing but Godot.
- It costs one export click per art iteration.
- Both files are committed, and LFS makes that affordable. Commit the `.blend` when a batch of work
  is done rather than on every save — each commit is a full copy in LFS storage.

## Alternatives rejected

**Direct `.blend` import.** The fastest inner loop, but it puts Blender on the critical path of every
build, and the import depends on the Blender version that wrote the file.

**FBX.** Godot reads it, but glTF is the format Godot's importer is built around, and it carries
materials and animation names more predictably.
