# Game design

The single home of every balance number. No number is chosen yet: every duration, range and speed
below is a word until it is written in **Balance values** and in its `.tres` under `data/`.

## Pitch

A third-person combat game with an over-the-shoulder camera. TVman has a television for a head, an
electric katana, and a power cable for a tail. The target is the handling of Metal Gear Solid V on
the character alone — before any enemy exists.

Buttons are named on an Xbox pad here; the full binding table is in [input-map.md](input-map.md).

## Movement

**On the ground**

- **Idle**, with variations.
- **Walk to run** — one continuous blend driven by how far the left stick is pushed.
- **Sprint** — L3.
- **Crouch** — R3. **Crouched walk** — the left stick while crouched.

**Chains**

- **Slide** — R3 while sprinting.
- **Long jump** — A during a slide. Keeps the slide's speed.
- **Slide into an enemy** — knocks them down; a dive kick can follow.
- **Roll out of a sprint** — B with a direction while sprinting.

**In the air**

- **Jump** — A. **Double jump** — A again in the air.
- **Dive kick** — R3 after the double jump.
- **Bounce** — a dive kick that lands on an enemy bounces TVman up and gives the double jump back.
- **Air attack** — X. **Plunging attack** — Y.

## Camera

- Over the shoulder, turned by the right stick.
- **D-pad left swaps the shoulder.** The camera glides across rather than cutting, and the aim
  point does not move, so a target held in the crosshair stays there.

## Defence

- **Guard** — hold LT.
- **Parry** — press LT on time. Every press of LT opens with a parry window, so the parry fires on
  the press, never on the release.
- **Dodge** — B with no direction. **Roll** — B with a direction.
- **Perfect dodge** — B on time.

## Draw stance — hold LB, katana sheathed

TVman takes the hilt and gets ready to draw.

- He can **walk slowly**, and **cannot jump**.
- **Release LB** — he draws.
- **Release LB just before a blow lands** — **instant execution**.
- **X or Y during the stance** — a stance strike. **He keeps the katana in hand afterwards.**

| Stance | X | Y |
|---|---|---|
| Katana unplugged | Stance strike X | Stance strike Y |
| Katana plugged | Plugged stance strike X | Plugged stance strike Y |

## Bare hands — katana sheathed or planted

- **X punches, Y kicks**, whether the katana is plugged or not.

## Grab — RT

- **Grab** — RT. **Throw** — RT again.
- **Throw into a group** — everyone the body hits goes down like skittles.
- **Human shield** — walk while holding the grab.
- **Silent takedown** — grab from behind while crouched. From the front, the enemy struggles.
- **Katana sheathed** — X is a **slap that intimidates**: the enemy surrenders or drops their weapon,
  and the enemies around them hesitate. Y is a **heavy blow that knocks out**.
- **Katana drawn** — X is a **pommel strike**, Y is an **execution**.
- **Screen flash** (hold D-pad up) — blinds the grabbed enemy, or the ones straight ahead.

## Katana, unplugged

- **Draw and sheathe** — tap LB.
- **Three-hit strings** — XXX, XXY, XYX, XYY, YXX, YXY, YYX, YYY.
- **Every movement above also exists with the katana drawn.**
- **Slide attack.**
- **Combat entry** — X while sprinting.

## Katana, plugged — RB

- **The eight strings have a plugged version.** The cable carries the **long, electric** attacks: Y
  opens strings where TVman fights with the cable itself.
- **Explosive attack** — X and Y together, when the gauge is almost empty. Afterwards, wall sockets
  stop recharging for a while.

## Targeted cut — hold LT, katana in hand

An arm to disarm, a leg to slow down.

| Katana | X | Y | Reach |
|---|---|---|---|
| Unplugged | Horizontal cut | Vertical cut | Normal |
| Plugged | Horizontal cut | Vertical cut | **Longer — the cable carries it** |

## Throwing the katana — LT + RT

1. **Throwing moves the cable to the katana**, even out of a wall socket. A katana is never thrown
   unplugged.
2. **If it hits nothing made for it**, it comes back on its own.
3. **If it hits a surface made for it**, it plants. A planted katana is an **anchor** TVman pulls
   himself to, or **electrifies the ground** around it.
4. **While it is planted**, TVman fights bare-handed. **LT + RT recalls it.**
5. **Past the cable's reach**, the cable comes loose. The katana stays planted and TVman has to
   **walk back to fetch it**.

## The cable

**The cable is in exactly one place: free, in the katana, or in a wall socket.**

| The cable is… | RB | LT + RB on a socket | LT + RB on an enemy |
|---|---|---|---|
| **Free** | Plugs the katana | Plugs into the wall | Pulls the enemy in |
| **In the katana** | Unplugs the katana | Moves to the wall | Pulls the enemy in |
| **In the wall** | Unplugs from the wall | Unplugs from the wall, aim held | Unplugs from the wall, aim held |

- **Plugged into a wall, no plugged attacks** — the cable is busy.
- **Walking too far from the socket unplugs.** The cable visibly pulls taut and the pad rumbles
  first.
- **No hopping straight from one socket to another**, and no pulling an enemy while in a wall.

## The gauge

**Draining**

- **Katana plugged** — the gauge drains with time, whether TVman strikes or not. When to plug in is
  the decision; the gauge does not care what happens once he has.
- **Unplugging the katana** stops the drain.
- **An empty gauge does not unplug.** There is simply no current.

**Recharging**

- **Only while plugged into a wall socket** — fast, with a generous cable reach. The gauge does not
  drain while TVman is in the wall.
- **After the explosive attack**, wall sockets stop recharging for a while.

## The television

- **Always on** by default, empty gauge included.
- **It is a torch first.** Lit in the dark, it also gives TVman away.
- **Tap D-pad up** — switches it off or on. **Hold** — flash.

## Enemies

**Their states — stunned, on the ground, in the air — are designed first when enemy work starts.**
They are what ties the moveset together: an attack says which state it causes and which state it
does something special to, and combinations appear without each one being authored.

## Later

- Electricity jumping from enemy to enemy through water or metal.
- A reward for unplugging.

## Balance values

_None yet. When one is chosen it is written here and in its `.tres` under `data/`, and nowhere
else._
