# Provenance for the profinite and pro-`p` groups roadmap

**This file is not normative.** [`README.md`](README.md) is the specification. Nothing here
is a prerequisite of a milestone. This file records dated ecosystem observations, migration
sources, licensing constraints, and the ownership split introduced by the arithmetic portfolio
restructuring.

## Portfolio migration record

This roadmap is the abstract part of `roed-math/TauCetiRoadmap` PR #3 at source revision
`da9fa831c97107f29381697e92044ae98c584dd0`. The source PR mixed general profinite and
pro-`p` theory with applications to maximal pro-`p` quotients of local absolute Galois groups.
The restructured boundary is:

- `ProfiniteProPGroups` retains supernatural order and index, Sylow theory, maximal pro-`p`
  quotients, Frattini and generator-rank theory, free pro-`C` and pro-`p` groups,
  presentations, cohomological freeness criteria, abstract Demushkin theory, completed group
  algebras, marked classification, and the standard presented group `D₀` with its marked
  generators and standard orientation;
- `LocalGaloisGroups` owns every declaration whose statement names a local field, its
  absolute Galois group or maximal pro-`p` quotient, a local cyclotomic character, a
  `[K : ℚ_p]` rank formula, or a marked identification of a local Galois group with `D₀`.

In particular, this roadmap exports `maximalProPQuotient` as a general construction but does
not define an absolute-Galois specialization. It exports `demushkinD0`, `d0A`, `d0S`, `d0Y`
and `standardD0Orientation`, but the theorem identifying `G_{ℚ₂}(2)` with that marked group is
downstream. The dependency is one-way: `LocalGaloisGroups` consumes this roadmap together
with `LocalFieldsRamification`, `ClassFieldTheory`, and `ProfiniteCohomology`.

## Mathlib work to watch

None of these projects is a prerequisite. If compatible declarations land, the roadmap keeps
its mathematical statements and adds comparison isomorphisms or removes redundant local
definitions.

- Continuous cohomology at the audited pin is carried by
  `Mathlib/Algebra/Category/ContinuousCohomology/Basic.lean`. A second line under
  `Mathlib/RepresentationTheory/Homological/ContCohomology/` appears in release `v4.32.2`.
  The `ProfiniteCohomology` roadmap owns explicit low-degree descriptions, exact sequences,
  change-of-group maps, and cups; this roadmap consumes that contract.
- Cup products for continuous cohomology existed in the FLT staging repository at
  `FLT/Mathlib/.../ContCohomology/CupProduct.lean` (FLT#1098, 2026-07-10), not in the
  audited Mathlib pin.
- Mathlib #35603 develops Frattini results for finite `p`-groups, the finite input to Layer 3.
- Mathlib #42200 develops `IsMulFG` unification, adjacent to topological finite generation.
- Mathlib #41961 and J. Pan's `lean-iwasawa` are adjacent to the completed group algebra used
  in the classification prerequisites.
- The `ProfiniteGrp` line includes #16648, #16992, #16993, #20740, #34893, #35540, and
  #39973, covering completion, residual finiteness, and additivization infrastructure.

The audit was performed on 2026-07-30 against Mathlib master `ccedd50412` and repeated on
2026-08-07 against release `v4.32.2`. At those snapshots there was no Mathlib-wide pro-`p`
predicate, supernatural order or index, profinite Sylow theory, topological Frattini theory,
free profinite presentation API, or Demushkin classification. These are dated observations,
not roadmap hypotheses.

## Same-owner implementation source

`roed-math/gq2-lean`, revision `d0714a7c431b64e18c422fb16cb5e93d79e5be25`, is
Apache-2.0 and has the same repository owner. It contains working single-instance
implementations that can inform the abstract milestones:

- `GQ2/ProfiniteQuotient.lean` informs Layer 0 quotients by closed normal subgroups.
- `GQ2/MaxProP.lean` informs Layer 3 `IsProP`, `proPKernel`, and the quotient universal
  property.
- `GQ2/FinitelyGenerated.lean`, `GQ2/FrattiniCriterion.lean`, and
  `GQ2/FrattiniNongen.lean` inform Layer 3 finite generation, Frattini detection, and
  Burnside-style surjectivity.
- `GQ2/FreeProfinite.lean` and `GQ2/ProfinitePresentation.lean` inform Layers 4 and 5 free
  objects and presentations by closed normal closure.
- `GQ2/Zhat.lean` supplies stress examples for Layers 0–2 and exponentiation calculations
  used by Layer 4.
- `GQ2/Demushkin.lean` informs the Layer 7 predicate. Its `demushkinQ` convention has no
  `q = 0` torsion-free case, so the roadmap ports the mathematical content, not that encoding.
- `GQ2/Orientation.lean` informs the abstract prescription property and uniqueness theorem.
  Its local cyclotomic identification is not a target here; it migrates to
  `LocalGaloisGroups`.
- `GQ2/Roe/Labute/{TwoCentralTower,Levelwise,StageLemma,SpanFoundation,GradedLie/*,Assembly}.lean`
  and `GQ2/Reconstruction.lean` inform Layers 8 and 9: lower 2-central towers, finite-level
  comparison, graded-Lie span arguments, compact assembly, and the Hopf step.
- `GQ2/Devissage*.lean` is outside this roadmap; it is project-specific self-duality
  machinery for a word complex.

The roadmap states each result intrinsically. Source choices such as universe placements,
`Nat.card` encodings, and project-specific marked generator names are not prescriptive.

## Other implementations, audit only

- `davidturturean/gq2-lean-turturean` is GPL-3.0 and had no immutable revision pinned in the
  audited branch. It contains an independent maximal pro-2 quotient and consumes the local
  classification as an axiom. **No code may be copied into Apache-licensed Tau Ceti without
  an explicit licensing decision.**
- `n-yamaguchi-0729/ProCGroups` is Apache-2.0, was created 2026-07-28, and had no immutable
  revision pinned in this record. It claimed overlapping free pro-`C`, maximal quotient,
  completed group algebra, and Fox-calculus material, but no Demushkin theory. Audit it
  declaration by declaration and contact the author before reuse; no milestone depends on it.

## Export and consumer boundary

The exact abstract names are pinned in [`Suggested.lean`](Suggested.lean). Important
downstream interfaces include:

- `proPKernel`, `maximalProPQuotient`,
  `maximalProPQuotient_zHat_equiv_padicInt`, `IsProP`, and `IsProPSylow`;
- `IsTopologicallyFinitelyGenerated`, `topologicalGeneratorRank`,
  `topologicalGeneratorRankNat`, and `proPFrattini`;
- `freeProfiniteGroup`, `freeProC`, `freeProP`, `presentedProfiniteGroup`, and
  `presentedProP`;
- `IsDemushkin`, `demushkinRank`, `demushkinQ`, `demushkinCharacter`, and
  `HasPrescriptionProperty`;
- `demushkinWordNeTwo`, `demushkinWordTwoOdd`, `demushkinWordTwoEven`, and the three marked
  classification theorems;
- `demushkinD0`, `d0A`, `d0S`, `d0Y`, `standardD0Orientation`, and its value theorems.

No export in this list carries a local-field hypothesis. `LocalGaloisGroups` supplies the
arithmetic carrier and proves that it satisfies these abstract interfaces.

## Coordination

Coordinate changes to Mathlib's `ProfiniteGrp` conventions with the authors of that line,
and changes to continuous cohomology with the `ProfiniteCohomology` roadmap. Register work
through this repository's claims process before beginning a substantial milestone. The
roadmap is tested against the repository's current manifest; updating that manifest remains
a repository-level decision.
