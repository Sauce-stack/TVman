# Architecture

## Physics layers

Named in `project.godot` and checked by `tools/verify_project_config.gd`. Scripts reference them
through a constants script, never as raw integers.

| # | Name | Holds |
|---|---|---|
| 1 | `world` | Static level geometry; the camera's spring arm collides with this |
| 2 | `player_body` | The player's `CharacterBody3D` |
| 3 | `enemy_body` | Enemy `CharacterBody3D`s |
| 4 | `player_hitbox` | Areas that deal the player's damage |
| 5 | `enemy_hitbox` | Areas that deal enemy damage |
| 6 | `player_hurtbox` | Areas where the player takes damage |
| 7 | `enemy_hurtbox` | Areas where enemies take damage |
| 8 | `interactable` | Pickups, doors, anything the player can use |
| 9 | `camera_collision` | Extra geometry the camera avoids but actors walk through |

## Camera

Over the shoulder: a yaw pivot on the player, a pitch pivot under it, and a `SpringArm3D` offset to
one side that shortens against `world` and `camera_collision`. Look input rotates the pivots; the
body turns toward the camera's yaw while aiming.

## Scenes, components, autoloads

_To write as they are created._
