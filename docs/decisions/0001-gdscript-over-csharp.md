# 0001 — GDScript, not C#

**Status:** Accepted
**Date:** 2026-09-14

## Context

Godot ships a standard build and a .NET build. The choice decides the language of every script and
the shape of every export.

## Decision

GDScript, statically typed, on the standard Godot 4.7.2 build. No `[dotnet]` block in
`project.godot`.

## Consequences

- Instant iteration: no build step between editing and running.
- No .NET runtime in the shipped bundle, and nothing extra to sign on macOS.
- The whole ecosystem's examples, addons and answers are GDScript first.
- Never add C# later without superseding this record.

## Alternatives rejected

**C#** — stronger typing, but a compile step on every change and a heavier release path.

**Hybrid GDScript plus C#** — powerful in a large team, and pure overhead in a small one.
