# Animation

How TVman's clips are authored, how they reach Godot, and the list of every clip the moveset in
[game-design.md](game-design.md) needs.

The goal is one thing: **any clip can follow any other without a visible snap**, and any clip can be
reworked in Blender without breaking the game. Almost every rule below serves one of those two.

## Three layers, three owners

| Layer | Owner | What it does |
|---|---|---|
| **Authored clips** | Blender | Every body movement: cycles, attacks, transitions |
| **Blending** | Godot's `AnimationTree` | Mixes clips — walk into run, legs running under an arm drawing |
| **Procedural** | Godot's skeleton modifiers | Head and chest turn toward the camera, the cable swings, feet meet the ground |

Anything the game can compute is not animated by hand. Anything that needs weight and intention is
not computed.

## Files

| What | Where |
|---|---|
| Working file | `art-source/characters/tvman/char_tvman.blend` |
| Working textures | `art-source/characters/tvman/textures/` |
| Katana working file | `art-source/weapons/katana/weapon_katana.blend` |
| What the game loads | `assets/characters/tvman/char_tvman.glb` |
| | `assets/weapons/katana/weapon_katana.glb` |

`art-source/` carries a `.gdignore`, so Godot never tries to import a `.blend` — which it can only do
by launching Blender, on every machine and on CI. The `.glb` is the contract; see
[ADR 0003](decisions/0003-gltf-over-blend.md). **One `.glb` holds the mesh, the rig and every clip.**

## The rig

The rig is what decides whether the rest is possible. It needs, as **deform bones**:

| Bones | Why |
|---|---|
| `root`, at the feet on the ground | The anchor every clip is measured from |
| `hips` | Carries the body; a slide or a roll moves it, not `root` |
| `spine`, `chest`, `upper_chest` | **At least three**, so the camera's turn can be spread across the back instead of snapping at the neck |
| `neck`, `head` | The head look |
| `shoulder`, `upper_arm`, `forearm`, `hand` — `.L` and `.R` | Arms |
| `thigh`, `shin`, `foot`, `toe` — `.L` and `.R` | Legs; `toe` lets a foot roll off the ground |
| `cable_01` … `cable_08`, then `plug` | The cable, from the back of the television head to the plug |
| `katana` | **The katana's own bone** — keyed in every clip, like an arm |
| `saya`, child of `hips` | The scabbard, worn **across the hips**. The sheathed katana rides it |

## The katana: one bone in the rig, one mesh of its own

**The katana is a bone**, so a swing is authored the way the rest of the body is — the blade's arc is
keyed, not deduced from the wrist. An object animated by the clips instead of a bone only exports
through NLA tracks, which is a trap Fight Island fell into.

**The mesh is not skinned into TVman.** It is its own `.glb` and its own scene, riding a
`BoneAttachment3D` that follows the `katana` bone. Three things depend on that:

- **A TVman without a katana is the same file** — the weapon is simply not instanced. There is no
  second export to keep in step.
- **A thrown katana leaves the body.** The very same node is reparented to the world, plants in a
  wall, hangs on the cable and comes back. Nothing is swapped, so nothing can pop.
- **Collision, the cable's anchor and the swing's trail** live in `katana.tscn`, where they belong.

**Where the bone hangs from changes with the state.** Two *Child Of* constraints on the `katana`
bone, `hand.R` and `saya`, with their influence keyed: drawing and sheathing are that influence
crossing over, on the frame the clip says so. The export samples the result, so no constraint ever
reaches Godot.

**Tick *Deform* on `katana`, `saya` and every other socket bone.** The export keeps deform bones
only, and a socket nothing is skinned to is dropped without a word — leaving the attachment with
nothing to follow.

**Keep a proxy blade in Blender**, parented to the `katana` bone, in a collection excluded from the
export. It is what lets you see the arcs while keying; what ships is the bone's motion.

**The cable is a bone chain** so it can be animated by hand in the attacks that fight with it, and
handed to the simulation everywhere else — see *Procedural* below.

Control bones — IK targets, pole targets, a Rigify control rig — are welcome, and **never exported**:
the export keeps deform bones only.

## Animating a long blade

The katana is as tall as TVman, and he wears it **horizontally across the hips**, sticking out on
both sides. That carry is the design, and it decides most of what follows.

- **The pivot is the grip, and the blade runs along −Z.** Every rule below assumes it.
- **The bone lags the hand by a frame or two on a swing.** A blade that turns exactly with the wrist
  has no weight. Offset its rotation keys slightly after the arm's, and let it overshoot at the end
  of the arc before settling — two keys, and it is the difference between a stick and a sword.
- **Key it back onto the hub pose like any other bone.** A swing that ends with the blade a few
  degrees off `guard` snaps on the next attack.
- **Sheathed, it belongs to `saya` and `saya` belongs to `hips`.** Walking and running cost no keys
  at all: it turns with the pelvis, which is what a belt-worn sword does.
- **Worn flat, it clears the floor and hits the world instead.** Nothing to solve when crouching —
  the blade is horizontal — but two metres of steel through the hips means it crosses doorways,
  cover and the camera. The camera's shoulder swap decides which side it cuts across the frame.
- **Rolling and sliding are where the hand takes the scabbard.** TVman grips `saya` with the off
  hand and swings it clear, the way a real swordsman does. A constraint from `hand.L` to `saya`,
  keyed on for those clips.
- **Drawing is the clip that costs the most.** A blade that long does not clear a horizontal
  scabbard by pulling: the scabbard has to swing back as the arm goes forward. Solve it in the draw
  and the sheathe, once, and every other clip inherits the answer.
- **The off hand sticks to the hilt with a constraint**, never by eye — key its influence on and off
  for two-handed moments. Sampling bakes it at export.

## The five rules that make clips blend

### 1. Every clip starts and ends on a hub pose

A **hub pose** is a pose several clips share. If an attack ends on `guard` and the next one starts
on `guard`, they chain perfectly, whatever happens in the middle. This is the single most effective
rule in the document.

| Hub pose | Held when |
|---|---|
| `stand` | Relaxed, katana sheathed |
| `crouch` | Crouched, katana sheathed |
| `fists` | Bare-handed guard |
| `guard` | Katana drawn, ready |
| `stance` | Hand on the hilt — the draw stance |
| `aim` | LT held: aim and guard |
| `grab` | Holding an enemy |

Save each one as a **pose asset** in Blender's Asset Browser. Starting a clip means applying a pose
asset on the first frame, never re-posing by eye — two poses that look the same are not the same.

### 2. Cycles share their footing

`walk_loop`, `run_loop`, `sprint_loop` and `crouch_walk_loop` are mixed by the left stick, and Godot
mixes them **by normalised time**. So in every cycle:

- **Frame 0 is the left foot's contact.** The right foot's contact is exactly halfway.
- **One loop is two steps**, never four.

A walk whose left foot lands at 0% mixed with a run whose left foot lands at 30% crosses the legs.
No blend setting fixes that; only the keys do.

### 3. Loops close on themselves

The last frame of a loop is **one frame before** a copy of the first. Copy frame 0 to the end, then
end the action's range a frame earlier — otherwise the same pose plays twice and the loop hitches.

Name every loop with a **`_loop` suffix**: Godot's importer sets looping from the name.

### 4. Movement is played in place, displacement lives on `hips`

- **Cycles are played in place.** Code moves TVman, which is what lets him stop or turn on the frame
  the stick says so — the Metal Gear feel lives there.
- **One-shot moves that travel** — roll, slide, long jump, attacks that step in — move `hips`, and
  `root` stays at the origin. Code reads how far the clip travels and moves the body by it.

### 5. Timing lives in data, not in keys

The frame a blow lands, the window where the next attack can be pressed, the moment a move can be
cancelled into a dodge: all of it goes in an attack `Resource` under `data/`, not into the clip.
A reworked swing then never silently breaks the fight — it only needs its numbers checked.

Every attack clip still has the same anatomy, so those numbers have something to point at:

**anticipation → strike → recovery → back to the hub pose.**

## Frame rate and scale

- **30 fps** for every action. Mixed frame rates blend, but they do not line up.
- **1 Blender unit = 1 metre**, transforms applied, TVman facing **−Y** in Blender. The 180° turn
  Godot needs is on the model instance in the scene, never baked into the `.blend`.

## What Godot does with them

One `AnimationTree` on TVman, organised like this:

- **Locomotion** — a `BlendSpace1D`: `idle_loop` → `walk_loop` → `run_loop` → `sprint_loop`, driven by
  the stick. A second one for crouching.
- **State machine** above it — ground, air, slide, dodge, grab, stance. Most transitions between
  states are a **short crossfade**.
- **Upper body layer** — clips that key only the arms and back (draw, sheathe, plug, aim) play
  **over** whatever the legs are doing, through a bone filter from `spine` upward. That is how TVman
  draws while running without a *run-and-draw* clip.
- **One-shots** — attacks, parries, executions — play over everything and hand back to the state
  underneath.

**Crossfade or author a transition?** Crossfade by default. Author a transition only when:

- **the feet change contact** in a way no cycle covers — starting, stopping, turning on the spot,
  landing;
- **the weight shifts hard** — a slide entry, a heavy landing;
- **a crossfade would pass through something** — the katana through the leg on a sheathe, a hand
  through the head.

Try the crossfade in the game first. Author only what looks wrong.

## Procedural — never animated

| Effect | How | When it lets go |
|---|---|---|
| **Head and chest follow the camera** | `LookAtModifier3D` on `head`, and smaller shares on `neck`, `upper_chest`, `chest`, all clamped | Faded out during attacks, executions and the grab |
| **Cable and plug swing** | `SpringBoneSimulator3D` on `cable_01…plug` | Faded out in the attacks that animate the cable by hand |
| **The sheathed katana lags and bounces** | `SpringBoneSimulator3D` on `sway_katana_01…02`, tightly clamped | Off while drawing, sheathing, rolling and sliding, where the clip owns the blade |
| **Cable reaching a point** — a thrown katana, an anchor, a socket, an enemy | Code drives the chain toward the target | The whole time the cable is attached to something in the world |
| **Feet on uneven ground** | Two-bone IK on the legs | Later — not needed on flat ground |

## Exporting from Blender

`File → Export → glTF 2.0`. Option names shift a little between Blender versions; these are the
ones that matter:

- **Format**: glTF Binary (`.glb`), written over `assets/characters/tvman/char_tvman.glb`.
- **Include**: the armature and the mesh.
- **Transform**: +Y up.
- **Armature**: export **deformation bones only**.
- **Animation**: mode **Actions**, with **animation sampling** on — that is what bakes the katana's
  constraints.

Give every action a **fake user** (`F` in the action editor), or Blender deletes the ones no object
is currently using on save.

Godot reimports on focus. **Never edit a clip inside Godot**: the next export overwrites it. And
**never rename a clip the game already asks for** — rename it in the game in the same change.

## Paired clips

An execution, a silent takedown and a struggle are **two clips that must line up**: TVman's and the
enemy's. Author both in one Blender scene, the two rigs placed where the game will place them, and
export each to its own character. They wait for the enemy rig.

## The clips

`Body` is **full** or **upper** — an upper clip plays over the legs.
`Batch` is the production order below.

### Batch 1 — standing and moving

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `idle_loop` | full | stand → stand | |
| `walk_loop` | full | cycle | Rule 2 |
| `run_loop` | full | cycle | Rule 2 |
| `sprint_loop` | full | cycle | Rule 2 |
| `run_start` | full | stand → run | Authored: feet change contact |
| `run_stop` | full | run → stand | Authored: the skid that sells the weight |
| `turn_180` | full | run → run | Authored: the turn on the spot |
| `crouch_idle_loop` | full | crouch → crouch | |
| `crouch_walk_loop` | full | cycle | Rule 2 |
| `stand_to_crouch` | full | stand → crouch | Crossfade first |
| `crouch_to_stand` | full | crouch → stand | Crossfade first |

### Batch 2 — air and evasion

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `jump_start` | full | stand → air | |
| `jump_rise_loop` | full | air | |
| `jump_fall_loop` | full | air | |
| `double_jump` | full | air → air | Also played by the bounce |
| `land_light` | full | air → stand | |
| `land_heavy` | full | air → crouch | |
| `dive_kick_start` | full | air → air | |
| `dive_kick_loop` | full | air | |
| `dive_kick_impact` | full | air → crouch | |
| `slide_start` | full | sprint → slide | Authored: hard weight shift |
| `slide_loop` | full | slide | |
| `slide_to_crouch` | full | slide → crouch | |
| `slide_to_stand` | full | slide → stand | |
| `long_jump` | full | slide → air | |
| `dodge` | full | stand → stand | B with no direction |
| `roll` | full | stand → stand | One forward roll; code turns TVman to the roll's direction first |

### Batch 3 — the katana in hand

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `draw` | upper | stand → guard | Plays while running |
| `sheathe` | upper | guard → stand | Authored: the blade must miss the leg |
| `guard_idle_loop` | full | guard → guard | |
| `guard_arms_loop` | upper | guard | Laid over the cycles while the katana is drawn |
| `plug` | upper | any → same | RB |
| `unplug` | upper | any → same | RB |
| `aim_enter` | upper | guard → aim | |
| `aim_loop` | upper | aim | Guard, over the cycles |
| `aim_exit` | upper | aim → guard | |
| `parry` | full | aim → aim | |
| `parry_success` | full | aim → guard | The riposte's opening |
| `stance_enter` | upper | stand → stance | LB held |
| `stance_loop` | upper | stance | Over `walk_loop`, played slowly |
| `stance_draw` | upper | stance → guard | LB released |
| `stance_strike_x` | full | stance → guard | |
| `stance_strike_y` | full | stance → guard | |
| `stance_strike_plugged_x` | full | stance → guard | |
| `stance_strike_plugged_y` | full | stance → guard | |

If `guard_arms_loop` looks stiff over the run, author full drawn cycles then — not before.

### Batch 4 — strings, unplugged

The eight strings do not need twenty-four clips. The first two hits are **shared**, and only the
finisher is unique — the finisher is what a player remembers.

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `attack_x1` | full | guard → guard | First hit of every X… string |
| `attack_y1` | full | guard → guard | First hit of every Y… string |
| `attack_x2` | full | guard → guard | Second hit after either |
| `attack_y2` | full | guard → guard | Second hit after either |
| `attack_xxx` … `attack_yyy` | full | guard → guard | **Eight finishers** |
| `attack_combat_entry` | full | sprint → guard | X while sprinting |
| `attack_slide` | full | slide → guard | |
| `attack_air_x` | full | air → air | |
| `attack_air_y_plunge` | full | air → guard | |

Twelve string clips, plus four.

### Batch 5 — strings, plugged

The same twelve with a `_plugged` suffix — `attack_x1_plugged` … `attack_yyy_plugged` — keying the
cable by hand. Plus:

| Clip | Body | From → to |
|---|---|---|
| `attack_explosive` | full | guard → guard |

### Batch 6 — bare hands and the grab

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `punch` | full | fists → fists | Bare-handed strings are still to design |
| `kick` | full | fists → fists | |
| `grab_attempt` | full | any → grab | |
| `grab_miss` | full | any → stand | Nobody to catch |
| `grab_hold_loop` | upper | grab | Over a slow walk: the human shield |
| `grab_throw` | full | grab → stand | |
| `grab_slap` | full | grab → grab | Sheathed X |
| `grab_knockout` | full | grab → stand | Sheathed Y |
| `grab_pommel` | full | grab → grab | Drawn X |
| `grab_execution` | full | grab → guard | Paired |
| `takedown_back` | full | crouch → crouch | Paired |
| `grab_struggle` | full | grab → grab | Paired — grabbed from the front |
| `stance_execution` | full | stance → guard | Paired — LB released on time |

### Batch 7 — aim, throw and cable

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `cut_horizontal` | full | aim → aim | X; the plugged reach is the cable, not another clip |
| `cut_vertical` | full | aim → aim | Y |
| `katana_throw` | upper | aim → aim | |
| `katana_catch` | upper | aim → guard | |
| `katana_recall` | upper | aim → aim | LT + RT |
| `anchor_pull` | full | aim → air | Pulled to a planted katana |
| `plug_throw` | upper | aim → aim | LT + RB |
| `enemy_pull` | upper | aim → guard | |

### Batch 8 — the TV and taking hits

| Clip | Body | From → to | Notes |
|---|---|---|---|
| `tv_toggle` | upper | any → same | Short |
| `tv_flash` | upper | any → same | |
| `idle_variation_a`, `_b` … | full | stand → stand | As many as wanted |
| `hit_light` | full | any → same | |
| `hit_heavy` | full | any → stand | |
| `knockdown` | full | any → ground | |
| `get_up` | full | ground → stand | |
| `death` | full | any | |

## Production order

1. **Build the rig and the seven hub poses.** Nothing else is worth animating before the bones and
   the poses are fixed — every clip is keyed against them.
2. **Batch 1**, exported and walking in Godot on a flat floor. **This is where the feel is decided**:
   the cycles, the start, the stop and the turn. Iterate here longest.
3. **Batches 2 and 3.**
4. **`attack_x1`, `attack_x2`, `attack_xxx`** alone — one full string — before the other seven
   finishers, to prove the chain and the timings in data.
5. The rest, batch by batch. **Paired clips last**: they need an enemy rig.
