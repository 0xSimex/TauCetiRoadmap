# Completed roadmaps

Roadmaps the maintainers have declared complete. Completion is a human judgment against
the roadmap's `README.md`, which is the definitive document; it is never inferred from
`Suggested.lean`, which only records suggested declaration forms for particular milestones
and is not exhaustive.

A declared-complete roadmap is archived here, outside `TauCetiRoadmap/`, so it no longer
appears in the list of active areas offered to contributors (human or AI): the worker
tooling, the issue-template dropdowns, and the root README all enumerate the directories
under `TauCetiRoadmap/` only.

The archived Lean files are not part of the ordinary `TauCetiRoadmap` build. Archival material
should never need updating, and a roadmap nobody is working on should not redden the build every
time the Tau Ceti pin moves forward.

A `Discharged.lean` record is instead checked against the revisions it names itself. Each carries
a one-line `tauceti-discharge:v1` header giving the exact Tau Ceti, Mathlib and toolchain
revisions it elaborates against, and `.github/scripts/check_discharged.py` rebuilds it against
*those* in a scratch workspace. So the record is frozen and reproducible at once: it never needs
touching again, and the check can be re-run later against the revisions where it was true.

That script is run on demand and is deliberately not part of required CI. Re-verification leans on
artifact caches and toolchain availability outside this repository, and those decay; as a gate it
would eventually block work on a roadmap nobody is touching, whereas on demand it merely stops
being useful. The header is worth having regardless of whether the rebuild still runs, since it
records exactly what was checked and against what.

- [Effective arithmetic bounds and geometry of numbers](EffectiveBounds/README.md)
  (declared complete 2026-07-02)
- [Weighted orthogonal L² bases: completeness, Hilbert bases, and products of orthogonal systems](OrthogonalL2Bases/README.md)
  (declared complete 2026-08-15)
