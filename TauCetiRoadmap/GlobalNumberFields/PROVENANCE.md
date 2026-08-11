# Global number fields: provenance and ecosystem audit

This file supports [`README.md`](README.md), which is the definitive roadmap. **Nothing here is
normative.** External repositories, source branches, review history, and dated ecosystem status are
not prerequisites.

Audit date: **2026-08-10**.

## Source roadmap material

The principal source was the corrected `roadmap/global-class-field-theory` branch of
`roed-math/TauCetiRoadmap`, read at
`5aa90a7a7bed6e2a0c6940ece96b5dafef4d823c`. The extracted material was:

- moduli, weak approximation, multiplicative congruences, ray and narrow class groups;
- adeles, ideles, the idele class group, topology, the global norm, and norm-one compactness;
- base change, Galois action, extension maps, and idele norm maps;
- the arithmetic part of the archimedean package;
- Hecke and ray class character carriers and infinity types;
- cyclotomic splitting and ramification;
- orders, conductors, proper ideals, and Picard groups.

Reciprocity, norm-index arguments, class fields, Hilbert reciprocity, ring class fields, and global
quadratic forms were intentionally not extracted. The master portfolio plan was used for that
ownership split only; no changed-file content from its coordination branch was used as a
mathematical source.

The source repository and this repository are Apache-2.0 licensed. The new roadmap rewrites and
reorganizes the specification rather than copying an external implementation.

The Number Field Arithmetic contracts were checked against local branch revision
`339413c45794df84c8de269ed2f40dc8a2724480`. In particular, the roadmap now abbreviates the
prime-to ideal group to that branch's `idealsAway` carrier instead of retaining the source
roadmap's duplicate `idealsPrimeTo` definition.

The extraction preserves the reviewed exact API names whose carriers remain owned here:
`primeToSubgroup`, `unitsCongruenceSubgroup`, `idealClass_eq_one_iff`, `finiteUnitsMap`, and
`ratModulus`. The first is a subgroup of `Kˣ`, distinct from the supplier-owned prime-to *ideal*
group; the second records the global-unit obstruction in the ray-class exact sequence. Their
earlier omission from `Suggested.lean` was compression loss, not an ownership change.

## Corrections made during extraction

The extraction changes several source-level choices.

1. Ray-class counting is promoted to an explicit arithmetic layer. The named exports
   `rayClassIdealCount` and `rayClassCharacter_partialSums` are required by Chebotarev; total ideal
   counting does not imply character cancellation in ray classes.
2. Mixed-place weak approximation is named `weakApproximation_denseRange`, because Global
   Quadratic Forms consumes the density theorem itself rather than only a congruence corollary.
3. Finite-place completion construction remains with Mathlib and Number Field Arithmetic; this
   roadmap owns the global place-indexed assembly.
4. `NarrowPic` is specified as a quotient of proper ideals. A quotient of all fractional ideals
   would ignore the multiplier-ring condition at a nonmaximal order.
5. Ring class fields move to Class Field Theory together with every other class-field existence
   construction.
6. The cyclotomic layer retains splitting, ramification, and carrier comparisons but no longer
   labels a global map there as reciprocity.

## Mathlib state used by the roadmap

At the project pin, Mathlib supplies:

- `HeightOneSpectrum`, `adicCompletion`, `InfinitePlace`, and infinite completions;
- `FiniteAdeleRing`, `AdeleRing`, and their canonical embeddings;
- the infinite-place weak approximation theorem
  `InfinitePlace.denseRange_algebraMap_pi`;
- `NumberField.prod_abs_eq_one` and the normalized infinite-place multiplicities;
- fractional ideals, class groups, the canonical embedding, ideal counting, and Dirichlet's unit
  theorem;
- cyclotomic fields and their ideal decomposition API.

The missing mixed-place weak approximation, ray-class counting, idele-class topology, Hecke
character carrier, infinity types, and nonmaximal-order theory are targets here.

## Coordination status

No external source-code permission issue is known. The roadmap is based on Apache-2.0 roadmap
material in the same repository family. Any later code port from another project must be audited
separately and recorded at its exact revision.

The exact declarations that need cross-branch signature alignment are:

```text
GlobalNumberFields.weakApproximation_denseRange
GlobalNumberFields.rayClassIdealCount
GlobalNumberFields.rayClassCharacter_partialSums
```

The first is consumed by Global Quadratic Forms. The latter two are consumed by Chebotarev.
