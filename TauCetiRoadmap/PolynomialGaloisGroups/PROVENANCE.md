# Provenance for the polynomial Galois groups roadmap

**This file is not part of the specification.** The specification is
[README.md](README.md). This file records where the data came from, what was checked and when,
and how this material relates to work outside Tau Ceti. Everything here has a date and will go
out of date. No milestone of the roadmap depends on anything in this file.

Status date: 2026-08-07. Pinned Mathlib: `9caeba1000`, the revision named in the repository's
`lake-manifest.json`.

## What was checked, and how

Every claim in the README about what Mathlib provides was checked against the pinned revision,
by reading the declaration in the Mathlib source tree. The same checks were run against the
current released Mathlib, `v4.32.2`, and gave the same answers, so none of the claims below
depends on which of the two is in use. Three claims in an earlier draft were wrong at both, and
were corrected:

- `solvableByRad` is an `IntermediateField`, in the root namespace. It is not a predicate on
  polynomials, and it is not in the `Polynomial` namespace. Solvability by radicals of a
  polynomial is stated as membership of a root in that field. The predicate `IsSolvableByRad` is
  deprecated in Mathlib since 2026-02-28.
- `card_rootSet_eq_natDegree` is in `Mathlib/FieldTheory/Separable.lean`.
- The class `Algebra.IsInvariant` is in `Mathlib/RingTheory/Invariant/Defs.lean`. The theorem
  `Ideal.Quotient.stabilizerHom_surjective` is in `Mathlib/RingTheory/Invariant/Basic.lean`, and
  the map `Ideal.Quotient.stabilizerHom` itself is in `Mathlib/RingTheory/Ideal/Over.lean`.

These facts about the surrounding ecosystem were also checked on 2026-08-07.

- Mathlib has no statement of Chebotarev density in any form. The only occurrence of the name is
  in `docs/1000.yaml`, which lists theorems that are not formalized.
- `Mathlib/GroupTheory/GroupAction/Jordan.lean` still carries
  `proof_wanted alternatingGroup_le_of_isPreprimitive_of_isCycle_mem`.
- `Mathlib/GroupTheory/Perm/MaximalSubgroups.lean` still names the imprimitive case of
  O'Nan-Scott as its next target.
- The TODO list of `Mathlib/RingTheory/Polynomial/Resultant/Basic.lean` states the goal
  `resultant (∏ a ∈ s, (X − C a)) f = ∏ a ∈ s, f.eval a`. That is the product form of the
  resultant, from which the root-product formula for the discriminant follows. The discriminant
  formula itself is not stated there.

## Facts checked by computation for this pass

- The invariant of the resolvent sextic,
  `Φ = Σ_{a ∈ ℤ/5} x_a² (x_{a+1} x_{a−1} + x_{a+2} x_{a−2})`, has ten terms, all with
  coefficient 1. Its stabilizer in `S₅` is exactly `AGL(1,5)`, of order 20, and its orbit has six
  elements. The stabilizer was compared with `AGL(1,5)` as a set, so the containment is an
  equality.
- The quartic invariant `x₀x₂ + x₁x₃` has a stabilizer of order 8 and an orbit of size 3.
- The quintic pair sum `x₀ + x₁` has a stabilizer of order 12 and an orbit of size 10.
- For the depressed quartic `X⁴ + pX² + qX + r`, the three values `r₀r₂+r₁r₃`, `r₀r₁+r₂r₃`, and
  `r₀r₃+r₁r₂` are the roots of `X³ − pX² − 4rX + (4pr − q²)`, and that cubic has the same
  discriminant as the quartic. Both facts follow from the symmetric function identities
  `e₁e₃ − 4e₄` and `e₃² + e₁²e₄ − 4e₂e₄`, and were confirmed by expansion.
- Each row of the table of Layer 6 was confirmed by closure computation from the listed
  generators: the order, the parity, the primitivity, and the transitivity.
- The two counterexamples for the bound in Jordan's theorem were confirmed by closure
  computation. `AGL(1,5)` has order 20, is primitive on 5 points, and contains a 5-cycle.
  `AGL(1,8)` has order 56, is primitive on 8 points, and contains a 7-cycle with one fixed point.
- The discriminants of the worked examples were recomputed. For `x⁵ + ax + b` the formula is
  `256a⁵ + 3125b⁴`, which gives `32000²` for `x⁵ + 20x − 16`, `8000²` for `x⁵ − 5x − 12`, `50000`
  for `x⁵ − 2`, and `2869 = 19·151` for `x⁵ − x − 1`.
- Dedekind's cubic `x³ + x² − 2x + 8` has discriminant `−2012 = −2²·503`.

## Related work outside Tau Ceti

- **The Mathlib program of A. Chambert-Loir** is the substrate of Layer 1. At the pinned version
  his files are `GroupAction/{Blocks, Primitive, Transitive, MultipleTransitivity,
  MultiplePrimitivity, Jordan, Iwasawa}.lean`, the machinery in
  `GroupAction/SubMulAction/{OfStabilizer, OfFixingSubgroup, Combination}.lean`, and the files on
  simplicity of the alternating group and on maximal subgroups. Follow his vocabulary
  (`IsPreprimitive`, `IsBlock`) throughout. As of 2026-08-07 his open Mathlib pull requests are
  #33916 on simplicity of `PSL₂`, and #33692, #33560, #33485, and #33402 on Dieudonné's theorem
  and transvections. None of them overlaps this roadmap. We found no Zulip thread that claims any
  of the material built here; the discussion trail in this area is the review threads on his pull
  requests.
- **The certification line of C. Birkbeck** is a downstream consumer of Layer 8.
  `CBirkbeck/CertifyingInvariantsNF`, which extends `alainchmt/RingOfIntegersProject`, certifies
  rings of integers, discriminants, signatures, class groups, and units through one results file
  per field. It has no component for Galois groups. The revision inspected is
  `59ae55dbe49840d26d267a86c3e5c8f4a866d169`, of 2026-06-30. `CBirkbeck/LeanBridge` links LMFDB
  knowls to Lean declarations through its `DEFINES` macro; the label predicates of Layers 6 and 7
  are the declarations that the `gg.*` knowls should point at. That repository declares no
  licence in its GitHub metadata, and no author was contacted about reuse during this pass.
  Inspect the mathematics and the shape of the interface only. Copy and adapt no code and no
  data without explicit permission. The certificate structures of Layer 8 are therefore written
  independently.
- **Tau Ceti material already merged.** `TauCeti/NumberTheory/Multiquadratic/Galois/*` and
  `Multiquadratic/Frobenius.lean`, from the merged multiquadratic roadmap, prove the
  elementary-abelian instance of the pattern of Layers 0 and 5. They have `signPattern` as an
  explicit `Gal ↪ (ι → ZMod 2)`, with `exists_isArithFrobAt_multiquadratic`,
  `signPattern_frobenius`, and `galoisGroupEquiv_frobenius`. They consume Mathlib's
  `IsArithFrobAt`, which is the foundation the *supplier* of Layer 5's imported theorem builds
  on. Generalize those lemmas rather than duplicate them.

## Boundary with the number field roadmaps

Dedekind's factorization theorem is not proved in this roadmap. Number Field Arithmetic Layer
3.10 owns it, as `exists_gal_fullCycleType_eq_factorizationType`, and Layer 5 imports that one
declaration; §What this roadmap consumes in `README.md` is the normative contract, and this
paragraph is only the dated context for it.

That boundary was moved during the group review of the open roadmaps, on 2026-08-09. Layer 5
previously reconstructed the theorem from Mathlib, through the ring generated by the roots, a
maximal ideal over `p`, the surjection of a decomposition group onto a residue Galois group, and
the triviality of inertia. Those four milestones are gone; the supplier owns them, and the
statement it exports is already in the vocabulary of this roadmap — over a reducible `f`, with
the fixed points restored — so nothing here had to change shape to consume it.

Ramification theory of number fields remains outside this roadmap: the different, the relative
discriminant ideal, decomposition fields, inertia fields, the Artin symbol on ideals, and the
tame and wild exponents. It is now outside in a stronger sense than before, since no milestone
here has a proof that passes through any of it.

## Data provenance and licensing

The reference generators are mathematical data, and they are in this repository. The export is
`transitive_groups_export.json`, and `TransitiveGroupData.lean` is generated from it. The header
of that Lean file carries the source, the exact query, the retrieval date, the SHA-256 of the
export, the conversion from 1-based cycles to `Fin n`, and the row counts. Nothing has to be
fetched to read or to build the roadmap.

The data is cited to its publication, which is the paper of Butler and McKay. The LMFDB serves
the same numbering. The comparison with the `TransitiveGroup(n, j)` identifiers of GAP and Magma
is an external cross-check of the numbering only; no code and no data come from either system.

Every one of the 174 rows was recomputed from its generators alone, and agreed with the columns
of the export: the order by the Schreier-Sims algorithm, the parity from the signs of the
generators, transitivity from the orbit of a point, primitivity from the minimal block containing
each pair of points, and solvability from the derived series, each term being the normal closure
of the commutators of the generators of the previous one.

Outputs of PARI and GAP were used only to check data. No code from either system was used or
adapted. Nothing is ported from a source under the GPL. Layer 7 proves the invariants of each
reference subgroup from its generators, so the data needs no trust beyond the numbering itself.
