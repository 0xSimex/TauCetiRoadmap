# Provenance

This file is not normative. `README.md` is the definitive roadmap; this file records dated
evidence, audit results, and decisions, so that reviewers can check the roadmap's claims
without redoing the searches, and so that stale facts can be re-verified against their
dates.
No roadmap milestone or dependency depends on this file.

## Portfolio restructuring record

This retained roadmap is the refactoring of PR #13 at source revision
`d7ebb2e91eacb6cdc84342a7bf34183751d8e23d`. The review's mathematical content,
convention fixes, LMFDB audits, and source routes remain in place; the restructuring changes
only portfolio ownership and the corresponding Lean interfaces.

The dependency arrows are now one-way from BelyiMaps to the final supplier namespaces:
`TauCetiRoadmap.AlgebraicCurves`, `TauCetiRoadmap.PolynomialGaloisGroups`, and
`TauCetiRoadmap.ProfiniteProPGroups`. The local `fullCycleType` prototype was removed in
favour of `PolynomialGaloisGroups.fullCycleType`; transitive-group labels use
`PolynomialGaloisGroups.TransitiveGroupIndex`, `referenceSubgroup`, and
`TransitiveGroupLabel`; and the local free-profinite/free-pro-`p`, `proPKernel`,
`maximalProPQuotient`, and `zHat` carriers were removed in favour of their
`ProfiniteProPGroups` declarations. `Suggested.lean` imports the exact supplier files, so
these contracts fail visibly if a supplier spelling or carrier changes.

BelyiMaps continues to own the branch-cycle theorem and the generic pro-`ℓ`
peripheral-power theorem. It has no dependency on `LocalGaloisGroups`, `ClassFieldTheory`,
or a `PeripheralActions` roadmap.

## Mathlib pin audit

Pin `9caeba1000` (2026-06-03), audited 2026-08-08 by grep over the checked-out package.

Present, load-bearing (see README §What Mathlib supplies for the full table):
`Equiv.Perm` cycle theory with `Equiv.Perm.partition` (pads with `1`s; bare `cycleType`
does not), `MulAction.IsBlock`/`IsBlockSystem`/`IsPreprimitive` and the Jordan theorems,
Burnside (`MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group`), `FreeGroup` with
`FreeGroupBasis` and `PresentedGroup`, `IsCoveringMap` (moved to
`Mathlib/Topology/Covering/Basic.lean`; the old path is a deprecated forwarder),
`IsCoveringMap.monodromy` + `monodromyFunctor` + `monodromy_trans_apply`
(`Mathlib/Topology/Homotopy/Lifting.lean`), the lifting criterion
`existsUnique_continuousMap_lifts_of_range_le`, `isCoveringMap_exp` /
`isCoveringMapOn_zpow` (`Mathlib/Analysis/Complex/CoveringMap.lean`),
`CategoryTheory/Galois/*` including the profinite topology on `Aut F` and the equivalence
`functorToContAction` (`Equivalence.lean`) and `IsFundamentalGroup`,
`ProfiniteGrp.profiniteCompletion` with `eta`/`lift`/adjunction (`Completion.lean`),
`ContinuousMulEquiv`, `modularCyclotomicCharacter` and `cyclotomicCharacter`
(`Mathlib/NumberTheory/Cyclotomic/CyclotomicCharacter.lean`; the `ℓ`-adic one takes `L`
explicitly, is stated on `L ≃+* L`, and carries no continuity statement),
`Field.absoluteGaloisGroup` (a `def` with derived `Group`/`TopologicalSpace` instances),
`OnePoint ℂ` with `OnePoint.equivProjectivization` and the `GL(2)` action,
`analyticOrderAt`, `MeromorphicNFAt`, `IsManifold 𝓘(ℂ) ω` (sole nontrivial complex
manifold instance: `ℍ`), `Geometry/Manifold/Complex.lean` maximum-principle corollaries.

Absent (verified by search, multiple spellings): any semilocal simple connectivity class,
any topological Seifert–van Kampen, covering-space classification/deck groups/universal
covers, `ẑ`, procyclic predicates, `Out G` or any outer-automorphism carrier, a topology
on automorphism groups of topological groups (the `Galois/Topology.lean` construction for
`Aut F` is the pattern to copy), étale fundamental groups (the `Scheme.Etale` category
exists; nobody proves it Galois), a named `ℙ¹` scheme, Riemann surfaces, Riemann–Roch,
Riemann–Hurwitz, divisors in `AlgebraicGeometry`, triangle groups, ribbon graphs,
dessins, hypermaps. `CircularOrder` exists but connects to nothing about `Equiv.Perm`;
ribbon-graph rotations use `Equiv.Perm.IsCycleOn` instead.

Conventions verified in source, 2026-08-08 (these justify the pinned product relation):
`End.mul_def : xs * ys = ys ≫ xs` and `Aut_mul_def : f * g = g.trans f`
(`Mathlib/CategoryTheory/Endomorphism.lean`), and
`monodromy_trans_apply : cov.monodromy (γ.trans γ') e = cov.monodromy γ' (cov.monodromy γ e)`.
Together they make the fiber monodromy a `MonoidHom` and force
`σinf * σ1 * σ0 = 1` as the relation matching "γ0 then γ1 then γ∞ nullhomotopic".

## Supplier contract after restructuring

Dated 2026-08-10. The README cites layers, which are specifications; this records the exact
portfolio interfaces consumed after the PR restructuring.

- **CharacterTheory** (merged): Layers 0–2 implemented in TauCeti
  (`TauCeti/RepresentationTheory/CharacterTable/`); Layer 3 (character table,
  orthogonality) and Layer 4 (central characters) specified but not implemented. The
  conversion `ω_χ(K_j) = |C_j|χ(g_j)/χ(1)` is Layer-4 prose with no pinned Lean name. The
  Frobenius product-one formula appears nowhere in the family — confirmed by grep — hence
  the ownership decision in README §Boundaries.
- **UniversalCovers** (merged): its `Suggested.lean` has no named declarations; delivered
  `TauCeti.*` names include `deckFundamentalGroupEquiv` (lands in `(π₁)ᵐᵒᵖ`),
  `fiberEquivQuotientRange`, `basepointChangeSubgroup`, and the two
  classification criteria. Open as of today: the correspondence is not yet onto
  (`subgroupQuotientProj` not known to be a covering map), and `Deck ≅ N(H)/H` is
  unproved. Layer 6.3 here cites the milestone, and Layer 6.2's associated cover
  `(Ũ × S)/π₁` supplies the constructive direction independently. It consumes the universal
  cover and free proper discontinuity, but Mathlib's `IsQuotientCoveringMap` proves only that
  `Ũ × S → (Ũ × S)/π₁` is a covering. The required projection `(Ũ × S)/π₁ → X` is a
  different map; Layer 6.2 must establish its covering property by an equivariant sheet
  computation. Thus this roadmap does not wait on the two UniversalCovers gaps, but it does
  retain that additional proof obligation of its own.
- **ConformalMapping** (merged): `TauCeti.exists_localDegree` and the branch-root API are
  delivered. Its L0–L3 are declared temporary shims to be deleted when mathlib4#33505
  lands; Layer 8.2's consumption of L0 inherits that refactor obligation, which is a
  rename, not a mathematical dependency.
- **ModularForms** (merged): Layer 10B specifies the compact-Riemann-surface cohomology
  chain (Forster §§14–17 route) in prose for general compact Riemann surfaces; its
  `Suggested.lean` pins no Riemann-surface carrier (verified by grep), which is why this
  roadmap owns the carrier conventions (README §Boundaries).
- **AlgebraicCurves** is the final supplier of `IsFunctionField`, `Place`, `Divisor`,
  `riemannRochSpace`, `genus`, ramification data, and the regular-model/function-field
  interfaces consumed by Layers 9–11. BelyiMaps owns only the analytic comparison.
- **PolynomialGaloisGroups** is the final supplier of
  `PolynomialGaloisGroups.fullCycleType`, `numTransitiveGroups`,
  `TransitiveGroupIndex`, `referenceSubgroup`, and `TransitiveGroupLabel`. The old local
  cycle-type carrier has been deleted rather than retained as an alias.
- **ProfiniteProPGroups** is the final supplier of `freeProfiniteGroup` with `.of` and
  `.lift`, `proPKernel`, `maximalProPQuotient`, `freeProP` with `.of`, `zHat`, and
  `maximalProPQuotient_zHat_equiv_padicInt`. Its exponentiation stops at abelian pro-`p`
  groups, so BelyiMaps Layer 12.2 still owns the generic profinite exponent ring and power
  calculus needed by the branch-cycle application.
  **Owner ruling (2026-08-08, retained): the dependency is one-directional.** BelyiMaps
  cites ProfiniteProPGroups; ProfiniteProPGroups gains no row, citation, or dependency
  pointing here.

## Decisions of record

1. **The product relation is `σinf * σ1 * σ0 = 1`**, where the implementation plan this
   roadmap started from prescribed `σ0 * σ1 * σinf = 1`. The plan licensed a documented
   change when the API audit forces one, and it does: with Mathlib's `End`-multiplication
   and covariant monodromy (verified above), the plan's relation would make every
   monodromy correspondence an antihomomorphism or force inverses through Layers 6–13,
   including a spurious inverse in the branch-cycle exponent.

   ⚠ **The LMFDB agrees typographically and disagrees mathematically**, and an earlier
   draft of this file got that backwards. Its knowl displays `σ_∞σ_1σ_0 = 1` (fetched
   2026-08-08), but its stored triples are Magma-computed with left-to-right composition,
   so as functions they satisfy `σ0 ∘ σ1 ∘ σinf = id` — verified below against frozen
   records, not read off the display. So the roadmap's relation and the LMFDB's stored data
   are related by the componentwise-inversion involution of Layer 0.1, which is exactly why
   that involution is a Layer 0 milestone.
2. **The carrier is named `PermutationTriple`**, not the plan's `BelyiTriple`: "permutation
   triple" is the term of the LMFDB knowl and of Musty–Schiavone–Sijsling–Voight, and the
   object carries no Belyi structure.
3. **`C := (T * P)⁻¹`** (so `C·T·P = 1`), matching the topological relation; a source or
   consumer with `P·T·C = 1` names the conjugate `P·C·P⁻¹`, and Layer 13.3's lemma
   records the two-line transfer.
4. **Layer 12 is field-theoretic**: `π₁ᵍᵉᵒ := Gal(Ω/ℚ̄(t))` for `Ω` the maximal extension
   unramified outside the three marked places, so the carrier is Mathlib Galois theory
   plus AlgebraicCurves ramification, and no étale-π₁-of-schemes development is needed.
   The scheme-theoretic comparison is an explicit scope exclusion.
5. **Geometry type lives in Layer 0** (an order-triple invariant), with the
   triangle-group trichotomy in Layer 4; the plan had it in its passport layer. The LMFDB
   audit confirms the choice: its `geomtype` is a function of `abc` alone, agreeing with
   `1/a + 1/b + 1/c` against `1` on all 1111 records, and is independent of the genus.

6. **The generic profinite algebra opens Layer 12**, as milestones 12.1, 12.2 and 12.3,
   rather than sitting in Layer 13. The exponentiation calculus was in Layer 13 in the first
   draft, which made 12.10 and 12.11 depend forwards on it. All three depend on nothing else
   in this roadmap, so they can still be built first.

   ⚠ **12.1, the profinite integers as a topological commutative ring, is this roadmap's,
   because no supplier has it.** ProfiniteProPGroups supplies the profinite completion of the
   infinite cyclic *group*; Mathlib has no `ẑ` at all (§Mathlib pin audit, re-verified
   2026-08-09 by grep for `ZHat`, `ProfiniteInt` and "profinite integers": no hits). But
   `(x ^ᶻ a) ^ᶻ b = x ^ᶻ (a·b)` needs a multiplication of exponents, the cyclotomic
   character needs `ẑˣ`, and the pro-`ℓ` comparison needs a ring map `ẑ → ℤ_[ℓ]`. An earlier
   draft used all three while citing only the group; that is the gap this milestone closes.
   `Suggested.lean` builds the carrier as the subring of compatible systems in
   `∀ n : ℕ+, ZMod n`; the index runs over `ℕ+` because `ZMod 0 = ℤ` and every `n` divides
   `0`, so including `0` would collapse the limit to `ℤ`.
7. **The graph-cover engine is stated over a wedge of `k` circles**, so `k = 1` yields
   the punctured-disc classification (Layer 7.1) and `k = 2` the three-point theory, one
   construction serving both.
8. **No topological orientation theory**: Layer 7.2 delivers a charted topological
   surface; orientation content rides on the Layer 8.5 complex structure. The plan's
   "oriented topological surface" clause is discharged there.
9. **Compact-Riemann-surface cohomology is consumed from ModularForms 10B**, not built:
   the plan predated that roadmap's 10B chain and asked for the substrate here; the audit
   found 10B supplies it for general compact Riemann surfaces.

10. **The descent direction of Belyi's theorem goes through Köck's relative moduli field**,
    not through specialization and pigeonhole. See §Routes not used for the rejected route
    and why it is rejected; the table above records the exact statements the chosen route
    consumes.

11. **Algebraic Belyi pairs are defined over characteristic-zero base fields only.**
    Separability and tame ramification are used from README Layer 9.7 onwards, the standard
    examples degenerate in small characteristic (`t ↦ t^n` is inseparable when
    `char k ∣ n`; `4t(1−t)` is constant in characteristic `2`), and Layers 10–13 are
    characteristic-zero statements. The carrier therefore takes `[CharZero k]` and carries
    no separability hypothesis, which is implied. The **local data at a marked place is the
    multiset of pairs `(e, f)`**; the unweighted multiset of ramification indices is a
    partition of the degree only over an algebraically closed base, because `Σ e·f = n`.

## Routes not used

Recorded so that nobody mistakes a rejected route for the plan, and so that the reasons
survive.

**Specialization and pigeonhole, for the descent to `ℚ̄`.** An earlier draft descended a
Belyi pair over `ℂ` by spreading its coefficients out over a `ℚ̄`-variety `V`, specializing
at the `ℚ̄`-points where a finite list of discriminants and resultants is nonzero, and
concluding from finiteness in bounded degree that one isomorphism class occurs on a dense
subset and therefore at the generic point. **Two steps do not hold as stated.** First,
geometric integrality of a specialized cover is not captured by the nonvanishing of a finite
list of discriminants and resultants attached to one primitive polynomial. Second, and
fatally, "one class occurs on a dense subset, therefore the generic point lies in its base
change" is not a valid inference: it needs an isomorphism scheme, a constructibility
theorem, or a rigidity theorem, none of which this roadmap owns. Köck's route — (3.1) ⟹
(3.2) ⟹ (2.2) — reaches the same conclusion with Riemann–Roch and the `Aut(ℂ)` lemmas
alone, and is what README Layer 10.5–10.7 now specify.

**The raw plane model, for analytification.** An earlier draft analytified an algebraic pair
`F = ℂ(t)[y]/(m)` by taking the affine zero locus of `m`, observing it is a covering off the
discriminant, and "filling the discriminant fibers with all `e = 1`" by a
removable-singularity argument, justified by the fact that `F` is unramified there. That
does not work: the plane locus can be **singular** over a zero of the discriminant, several
branches can cross, and the fiber can have fewer points than the number of places — so there
is nothing for removability to extend. Algebraic unramifiedness is a statement about places,
and it becomes a statement about the covering only through the local comparison theorem now
stated as README Layer 9.6, which identifies the cycle lengths of the local monodromy with
the ramification indices of the places above the point. What the construction produces is
the **normalization**, one point per place; the map to the plane locus is injective only off
its singular points.

## External consumer note

The dyadic instance (Layer 13.4) is sized for the `gq2` project's axiom B8
(`GQ2.PeripheralCyclotomicAction` in `roed-math/gq2-lean`, inspected 2026-08-08):
`GQ2.Delta = maxProPQuotient 2 (FreeProfiniteGroup (Fin 2))` matches `Δ_2`;
`GQ2.deltaP/T` match `P_2, T_2`; `GQ2.deltaC = (P·T)⁻¹` is the conjugate `P·C_2·P⁻¹` of
this roadmap's `C_2`, handled by the Layer 13.3 transfer remark; the bundle's conjugation
convention `x ^ c = c⁻¹xc` matches the statement here; and the bundle's `ι`-pinning
(`hι_proj`: the `ẑ → ℤ_2` projection of the exponent is the unit) corresponds to the
Layer 12.3 component comparison. The bundle's citation of record — Stix, ASPM 63 (2012),
§3.3 and Definition 37, with Deligne (MSRI 16, 1989) as the classical origin, and the
all-units form needing cyclotomic surjectivity — is decomposed here as
Layer 12.11 (Stix's action) + Layer 13.2 (surjectivity). An adapter producing the `gq2`
bundle from Layer 13.4 is packaging, not mathematics, and lives outside this repository.

## Sources, verified

Read directly and checked against the README's citations, 2026-08-08. A fuller transcript
with verbatim quotations is in the session handoff notes.

**Köck, "Belyi's theorem revisited"** (local PDF, `references/`; arXiv:math/0108222), read
in full 2026-08-09. Belyi's theorem is **(3.3) Theorem** — also stated unnumbered in the
introduction, so a citation to "Theorem 1.1" is wrong. Degree reduction is **(3.5) Lemma**,
whose well-founded measure is `#S` for `S` closed under conjugation over `ℚ`, *not* a field
degree. The Belyi polynomial is **(3.6) Lemma**,
`q₁(z) = ((m+n)^{m+n}/(m^m n^n)) z^m (1−z)^n`.

**The descent direction, statement by statement**, since README Layer 10 is now built on it:

| Köck | statement |
| --- | --- |
| **(1.4) Lemma** | every automorphism of a subfield `K ⊆ ℂ` extends to `ℂ`, and `ℂ^{Aut(ℂ/K)} = K` |
| **(1.5) Lemma** | if `Aut(ℂ/K) ⊆ U` for a **finite** extension `K/ℂ^U`, then `U` is closed |
| **(1.6) Lemma** | `[U : V] < ∞` ⟹ `ℂ^V/ℂ^U` finite, with `[ℂ^V : ℂ^U] ≤ [U : V]` when `V ⊴ U` or `U` closed, and `=` when `V` closed |
| **(1.9) Theorem** | Weil's criterion, weakened: a finite `G ≤ Aut(L)` with birational `f_σ : X^σ → X` satisfying `f_{στ} = f_σ ∘ f_τ^σ` gives a model over `L^G` up to birational equivalence |
| **(1.10) Lemma** | Galois descent: `L ⊗_{L^G} W^G ≅ W` for a semilinear action of a finite `G ≤ Aut(L)` on an `L`-vector space `W` |
| **(2.1) Definition** | `M(X,t) := ℂ^{U(X,t)}`, with `U(X,t)` the `σ` admitting `f_σ : X^σ → X` with `t ∘ f_σ = Proj(σ) ∘ t^σ` |
| **(2.2) Theorem** | `X` and `t` are defined over a **finite extension** of `M(X,t)`, and over `M(X,t)` itself when `t` is Galois |
| **(3.1) Proposition** | finitely many isomorphism classes of degree-`d` pairs with critical values in a fixed finite `S` |
| **(3.2) Corollary** | if the critical values are `K`-rational then `M(X,t)` lies in a finite extension of `K` |

⚠ **(2.2) needs neither (1.8) nor Weil descent.** Its proof is explicit: pick `Q ∈ ℙ¹(ℚ)`
unbranched and `P` above it, use Riemann–Roch on `(g+1)[P]` to get `z` with `P` its only
pole, take the pole order minimal, normalize the Laurent expansion in the local parameter
`t − Q` so the leading coefficient is `1` and the constant term `0` — which makes `z`
**unique** — and observe that `U(X,t,P)`, of finite index in `U(X,t)`, fixes `z` and hence
the coefficients of its minimal polynomial; (1.6) then puts them in a finite extension of
`M(X,t)`. (1.9)/(1.10) are used only in his §1, on the *absolute* moduli field.

⚠ Two gaps in Köck that the roadmap must discharge rather than cite: (3.6) applies the
induction hypothesis without showing the cardinality has dropped, and its hypothesis
`T ⊆ ℚ` does not match the `Crit(p) ∪ p(S) ⊆ ℚ ∪ {∞}` supplied to it. Both are recorded at
README Layer 10.2.

⚠ **The critical set of `x^m(1−x)^n`.** `B′_{m,n}` is a constant times
`x^{m−1}(1−x)^{n−1}(m − (m+n)x)`, so its zero set is **contained in** `{0, 1, m/(m+n)}`,
with equality only when `m > 1` and `n > 1`. At `B_{1,1} = 4x(1−x)` the only critical point
is `1/2`. README Layer 10.3 states the containment.

**Stix, "On cuspidal sections of algebraic fundamental groups"**, ASPM 63 (2012), 519–563.
The cyclotomic action on cuspidal inertia is **Definition 37(i)**, in **§7 "Orientation and
degree"** — a commutative square which for a decomposition-group element reads
`γ x γ⁻¹ = x^{χ(γ)}`, the exponent **not** inverted. ⚠ Three traps: it is not in §3.3, which
only sets up inertia and decomposition groups and contains no cyclotomic formula; the
numbering exists only in the published ASPM version, the arXiv preprint (0809.0017) carrying
the same content as unnumbered text in §7.1; and Stix's `π₁` is the opposite group of
`Aut(Ũ/U)` (§3.1), compensated by the inverse in his Definition 10, so the pair of
conventions cancels and the exponent is unaffected. Stix does not write `σ(ζ) = ζ^{χ(σ)}`
explicitly; it is pinned by his §7 definition of `Ẑ(1)` and by Definition 38, which makes
the standard orientation the tame character `σ ↦ σ(ⁿ√f)/ⁿ√f`.

**Fried**, Comm. Algebra 5 (1977): the branch cycle lemma is **(5.2)**, with exponent
`−c_γ` in his normalization (`γ(ζ_N) = ζ_N^{c_γ}`), the conjugation landing in
`N_{S_n}(G)`, and the statement relating **conjugacy classes only**, never representatives.
⚠ Völklein's restatement (p. 39) uses the opposite sign again. The roadmap's Layer 12.11 is
pinned by its own Kummer identity for exactly this reason.

**Lando–Zvonkin**, *Graphs on Surfaces*: the genus statement is **Proposition 1.5.3**
(p. 44), `χ(H) = c(σ) + c(α) + c(φ) − n = 2 − 2g`, for a hypermap = 3-constellation
(Definition 1.5.1), which is a transitive product-one triple by Definition 1.1.1.
⚠ **Their proof is topological**, so `χ ≤ 2` and the parity come there from the surface's
existence — the roadmap's Layer 0.6 deliberately proves them combinatorially instead, and
says so. Earlier drafts of this file cited "Theorem 1.3.10" and "1.2.20": both exist but are
the wrong results (the Euler characteristic of a *map*, and Construction 1.2.20 =
Riemann–Hurwitz).

**Couveignes**, "Calcul et rationalité de fonctions de Belyi en genre 0", Ann. Inst.
Fourier 44 (1994), open access on Numdam: **Théorème 3** ("Critère de Weil", p. 22) is the
accessible form of Weil's descent criterion (Köck cites Weil's original as his Theorem 1);
**Théorème 8** descends a genus-zero Belyi map whose automorphism group is cyclic of odd
order — trivial included — to the field of moduli, ⚠ **but on a conic, not necessarily on
`ℙ¹`**; §8.3 gives the Hilbert-symbol obstruction in the cyclic even-order case. README
Layer 11.6 carries the conic caveat.

**Girondo–González-Diez** and **Forster** were read directly on 2026-08-08 from the copies
in `~/claude/references`; per-statement extracts are in `ggd-extract.md` and
`forster-extract.md` beside them, and the numbers are folded into the README's `*Source:*`
lines for Layers 4.1, 4.4, 4.5, 5, 6.1, 6.3, 6.5, 7.1, 7.4, 8.1–8.3, 8.5, 8.6, 9.2, 9.3,
10.6, 12.12 and 13.5. Four findings changed the roadmap rather than annotating it:

- **Girondo–González-Diez Theorem 4.49** proves faithfulness on genus-zero dessins by
  **Lenstra's** argument — the polynomial `p_α = ∫ x(x−1)²(x−α)³` with its three *pairwise
  distinct* critical multiplicities `2, 3, 4`, plus **Lemma 4.50** — and **Theorem 4.48**
  states faithfulness for every genus, proved genus by genus. Layer 13.5 was rewritten onto
  Lenstra's route, which is elementary and stays in `ℚ̄[x]`; it previously used an
  elliptic-curve `j`-invariant argument, and so previously depended on AlgebraicCurves
  Layer 10 and on Mathlib's `WeierstrassCurve.ModelsWithJ`/`IsomOfJ`. Those dependencies are
  now gone.
- **Its §2.4 supplies no matrices and no trace formula** for the general hyperbolic triangle
  group, and its abstract presentation is unnumbered prose citing Jones–Singerman rather than
  a proved statement; the geometric route runs through **Theorem 2.27** (Poincaré's polygon
  theorem). Layer 4.5 therefore owns its explicit `PSL(2,ℝ)` construction and says so. Katok,
  which the earlier draft cited for those matrices, is dropped rather than left unverifiable.
- **Its §3.8 contains no field-of-moduli-versus-field-of-definition statement**, verified by
  whole-book search, which confirms Layer 11.6's reliance on Couveignes rather than on this
  book.
- **The phrase "Riemann existence theorem" does not occur** in its chapters 1–4. Layer 8.6
  now cites **Theorem 2.61** and **Proposition 2.63** by number and records that the name is
  this roadmap's.

⚠ **A third convention witness.** Girondo–González-Diez p. 148 defines monodromy as
`M_f(γ) = σ_γ⁻¹` and p. 149 states: "Notice that if we had chosen to define `M_f(γ) = σ_γ`
we would have obtained an anti-homomorphism." Their `π₁` composes paths in the geometers'
order, the pin's `End.mul_def` composes in the opposite one, so the un-inverted `σ_γ` is the
homomorphism *here*. Their triples are therefore the componentwise inverses of this
roadmap's, exactly as the LMFDB's are — three conventions, one Layer 0.1 involution between
them. Verified against the page, not inferred.

**Szamuely, *Galois Groups and Fundamental Groups* (CSAM 117)** was read 2026-08-08 (an
earlier copy supplied was Gille–Szamuely's *Central Simple Algebras and Galois Cohomology*, a
different book; that gap is closed). Its Chapter 4 is Layer 12 nearly milestone for
milestone:

| Layer | Szamuely |
| --- | --- |
| 12.4 the `ℚ̄`/`ℂ` comparison | **Theorem 4.6.10**, **Corollary 4.6.11** (base change between algebraically closed fields of characteristic `0` is an equivalence on finite étale covers) |
| 12.6 the comparison isomorphism | **Example 4.6.12(3)**: `π₁(ℙ¹ ∖ {0,1,∞})` is free profinite on two generators; **4.6.12(2)** is the Kummer case `≅ ẑ` |
| 12.8 the exact sequence and outer action | **Proposition 4.7.1** and the definition of `ρ_U : Gal(k̄|k) → Out(π₁(U_k̄))` in §4.7 |
| 12.9 peripheral inertia | **Lemma 4.7.2** (the stabilizer of a pro-point over a `k`-rational point is its inertia group) |
| 12.10 the cyclotomic character | **Example 4.7.4** (constructed as `Gal(k̄|k) → Aut(ẑ) ≅ ẑ^×`) |
| 12.11 the branch-cycle theorem | **Remark 4.7.5**: the action on inertia is by the cyclotomic character in characteristic zero, by Kummer theory on a local parameter |

⚠ **A fourth witness for the exponent, and it is non-inverted.** Example 4.7.4 fixes the
direction explicitly: `σ` carries the automorphism `ⁿ√t ↦ ω_n·ⁿ√t` to `ⁿ√t ↦ σ(ω_n)·ⁿ√t`,
which with `σ(ω_n) = ω_n^{χ(σ)}` is `γ ↦ γ^{χ(σ)}`. That agrees with this roadmap's own
Kummer computation and with Stix's Definition 37(i), against Fried's `−c_γ` and Völklein's
opposite sign — the disagreement being conventions, not mathematics.

⚠ **Corollary 4.7.3 corrected a warning in Layer 12.8.** When `U` has a `k`-rational point
the exact sequence *splits*, and `ℙ¹_ℚ ∖ {0,1,∞}` has many. So the earlier draft's "a lift
exists only after choosing a rational or tangential basepoint, which is outside this roadmap"
understated the situation: lifts exist and are easy; what fails is **canonicity**, since each
rational basepoint gives its own splitting. The milestone now says that.

Still to locate for numbering: Serre (*Topics in Galois Theory*), Deligne (MSRI 16),
MSSV (ANTS XIII), Dixon–Mortimer (GTM 163).

## LMFDB state

Two independent retrievals, both 2026-08-08: the JSON API
(`https://www.lmfdb.org/api/belyi_galmaps/?_format=json&...`), and the LMFDB source
together with a full read-only pass over the `belyi_*` tables of the project's own dev
mirror. The source is `github.com/LMFDB/lmfdb` **main at `e2039c3`** (2026-08-07); the
`lmfdb/belyi/` and `scripts/belyi/` trees were verified byte-identical to it. Table sizes:
`belyi_galmaps` 1111 rows, `belyi_passports` 1007, `belyi_galmap_portraits` 915,
`belyi_specializations` 5106 (the last referenced by no application code).

⚠ The in-repo `scripts/belyi/Schema.md` is stale and must not be used: it omits
`is_primitive`, `primitivization`, the `plane_*` columns and others. The column lists below
come from `information_schema`, not from it.

⚠ The API rate-limits to a CAPTCHA challenge after roughly six requests in a minute;
pacing at one request per 75–90 seconds runs clean. It also requires typed query values
(`deg=i4`, not `deg=4`), ignores `_limit`, and paginates by `_offset` in pages of 100.

### The composition convention, verified

The knowl `belyi.permutation_triple` (fetched 2026-08-08) defines a permutation triple as
`σ = (σ_0, σ_1, σ_∞) ∈ S_d³` with `σ_∞σ_1σ_0 = 1`, and states no composition order. The
order is settled by the stored data. Reading `triples_cyc` as cycle notation and composing
in Mathlib's convention `(f * g)(x) = f (g x)`:

| record | `σ0` | `σ1` | `σinf` | `σ0 ∘ σ1 ∘ σinf` | `σinf ∘ σ1 ∘ σ0` |
| --- | --- | --- | --- | --- | --- |
| `3T2-3_2.1_2.1-a` | `(1,2,3)` | `(2,3)` | `(1,2)` | `id` | `1 ↦ 3` |
| `4T3-4_2.2_2.1.1-a` | `(1,2,3,4)` | `(1,2)(3,4)` | `(1,3)` | `id` | `1 ↦ 3` |
| `4T5-4_3.1_2.1.1-a` | `(1,2,3,4)` | `(2,4,3)` | `(1,2)` | `id` | `1 ↦ 4` |

So the stored triples satisfy **`σ0 * σ1 * σinf = 1`** in Mathlib's multiplication: the
LMFDB composes left to right, as its Magma provenance implies. The roadmap's relation
(`σinf * σ1 * σ0 = 1`) is therefore the componentwise inverse of the stored one, which is
Layer 0.1's involution, and Layer 14.2's translation lemma is exactly that involution.

**Checked exhaustively, not sampled.** Over all 4734 stored triples of `belyi_galmaps`,
`σ0 ∘ σ1 ∘ σinf = id` holds in **4734 of 4734**; the reverse order holds in only 18 (those
being the records symmetric under the swap). The two `decide`-checked `example`s in
`Suggested.lean` reproduce one instance of this in Lean.

⚠ The LMFDB source contains **no comment, docstring, or identifier anywhere** stating the
composition convention — a grep over `*.py`, `*.m`, `*.md`, `*.html` for `convention`,
`compose`, `left to right` and the like turns up nothing relevant. The convention is
recoverable only from the data, which is why it is recorded here as a computation.

⚠ Records whose data is symmetric under the swap do not discriminate — `2T1-2_2_1.1-a`
(`σ1 = σ0`, `σinf = 1`) and every `[n]/[n]/[1ⁿ]` record satisfy both orders. A convention
check must use a record with three distinct non-commuting entries; the three above are
recorded because they do.

The one-line `triples` and the cycle `triples_cyc` agree: `[2,3,4,1]` is the image list
`1↦2, 2↦3, 3↦4, 4↦1`, that is `(1,2,3,4)`.

### Schema

`belyi_galmaps` columns: `BelyiDB_label, BelyiDB_plabel, a_s, abc, aut_group, b_s,
base_field, base_field_label, c_s, curve, curve_label, deg, embeddings, friends, g,
geomtype, group, group_num, id, is_primitive, label, lambdas, map, orbit_size, pass_size,
plabel, plane_constant, plane_map_constant_factored, plane_model, primitivization, triples,
triples_cyc`.

`belyi_passports` columns: `BelyiDB_plabel, a_s, abc, aut_group, b_s, c_s, deg, g,
geomtype, group, group_num, id, is_primitive, lambdas, maxdegbf, num_orbits, pass_size,
plabel, primitivization, triples`. There is no `base_field`, `curve`, `map`, `friends` or
`orbit_size` at passport level, and `maxdegbf` exists only there.

Four schema facts that a Lean-side record type must respect:

1. **`curve_label` is absent, not null**, on records with no curve friend. The option must
   be keyed on key-presence.
2. **`(a_s, b_s, c_s)` is `abc` sorted ascending** — verified 1111/1111, and `abc`
   itself is *not* sorted: it is `(ord σ0, ord σ1, ord σinf)` in that order, and 1022 of
   1111 rows are not ascending while 555 are not monotone in either direction
   (`5T5-4.1_2.2.1_3.2-a` has `abc = [4,2,6]`). The `a_s`/`b_s`/`c_s` columns exist only to
   serve search (`query_convert_abc_list` sorts the user's input before matching) and are
   never displayed. ⚠ An earlier draft of this file said "reversed", inferred from two
   records that happened to be descending; the sorted reading is the one that holds on all
   1111.
3. **`geomtype` is not a function of `g`.** `4T4-3.1_3.1_3.1-a` has `g = 0` and
   `geomtype = "E"`; `4T5-4_4_3.1-a` has `g = 1` and `geomtype = "H"`. The field records
   the orbifold trichotomy from `1/a + 1/b + 1/c` against `1`, exactly Layer 0.7's
   `geometryType`, and never the genus.
4. **`pass_size` counts isomorphism classes, and is not a count of stored rows.** It
   appears on both record levels and means the passport's size on both; `orbit_size` is the
   individual map's Galois orbit size; `num_orbits` is passport-only. Verified over the
   whole table:

   | claim | holds |
   | --- | --- |
   | `pass_size` = number of simultaneous-`S_d`-conjugacy classes among `passport.triples` | **1007 / 1007** |
   | `num_orbits` = number of galmap rows with that `plabel` | **1007 / 1007** |
   | `maxdegbf` = max `orbit_size` over the passport's galmaps | **1007 / 1007** |
   | `len(galmap.triples)` = `galmap.orbit_size` | **1111 / 1111** |
   | `Σ orbit_size` over a passport's galmaps = `pass_size` | 1005 / 1007 |
   | `len(galmap.triples)` = `pass_size` | 923 / 1111 |

   ⚠ **`Σ orbit_size = pass_size` is NOT an identity** and must not be asserted as one. It
   fails exactly when a Galois orbit's per-embedding triples are simultaneously conjugate to
   one another — the two witnesses are `8T37-4.4_4.4_3.3.1.1` (two stored triples, one
   class, `pass_size = 1`) and `8T37-4.4_3.3.1.1_3.3.1.1` (four stored, two classes,
   `pass_size = 2`). An earlier draft of this file and of README Layer 14.3 asserted the
   identity; both are corrected.

   ⚠ **Those two witnesses also refute `orbit_size = trueOrbitSize`.** The stored count is
   `len(galmap.triples)`, verified 1111/1111 above — a count of **embedding entries**. On
   the two records it exceeds the number of Belyi-pair isomorphism classes they reach,
   because different stored embeddings give simultaneously conjugate triples and hence, by
   the Riemann-existence dictionary, the same class. So the stored field cannot in general
   be the cardinality of the Galois orbit of a class. README Layer 11.7 states the correct
   relation as a surjection `G/H ↠ G/S` of coset spaces, and README Layer 14.2 keeps
   `storedEmbeddingCount` and `trueOrbitSize` as two named quantities with one theorem
   between them.

   The knowl `belyi.pass_size` reads "The number of isomorphism classes of Belyi maps
   belonging to a given passport", which is exactly Layer 1.2's `passportSize`, and an
   independent exhaustive enumeration confirms it: for every passport of degree ≤ 7,
   `pass_size` equals the number of transitive product-one triples of the prescribed
   ramification type with monodromy in the given `dTt` class, up to simultaneous
   conjugation — 251 of 251, with the degree-8 and degree-9 checks agreeing once transitive
   classes of equal order are separated.

5. **`maxdegbf` means maximum orbit size**, despite the name suggesting a base-field
   degree; the interface labels it "Maximum orbit size". It coincides with the maximum
   base-field degree on 1003 of 1007 rows only.

6. **`triples_cyc` omits fixed points** — cycle-notation strings with no 1-cycles, the
   identity written `"()"`. Recovering `lambdas` from `triples_cyc` therefore requires
   padding, which is Layer 0.5's `fullCycleType` trap in database form. `triples` is
   one-line image notation, 1-indexed.

7. **`embeddings` is indexed against `triples`/`triples_cyc` position by position**, and
   the application relies on it: the `i`-th embedding is substituted for the base-field
   generator when rendering the `i`-th triple's curve and map. Layer 14.2's embeddings
   statement is about that correspondence, not about the values.

### Frozen acceptance records (Layer 14.6)

Five records, covering genus zero, positive genus, primitive, imprimitive, a
multiple-orbit passport, and links to both an elliptic and a genus-two curve.

1. **`4T1-4_4_1.1.1.1-a`** — genus 0, imprimitive. `deg 4`, `g 0`, `group "4T1"`,
   `abc [4,4,1]`, `lambdas [[4],[4],[1,1,1,1]]`, `geomtype "S"`, `is_primitive false`,
   `primitivization "2T1-2_2_1.1-a"`, `base_field_label "1.1.1.1"`, `orbit_size 1`,
   `pass_size 1`, `curve "PP1"`, `map "-1/(x^4-1)"`,
   `triples_cyc [["(1,2,3,4)","(1,4,3,2)","()"]]`, `friends []`.
2. **`3T2-3_2.1_2.1-a`** — genus 0, primitive. `deg 3`, `g 0`, `abc [3,2,2]`,
   `lambdas [[3],[2,1],[2,1]]`, `geomtype "S"`, `is_primitive true`,
   `base_field_label "1.1.1.1"`, `map "1/2/(x^3-3/4*x+1/4)"`,
   `triples_cyc [["(1,2,3)","(2,3)","(1,2)"]]`.
3. **`3T1-3_3_3-a`** — genus 1, primitive, linked elliptic curve over a number field.
   `deg 3`, `g 1`, `abc [3,3,3]`, `lambdas [[3],[3],[3]]`, `geomtype "E"`,
   `base_field [1,-1,1]` (that is `x² − x + 1`, so `ℚ(ζ₆)`), `base_field_label "2.0.3.1"`,
   `embeddings [[0.5, 0.8660254037844387]]`, `curve "y^2=x^3+1"`,
   `curve_label "2.0.3.1-144.1-CMa1"`, `friends ["EllipticCurve/2.0.3.1/144.1/CMa/1"]`,
   `triples_cyc [["(1,2,3)","(1,2,3)","(1,2,3)"]]`. The smallest record whose base field is
   not `ℚ`.
4. **`5T1-5_5_5-a`, `-b`, `-c` and the passport `5T1-5_5_5`** — genus 2, primitive, a
   passport with three Galois orbits. Passport: `num_orbits 3`, `pass_size 3`,
   `maxdegbf 1`, `lambdas [[5],[5],[5]]`, `geomtype "H"`, and `triples` listing exactly the
   three galmaps' triples. The three galmaps have `orbit_size 1` each and
   `base_field_label "1.1.1.1"`, with curves `y^2=x^6+2*x`, `y^2=x^6-2*x`,
   `y^2=4*x^5+1/4` and `triples_cyc` respectively
   `[["(1,2,3,4,5)","(1,4,2,5,3)","(1,2,3,4,5)"]]`,
   `[["(1,2,3,4,5)","(1,2,3,4,5)","(1,4,2,5,3)"]]`,
   `[["(1,2,3,4,5)","(1,3,5,2,4)","(1,3,5,2,4)"]]`. This is the roadmap's witness that a
   passport is not a Galois orbit.
5. **`6T6-6_6_3.3-a`** — genus 2, imprimitive, linked genus-2 curve. `deg 6`, `g 2`,
   `abc [6,6,3]`, `lambdas [[6],[6],[3,3]]`, `geomtype "H"`, `is_primitive false`,
   `primitivization "3T1-3_3_3-a"` (record 3 above, so the pair also freezes the
   primitivization relation), `curve "y^2=x^6+4*x^4+6*x^2+3"`,
   `curve_label "1728.b.442368.1"`, `friends ["Genus2Curve/Q/1728/b/442368/1"]`,
   `triples_cyc [["(1,6,2,4,3,5)","(1,3,5,4,6,2)","(1,3,5)(2,4,6)"]]`.

Other multiple-orbit passports available if a different witness is wanted:
`5T4-5_5_3.1.1` (2 orbits, size 2), `6T12-5.1_5.1_3.3` (2, 2), `6T15-5.1_4.2_4.2` (2, 4),
`6T15-5.1_5.1_4.2` (2, 8), `6T15-5.1_5.1_5.1` (4, 8), `6T16-5.1_3.2.1_3.2.1` (2, 7),
`6T16-6_6_5.1` (2, 7). The `6T15` family is where base fields become interesting:
`6T15-5.1_5.1_4.2-a` has `base_field_label "4.0.14400.3"` and `-b` has `"4.2.24000.2"`,
two different quartic fields inside one passport.

### The complete degree ≤ 4 table (Layer 3.5)

Thirteen galmaps and thirteen passports, in bijection: every passport at these degrees has
`num_orbits = 1`, `pass_size = 1`, `orbit_size = 1`, `maxdegbf = 1`. Confirmed three ways —
per-degree queries returning 1, 1, 3, 8 with exhausted pagination; the label-ordered first
page; and the passport listing.

| label | deg | g | group | abc | lambdas | geomtype | prim | base field | primitivization |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `1T1-1_1_1-a` | 1 | 0 | 1T1 | [1,1,1] | [[1],[1],[1]] | S | yes | 1.1.1.1 | self |
| `2T1-2_2_1.1-a` | 2 | 0 | 2T1 | [2,2,1] | [[2],[2],[1,1]] | S | yes | 1.1.1.1 | self |
| `3T1-3_3_1.1.1-a` | 3 | 0 | 3T1 | [3,3,1] | [[3],[3],[1,1,1]] | S | yes | 1.1.1.1 | self |
| `3T1-3_3_3-a` | 3 | 1 | 3T1 | [3,3,3] | [[3],[3],[3]] | E | yes | 2.0.3.1 | self |
| `3T2-3_2.1_2.1-a` | 3 | 0 | 3T2 | [3,2,2] | [[3],[2,1],[2,1]] | S | yes | 1.1.1.1 | self |
| `4T1-4_4_1.1.1.1-a` | 4 | 0 | 4T1 | [4,4,1] | [[4],[4],[1,1,1,1]] | S | no | 1.1.1.1 | `2T1-2_2_1.1-a` |
| `4T1-4_4_2.2-a` | 4 | 1 | 4T1 | [4,4,2] | [[4],[4],[2,2]] | E | no | 1.1.1.1 | `2T1-2_2_1.1-a` |
| `4T2-2.2_2.2_2.2-a` | 4 | 0 | 4T2 | [2,2,2] | [[2,2],[2,2],[2,2]] | S | no | 1.1.1.1 | `2T1-2_2_1.1-a` |
| `4T3-4_2.2_2.1.1-a` | 4 | 0 | 4T3 | [4,2,2] | [[4],[2,2],[2,1,1]] | S | no | 1.1.1.1 | `2T1-2_2_1.1-a` |
| `4T4-3.1_3.1_2.2-a` | 4 | 0 | 4T4 | [3,3,2] | [[3,1],[3,1],[2,2]] | S | yes | 1.1.1.1 | self |
| `4T4-3.1_3.1_3.1-a` | 4 | 0 | 4T4 | [3,3,3] | [[3,1],[3,1],[3,1]] | E | yes | 1.1.1.1 | self |
| `4T5-4_3.1_2.1.1-a` | 4 | 0 | 4T5 | [4,3,2] | [[4],[3,1],[2,1,1]] | S | yes | 1.1.1.1 | self |
| `4T5-4_4_3.1-a` | 4 | 1 | 4T5 | [4,4,3] | [[4],[4],[3,1]] | H | yes | 1.1.1.1 | self |

Their `triples_cyc`, in the same order, are: `["()","()","()"]`;
`["(1,2)","(1,2)","()"]`; `["(1,2,3)","(1,3,2)","()"]`; `["(1,2,3)","(1,2,3)","(1,2,3)"]`;
`["(1,2,3)","(2,3)","(1,2)"]`; `["(1,2,3,4)","(1,4,3,2)","()"]`;
`["(1,2,3,4)","(1,2,3,4)","(1,3)(2,4)"]`; `["(1,4)(2,3)","(1,2)(3,4)","(1,3)(2,4)"]`;
`["(1,2,3,4)","(1,2)(3,4)","(1,3)"]`; `["(1,2,3)","(1,2,4)","(1,3)(2,4)"]`;
`["(1,2,3)","(1,3,4)","(2,4,3)"]`; `["(1,2,3,4)","(2,4,3)","(1,2)"]`;
`["(1,2,3,4)","(1,3,4,2)","(1,3,4)"]`.

Two facts worth stating as acceptance properties of Layer 3.5: exactly four of the thirteen
are imprimitive, and **all four primitivize to `2T1-2_2_1.1-a`**; and the two records with
`g = 1` at degree 4 (`4T1-4_4_2.2-a`, `4T5-4_4_3.1-a`) have friends
`EllipticCurve/Q/32/a/3` and `EllipticCurve/Q/48/a/6` respectively, so Layer 10.8's
genus-one acceptance example can be taken from frozen data rather than constructed.

⚠ The table is the roadmap's *comparison target*, not evidence of completeness. Layer 3.5
proves its own classification and checks that each frozen record matches exactly one
enumerated class and distinct records match distinct classes; that every class appears in
the database is not claimed, and Layer 14 excludes completeness by name.

### The independent enumeration behind Layer 3.5

Computed 2026-08-09 by exhaustive search over `Equiv.Perm (Fin n)²`, in this roadmap's
convention `σinf = (σ1 · σ0)⁻¹` — the assertion `σinf · σ1 · σ0 = 1` is checked on every
triple generated — keeping the connected ones and quotienting by simultaneous conjugation
by all of `S_n`:

```text
degree                          1    2    3    4    5
connected classes               1    3    7   26   97
ordered passports (with G)      1    3    7   26   74
ordered passports (without G)   1    3    7   26   70
```

The monodromy group enters **up to conjugacy in `S_n`**, which is the only way it is defined
on a simultaneous-conjugacy class. At degree `5` exactly four cycle-type passports split
once it is added — `([4,1],[4,1],[5])` and its two rotations, into `F₂₀` and `S₅`, and
`([5],[5],[5])` into `C₅` and `A₅` — so `70 + 4 = 74`.

**Every ordered passport in degree `≤ 4` has size exactly `1`**, under both readings — with
the monodromy group as part of the passport datum, which is the LMFDB's convention since
`plabel = dTj-λ₀_λ₁_λ∞`, and without it. So a milestone demanding a multi-class passport at
those degrees is unsatisfiable, and Layer 3.5 no longer asks for one.

The smallest multi-class passport is at **degree 5**: with the group, fifty-two of size `1`,
twenty-one of size `2` and one of size `3`, so `52 + 2·21 + 3 = 97` classes in `74`
passports. The size-`3` witness is monodromy `C₅` with partitions
`([5],[5],[5])`, and it can be checked by hand: writing a triple of powers of a `5`-cycle
`r` as its exponent vector `(a,b,c)` with `a,b,c ∈ {1,2,3,4}` and `a + b + c ≡ 0 (mod 5)`,
there are `12` such vectors; `N_{S₅}(C₅) = F₂₀` acts through `(ℤ/5)ˣ` by scaling, since the
`C₅` part is inner and `C₅` is abelian; and scaling to `a = 1` leaves exactly
`(1,1,3), (1,2,2), (1,3,1)` — that is `(r, r, r³)`, `(r, r², r²)`, `(r, r³, r)`. `12 / 4 = 3`.

⚠ **An earlier revision of this file recorded `78` here, and defended it against a review
that said `74`. The review was right.** The error was in canonicalising the monodromy group:
taking `min` over a Python `frozenset` of conjugates uses the **subset** relation, a partial
order, so conjugate subgroups were never identified and the four splitting passports above
were each counted twice. Canonicalise with a genuine total order — `min` over
`tuple(sorted(…))` — and the count is `74`. The arithmetic offered no protection: the wrong
distribution `60 + 2·17 + 3` and the right one `52 + 2·21 + 3` both total `97`. Anything
resting on a count of orbits under conjugacy should be checked the same way.

⚠ `1 + 3 + 7 + 26 = 37` ordered classes in degrees `1` through `4`, against the database's
**thirteen** frozen records at those degrees. The database is not incomplete here: it
tabulates one ordered passport per `S₃`-orbit under the branch-point action (Layer 2.6),
retaining all classes inside the chosen ordered passport. That is
Musty–Schiavone–Sijsling–Voight, *A database of Belyi maps*, **Algorithm 2.3.1**, and it is
why README Layer 14.4 certifies the tabulated representative as carrier-only data rather
than deriving it. The comparison Layer 3.5 makes is therefore one-directional: every frozen
record matches exactly one enumerated class, distinct records match distinct classes, and
the records' passports form a set of `S₃`-orbit representatives.

## The prerequisite check

Two mechanical checks stand behind the roadmap's dependency claims, and they check different
things.

1. **The `*Prerequisites:*` lines.** A parser reads every milestone's prerequisite line,
   **expands numerical ranges** such as `9.3–9.6`, and rejects self references, references to
   later milestones, nonexistent milestone numbers, and ranges that are reversed or cross a
   layer. ⚠ **Range expansion is the whole point.** An earlier version of this checker did
   not expand ranges, and that is exactly where both of the roadmap's real forward
   references hid — Layer 12.7 listing "Layers 12.4–12.8", which includes itself and a
   future milestone, and Layer 12.10 listing "Layers 12.7–12.11". A DAG claim made with a
   checker that does not expand ranges is worth nothing, and this file does not repeat one.
2. **The prose.** The prerequisite lines are not the only place a dependency can hide: a
   milestone whose body says "by 12.9" while sitting at 12.6 depends forwards whatever its
   prerequisite line says. A second pass reports every milestone-number reference in a
   milestone's body that points later, excluding the `*Source:*` and
   `*Downstream interfaces.*` material, where forward references are deliberate. ⚠ This pass
   **reports, it does not gate**: the roadmap uses forward *pointers* on purpose
   ("that is Layer 10"), and only a human can tell a pointer from a dependency. It also
   over-reports, since a milestone's block runs to the next `####` heading and so absorbs an
   intervening layer introduction.

## Open items tracked here

- Every load-bearing citation now carries a verified number. Köck, Stix, Fried,
  Lando–Zvonkin, Couveignes, Weil, Girondo–González-Diez, Forster and Szamuely are all
  done — see §Sources, verified. Katok is no longer wanted: Layer 4.5 owns its construction.
  What remains is secondary attribution only: Serre (*Topics in Galois Theory*), Deligne
  (MSRI 16), MSSV (ANTS XIII), Dixon–Mortimer (GTM 163).
- The LMFDB source commit behind the frozen schema above: the records were taken from the
  live API, so the column lists are dated rather than pinned to a `github.com/LMFDB/lmfdb`
  revision. Pinning one would let Layer 14.1's certificate cite a source file.
- Whether the MSSV paper states the composition order in words, which would let Layer 14.2
  cite a sentence in addition to the frozen-record computation above.
