# Documentation

| Document | What it answers |
|---|---|
| [game-design.md](game-design.md) | The game: loop, combat, and **every balance number** |
| [architecture.md](architecture.md) | Scene composition, components, autoloads, physics layers |
| [conventions.md](conventions.md) | GDScript style, and why file naming overrides the global rule |
| [input-map.md](input-map.md) | Every action on both schemes, and the decisions behind them |
| [animation.md](animation.md) | The rig, the rules that make clips blend, and every clip to author |
| [contributing.md](contributing.md) | Git workflow, `.tscn` conflicts, the documentation trigger table |
| [roadmap.md](roadmap.md) | Milestones, with exit criteria |
| [decisions/](decisions/) | Architecture decision records |

## Where a fact lives

**One home per fact.** A balance number lives in `game-design.md` and in `data/*.tres`, and nowhere
else. A settled question becomes an ADR in `decisions/`.
