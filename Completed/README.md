# Completed roadmaps

Roadmaps the maintainers have declared complete. Completion is a human judgment against
the roadmap's `README.md`, which is the definitive document; it is never inferred from
`Suggested.lean`, which only records suggested declaration forms for particular milestones
and is not exhaustive.

A declared-complete roadmap is archived here, outside `TauCetiRoadmap/`, so it no longer
appears in the list of active areas offered to contributors (human or AI): the worker
tooling, the issue-template dropdowns, and the root README all enumerate the directories
under `TauCetiRoadmap/` only.

The archived `Suggested.lean` files are no longer built by CI. Archival material should never need
updating, and a roadmap nobody is working on should not redden the build every time the Tau Ceti
pin moves forward. Where a roadmap was closed out by discharging its targets in place, the file
carries a one-line `tauceti-discharge:v1` header naming the Tau Ceti, Mathlib and toolchain
revisions it elaborates against, and `.github/scripts/check_discharged.py` rebuilds it against
*those* in a scratch workspace. That script is run on demand and is deliberately not required CI:
re-verification leans on artifact caches and toolchain availability that decay, so as a gate it
would eventually block work for no one's benefit, whereas on demand it merely stops being useful.

- [Effective arithmetic bounds and geometry of numbers](EffectiveBounds/README.md)
  (declared complete 2026-07-02)
- [Weighted orthogonal L² bases: completeness, Hilbert bases, and products of orthogonal systems](OrthogonalL2Bases/README.md)
  (declared complete 2026-08-16)
