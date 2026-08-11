# Provenance for Local Fields and Ramification

This dated file records the sources and portfolio migration behind the normative roadmap in
[`README.md`](README.md). It is not itself a prerequisite list.
It is explicitly non-normative: no roadmap milestone or dependency depends on it.

## Portfolio source and extraction boundary

The retained material comes from Tau Ceti PR
[#2](https://github.com/roed-math/TauCetiRoadmap/pull/2), source commit
`860e95df4902f4cc354def542347897d661cdcc1`.

| source material at that commit | destination after restructuring |
|---|---|
| Layers 0–4: local fields, units, unramified extensions, ramification, tame quotient | retained here |
| Layers 5–8: finite Tate cohomology, class formations, local reciprocity and duality | `ClassFieldTheory` |
| Layer 9 and the arithmetic pro-`p` interfaces: `G_K(p)`, rank, roots of unity and local presentations | `LocalGaloisGroups` |

The split is by mathematical ownership, not by deletion. A detailed portfolio migration ledger
recording every numbered and lettered source milestone is maintained privately as an internal
coordination artifact.

## Primary references

- Jean-Pierre Serre, *Local Fields*, especially Chapters II, IV, V, and XIII–XV.
- Jürgen Neukirch, *Algebraic Number Theory*, Chapters II and V.
- Neukirch–Schmidt–Wingberg, *Cohomology of Number Fields*, §7.5 for the tame quotient.
- Luis Ribes and Pavel Zalesskii, *Profinite Groups*, for free profinite groups and presentations.

## Lean projects surveyed

Survey dates below are inherited from the source roadmap and should be refreshed when the
corresponding implementation work begins.

### `kbuzzard/ClassFieldTheory`

Revision `ccc3323c6750abca25b49b35106f54eb3a398509` (checked 2026-08-06), Apache-2.0.
At that revision the project had sorry-free local-field instances, the valuation exact sequence,
canonical finite unramified extensions and `maximalUnramified`, the Teichmuller character, and
the `IsNonarchimedeanLocalField ℚ_[p]` instance. Positive-degree vanishing for unramified
units, the local-unit Herbrand quotient, the fundamental class, and the Artin map were still
open. The relevant files were `IsNonarchimedeanLocalField/ValuationExactSequence.lean`,
`IsNonarchimedeanLocalField/Unramified.lean`, `LocalCFT/Teichmuller.lean`, and `Qp.lean`.

Work that has landed in Mathlib is consumed from Mathlib. Any adaptation of unmerged code or
proof structure requires maintainer contact and an explicit record of the outcome. Its finite
Tate, class-formation, and reciprocity work is now relevant to the separate
`ClassFieldTheory` roadmap, not to this one.

### `Akwardbro/RamificationGroup`

Revision `c3fd8515a8e35c2876057ab59f4751be6638f3ab` (checked 2026-08-06). No licence file was found.
The repository is prior art for lower and upper ramification groups and Herbrand functions. At
that revision it was built on the `mariainesdff` stack rather than
`IsNonarchimedeanLocalField`, development had stopped in March 2026, and roughly 27 of 41 files
still contained `sorry`. No code, comments, or project-specific organization may be transferred
without licence clarification and author permission.

### `mariainesdff/LocalClassFieldTheory`

Revision `9ebdafa0b464df096037c10a2597c40f7e046602` (checked 2026-08-06). No licence file was found.
At that revision it had complete-DVR local fields and uniqueness of valuation extension, an
empty `ClassFormation.lean`, and no Lubin–Tate theory; development had stopped in July 2025. Its
valuation-extension and spectral-norm work that landed in Mathlib is consumed there. Unmerged
code remains citation-only unless the licence and permission are clarified.

### `davidturturean/gq2-lean-turturean`

GPL-3.0. This is comparison material only; its licence is not compatible with copying code into
Tau Ceti.

## Mathlib alignment

The roadmap follows Mathlib's `ValuativeRel` and `IsNonarchimedeanLocalField` vocabulary. The
2026 survey identified active work on valuative topology, valuation spectra, and inertia APIs,
but no complete upstream implementation of higher ramification groups or Herbrand functions.
An open Mathlib pull request is never a reason to block a milestone: implement the agreed Tau
Ceti API, then replace it with an upstream declaration when one lands.

The 2026-08-06 source audit tracked the `ValuativeRel` work in Mathlib PRs #26886, #26885,
#26827, #40309, #36769, #40315, #30135, #27181, #27180, and #38009; the ring-level
ramification/inertia work in #41591, #35808, #36843, #35991, #36733, #37031, #40955, #40387,
and #40952; and the formal-group work in #38213, #36167, and #41710. These are dated watch
items, not dependencies. No open Mathlib pull request implementing the higher ramification
groups or Herbrand functions required here was found in that audit.

The accepted continuous-cohomology carrier belongs to `ProfiniteCohomology`; this roadmap does
not create a competing carrier. Abstract pro-`p` Sylow and free-group theory belongs to
`ProfiniteProPGroups`. Arithmetic reciprocity and local duality belong to `ClassFieldTheory`.

## Convention audit

Implementations must keep the following translations explicit:

- Mathlib's multiplicative valuation has a uniformizer below `1`; the roadmap's additive
  normalization has value `1` on a uniformizer.
- Arithmetic Frobenius is the primary convention; geometric Frobenius is its inverse.
- Lower numbering is suited to subgroups and upper numbering to quotients.
- The tame quotient is the quotient by wild inertia and still contains prime-to-`p` inertia; it
  is not the maximal pro-`p` quotient.

## Downstream consumers

The stable consumers are `ClassFieldTheory`, `LocalGaloisGroups`,
`QuadraticFormInvariants`, and `AdelicAlgebraicGroups`. Consumer-specific acceptance labels are
kept in those roadmaps' provenance files rather than shaping this generic roadmap.
