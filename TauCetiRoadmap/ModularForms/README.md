# Roadmap: modular forms — Hecke theory, newforms, and L-functions

Mathlib has the *foundations* of modular forms — `SlashInvariantForm`, `ModularForm`,
`CuspForm` and their classes ([`ModularFormClass`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/ModularForms/Basic.html#ModularFormClass),
`CuspFormClass`, in `Mathlib/NumberTheory/ModularForms/Basic.lean`), the slash action
(`SlashActions.lean`), the congruence subgroups `Γ(N)`, `Γ₀(N)`, `Γ₁(N)`
(`CongruenceSubgroups.lean`), Eisenstein series and `E₄, E₆` (`EisensteinSeries/*`), the
`q`-expansion and [`cuspFunction`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/ModularForms/QExpansion.html)
(`QExpansion.lean`), the Petersson integrand (`Petersson.lean`), the cusp-form submodule, `Δ`,
`η`, the level-one dimension formula and level-one **Sturm bound** (`LevelOne/DimensionFormula.lean`),
and — new in July 2026 — the first slice of the **abstract Hecke ring**
(`NumberTheory/HeckeRing/Defs.lean`). It has **no Hecke operators acting on modular forms**, no
theory of **eigenforms / newforms / oldforms**, no **L-function of a modular
form**, no **valence formula**, and no **general dimension formulas**. We build the classical
arithmetic theory of modular forms on top of Mathlib's analytic foundation: modular forms with
character, the valence formula at general level, the Hecke algebra, the Petersson inner
product, newforms and strong multiplicity one, Atkin–Lehner and Fricke operators, the
L-function with its Euler product and functional equation, the theorem that the coefficient
field of a newform is a number field, and the level-one **Eichler–Selberg trace formula** — the
content of a masters/PhD course on the subject,
resting throughout on complex analysis, Fourier analysis, and the arithmetic of `SL₂(ℤ)`.

The hardest target is the **dimension formulas** for `M_k(Γ)` and `S_k(Γ)` at general level
(Diamond–Shurman Thm 3.5.1), proved by the **classical analytic route**: the valence formula
together with the elliptic-point and cusp counts of the quotient `Γ\ℍ`. Mere
*finite-dimensionality* at general level is **not** the hard part — it arrives in Mathlib by the
elementary Sturm-bound route (see Layer 10) and this roadmap consumes it. What this roadmap adds
is the **exact dimension formula** of Diamond–Shurman Thm 3.5.1 — `dim M_k(Γ)` and `dim S_k(Γ)`
in terms of the genus `g` of `X(Γ)`, the numbers `ε₂` and `ε₃` of elliptic points of order `2`
and `3`, and the number `ε∞` of cusps — which means computing those four invariants for a given
`Γ`, not just knowing the spaces are finite-dimensional. The modular curve here
**is** the analytic quotient `Γ\ℍ`, compactified by adjoining the cusps to a compact Riemann
surface — defined directly, with no functor, no representability, and no algebraic moduli
problem.

Suggested home: `TauCeti/NumberTheory/ModularForms/`.

A large body of this theory — `sorry`-free apart from three flagged gaps (see *Provenance*) —
already exists in the AINTLIB `LeanModularForms`
project (~250 source files). This roadmap specifies the **mathematics**; the file-by-file
migration map is in the secondary *Provenance* section and in `Suggested.lean`. Porting it into
`TauCeti/` is the opportunity to restate everything in Mathlib's vocabulary and to **clean up** —
the project's own audits estimate that the newform and eigenform/SMO subtrees alone carry
~30–36% redundancy (parallel `ModularForm`/`CuspForm` chains, dead scaffolding, near-duplicate
`slash` variants) that consolidates on the way in.

## Standing hypotheses and conventions

Spell hypotheses out; **do not** bundle "a modular form with all its invariants" into one class.
Pin these conventions before writing code — implementors make bad, divergent choices otherwise.

- **Levels and characters.** Work with `Γ₁(N) ≤ Γ ≤ Γ₀(N)`. The space with **nebentypus** `χ` is
  `M_k(N, χ) = M_k(Γ₁(N), χ)`, the simultaneous `χ`-eigenspace of the diamond operators inside
  `M_k(Γ₁(N))` — a `Submodule`, defined in Layer 0 exactly as in AINTLIB. Reserve `M_k(Γ)` for a
  bare congruence subgroup. ⚠ This gives **two ways to say `M_k(Γ₀(N))`** — as forms on the
  bare group `Γ₀(N)`, and as `M_k(N, χ)` for `χ` trivial. That is unavoidable, so decide it
  once: prove the two **isomorphic** (a named milestone), treat `M_k(Γ₀(N))` as the default
  spelling for trivial nebentypus, and convert to it where possible. The character has two faces, and AINTLIB uses both deliberately: a
  unit homomorphism `χ : (ZMod N)ˣ →* ℂˣ` where it indexes eigenspaces, and Mathlib's
  `DirichletCharacter ℂ N` (`= MulChar (ZMod N) ℂ` — use it, do not reinvent) where a formula
  evaluates `χ` at arbitrary residues with `χ(p) = 0` for `p ∣ N`, bridged by
  `DirichletCharacter.toUnitHom` one way (so AINTLIB's conductor-theorem statements) and the
  zero-extension `Newform.dirichletLift` the other (so its Euler product). Keep both faces and
  the maps between them; do not fuse them into a third notion.
- **The weight-`k` slash.** Use Mathlib's `SlashAction`/`ModularForm.slash` and its `k` and
  `GL₂(ℝ)⁺`/`GL₂(ℚ)⁺` conventions throughout; the Hecke double-coset operators are built from it.
  ⚠ Two normalizations of the Hecke action circulate, differing by a power of the determinant;
  use the **arithmetic** one — Diamond–Shurman's, the one with no square roots in odd weight —
  and use it *only*. The Shimura normalization is **not** wanted here: from the automorphic
  side there is no canonical representation attached to a modular form anyway (one may twist
  by `‖det‖^s`), so carrying a second normalization buys nothing this roadmap needs. AINTLIB
  has a `ShimuraHom` comparison; it is not a target.
- **`Tₙ` is defined for every `n`, and at `p ∣ N` it *is* `Uₚ`.** Miyake (§4.5, Lemma 4.5.7),
  Diamond–Shurman (Prop. 5.2.1–5.2.2, eq. (5.3)–(5.4)) and Shimura (3.5.12) all define `T(n)`
  for **all** `n ≥ 1`, with the nebentypus extended by `χ(d) = 0` for `(d, N) > 1`. The
  coefficient formula `aₘ(Tₚ f) = a_{mp}(f) + χ(p)p^{k−1}a_{m/p}(f)` then degenerates at
  `p ∣ N` to `aₘ(Tₚ f) = a_{mp}(f)` — which is exactly the operator modern papers write `Uₚ`.
  So there is **no second operator**: follow the sources and define `Tₙ` uniformly, then
  provide `Uₚ` as an **alias at `p ∣ N` with the lemma `Uₚ = Tₚ`** (Layer 2), so both
  vocabularies are available and provably the same. Likewise the recurrence
  `T_{p^{r+2}} = Tₚ T_{p^{r+1}} − p^{k−1}⟨p⟩T_{p^r}` is uniform once `⟨p⟩ = 0` at bad `p`,
  degenerating to `T_{p^r} = Tₚ^r`. ⚠ Genuine diamond operators are indexed by
  `(ZMod N)ˣ` only; the `⟨n⟩ = 0` extension to non-units is a *separate* zero-extended
  notation for uniform formulas — do not conflate the two, and do not pretend a non-unit
  indexes an automorphism.
- **What "eigenform" means — the call, made once, following the sources.** The bare word
  `Eigenform` is reserved for the **full** notion, as in **Diamond–Shurman Definition 5.8.1**:
  a nonzero form that is an eigenvector for `Tₙ` at **every** `n ≥ 1` (their zero-extended
  `⟨n⟩` clause is vacuous at bad `n`, so the substantive content is the `Tₙ`). This is the
  right thing to call `Eigenform` because its eigenvalue system *contains* the bad-prime data
  that the Euler factors (Layer 7) and Atkin–Lehner–Li (Layer 4) consume.
  The weaker, good-`n` notion — eigenvector for `Tₙ` whenever `(n, N) = 1` — is exactly the
  natural *hypothesis* of the newform arguments (it is the family that is normal for the
  Petersson product, hence simultaneously diagonalizable: Miyake Thm 4.5.4(3), D–S Thm 5.5.4)
  and so it needs a name of its own — but a **qualified** one, since no source gives it the
  bare word: `IsEigenformAwayFromLevel` (say "good Hecke eigenform" in prose, never plain
  "eigenform"). Miyake has no free-standing "eigenform" at all; he says "common eigenfunction"
  relative to a stated family.
- **Normalized eigenforms and newforms.** A form is `normalized` when `a₁ = 1`. A **newform**
  is defined the proof-friendly way, following Miyake's *primitive form* (§4.6): normalized,
  lying in the new subspace — the orthogonal complement of the oldspace under
  the Petersson product, defined in Layer 3, where the old/new decomposition is a milestone —
  and **eigen away from the level**. That every newform is then a *full* eigenform is a
  **theorem**, not part of the definition (D–S Thm 5.8.2 / Miyake Thm 4.6.13), and it is what
  makes the bad-prime eigenvalues (Layer 4) available. Building the full condition into the
  newform hypothesis would put a hard theorem into the hypotheses of the newform-decomposition
  argument, which is why the sources do not do it.
  State eigenvalue results for normalized forms, so that
  `Tₙ f = aₙ(f) · f` (Hecke eigenvalue = Fourier coefficient).
- **Coefficient field.** The coefficient field of a newform is `CoefficientField f = ℚ(aₙ : n ≥ 1)
  ⊆ ℂ`, an `IntermediateField ℚ ℂ`. (Name it `CoefficientField`, not after the form: no `K_f`.)
  It is a *number field* — a theorem (Layer 8), not an assumption. The `IntermediateField ℚ ℂ`
  typing is deliberate and does real work: because the forms here are complex-analytic, the
  coefficient field comes with a **preferred embedding into `ℂ`**, and the Galois-orbit and
  self-duality statements of Layer 9 are about that embedded field, not an abstract number
  field.
- **`q`-expansions are the computational interface.** State Hecke recurrences, Euler products,
  and eigenform characterizations on the Fourier coefficients `aₙ(f)` via `qExpansion`, not on
  bespoke coefficient types.
- **Ride Mathlib's bundled form types — the analytic invariants travel *inside* the type.** State
  every target over `ModularForm` / `CuspForm` / `ModularFormClass` (and, for nebentypus spaces,
  membership in `modFormCharSpace k χ`), **never** over a raw `ℍ → ℂ`: holomorphy, boundedness /
  vanishing at the cusps, and Γ-automorphy are structure fields that cannot be silently dropped. When
  porting a result, **copy AINTLIB's hypotheses verbatim** rather than "cleaning them up" — in
  particular the `Tₚ`-recurrence's `f ∈ modFormCharSpace k χ` and `Coprime p N` (which pick the
  operator and give `χ(p)` its meaning), the `a₁ = 1` normalization (a field of `Newform`, not of
  `Eigenform`), the **shared nebentypus and finite exceptional set** in `strongMultiplicityOne`
  (Layer 5), and the `0 < k`, width-one, and Fricke-companion hypotheses of the functional
  equation (Layer 7). These are the modular-forms analogue of the curve-regularity hypotheses the Contour
  roadmap carries; keeping them visible is why this roadmap does **not** hit the "raw restatement
  drops an invariant" failure.

## What Mathlib already has (consume)

- **Forms and classes:** `ModularForm Γ k`, `CuspForm Γ k`, `SlashInvariantForm`,
  `ModularFormClass`, `CuspFormClass`, the `ℂ`-module structures, `ModularForm.mul`, `E₄`, `E₆`,
  `Δ`, `η` (`NumberTheory/ModularForms/*`).
- **Congruence subgroups:** `CongruenceSubgroup.Gamma`, `Gamma0`, `Gamma1`, and the maps between
  them (`CongruenceSubgroups.lean`).
- **The upper half-plane and the `SL₂` action:** `UpperHalfPlane`, the Möbius action, the
  fundamental domain and proper discontinuity (`Analysis/Complex/UpperHalfPlane/*`,
  `ModularForms/ProperlyDiscontinuous.lean`).
- **`q`-expansions and cusps:** `qExpansion`, `cuspFunction`, `BoundedAtCusp`, the bounds
  `|aₙ| = O(n^{k})` / `O(n^{k/2})` substrate (`QExpansion.lean`, `Bounds.lean`).
- **Eisenstein series:** `eisensteinSeries`, `gammaSet`, the level-`Γ(N)` series and their
  `q`-expansions (`EisensteinSeries/*`).
- **Petersson integrand:** `petersson k f f' τ`, the pointwise pairing (`Petersson.lean`).
- **Dirichlet characters:** `DirichletCharacter`, conductor, primitivity, `changeLevel`, Gauss
  sums, the Dirichlet L-function with its functional equation
  (`NumberTheory/DirichletCharacter/*`, `LSeries/*`).
- **L-series substrate:** `LSeries`, `LSeriesSummable`, `LSeriesHasSum`, abscissa of convergence,
  and the Euler-product API (`riemannZeta_eulerProduct`, `LSeries/Dirichlet.lean`,
  `EulerProduct/*`).
- **Number fields:** `NumberField`, `IntermediateField`, the Galois theory of `ℚ̄/ℚ` — the target
  of the coefficient-field layer.
- **The abstract Hecke ring (landing now — July 2026):**
  [`NumberTheory/HeckeRing/Defs.lean`](https://github.com/leanprover-community/mathlib4/pull/41251)
  has the Hecke-triple compatibility class `IsHeckeTriple Δ H₁ H₂` (commensurable subgroups of a
  common submonoid `Δ` lying in their commensurator — the finiteness making `H₁gH₂` a finite
  union of left cosets), the double-coset basis `HeckeCoset Δ H₁ H₂`, the coset module
  `HeckeCosetModule Δ H₁ H₂ Z`, and the Hecke ring `HeckeRing Δ H Z` (notation `𝕋`), on top of
  `GroupTheory/DoubleCoset` and `GroupTheory/Commensurable`. The **convolution product, identity,
  and associativity** are the open review stack
  [#41253](https://github.com/leanprover-community/mathlib4/pull/41253)–[#41256](https://github.com/leanprover-community/mathlib4/pull/41256), [#41277](https://github.com/leanprover-community/mathlib4/pull/41277), [#41279](https://github.com/leanprover-community/mathlib4/pull/41279), and [#41328](https://github.com/leanprover-community/mathlib4/pull/41328),
  upstreamed from AINTLIB's `HeckeRIngs/AbstractHeckeRing/*`. Layer 2 **consumes** this; do not
  re-found the abstract ring in `TauCeti/`.
- **The Sturm bound — level one merged, finite index in review:**
  `ModularForm.sturm_bound_levelOne` and the even-weight dimension formula
  `ModularForm.dimension_level_one` (`LevelOne/DimensionFormula.lean`,
  [#38993](https://github.com/leanprover-community/mathlib4/pull/38993)); the finite-index Sturm
  bound `ModularForm.sturm_bound_finiteIndex` with a `Module.Finite ℂ (ModularForm 𝒢 k)`
  instance — finite-dimensionality at **every** level — is the open stack
  [#39000](https://github.com/leanprover-community/mathlib4/pull/39000)
  (+[#39083](https://github.com/leanprover-community/mathlib4/pull/39083)/[#39086](https://github.com/leanprover-community/mathlib4/pull/39086)/[#39087](https://github.com/leanprover-community/mathlib4/pull/39087)/[#39088](https://github.com/leanprover-community/mathlib4/pull/39088):
  cusp widths, the modular norm map and its `q`-expansion decomposition). Layer 10 **consumes**
  finite-dimensionality from here; the exact dimension formulas remain the hard target.

## What is missing (build here)

The valence formula at general level; the diamond operators `⟨d⟩` and the character spaces
`M_k(N,χ)`; the Hecke operators `Tₙ` (`Tₚ` is the prime case, not a separate object) and the (commutative) Hecke-ring action on
`M_k(N,χ)` — the abstract ring is Mathlib's, its `GL₂` realization and action are not; the Petersson inner product as
an actual inner product and the Petersson adjoint `Tₙ* = ⟨n⟩⁻¹Tₙ` for `(n,N)=1` — normality, not
self-adjointness at general nebentypus; the old/new decomposition
and its orthogonality; eigenforms, newforms, oldforms, primitive forms; the Atkin–Lehner Main
Lemma (D–S 5.7.1), the newform decomposition with its conductor, the bad-prime eigenvalue
classification, and **strong multiplicity one**; Atkin–Lehner and Fricke operators and their
signs; the L-function of a modular form with its **Euler product**, **completed form**,
**functional equation**, and **analytic continuation**; the **coefficient field** and the proof
that it is a number field — both **already constructed in AINTLIB**, so this one is a migration
(§Layer 8, §Provenance); the LMFDB invariants (Satake parameters, Hecke characteristic
polynomials, Galois orbits, labels, …); the **modular curve** `X(Γ)` as the compactified analytic
quotient `Γ\ℍ`, with its cusps, elliptic points, and genus; the **dimension formulas** for
`M_k(Γ)` and `S_k(Γ)` — the valence formula for the upper bounds, the lower bounds **gated on a
planned compact-Riemann-surfaces roadmap** supplying analytic Riemann–Roch (Layer 10); and the level-one **Eichler–Selberg trace
formula** together with the **Hurwitz class numbers** it needs (absent from Mathlib). Apart from
the abstract Hecke ring and the
Sturm-bound finiteness now landing in Mathlib (consumed above), none of this is upstream.

---

## The build, in layers

The ordering is the dependency order; independent lanes (e.g. L-functions vs. the modular curve)
can proceed in parallel once their inputs exist. As each layer makes the next layer's *types*
expressible in `TauCeti/`, its milestones go into `Suggested.lean` (with `sorry`). Embedded Lean
below sketches signatures; it is illustrative, not required to compile.

### Layer 0: diamond operators and modular forms with character (nebentypus)
- **Diamond operators first — from the slash action alone.** `Γ₁(N) ⊴ Γ₀(N)` with
  `Γ₀(N)/Γ₁(N) ≅ (ℤ/N)ˣ` via the lower-right entry, so slashing by (any lift of) `d ∈ (ZMod N)ˣ`
  is a well-defined `ℂ`-linear endomorphism of `M_k(Γ₁(N))` and of `S_k(Γ₁(N))`: the **diamond
  operator** `⟨d⟩`, packaged as monoid homs into the endomorphism algebras (AINTLIB `diamondOp`
  / `diamondOpCusp`, `diamondOpHom : (ZMod N)ˣ →* Module.End ℂ (ModularForm ((Gamma1 N).map
  (mapGL ℝ)) k)`). This needs only Mathlib's slash action and the normality of `Γ₁(N)` — no
  Hecke theory.
- **Modular forms with character `M_k(N, χ)` and `S_k(N, χ)` — as in AINTLIB**: the simultaneous
  `χ`-eigenspace of the diamond operators, a `Submodule` of Mathlib's `ModularForm`, **not** a
  new bundled type with a twisted transformation law:
  ```lean
  -- AINTLIB (HeckeRIngs/GL2/Gamma1Pair.lean), verbatim:
  noncomputable def modFormCharSpace [NeZero N] (k : ℤ) (χ : (ZMod N)ˣ →* ℂˣ) :
      Submodule ℂ (ModularForm ((Gamma1 N).map (mapGL ℝ)) k) :=
    ⨅ d : (ZMod N)ˣ, Module.End.eigenspace (diamondOpHom k d) (↑(χ d))   -- and cuspFormCharSpace
  ```
  These spaces are the general setting for the entire roadmap; all of the Hecke, Petersson, and
  eigenform theory below lives on them. The classical **nebentypus transformation law is a
  theorem here**, not the definition (AINTLIB `modFormCharSpace_iff_nebentypus`):
  `f ∈ M_k(N, χ) ↔ ∀ γ ∈ Γ₀(N), f ∣[k] γ = χ(d_γ) • f`.
  ⚠ Do **not** re-found these spaces by re-defining the slash action with a character built in
  (a `ModularFormWithChar` type): the eigenspace-in-a-`Submodule` definition keeps every Mathlib
  lemma about `ModularForm Γ k` applicable to elements of `M_k(N,χ)` for free, matches the
  AINTLIB corpus this roadmap migrates (so its theorems restate verbatim), and makes the
  decomposition below a statement about honest subspaces of one fixed space.
- **The nebentypus decomposition** of `M_k(Γ₁(N))` — **already proved in AINTLIB**; migrate,
  don't re-derive. The diamond action is simultaneously diagonalizable with the `M_k(N,χ)` as
  its isotypic components, an **internal** direct sum:
  ```lean
  -- AINTLIB (HeckeRIngs/GL2/CharacterDecomp.lean): iSupIndep + iSup = ⊤, packaged as
  theorem ModularForm_Gamma1_charSpace_directSum (k : ℤ) [DecidableEq ((ZMod N)ˣ →* ℂˣ)] :
      DirectSum.IsInternal (fun χ : (ZMod N)ˣ →* ℂˣ ↦ modFormCharSpace k χ)
  ```
  (halves: `ModularForm_Gamma1_iSupIndep_charSpace`, `ModularForm_Gamma1_iSup_charSpace`; cusp
  versions alongside). ⚠ This is an internal direct sum of subspaces of `M_k(Γ₁(N))`, **not** a
  naive equality of a type with an external `⨁`.
- **Eisenstein series with character** `E_k^{χ,ψ}` (#37): the character-twisted series as named
  modular forms on `Γ₀(N)` with nebentypus, their `q`-expansions in terms of generalized
  Bernoulli numbers and twisted divisor sums, and the Eisenstein subspace.
  ⚠ Match Mathlib's `eisensteinSeries`/`gammaSet` indexing; do not introduce a second Eisenstein
  API.

### Layer 1: the valence formula (general level)
- Consumes the [Contour Integration roadmap](../ContourIntegration/README.md). For a nonzero
  `f ∈ M_k(SL₂(ℤ))`, the **valence formula** is a sum over the
  `SL₂(ℤ)`-**orbits** of points of `ℍ` — `ord_P(f)` is constant on an orbit, hence well-defined
  on it — with the two **elliptic orbits** `[i]`, `[ρ]` weighted by the reciprocal `1/e_P` of
  their stabilizer orders (`e_i = 2`, `e_ρ = 3`) and the cusp `∞` contributing `ord_∞`. The
  statement is AINTLIB's, already proved — port the statement as it stands
  (`ForMathlib/ValenceFormulaFinal.lean`), under a Mathlib-style name: the `_textbook` suffix
  is an AINTLIB-internal disambiguator and does **not** survive the port (`valence_formula`):
  ```lean
  theorem valence_formula_textbook {k : ℤ} (f : ModularForm (Gamma 1) k) (hf : f ≠ 0) :
      (orderAtCusp' f : ℂ) +
      (1/2 : ℂ) * ↑(orderOfVanishingAt' (⇑f) ellipticPointI') +
      (1/3 : ℂ) * ↑(orderOfVanishingAt' (⇑f) ellipticPointRho') +
      ∑ᶠ (q : NonEllOrbitFM), ordOrbitQ f q =
      (k : ℂ) / 12
  ```
  in text: `ord_∞(f) + ½·ord_i(f) + ⅓·ord_ρ(f) + Σ_q ord_q(f) = k/12`, the sum running over the
  non-elliptic `SL₂(ℤ)`-orbits of `ℍ`; equivalently `Σ_{P ∈ SL₂(ℤ)\ℍ*} (1/e_P)·ord_P(f) = k/12`
  over the orbits of the extended upper half-plane `ℍ* = ℍ ∪ {cusps}`. ⚠ The summation index is
  **orbits in `ℍ`, not points** — exactly the `∑ᶠ` over `NonEllOrbitFM` above.
- The proof is the contour integral of `f'/f` around the fundamental-domain boundary; `i` and `ρ`
  sit **on** that contour, so their `½` and `⅓` weights are the Hungerbühler–Wasem generalized
  winding numbers of points on a cycle (Contour roadmap) — the precise reason the elliptic weights
  are `1/e_P`.
- **General level:** push to a finite-index `Γ ≤ SL₂(ℤ)` via the degree-`[SL₂(ℤ):±Γ]` covering,
  giving `Σ_{P ∈ Γ\ℍ*} (1/e_P)·ord_P(f) = k·[SL₂(ℤ):±Γ]/12` over the `Γ`-orbits, the input both to
  low-weight vanishing and to the dimension formulas (Layer 10).
- The **Sturm bound** heading into Mathlib (`sturm_bound_finiteIndex`, Layer 10) is the
  *inequality shadow* of this formula — `ord_∞(f) ≤ k·[SL₂(ℤ):Γ]/12` for `f ≠ 0`, since every
  other term is `≥ 0` — proved there by the elementary norm-map route with no contour
  integration. The valence formula is what upgrades that inequality to the exact `k/12` mass
  count, and it is absent from Mathlib at every level; it is this roadmap's route to the exact
  dimension formulas.

### Layer 2: Hecke operators and the Hecke algebra
- **(a) The abstract Hecke ring — consume Mathlib's.** The double-coset ring of a Hecke pair is
  landing in Mathlib (`NumberTheory/HeckeRing/Defs.lean` #41251, merged; the convolution ring
  structure in review, #41253–#41256, #41277, #41279, #41328 — see *What Mathlib already has*): `IsHeckeTriple`,
  `HeckeCoset`, `𝕋 Δ H Z`, with the finiteness (`Γ ∩ gΓg⁻¹` of finite index, so `ΓgΓ = ⊔ᵢ gᵢΓ`
  is a finite union of cosets) packaged in the commensurator conditions. What this roadmap adds
  on top: the classical `GL₂(ℚ)` instances — `Γ₀(N)`, `Γ₁(N)` inside the integral-matrix
  submonoid (AINTLIB `Gamma0_pair`, `Gamma1Pair.lean`) — the degree map, and **commutativity**
  via the transpose anti-involution fixing every double coset (AINTLIB
  `mul_comm_of_antiInvolution`, `GLn/TransposeAntiInvolution.lean`). Keep the
  abstract ring separate from its action, so the structural facts (commutativity, generation by
  `T_p`, `⟨p⟩`) are proved once.
- **(b) The action on forms.** `Tₙ`, `Tₚ` as `ℂ`-linear endomorphisms of `M_k(Γ₁(N))` preserving
  `M_k(N,χ)` and `S_k(N,χ)`, the ring homomorphism from the abstract ring, and the explicit
  **`q`-expansion recurrences** — AINTLIB's shapes:
  ```lean
  -- the operator (HeckeRIngs/GL2/HeckeT_n.lean) and the ring action on the χ-space
  -- (HeckeRIngs/GL2/Unified/NebentypusHeckeRingHom.lean):
  def heckeT_n [NeZero N] (k : ℤ) (n : ℕ) [NeZero n] :
      Module.End ℂ (ModularForm ((Gamma1 N).map (mapGL ℝ)) k)
  noncomputable def heckeRingHomCharSpace :   -- Φ_χ
      𝕋 (Gamma0_pair N) ℤ →+* Module.End ℂ (modFormCharSpace k χ)
  -- a_m(T_p f) = a_{mp}(f) + χ(p) p^{k-1} a_{m/p}(f)   (p ∤ N case), etc. (Diamond–Shurman §5.2–5.3)
  ```
  with `Tₘ Tₙ = Tₘₙ` for `(m,n)=1` and the prime-power recurrence
  (`MultiplicationTable.lean`: `T_sum_mul_coprime`, `T_sum_ppow_recurrence`, and the general
  `T_sum_mul`). The Fourier-side statements (`FourierHecke.lean`) carry
  `f ∈ modFormCharSpace k χ` and `Nat.Coprime n N` — keep those hypotheses.
  ⚠ Adopt Diamond–Shurman's convention `χ(p) = 0` for `p ∣ N` (the `Newform.dirichletLift`
  zero-extension), so the single recurrence also covers the bad-prime operator (`p ∣ N`);
  AINTLIB's `p ∣ N` branch indeed carries no `χ` term.
- **`Uₚ` is an alias, and that is a milestone.** With the convention above, at `p ∣ N` the
  recurrence reads `aₘ(Tₚ f) = a_{mp}(f)` — which is the *definition* of the operator modern
  papers call `Uₚ`. Following Miyake, D–S and Shimura, `Tₙ` is the primitive notion, defined
  for **all** `n`; `Uₚ` is introduced as notation at `p ∣ N` together with the lemma
  **`Uₚ = Tₚ`**, so that literature stated either way can be consumed without a translation
  layer. Similarly `T_{p^r} = Tₚ^r` at `p ∣ N` (AINTLIB `heckeT_ppow_eq_pow_of_not_coprime`),
  the degenerate case of the prime-power recurrence once `⟨p⟩ = 0`. ⚠ Do not introduce `Uₚ` as
  an independent operator, and do not let the zero-extended `⟨n⟩` masquerade as a diamond
  automorphism at non-units (conventions).
- **The diamond operators land in the Hecke algebra.** The slash-defined `⟨d⟩` of Layer 0 are
  recovered here as the double cosets of `Γ₀(N)/Γ₁(N) ≅ (ℤ/N)ˣ` (the diamond part of AINTLIB's
  `heckeRingDn : 𝕋 (Gamma0_pair N) ℤ`), and on `M_k(N, χ)` the ring acts through
  `heckeRingHomCharSpace` with `⟨d⟩` acting by the scalar `χ(d)` — immediate from Layer 0's
  `mem_modFormCharSpace_iff`. The compatibility of the two descriptions is a **theorem** here,
  not a definition.
  ⚠ The action must preserve cuspidality and the nebentypus; prove that, don't assume it.

- The Hecke algebra in this roadmap is the classical double-coset ring of (a)–(b). Its adelic
  reformulation is **out of scope** here and left to a future roadmap.

### Layer 3: the Petersson inner product, adjoints, oldforms and newforms
- **The Petersson inner product** as a genuine positive-definite Hermitian inner product on
  `S_k(Γ)` (integrate Mathlib's `petersson` integrand over a fundamental domain against the
  hyperbolic measure — AINTLIB's level-`N` pairing `petN`, `Modularforms/PeterssonLevelN.lean`),
  and **the Petersson adjoint of `Tₙ`** for `(n,N)=1`: `⟨Tₙ f, g⟩ = ⟨f, ⟨n⟩⁻¹Tₙ g⟩`, i.e.
  `Tₙ* = ⟨n⟩⁻¹Tₙ` on `S_k(Γ₁(N))` — AINTLIB `heckeT_n_adjoint`, hypotheses `[NeZero n]` and
  `Nat.Coprime n N`, `HeckeRIngs/GL2/AdjointTheoryPetersson.lean`. On `S_k(N,χ)` this reads
  `Tₙ* = χ(n)⁻¹Tₙ`, so the good `Tₙ` are **normal** (AINTLIB `heckeT_n_normal`), commuting,
  and hence admit a simultaneous **orthonormal** eigenbasis (AINTLIB
  `exists_simultaneous_eigenform_basis`). They are genuinely self-adjoint on the
  trivial-character component, and more generally whenever `χ(n) = 1`; for non-real `χ` the
  eigenvalues need not be real, which is why normality — not self-adjointness — is the correct
  statement, and any old/new-stability argument must use the twisted adjoint together with
  diamond-operator stability.
- **Oldforms and newforms (the spaces):** the old subspace `S_k(N)^{old}` spanned by
  level-raising images `f(τ), f(dτ)` from proper divisors, the **new** subspace `S_k(N)^{new}` as
  its Petersson-orthogonal complement (AINTLIB `cuspFormsOld`, `cuspFormsNew`,
  `Newforms/Basic.lean`), and their orthogonality and `Tₙ`-stability.
  ⚠ Old-subspace stability under the **bad-prime** `Uₚ` (`p ∣ N`; Diamond–Shurman Prop 5.6.2) is
  a flagged open `sorry` in AINTLIB (`peterssonInner_aggregate_eq_zero_of_new_old`,
  `Newforms/AdjointTheoryBadPrime.lean`), with a source-faithful Fricke-route replacement in
  progress (`Newforms/{BadPrimeFDTiling,BadPrimeTraceFricke,FrickeOldStable}.lean`) — a proof
  obligation of this layer, not a finished migration.

### Layer 4: eigenforms, newforms, primitive forms; the conductor

⚠ **Naming, on porting.** The structure below is AINTLIB's, and it is the *good-`n`* notion:
it constrains only `(n, N) = 1`. Per the conventions, it therefore ports as
**`EigenformAwayFromLevel`**, and the bare name `Eigenform` is reserved for the full
(all-`Tₙ`) notion of D–S Def. 5.8.1 — which AINTLIB currently carries as the predicate
`IsFullEigenform`. (AINTLIB's docstring cites "DS Definition 5.5.4" for its structure; D–S
5.5.4 is a *Theorem* — the good-Hecke simultaneous diagonalization — and the definition of
"eigenform" is 5.8.1. Fix the citation with the rename.)

- **Definitions — AINTLIB's actual shapes** (`Newforms/{Basic,Newform}.lean`), abridged:
  ```lean
  structure Eigenform (N : ℕ) [NeZero N] (k : ℤ)
      extends CuspForm ((Gamma1 N).map (mapGL ℝ)) k where     -- Γ₁(N) as a GL₂(ℝ)-subgroup
    χ : (ZMod N)ˣ →* ℂˣ                                       -- the nebentypus travels with the form
    mem_charSpace : toCuspForm.toModularForm' ∈ modFormCharSpace k χ
    ringEigenvalue : ℕ+ → ℂ                                   -- packaged eigenvalue data
    isRingEigen : ∀ n : ℕ+, Nat.Coprime n.val N → …           -- heckeRingDn n acts by ringEigenvalue n
                                                              --   via heckeRingHomCharSpace; good n only
    ringEigen_bad : ∀ n : ℕ+, ¬ Nat.Coprime n.val N → ringEigenvalue n = 0  -- pin bad n: no junk data

  structure Newform (N : ℕ) [NeZero N] (k : ℤ) extends Eigenform N k where
    isNew  : toCuspForm ∈ cuspFormsNewExtended N k            -- new-subspace membership
    isNorm : (UpperHalfPlane.qExpansion 1 toCuspForm).coeff 1 = 1   -- a₁ = 1
  ```
  with `PrimitiveForm := Newform` (the object that carries an LMFDB label), the eigenvalue API
  `Eigenform.eigenvalue`/`ringEigenvalue`, and the propositional `IsEigenform`/`IsFullEigenform`.
  Note the `Newform` shape matches Miyake's *primitive form* exactly — new subspace,
  normalized, eigen away from the level — which is why `PrimitiveForm := Newform` is the right
  identification and why the all-`n` upgrade stays a theorem.
  Two design points the packaging encodes, to keep: eigen-ness is demanded **only at `n`
  coprime to `N`** (the bad-`n` ring element lives in other double cosets), with the all-`n`
  upgrade for a `Newform` the **Atkin–Lehner–Li theorem** (`Newform.isFullEigenform`; D–S Thm
  5.8.2 / Miyake Thm 4.6.13), not a
  structure field. ⚠ **The bad-index slot carries no arithmetic.** `ringEigenvalue n` for
  `(n, N) > 1` is *not* the `Uₙ`-eigenvalue — the operator `Tₙ = Uₙ` exists perfectly well
  (Layer 2) and a newform *is* an eigenvector for it; the point is only that this *ring-side
  packaging* does not record it: the bad-prime ring element lies in a disjoint
  double-coset class and is not packaged by `isRingEigen` at all, so the slot is unconstrained
  and is **normalized to `0`** purely to avoid over-specification (without it, infinitely many
  `Eigenform` terms sit over one cusp form; with it, `Eigenform.ext_of_toCuspForm`). It is
  emphatically **not** a claim that `U_p f = 0` for `p ∣ N` — see the bad-prime milestone
  below, where the genuine eigenvalues live. `IsFullEigenform` quantifies over a *fresh*
  eigenvalue function, so no statement here is weakened by the convention.
  Two further **pinned porting decisions**: **(a) nonzeroness** — as displayed, the structure
  admits the zero cusp form (with arbitrary `χ`), while the conventions above define an
  eigenform as a *nonzero* simultaneous eigenvector; the port adds `ne_zero : toCuspForm ≠ 0`
  to `EigenformAwayFromLevel` (for `Newform` the `a₁ = 1` field already excludes zero).
  **(b) the total eigenvalue slot is implementation, not API** — the ported *public* eigenvalue
  interface exposes eigenvalues at good indices only (hypothesis-guarded by `Nat.Coprime n N`,
  or on a good-index subtype); the total `ringEigenvalue` with its zero-filled bad slots stays
  an internal representation detail (it exists to make `Eigenform.ext_of_toCuspForm` true), so
  no downstream statement can quietly consume a meaningless `0` at a bad index.
- **Bad-prime eigenvalues** (Atkin–Lehner–Li; Miyake Thm 4.6.17). The real content the slot
  above deliberately omits: for a newform `f ∈ S_k(N, χ)` and `p ∣ N`, the eigenvalue of `U_p`
  is the Fourier coefficient `a_p`, and with `c = v_p(cond χ)`,
  **`a_p ≠ 0 ⟺ v_p(N) = max(1, c)`** — explicitly, `a_p² = χ^{(p)}(p)·p^{k-2}` (so
  `|a_p| = p^{(k-2)/2}`, and `a_p = ±p^{(k-2)/2}` exactly when `χ^{(p)}(p) = 1`, e.g. trivial
  nebentypus) when `v_p(N) = 1` and `c = 0`; `|a_p| = p^{(k-1)/2}` — note the **different
  exponent** — when `v_p(N) = c ≥ 1`; and `a_p = 0` otherwise (`c = 0` with `v_p(N) ≥ 2`, or
  `0 < c < v_p(N)`). Here `χ^{(p)}` is the prime-to-`p` part of `χ`. Worked instances: the
  level-`11` weight-`2` newform has `a₁₁ = 1 = ±11^0`; the level-`7` weight-`3` newform
  `7.3.b.a` has `a₇ = −7`, matching `7^{(3-1)/2}` and *not* `7^{(3-2)/2}`. This milestone is
  where the bad-prime data actually lives.
- **The Atkin–Lehner Main Lemma** (Diamond–Shurman Thm 5.7.1 — D–S title §5.7 "The Main Lemma"
  and label the theorem so; outside that book the bare phrase is ambiguous, so always cite it):
  a cusp form `f ∈ S_k(Γ₁(N))` whose Fourier coefficients vanish at every index coprime to `N`
  (`aₙ = 0` whenever `(n, N) = 1`) is an **oldform** — in the sharp form D–S prove,
  `f = Σ_{p ∣ N} ι_p f_p` with `f_p ∈ S_k(Γ₁(N/p))` and `(ι_p f_p)(z) = f_p(pz)`, which is
  what the decomposition arguments downstream actually consume. In the latest AINTLIB this is **fully
  proved**, global statement included: `mainLemma` (`Newforms/MainLemmaProof.lean`) follows by
  nebentypus decomposition from the per-character route `mainLemma_charSpace_routeB`
  (`StrongMultiplicityOne.lean`, Miyake's sieve/conductor descent) — a migration, not a new
  proof obligation.
- **The level-lowering dichotomy for rescaled forms** (Miyake Thm 4.6.4 — this *is* 4.6.4;
  the packaged theorem below is Miyake **Cor 4.6.20**, so do not cite 4.6.4 for it). What
  AINTLIB proves — `sorry`-free, hypotheses
  and all (`conductor_theorem_dichotomy_cuspForm_strong`, `Eigenforms/ConductorTheorem.lean`) —
  is the level-lowering step: for `l ∣ N`, `χ : DirichletCharacter ℂ N`, and a `T`-periodic
  `f : ℍ → ℂ` whose level-raise by `l` lies in `S_k(N, χ)`, **either** `χ` factors through `N/l`
  and `f` is itself a cusp form in `S_k(N/l, χ↓)` for the lowered character, **or** `f = 0`.
  Port that statement as-is; the packaged **newform decomposition** — the existence and
  uniqueness of the associated primitive form; "the conductor theorem" is *not* standard
  terminology and is avoided (Miyake Cor 4.6.20; Diamond–Shurman Thm 5.8.3 with Prop 5.8.4 and
  Exercise 5.8.6(b), the last invoking strong multiplicity one for uniqueness) — every normalized good-Hecke
  eigenform at level `N` shares its eigenvalues away from `N` with a **unique** newform `g` of
  a **unique** minimal level `M ∣ N`, its **conductor**, and lies in the associated oldspace
  `span { g(dz) : d ∣ N/M }`, with `cond χ ∣ M` — is the target assembled from the
  dichotomy and the Main Lemma. ⚠ The uniqueness is of `(M, g)` — equivalently of the
  good-Hecke eigensystem, by Layer 5's strong multiplicity one — **not** of the eigenform
  itself: an `Eigenform` records eigen-ness only at `n` coprime to `N`, so at level `2M` every
  normalized `g(z) + c·g(2z)` qualifies, and the `Uₚ`-eigenvectors in the oldspace are the
  `p`-stabilizations — nontrivial combinations, not single degeneracy images `g(dz)`. Do not
  strengthen the conclusion to "`f` *is* a level-raise of `g`"; it is false in exactly these
  examples.

### Layer 5: strong multiplicity one and the eigenform characterization
- **Strong multiplicity one** (Miyake Thm 4.6.12 — the "strong" form, with eigenvalue agreement
  only at indices prime to some integer `L`, is **Miyake's**; Diamond–Shurman Thm 5.8.2 is the
  weaker all-`(n,N) = 1` version, and D–S explicitly defer strong multiplicity one to [Miy89]),
  **as proved in
  AINTLIB** (`strongMultiplicityOne`, `StrongMultiplicityOne/ConstantMultiple.lean`): two
  `Newform N k` **with the same nebentypus** — both underlying forms in `modFormCharSpace k χ` —
  whose eigenvalues agree at every index `n` coprime to `N` outside a **finite exceptional set**
  are equal. Keep all three hypothesis groups: same level and weight (in the type), the shared
  `χ`, and the finite exceptional set of coprime indices (that finite slack is the "strong";
  nothing is assumed at `p ∣ N`). The key step is `strongMultiplicityOne_constMul` — a `Newform`
  and an `Eigenform` sharing eigenvalues are proportional — and `a₁ = 1` pins the constant to
  `1`.
- On top of the migrated theorem, the further targets of this layer: **multiplicity one** (each
  simultaneous Hecke eigenspace in the new subspace is one-dimensional) and the newforms as an
  **orthogonal basis** of `S_k(Γ₁(N))^{new}` (the closing clause of Diamond–Shurman Thm 5.8.2;
  Miyake Thm 4.6.13(2): the new part has a basis of primitive forms).
- **Diamond–Shurman Proposition 5.8.5** (the coefficient characterization): for `f ∈ M_k(N,χ)`,
  `f` is a normalized eigenform **iff** its Fourier coefficients satisfy
  ```text
  (1)  a₁ = 1
  (2)  a_{p^r} = a_p·a_{p^{r-1}} − χ(p)·p^{k-1}·a_{p^{r-2}}   for all primes p and r ≥ 2
  (3)  a_{mn} = a_m·a_n   whenever (m,n) = 1.
  ```
  This is what the Euler product (Layer 7) rests on: conditions (2)–(3) are exactly
  multiplicativity of the Dirichlet series.

### Layer 6: Atkin–Lehner and Fricke operators
- The Atkin–Lehner involutions `W_Q` for each **exact divisor** `Q ‖ N` — meaning `Q ∣ N` with
  `gcd(Q, N/Q) = 1`; standard (also "unitary divisor", "Hall divisor"), but **define the
  notation**, since `pʳ ‖ N` elsewhere means exact `p`-adic divisibility — the **Fricke
  involution** `W_N` (the `Q = N` slash by `[0,-1;N,0]`), and their relations with `Tₙ`
  (commute away from `Q`). Every exact divisor is `∏_{p ∈ S} p^{v_p(N)}` for a set `S` of
  primes dividing `N`, so the family is generated by the prime-power `W_{p^{v_p(N)}}` and (for
  trivial nebentypus) `⟨W_{p^{v_p(N)}} : p ∣ N⟩ ≅ (ℤ/2)^{ω(N)}` with `W_Q W_R = W_{QR/gcd(Q,R)²}`:
  general `Q` is packaging convenience, not extra content, and the prime-power case alone
  suffices for the sign theory.
- **The signs, at the right generality.** For **trivial nebentypus** — Atkin–Lehner's setting —
  the `W_Q` are involutions of `S_k(Γ₀(N))` commuting with the good `Tₙ`, and on a newform
  `W_Q f = ε_Q(f)·f` with `ε_Q ∈ {±1}`, the signs multiplying to the Fricke sign — the sign of
  the functional equation. For **general nebentypus** the `W_Q` are *not* involutions of the
  `χ`-space: the Fricke operator sends a primitive form to a scalar multiple of its **conjugate
  form** (`f ∣ W_N = c·f_ρ`, with `f_ρ` the primitive form with conjugated coefficients —
  Miyake Thm 4.6.15(2)), and the right invariants are the Atkin–Li **pseudo-eigenvalues**
  `λ_Q(f)` of modulus `1`. State the `±1` sign theorems for trivial `χ` only; a genuine FE sign
  beyond that needs `f` self-dual (`f = f_ρ`).
- AINTLIB provides the Fricke side to migrate — `frickeOperator`/`frickeOperatorCusp`, the
  normalizing `frickeScalar`, and the character-space transport `frickeCharRestrict`/
  `frickeCharEquiv` (`HeckeRIngs/GL2/Fricke.lean`), with old-space stability in
  `Newforms/{FrickeOldStable,BadPrimeTraceFricke}.lean`. The general `W_Q` family for `Q ‖ N`
  and the sign theory on newforms are **new** here.

### Layer 7: L-functions
- **The L-function** `L(s,f) = Σ_{n≥1} aₙ(f)·n^{-s}` (AINTLIB `lCoeff`/`lSeries`,
  `Modularforms/LFunction.lean`), built on Mathlib's `LSeries`, with **convergence** as proved,
  on arithmetic subgroups (the `Γ.IsArithmetic` class): abscissa `≤ k/2 + 1` for cusp forms
  (`abscissaOfAbsConv_lCoeff_le_cuspForm` — the cusp-form half of Diamond–Shurman Prop 5.9.1,
  from Hecke's `aₙ = O(n^{k/2})`), and `≤ k + 1` for modular forms **of weight `k ≥ 0`**
  (`abscissaOfAbsConv_lCoeff_le` carries the hypothesis `0 ≤ k` — keep it). ⚠ The non-cuspidal
  bound comes from Mathlib's `aₙ = O(nᵏ)` and is **weaker** than D–S Prop 5.9.1, whose
  non-cuspidal statement is `Re s > k` (via `aₙ = O(n^{k−1})`); **tightening the non-cuspidal
  abscissa to `≤ k` is a milestone of this layer** — the honest D–S 5.9.1 bound, a
  divisor-sum estimate `aₙ = O(n^{k−1})` on the Eisenstein part, aligning the roadmap with the
  result it cites.
- ⚠ **Where the character lives in the Euler product.** The formula below mentions `χ(p)`
  while `f` has type `Newform N k`, which looks as though the type has lost the nebentypus. It
  has not: `χ` is a **field of the structure** (conventions, Layer 4), carried by the form
  itself, and the Euler product evaluates it through the zero-extension
  `Newform.dirichletLift`. **Decided (v1): `χ` stays a field.** The port keeps AINTLIB's
  shape — migration fidelity, and `mem_charSpace` already recovers every per-`χ` statement.
  The parameter variant `Newform N k χ` (with `Σ χ, Newform N k χ` for uses that genuinely
  range over characters, e.g. LMFDB orbits, and Galois conjugation typed as
  `Newform N k χ → Newform N k (σ • χ)`) was weighed and is **not** v1: if a downstream
  application needs typed character preservation, that refactor is a scoped follow-up with its
  own review, not an implementor's choice mid-migration — consistent with the character-space
  definition of Layer 0 either way.
- **The Euler product** for a newform (from Prop 5.8.5; AINTLIB `lSeries_eulerProduct`,
  `Modularforms/LFunctionEuler.lean`): for `f : Newform N k` and `Re s > k/2 + 1`,
  `L(s,f) = ∏_p (1 − aₚ p^{-s} + χ(p) p^{k-1-2s})^{-1}` (#30), the nebentypus zero-extended to
  `p ∣ N` by `Newform.dirichletLift`.
- **The completed L-function and Hecke's functional equation — in AINTLIB's proved form**
  (`Modularforms/LFunctionFEqN.lean`): the completed `Λ_N(s, f)` via the Mellin transform of the
  imaginary-axis restriction, and, for weight `k > 0` on width-one-at-`∞` arithmetic carriers
  with `g = (√N)^{2−k} • (f ∣[k] W_N)` the Petersson-normalized **Fricke companion**,
  `Λ_N(k − s, f) = i^k · Λ_N(s, g)` (`lcompletedN_functional_equation`, specialized to the
  `Γ₁(N)` carrier as `…_Gamma1`); `Λ_N(·, f)` is **entire** (`differentiable_lcompletedΛN`) and
  `L(s,f)` has **analytic continuation** to `ℂ` (`lSeriesN_hasEntireExtension`). Port the
  two-form statement with its hypotheses (`0 < k`, strict width one, the companion equation);
  the one-form `Λ_N(s,f) = ±Λ_N(k−s,f)` with a genuine **sign** (Diamond–Shurman Thm 5.10.2, on
  the Fricke eigenspaces `S_k(Γ₁(N))^±`) is the corollary once Layer 6 gives `W_N f = ε·f` —
  trivial nebentypus, or self-dual `f = f_ρ`.
- **Analytic rank and analytic conductor** (#31): the order of vanishing of `L(f,·)` at the
  central point `s = k/2`, and the **analytic conductor pinned** as Iwaniec–Kowalski (5.7) for
  the weight-`k` gamma factor: with `s_an := s − (k−1)/2` the analytic normalization (the
  central point `s = k/2` is `s_an = 1/2`, and the Γ-factor is
  `Γ_ℝ(s_an + (k−1)/2)·Γ_ℝ(s_an + (k+1)/2)` up to exponentials),
  `𝔮(f, s) := N · (|s_an + (k−1)/2| + 3) · (|s_an + (k+1)/2| + 3)`, and `𝔮(f) := 𝔮(f, k/2)`
  at the central point. This is the definition; do not substitute another normalization
  without renaming.

### Layer 8: modular symbols, the integral Hecke algebra, and coefficient fields

⚠ **This layer contains the roadmap's one genuinely non-elementary machine, and it is named
here rather than hidden in a file path** (review): the coefficient field is a number field
*because* of an integral structure, and the only route to that structure which stays inside
this roadmap's analytic scope is **Eichler–Shimura via modular symbols**. (The alternative —
`S_k(Γ) ≅ H⁰(X(Γ), ω^k)` over `ℚ` by GAGA and algebraic geometry — is a far bigger project
than this roadmap and is **out of scope**.) **Part of this development already exists, due to
Nicola Falciola** ([@Nicola9Falciola](https://github.com/Nicola9Falciola), VU Amsterdam) —
coordinate with that work rather than duplicating it, and credit it on migration; the AINTLIB
files below are attributed collectively, so check with him which pieces are his before
reassigning any milestone as new work. The milestones:

- **The modular-symbol module `𝕄 N k` — no group cohomology.** ⚠ The lattice is built
  **homologically and concretely**, not as parabolic cohomology: `𝕄 N k` is the
  `Γ₁(N)`-**coinvariants** of `Div⁰(ℙ¹(ℚ)) ⊗_ℤ Sym^{k−2}(ℤ²)` — degree-zero divisors on the
  cusps tensored with the weight coefficient system, modulo the group action. This is
  deliberate: it needs no `H¹`, no parabolic subgroup bookkeeping, and no cohomological
  comparison, and it is what the provenance actually uses. The milestone is that **`𝕄 N k` is a
  finite `ℤ`-module**, by a Manin-style orbit-spanning argument — exhibit a finite set whose
  `Γ₁(N)`-orbit spans, using finiteness of the cusps, the difference description of `Div⁰`, and
  finite generation of `Γ₁(N)`. This is the Hecke-stable lattice of the whole story, and note
  where it lives: on the *symbol* side, so **no lattice inside the space of forms is ever
  constructed**
  (AINTLIB `ModularSymbols/{ModuleM,ModuleMFinite,CoefficientSystem,FinitelyManyCusps,CoinvariantsFinite}.lean`).
- **Manin symbols and the fundamental domain.** The `SL₂(ℤ)`-generation and fundamental-domain
  boundary apparatus that presents the symbol module concretely
  (`ModularSymbols/{SL2Generation,ManinFD,FundamentalDomainBoundary}.lean`) — also the entry
  point for any downstream *computation* (worked examples).
- **The Hecke action on symbols**, its commutativity, and its integrality
  (`ModularSymbols/{HeckeSymbol,HeckeCommute,HeckeFinite}.lean`).
- **The period map — into the `ℤ`-dual of the symbols, in three steps.** ⚠ It is **not** a map
  from forms to symbols: it is
  `periodMap' : S_k(Γ₁(N)) →ₗ[ℂ] (𝕄 N k →ₗ[ℤ] ℂ)`, so a cusp form becomes a `ℤ`-linear
  **functional on** the lattice. (That is the natural direction — symbols are cycles, forms are
  the things you integrate over them — and it is why the lattice sits on the *source* of the
  functionals and never has to be transported anywhere.) Build it as the provenance does:
  **(i) the raw pairing.** `rawPairing f : (Div⁰ ℤ ⊗_ℤ Sym^{k−2} ℤ) →ₗ[ℤ] ℂ`, sending
  `{α, β} ⊗ P` to `∫_β^α f(z)·P(z, 1) dz` along the geodesic — defined before any quotient,
  hence with no well-definedness obligation yet.
  **(ii) `Γ₁(N)`-invariance — the one analytic input of this step.** `IsPeriodInvariant f`:
  precomposing `rawPairing f` with the diagonal action of `γ` leaves it unchanged
  (Shimura (8.2.15)/(8.2.16)). Its algebraic half is the `Sym^{k−2}`-action identity; its
  analytic half is **path-independence of the cusp-difference integral** — Cauchy's theorem on
  the region between the geodesics `β → α` and `γβ → γα`. State this as its own milestone; it
  is small, but it is where the analysis actually enters the *construction* (as opposed to the
  injectivity proof).
  **(iii) descent.** Given the invariance, `rawPairing f` descends through the coinvariants to
  `𝕄 N k →ₗ[ℤ] ℂ`, and `periodMap'` is the resulting `ℂ`-linear map.
  Then the **equivariance** milestones (`periodMap'_heckeEnd`, `periodMap'_diamond`):
  `periodMap' (Tₙ f) = (periodMap' f) ∘ Tₙ^{sym}` — note the operator appears by
  **precomposition**, i.e. as a transpose, which is exactly what the dual placement forces
  (`ModularSymbols/{PeriodMap,PeriodIntegral,PeriodInvariant,PeriodHecke}.lean`).
- **Injectivity of the period map** — the analytic heart, and there are two routes; the
  roadmap takes the one the provenance actually proves.
  **Route of record — the Eichler integral (Bol).** For `f ∈ S_k` let `E_f` be its **Eichler
  integral**, the `(k−1)`-fold antiderivative, so that Bol's identity gives
  `f = ((2πi)^{−1})^{k−1}·D^{k−1}E_f`. Assume every period of `f` vanishes. Then, in order:
  **(i)** `E_f∣[2−k]γ − E_f` is the *period polynomial* of `f` at `γ`, of degree `≤ k−2` with
  the periods as coefficients — so it vanishes, and `E_f` is genuinely `Γ₁(N)`-invariant in
  weight `2 − k`;
  **(ii)** `E_f` is **bounded at every cusp** — this is where the analysis sits, and it splits
  in two: at `i∞` from cusp decay of `f` by a dominated-integral bound, and at a **finite**
  cusp (`γ·∞ ≠ ∞`) by slashing and decomposing `(E_f)∣[2−k]γ = E_g − C_k·(cusp value of g)`
  for the conjugate form `g = f∣[k]γ`, where the cusp-value term dies because vanishing periods
  for `f` force them for `g` (`det γ = 1`), leaving `C_k·E_g`, bounded by the same estimate;
  **(iii)** so `E_f` is holomorphic, invariant in weight `2 − k ≤ 0`, and bounded at all cusps.
  For `k > 2` the strictly negative weight forces `E_f = 0` outright (a nonzero constant is not
  invariant of negative weight); at `k = 2` the weight is `0`, and holomorphic + invariant +
  bounded gives only **constancy** — the constant then vanishes because the `q`-expansion
  Eichler integral is normalized with zero constant term (`eichlerCoeff f m = a_m/m^{k−1}`,
  `m ≥ 1`, so `E_f → 0` at `i∞`). Either way `f = D^{k−1}E_f = 0` — and constancy alone would
  already suffice, since the derivative kills constants.
  ⚠ Note `k ≥ 2` is used twice (Bol needs `k − 1 ≥ 1`; step (iii) needs `2 − k ≤ 0`), which is
  precisely why weight `1` is outside this method. And note what never appears: no Stokes
  theorem, no Petersson product, no cup product — only contour manipulation and growth
  estimates, which is why this route came out axiom-clean while the alternative below did not
  (`ModularSymbols/EichlerInjective.lean`: `eichler_slash_invariant`, `eichler_bdd_at_cusp`,
  `eichler_eq_zero`, `bol_iterated_eichler`, capstone `periodMap'_injective_eichler`).
  **Alternative — Shimura's period pairing.** The real bilinear pairing `A(f, g)` of Shimura
  §8.2 (8.2.17)/(8.2.22): a Green's/region-Stokes identity rewrites the Petersson *area*
  integral over a fundamental domain as a *boundary* integral of an exact form, and
  non-degeneracy of `A` then forces `f = 0`. This is the classical "periods determine the
  Petersson norm" argument. ⚠ It is carried in the provenance in Shimura's **integral** form
  (`ModularSymbols/{PeriodInjective,PeterssonStokes}.lean`), and `PeterssonStokes.lean` is
  where the open analytic input (`interior_edges_cancel_sum`) sits. Its usual cohomological
  packaging — Haberland's cup-product formula on parabolic cohomology — is **not** used here
  and is **not** in the provenance; this roadmap deliberately keeps group cohomology out of
  the layer entirely, so do not describe the analytic heart as "a cup product".
- **The transfer to the form side — a free-algebra kernel inclusion, and no analysis at all.**
  This is the step that answers "where is the Hecke-stable lattice?", so state it in full.
  There is **no lattice inside `S_k`**: the integral object is `𝕄 N k`, integral by
  construction, and Hecke-stable for free because the operators are *defined* on symbols. The
  transfer is then pure algebra (`heckeAlgℤ_finite_of_period`):
  **(i)** index the generators by `Idx = ℕ⁺ ⊕ (ZMod N)ˣ` and form two evaluation `ℤ`-algebra
  maps out of the **free** `ℤ`-algebra on `Idx` — `evalS` into `End_ℂ(S_k)`, whose range *is*
  `heckeAlgℤ N k`, and `evalM` into `End_ℤ(𝕄 N k)`. Free, so the universal property applies
  even though the endomorphism rings are noncommutative.
  **(ii)** `𝕄` is `ℤ`-finite and `ℤ` is noetherian, so `End_ℤ(𝕄)` is `ℤ`-finite, hence so is
  `range evalM`.
  **(iii)** the generator equivariance extends along the free algebra by induction, and
  injectivity of `periodMap'` then gives **`ker evalM ≤ ker evalS`**.
  **(iv)** so `FreeAlgebra ⧸ ker evalM ↠ FreeAlgebra ⧸ ker evalS ≅ range evalS = heckeAlgℤ`,
  and `ℤ`-finiteness transports along the surjection.
  ⚠ One hypothesis in (iii) is not decoration: the transpose `dualPrecomp` is an
  **anti**-homomorphism, so the multiplicative step of the induction needs the two images to
  commute — which is why **Hecke commutativity on the symbol side** is an explicit input.
  Note what this argument does *not* need: no Eichler–Shimura **isomorphism**. Injectivity
  alone makes the form-side algebra a *quotient* of the symbol-side one, which is all that
  `ℤ`-module-finiteness requires. The full comparison `𝕄 ⊗ ℂ ≅ S_k ⊕ \overline{S_k}` would
  upgrade the quotient to a faithful embedding, and is **not** a milestone here.
- **And then the coefficient field, in two lines.** `heckeAlgℤ` module-finite over `ℤ` makes
  every `Tₙ` integral over `ℤ`, hence every eigenvalue `aₙ` an **algebraic integer**; the
  eigenvalue homomorphism therefore has `ℤ`-finite range (`newformEigenHom_range_finite`), so
  `ℚ(aₙ : n)` is a finite-dimensional `ℚ`-algebra which is a domain, hence a field — a number
  field (`finiteDimensional_coeffField_of_rangeFinite`).

- **The coefficient field** `CoefficientField f = ℚ(aₙ : n) ⊆ ℂ` of a newform (#34), and the
  headline result that **it is a number field**. ⚠ **This is already constructed and proved in
  AINTLIB** — the layer's headline is a *migration*, not new mathematics: `Labels/NewformOrbit.lean`
  defines `coeffField` and proves `coeffSeq_isIntegral` (the coefficients are algebraic
  integers), `finiteDimensional_coeffField_of_rangeFinite`, the live **instance**
  `instNumberFieldCoeffField`, and `coeffField_numberField_of_two_le`, on top of
  `Labels/{HeckeFieldArithmetic,HeckeAlgFiniteFinal}.lean` (the integral Hecke algebra and its
  finiteness) and the modular-symbol period route above. What is *not* already done is the
  weight-1 branch (below) and the CI/axiom audit the migration owes. AINTLIB's shapes
  (port name `CoefficientField` per the conventions):
  ```lean
  def coeffField (f : Newform N k) : IntermediateField ℚ ℂ
  instance instNumberFieldCoeffField (f : Newform N k) : NumberField (coeffField f)
  theorem coeffField_numberField_of_two_le (f : Newform N k) (hk : 2 ≤ k) :
      NumberField (coeffField f)          -- the axiom-clean route, no weight-1 input
  ```
  proved via the **integral Hecke algebra `heckeAlgℤ N k` is a finitely generated ℤ-module** —
  from the modular-symbol lattice above, so that every `Tₙ` is integral over `ℤ`, every
  eigenvalue `aₙ` is an **algebraic integer**, and `ℚ(aₙ : n)` is a finite-dimensional domain
  over `ℚ`, hence a number field (Shimura Thm 3.48/3.51/3.52, Miyake Thm 4.5.9/4.5.19).
  ⚠ **The weight split is real and is stated, not smoothed over.** For `k ≥ 2` the finiteness
  is the modular-symbol period route above
  (AINTLIB `heckeAlgℤ_finite_of_two_le` / `ModularSymbols.heckeAlgℤ_finite_of_period`,
  axiom-clean), needing **no** lattice on the form side. **Weight 1 is outside this method
  entirely** — `Sym^{−1}` does not exist and weight-one forms are not cohomological in this
  sense — and is a separate milestone with its own input: either Deligne–Serre 1974 (Prop 2.7,
  the classical route, via the attached Artin representation) or a `q`-expansion/integral-model
  argument; AINTLIB's `k < 2` branch (`heckeAlgℤ_finite_of_lattice`) still rests on the
  isolated unproved `exists_HeckeStableLattice_one`, with `U_p`-stability at `p ∣ N` needing
  separate care. `k ≤ 0` is trivial. Do not present the unconditional statement as though one
  argument covered all weights.

### Layer 9: the LMFDB invariant layer
Each is a named definition with its basic API, mostly short once Layer 8 exists:
- **Hecke characteristic polynomials** (#35): `charpoly(Tₙ | S_k(N,χ)^{new})`, its coefficients as
  traces of Hecke operators, and the factorization into Galois orbits.
- **Satake parameters and angles** (#32): the unconditional object is the **unordered pair**
  `{α_p, β_p}` of roots of `X² − aₚX + χ(p)p^{k-1}` — defined for every good `p`, no hypotheses.
  A single **angle** is defined only where it is canonical: for trivial nebentypus (more
  generally, self-dual `f`), where `a_p/p^{(k-1)/2} ∈ ℝ`, and **under the Ramanujan–Deligne
  bound `|aₚ| ≤ 2p^{(k-1)/2}` as an explicit hypothesis**, set `θ_p ∈ [0, π]` by
  `a_p = 2p^{(k-1)/2}·cos θ_p`. For general complex `χ` there is no canonical single angle
  (one must choose a square root of `χ(p)` and quotient by the root swap), so the roadmap does
  not pretend to furnish one. Proving Ramanujan–Deligne is **not a target** — it needs the Weil
  conjectures and Deligne's reduction of Ramanujan to them, far outside the analytic scope
  here — which is exactly why the angle is packaged as conditional rather than presented as an
  unconditional invariant.
- **Galois-conjugate forms and orbits** (#38): `f^σ` (act on coefficients), the orbit `{f^σ}` and
  `#orbit = [CoefficientField f : ℚ]` (exact because the coefficients generate
  `CoefficientField f` by its very definition); **inner twists** (#42). These consume Layer 8's integrality —
  the coefficients must be algebraic for `σ` to act at all — so they sit downstream of the
  modular-symbol machinery, not beside it.
- **Galois-group certification** (what the weight-60 example needs): the Galois closure
  of `CoefficientField f` and a decision procedure for its **solvability**, presented as a
  *certificate checker* rather than a search — Dedekind/Frobenius **cycle-type certificates**
  (factor the minimal polynomial modulo well-chosen primes, read off cycle types, conclude
  transitivity plus a generating element) and the discriminant square test. This is the API a
  downstream computational repo calls; `CBirkbeck/CertifyingInvariantsNF`, bridged into
  LeanBridge, is the existing implementation (§Provenance).
- **Dual / self-dual** (#55): `f̄` (conjugate coefficients) and `IsSelfDual f ↔ ∀n, (aₙ).im = 0`.
- **Labels** (#33, #13): the LMFDB label `N.k.a.x` (level, weight, character Galois-orbit, newform
  Galois-orbit), Conrey labels and Galois orbits of Dirichlet characters.
- **Bad primes** (#54): `badPrimes f = N.primeFactors`.

### Layer 10: the modular curve `Γ\ℍ` and the dimension formulas
The modular curve here is the **analytic quotient `Γ\ℍ`**, compactified to a compact Riemann
surface `X(Γ) = Γ\ℍ*` by adjoining the cusps `Γ\ℙ¹(ℚ)` — defined directly, with **no functor, no
representability, no moduli problem**.

- **The Sturm bound and finite-dimensionality — consume from Mathlib, don't re-prove.** A
  nonzero `f ∈ M_k(Γ)` has `q`-order at `∞` at most `k·[SL₂(ℤ):Γ]/12`; consequently `M_k(Γ)`
  and `S_k(Γ)` are **finite-dimensional at every level**. Level one is merged
  (`ModularForm.sturm_bound_levelOne`, #38993); the finite-index/arithmetic case —
  `ModularForm.sturm_bound_finiteIndex` and the `Module.Finite ℂ (ModularForm 𝒢 k)` instance —
  is the in-review stack #39000 (+#39083/#39086/#39087/#39088), proved by the elementary
  **modular norm map** route (`∏_γ f∣[k]γ` over coset representatives lands at level one, where
  the level-one bound kills it) — the same argument as AINTLIB's `dim_gen_cong_levels`
  (`Modularforms/DimGenCongLevels/*`), which it upstreams. Downstream, the Sturm bound is this
  layer's **main computational criterion**: two forms agreeing on the first `⌊k·[SL₂(ℤ):Γ]/12⌋ + 1`
  coefficients are equal, which is how the concrete dimension instances in `Suggested.lean` and
  the LMFDB layer's equality checks (Layer 9) become finite computations.
- **The analytic theory of cusps and compactification.** Build `X(Γ) = Γ\ℍ*` as a compact Riemann
  surface: the topology and complex charts at ordinary points, at the elliptic points (where the
  chart is `z ↦ z^{e_P}`), and at the cusps (the `q`-disc chart); the **cusp count** `ε∞ = #Γ\ℙ¹(ℚ)`
  and the **elliptic-point counts** `ε₂, ε₃` (periods `2, 3`, counted in the `PSL₂(ℤ)`-image where
  the elliptic stabilizers are cyclic of order `2, 3`); and the **genus** `g` of `X(Γ)` as
  the genus of this compact Riemann surface — via the Euler characteristic of the
  `SL₂(ℤ)\ℍ*`-covering (Diamond–Shurman §3.1, §3.9). These
  counts and the genus are the inputs to the dimension formulas; building them is part of this
  layer, not assumed.
- **The dimension formulas** (Diamond–Shurman Thm 3.5.1) — honest about their two halves. The
  Layer-1 valence formula with the `ε₂, ε₃, ε∞` counts and the genus `g` above yields the
  **upper bounds**: enough imposed zeros force a form to vanish. It does **not** by itself
  produce the required number of independent forms. The **lower bounds are Riemann–Roch**:
  identify `M_k(Γ)` and `S_k(Γ)` with section spaces of the weight-`k` automorphy divisor on
  `X(Γ)` (with the `⌊·⌋`-corrections at elliptic points and cusps — D–S §§3.5–3.6), and apply
  **analytic Riemann–Roch** `ℓ(D) − ℓ(K−D) = deg D + 1 − g` on the compact Riemann surface
  `X(Γ)`, together with `S_2(Γ) ≅ H⁰(X(Γ), Ω¹)` and `dim H⁰(X, Ω¹) = g`.
  ⚠ **Analytic Riemann–Roch is consumed here, not built — and its roadmap does not exist
  yet.** Divisors and Riemann–Roch on compact Riemann surfaces belong to a **planned**
  compact-Riemann-surfaces roadmap (in the spirit of the PR #36 review's advice: analytic
  curve, no GAGA, but Riemann–Roch actually supplied). Until that roadmap is written and
  cited here, **the exact general formulas below are *not* part of this roadmap's grounded
  portion**: they are stated as the layer's summit and explicitly **gated** on that future
  roadmap, per the repository rule that missing material must be a target here or in a cited
  roadmap. What *is* grounded now: `X(Γ)` and its charts, the `ε₂, ε₃, ε∞` counts and the
  genus, finite-dimensionality via the Sturm stack, the valence-formula **upper bounds**, and
  the concrete `Suggested.lean` instances — whose lower bounds come from explicitly exhibited
  forms (the level-`11` eta quotient, weight-`2` Eisenstein series), not from general
  Riemann–Roch. That Riemann–Roch input is *not* the Jacobian Challenge's algebraic
  `χ(L) = deg L + 1 − g` (its Layer B): identifying the analytic and algebraic theories is a
  comparison this roadmap deliberately does not own. With the gated inputs, the formulas —
  extending Mathlib's level-one `ModularForm.dimension_level_one` to general level — read,
  for **even `k`**:
  ```text
  dim M_k(Γ) = (k-1)(g-1) + ⌊k/4⌋·ε₂ + ⌊k/3⌋·ε₃ + (k/2)·ε∞          (k ≥ 2)
  dim S_k(Γ) = (k-1)(g-1) + ⌊k/4⌋·ε₂ + ⌊k/3⌋·ε₃ + (k/2 - 1)·ε∞      (k ≥ 4),   dim S_2(Γ) = g
  ```
  (`dim M_0 = 1`, `dim S_0 = 0`, both `0` for `k < 0`); the **odd-`k`** formulas (D–S §3.6) split
  the cusps into regular and irregular and drop the `ε₂` term. `dim S_2(Γ) = g` is the statement
  that weight-two cusp forms are the holomorphic differentials on `X(Γ)`.
- `Suggested.lean` seeds this layer with concrete instances at levels `> 1`: `dim S_2(Γ₀(11)) = 1`,
  `dim S_2(Γ₀(23)) = 2`, `dim S_2(Γ₀(2)) = 0`, `dim M_2(Γ₀(11)) = 2`. The general even-weight
  formula above is the layer's headline target; it is stated here in the README (its inputs are
  the `ε₂, ε₃, ε∞, g` of `X(Γ)` from this same layer **plus the gated analytic Riemann–Roch
  input above — so it sits outside the grounded portion until the compact-Riemann-surfaces
  roadmap exists**; the concrete instances are grounded independently), and is **not** seeded
  as a
  free-parameter `example` in `Suggested.lean`, since with `g, ε₂, ε₃, ε∞` as free variables it is
  false for the wrong data. We keep only the concrete, verifiable instances and pin the general
  statement in prose.

### Layer 11: the Eichler–Selberg trace formula (level one)
An independent lane off Layers 2–3 and **not an AINTLIB migration**: neither AINTLIB nor Mathlib
has any of it (no Hurwitz class numbers, no trace formula) — this layer is new formalization
ground, and we found no Lean prior art (as of July 2026).

- **Hurwitz class numbers, combinatorially.** `H : ℕ → ℚ` with `H 0 = −1/12` and, for `D > 0`
  with `−D ≡ 0, 1 (mod 4)`, `H D` = the number of `SL₂(ℤ)`-classes of positive-definite integral
  binary quadratic forms `ax² + bxy + cy²` of discriminant `b² − 4ac = −D`, counting the classes
  of multiples of `x² + y²` with weight `1/2` and of `x² + xy + y²` with weight `1/3`
  (`H D = 0` for `−D ≡ 2, 3 (mod 4)`). Define it by **reduced forms** — a finite, decidable
  count: **no class groups, no class field theory** — and ship it with the first values
  `H 3 = 1/3`, `H 4 = 1/2`, `H 7 = 1`, `H 8 = 1` as `decide`-style tests. Independently
  Mathlib-worthy.
- **The weight polynomials.** `P_k(t, n)`, the coefficient family with generating function
  `Σ_{k ≥ 2} P_k(t,n)·x^{k−2} = (1 − tx + nx²)⁻¹`, i.e.
  `P_k(t,n) = (ρ^{k−1} − ρ̄^{k−1})/(ρ − ρ̄)` for `ρ + ρ̄ = t`, `ρρ̄ = n` — Miyake's elliptic
  weight `a_k(t)` (§6.8) — equivalently `n^{(k−2)/2}·U_{k−2}(t/(2√n))`: relate it to Mathlib's
  Chebyshev polynomials (`Polynomial.Chebyshev.U`), do not re-found a polynomial family.
- **The trace formula** (even `k ≥ 4`, `n ≥ 1`):
  ```text
  tr(Tₙ | S_k(SL₂(ℤ))) = −½·Σ_{t ∈ ℤ, t² ≤ 4n} P_k(t,n)·H(4n − t²) − ½·Σ_{d·d′ = n, d,d′ > 0} min(d,d′)^{k−1}
  ```
  ⚠ Pin the packaging before writing code: this is Zagier's normalization, in which
  `H 0 = −1/12` makes the `t² = 4n` terms absorb the identity/volume contribution
  (`P_k(±2√n, n) = (k−1)·n^{(k−2)/2}`) and the divisor sum carries the hyperbolic and parabolic
  mass; Miyake Thm 6.8.4 keeps these contributions separate. Either bookkeeping works; do not
  mix them. The `k = 2` variant carries a `σ₁(n)`-type correction term — the quasi-modular
  `E₂`/regularization phenomenon — and is **out of scope**: the scope wall below applies to it
  as to general level, and nothing on this roadmap consumes it (the acceptance criteria live
  at `k ≥ 4` and `k = 12`).
- **The route of record is the period-polynomial route** (Popa–Zagier): compute the Hecke
  action and its trace on **period polynomials** — the world of AINTLIB's
  `HeckeRIngs/GL2/ModularSymbols/*` (`HeckeSymbol`, `PeriodHecke`, `SL2Generation`) — where
  the trace identity is provable with **no analytic input**; the transfer to `S_k(SL₂(ℤ))`
  uses the Eichler–Shimura comparison. ⚠ **The transfer route is pinned now, not left to the
  implementor: the dimension-count route, with the comparison space named exactly.** Let
  `w = k − 2` and define the period-polynomial space
  `W_w = ker(1 + S) ∩ ker(1 + U + U²)` inside the degree-`≤ w` polynomials, where
  `S = (0, −1; 1, 0)` and `U = (1, −1; 1, 0)` are the standard order-`2` and order-`3`
  elements of `PSL₂(ℤ)`, with its even and odd parts `W_w^±`. Construct the **odd** period
  map `S_k → W_w⁻` and the **extended even** period map `M_k → W_w⁺`, whose even part
  includes the Eisenstein polynomial `X^w − Y^w` representing `E_k`; prove both
  **Hecke-equivariant and injective** (the odd map is Layer 8's injectivity in
  period-polynomial clothing); compute `dim W_w^±` **algebraically** — finite linear algebra
  on polynomial spaces — and conclude from Mathlib's `ModularForm.dimension_level_one` the
  Hecke-equivariant isomorphism `M_k ⊕ S_k ≅ W_w` by dimension count. Popa–Zagier's algebraic
  trace computation then runs on the **full** `W_w` —
  `tr(Tₙ | W_w) = tr(Tₙ | M_k) + tr(Tₙ | S_k)` — and the cusp-form trace is isolated by
  subtracting the Eisenstein eigenvalue `σ_{k−1}(n)`. Two consequences, both deliberate:
  Layer 8's injectivity never touches `interior_edges_cancel_sum`, so that open `sorry`
  acquires **no** second consumer — what this route avoids is the *cohomological*
  (coboundary / parabolic-cohomology) packaging, **not** the even/odd and Eisenstein
  bookkeeping, which is real work and is named above as targets; and the `tr T(1) = dim S_k`
  acceptance criterion below becomes a **consistency check** of the transfer, not an
  independent re-derivation of the dimension formula, which is now one of its inputs. Chosen over the kernel route (Miyake
  §§6.1–6.4; Zagier's appendix in Lang: the two-variable kernel
  `ω_n(z, w) = Σ_{ad−bc=n} (czw + dz + aw + b)^{−k}` as the Petersson kernel of `Tₙ`, unfolded
  over conjugacy classes — ⚠ and note that appendix's **published error**: Case 3 (p. 53,
  hyperbolic matrices with rational fixed points) interchanges a sum and an integral without
  absolute convergence, plus a sign slip; the fix, via truncated fundamental domains, is
  Zagier's own *Correction* in LNM 627 (references), which anyone taking this route must
  follow) because the kernel route requires the Petersson-coefficient /
  Poincaré-series machinery of Miyake Thms 2.6.9–2.6.10, which neither Mathlib nor AINTLIB
  has — that machinery is **out of scope for this layer** (it would be a subproject of its
  own), while the period-polynomial route consumes only rails Layers 2 and 8 already lay. The
  class `H(4n − t²)` enters either way by counting integer matrices of determinant `n` and
  trace `t` up to conjugacy ↔ binary quadratic forms of discriminant `t² − 4n`.
- **Acceptance criteria:** `tr T(1) = dim S_k(SL₂(ℤ))` against Mathlib's
  `ModularForm.dimension_level_one` — a **consistency check** of the pinned transfer route
  (which consumes that dimension formula), not an independent re-derivation of it;
  `tr T(2) | S₁₂ = τ(2) = −24` — the Δ worked example, reached from a second direction;
  the characteristic polynomial of `T₂` on `S_k(SL₂(ℤ))` for a few `k`, feeding Layer 9's
  `charpoly` targets at level one.
- **Scope wall.** The general-level formula — `tr(Tₙ | S_k(Γ₀(N), χ))`, Miyake Thm 6.8.4, proved
  there for orders in indefinite quaternion algebras via §§6.5–6.7 (local conjugacy classes,
  optimal-embedding counts, Eichler symbols, class numbers of non-maximal orders of `ℚ[α]`) — is
  **out of scope**: that apparatus shares nothing with this roadmap's layers and belongs to a
  future roadmap (Hijikata's formula), not to an extension of this layer.
- **A second route to the weight-60 example, once this layer works.** The characteristic
  polynomial of `T₂` on `S_k(SL₂(ℤ))` is determined by the traces `tr(T_{2ⁿ})` for
  `1 ≤ n ≤ dim S_k` (Newton's identities on the eigenvalues of `T₂`, since `T_{2ⁿ}` is a
  polynomial in `T₂`), and at `k = 60` that is `n ≤ 5` — all computable from this layer's trace
  formula. Whether that is cheaper than the Victor Miller route of the worked examples is an
  open practical question and worth trying; record the answer when someone does. Either way it
  gives Layer 11 a concrete downstream consumer.

## Worked examples (acceptance criteria, keeping the theory honest)

⚠ **How the examples are computed — the policy, stated once.** There are two ways to get
`q`-expansions of actual eigenforms. (1) Develop enough theory to compute at any weight and
level; that means modular symbols with an explicit presentation and Hecke matrices, and it is
substantial work. (2) Restrict to forms with an **eta-quotient expansion**, where the
coefficients come out of a product formula by elementary manipulation. **This roadmap does
(2).** The rule of thumb is `(N+1)k = 24`: `Δ` (`N = 1`, `k = 12`), the level-`11` weight-`2`
newform (`12 · 2 = 24`), the level-`7` weight-`3` form (`8 · 3 = 24`) — and one is in good
shape when the relevant cusp-form space is `1`-dimensional, so the eta quotient *is* the
newform. Anything outside that class — level `37`, the weight-`60` charpoly, non-rational
coefficient fields — is **not** an acceptance criterion of this roadmap and is routed to the
downstream computational repository (weight-`60` entry below). Note the consequence for
route (2): eta quotients have **rational** coefficients, so no example with non-real `aₙ` can
be reached this way.

- **Δ at level one** (`k = 12`, `N = 1`): the unique normalized cusp form; `τ(p)` are its Hecke
  eigenvalues; `aₙ` multiplicative with the `τ(p^r)` recurrence (Prop 5.8.5). The first eigenvalue
  is concrete: **`T₂` acts on `Δ` by `−24`** (`a₂(Δ) = τ(2) = −24`, from the coefficient of `q²`
  in `Δ = q∏(1−qⁿ)²⁴`, equivalently `(E₄³ − E₆²)/1728`) — a fully computable acceptance test of the
  Hecke action (Layer 2).
- **Level 11, weight 2** (`S₂(Γ₀(11))`, dimension 1): a single newform, the elliptic curve `11a`;
  its Fricke sign (Layer 6) and the root-number-`+1` functional equation (Layer 7) — the sign
  forces only *even* analytic rank; rank `0` itself would additionally need a central-value
  nonvanishing argument this roadmap does not claim. Like `Δ`, it has a
  **product formula** making the coefficients computable by the same route:
  `f = η(z)²η(11z)² = q∏_{n≥1}(1−qⁿ)²(1−q^{11n})²` — note the squares, and note that
  `η(z)η(11z)` is *not* the weight-`1` form to reach for: it fails the standard eta-quotient
  criterion (`Σ d·r_d = 1 + 11 = 12 ≢ 0 (mod 24)`, Ligozat/Newman), so it carries a weight-`1`
  transformation law only with a nontrivial finite **eta multiplier** on `Γ₀(11)` — a perfectly
  meaningful law, but not one with a Dirichlet nebentypus, hence outside this roadmap's
  transformation-law conventions; the genuine weight-`1` eta quotient with a Dirichlet
  character is `η(z)η(23z)`, from the same `(N+1)k = 24` rule — so `a₂ = −2`, and `a₁₁ = 1`, the bad-prime
  eigenvalue predicted by Layer 4's
  classification at `v₁₁(N) = 1`, `χ` trivial (`±11^{(2−2)/2} = ±1`).
- **Level 37, weight 2** — the honest version, split by what is *derivable* and what is
  *computed*. Derivable here: `dim S₂(Γ₀(37)) = 2` (Layer 10); the space is **entirely new**,
  since `37` is prime and `S₂(SL₂(ℤ)) = 0` leaves no oldforms; semisimplicity of the commuting
  good Hecke operators plus multiplicity one (Layer 5) gives **exactly two normalized complex
  eigenforms**, each — since `w₃₇` commutes with the good `Tₙ` and squares to `1` — an
  Atkin–Lehner eigenvector of sign `±1` (Layer 6), so `tr(w₃₇) ∈ {−2, 0, 2}`. **Not** derivable
  from those facts: that the two are *rational* newforms rather than one quadratic Galois orbit,
  and that their signs are **opposite** (`tr w₃₇ = 0`). Both are computations — Manin symbols,
  or the genus of `X₀(37)/w₃₇` — and belong to the downstream computational repo described in
  the weight-60 entry below, not to this roadmap's acceptance criteria.
- **A newform with non-real `aₙ`** — ⚠ **not an acceptance criterion here**, and the entry is
  kept only to say why. Such a form would exercise the coefficient-field (Layer 8) and
  not-self-dual (Layer 9) statements, but eta quotients have rational coefficients, so the
  computational policy above cannot reach one: exhibiting it needs an explicit `q`-expansion at
  a specific level and weight, i.e. modular symbols. It therefore belongs to the downstream
  computational repository, together with a definite target (a nebentypus newform such as
  `13.2.e.a`) rather than an unnamed "some newform".
- **`η²⁴ = Δ`** as a weight-12 eta quotient (#19): develop `η = q^{1/24}∏(1−qⁿ)` and its `SL₂(ℤ)`
  transformation, and the Ligozat criterion, as an explicit worked example of a modular form rather
  than as general theory.
- **The coefficient-field example — a weight-60 level-one eigenform with non-solvable
  coefficient field.** There is a normalized eigenform `f ∈ S₆₀(SL₂(ℤ))` whose coefficient field
  `CoefficientField f` has a Galois closure over `ℚ` that is **not solvable** — the first known
  example, computed by Buzzard in 1992 in answer to a question of Ramakrishnan
  ([*J. Number Theory* **57** (1996)](https://www.sciencedirect.com/science/article/pii/S0022314X96900396)),
  and suggested for this roadmap by its author on the predecessor PR.
  ⚠ **Scope split (review).** The explicit numerical verification is *not* a target of this
  roadmap: it is an exact power-series-and-linear-algebra calculation of a different character
  from everything above, and it belongs in a **separate repository depending on Tau Ceti**
  (`CBirkbeck/LeanBridge` is the existing instance of exactly that — see §Provenance). What
  this roadmap owes is the **reusable API that makes such a verification a finite calculation
  and nothing more**, namely:
  - the level-one **graded-ring structure** `M_*(SL₂(ℤ)) = ℂ[E₄, E₆]` with `S_k = Δ·M_{k−12}`
    (Mathlib has `Δ = (E₄³ − E₆²)/1728` in `LevelOne/GradedRing.lean` but **not** the
    generation statement — a genuine gap this roadmap fills), so any level-one form is named by
    a polynomial in `E₄, E₆`;
  - a **`q`-expansion evaluation interface**: the coefficients of such a polynomial expression
    as computable rational data;
  - the **Sturm-bound comparison lemma** — two level-one forms of weight `k` agreeing to
    `⌊k/12⌋` are equal — which turns "match finitely many coefficients" into an identity
    (Mathlib's `sturm_bound_levelOne`, consumed in Layer 10);
  - the **`Tₙ` action on `q`-expansions** in the form `aₘ(Tₙf) = Σ_{d ∣ (m,n)} d^{k−1} a_{mn/d²}(f)`
    (Layer 2), so Hecke matrices are extractable;
  - the Layer-8 identification `CoefficientField f = ℚ(α)` for the eigenvalue field, and the
    Layer-9 **Galois-group certification interface** (below), so that "non-solvable" is a
    checkable property of an explicit minimal polynomial.
  With those in place the remaining work is the calculation itself: at `k = 60` the space has
  dimension `5`, the Sturm bound is `5`, expansions through `q¹⁰` suffice, and the
  characteristic polynomial of `T₂` is an irreducible quintic whose Galois group is `S₅` —
  certified by Frobenius cycle types (irreducible mod `83`, factoring as `2+1+1+1` mod `17`:
  transitive plus a transposition in prime degree forces `S₅`).

## Ordering

Layer 0 (diamond operators and nebentypus) and Layer 2 (Hecke operators) are the trunk and come
first; the valence
formula (Layer 1) is an independent early lane that only needs the Contour Integration roadmap.
Layers 3–5 (Petersson → newforms → strong multiplicity one) are the core arithmetic and must be
sequential. Layers 6–7 (Atkin–Lehner → L-functions) and Layer 8 (coefficient fields) consume
Layer 5; Layer 9 (LMFDB invariants) consumes Layer 8. Layer 10 (the modular curve `Γ\ℍ` and the
dimension formulas) consumes Layer 1 and Mathlib's Sturm-bound finiteness, and is otherwise
independent. Layer 11 (the level-one trace formula) consumes Layer 2 and the Layer-8
modular-symbol/Eichler–Shimura machinery on its period-polynomial route of record, is
otherwise independent,
and feeds Layer 9's characteristic-polynomial targets while cross-checking Layer 10 at level
one.

## Provenance (migrate and clean from AINTLIB `LeanModularForms`)

**The downstream computational repository.** Distinct from the migration map below, and worth
naming first because it fixes this roadmap's boundary: `CBirkbeck/LeanBridge` ("Link LMFDB and
Lean") is a **separate repository that depends on the library**, where explicit numerical
verifications live — exactly the split the weight-60 entry pins. It already contains, `sorry`-free,
generated `q`-expansion certifications for level-one weights `12`–`316` (≈2150 files under
`LeanBridge/ForMathlib/QExpansion/LMFDB/`), each constructing the LMFDB orbit explicitly in the
`(E₄, E₆)` basis and proving a Sturm-bound **uniqueness theorem**. `Weight_60.lean` is the
weight-60 case: the orbit `1.60.a.a`, the explicit degree-`5` minimal polynomial of `α`, the
`q`-coefficients decomposed over `ℚ(α)`, and `identifies_lmfdb_1_60_a_orbit` via
`ModularForm.eq_of_sturm_bound`. Its `add-galois-certification` branch bridges
`CBirkbeck/CertifyingInvariantsNF` (Dedekind/Frobenius cycle-type certificates, the discriminant
square test), which is the Layer-9 certification interface's implementation. Nothing in that
repository is a target *of this roadmap*; it is the consumer that tells us which **API** the
roadmap owes (Layer 9 and the weight-60 worked example list them), and the evidence that the
remaining work there is calculation rather than theory.

Secondary to the mathematics above: the migration map. The reference is the AINTLIB monorepo's
`projects/LeanModularForms/` on branch **`dev/leanmodularforms`** (resynced **2026-07-17**, re-verified **2026-07-23**, at
`112d12d95`); paths are relative to its `LeanModularForms/`. The tree is **actively
restructured**, so verify names against the live tree before porting. Headline theorems are
`sorry`-free unless flagged; the flagged open `sorry`s are exactly three —
`exists_HeckeStableLattice_one` (L8), `interior_edges_cancel_sum` (L8), and
`peterssonInner_aggregate_eq_zero_of_new_old` (L3, bad primes) — plus the
`ModularSymbols/Skeleton.lean` spec file and the out-of-scope `GLn/PolynomialRing.lean`
general-`n` branch.

- **Nebentypus / characters (L0):** `HeckeRIngs/GL2/Gamma1Pair.lean` (`diamondOp*`,
  `diamondOpHom`, `modFormCharSpace`, `cuspFormCharSpace`, the `*_iff_nebentypus` bridges);
  `HeckeRIngs/GL2/CharacterDecomp.lean` (`ModularForm_Gamma1_charSpace_directSum` and its
  `iSupIndep`/`iSup` halves, plus the cusp-form versions).
- **Valence formula (L1):** `ForMathlib/ValenceFormulaFinal.lean` (`valence_formula_textbook`)
  on top of `ForMathlib/ValenceFormula*.lean` and `ForMathlib/ValenceFormula/WindingWeights/*`,
  with the FD-boundary bridge (`ForMathlib/*FDBoundary*`, `*CornerFTC*`, `*CrossingAt*`) over
  the Contour Integration roadmap's results.
- **Hecke theory (L2):** `HeckeRIngs/AbstractHeckeRing/*` (the abstract ring — **being
  upstreamed** as Mathlib #41251 merged + #41253–#41256, #41277, #41279, #41328 in review; commutativity via
  `mul_comm_of_antiInvolution` with `GLn/TransposeAntiInvolution.lean`);
  `HeckeRIngs/GL2/{Basic,HeckeT_p,HeckeT_p_Gamma0,HeckeT_p_Gamma1,HeckeT_p_GLpair,HeckeT_n,FourierHecke,MultiplicationTable,CongruenceIndex,Degree,LevelEmbed,LevelRaise}.lean`;
  the ring-action layer
  `HeckeRIngs/GL2/Unified/{Gamma0RingDn,NebentypusHeckeRingHom,RingTransport,TwistedHeckeRing}.lean`
  (`heckeRingDn`, `heckeRingHomCharSpace`). ⚠ `ShimuraHom.lean` and
  `heckeRingHomCharSpaceShimura` are **deliberately not ported**: the conventions fix the
  arithmetic normalization as the only one, so the Shimura-normalized action stays behind.
- **Petersson / old–new (L3):** `Modularforms/{PeterssonInner,PeterssonInnerProduct,PeterssonLevelN}.lean`
  (`petN`, `μ_hyp`), `HeckeRIngs/GL2/AdjointTheory*.lean` (`heckeT_n_adjoint`),
  `HeckeRIngs/GL2/Newforms/Basic.lean` (`cuspFormsOld`, `cuspFormsNew`, orthogonality,
  `isCompl`). ⚠ Bad-prime old-stability is the flagged `sorry`
  `peterssonInner_aggregate_eq_zero_of_new_old` (`Newforms/AdjointTheoryBadPrime.lean`); the
  source-faithful Fricke replacement route is
  `Newforms/{BadPrimeFDTiling,BadPrimeTraceFricke,FrickeOldStable}.lean`.
- **Newforms / conductor (L4):**
  `HeckeRIngs/GL2/Newforms/{Basic,Newform,FullEigenform,CoeffSeq,MainLemmaProof,Molteni}.lean`,
  `HeckeRIngs/GL2/Unified/EigenformFromRing.lean`, `Eigenforms/{MainLemma,AtkinLehner}.lean`
  (Miyake §4.6 coprime sieving and the `q`-support/descent machinery),
  `Eigenforms/ConductorTheorem.lean` (proved: `conductor_theorem_dichotomy_cuspForm_strong`).
  The Main Lemma is **fully proved**: global `mainLemma` (`Newforms/MainLemmaProof.lean`) via
  `mainLemma_charSpace_routeB` (`StrongMultiplicityOne.lean`).
- **Strong multiplicity one (L5):** `StrongMultiplicityOne.lean` and `StrongMultiplicityOne/*`
  (`InductiveStep`, `HeckeDescent`, `DescentCharSpace`, `ConstantMultiple` — the `sorry`-free
  `strongMultiplicityOne` and `strongMultiplicityOne_constMul`); the §5.8.5 characterization in
  `HeckeRIngs/GL2/Newforms/{FullEigenform,CoeffSeq}.lean` and `HeckeRIngs/GL2/FourierHecke.lean`.
- **Fricke (L6):** `HeckeRIngs/GL2/Fricke.lean` (`frickeOperator`, `frickeScalar`,
  `frickeCharRestrict`/`frickeCharEquiv`),
  `HeckeRIngs/GL2/Newforms/{FrickeOldStable,BadPrimeTraceFricke}.lean`. The general `W_Q` family
  and the newform signs are **new** here.
- **L-functions (L7):**
  `Modularforms/{LFunction,LFunctionEuler,LFunctionFEq,LFunctionFEqN,ResToImagAxis,AtImInfty}.lean`
  (`lCoeff`, `lSeries`, `lSeries_eulerProduct`, `lcompletedΛN`,
  `lcompletedN_functional_equation`, `differentiable_lcompletedΛN`,
  `lSeriesN_hasEntireExtension`).
- **Coefficient field (L8) — constructed, not to build:** `Labels/{HeckeFieldArithmetic,HeckeAlgFiniteFinal,NewformOrbit}.lean`
  (`heckeAlgℤ`, `heckeAlgℤ_finite_of_two_le`/`heckeAlgℤ_finite_of_lattice`, `coeffField`,
  `coeffSeq_isIntegral`, `finiteDimensional_coeffField_of_rangeFinite`, the instance
  `instNumberFieldCoeffField`, `newformEigenHom_range_finite`,
  `coeffField_numberField_of_two_le`) plus the integral-period route in
  `HeckeRIngs/GL2/ModularSymbols/*` — where the working injectivity route is
  `EichlerInjective.lean` (`periodMap'_injective_eichler`, proved, `#print axioms` clean, and
  *not* passing through `interior_edges_cancel_sum`), while `PeterssonStokes.lean` carries the alternative
  Shimura/Green's-identity route and is where the open analytic input sits. Largely proved
  (`k ≥ 2` axiom-clean); residual `sorry`s are
  the weight-1 lattice `exists_HeckeStableLattice_one` (`Labels/HeckeFieldArithmetic.lean`) and
  the Eichler–Shimura boundary-cancellation step `interior_edges_cancel_sum`
  (`ModularSymbols/PeterssonStokes.lean`). ⚠ **Attribution:** part of the modular-symbol
  development is due to **Nicola Falciola** (VU Amsterdam); the files carry a collective
  "LeanModularForms contributors" header, so establish per-file authorship with him before
  porting, and carry it into the ported headers.
- **LMFDB layer (L9):** `Labels/{Label,Encoding,NewformOrbit,CharacterOrbit}.lean`.
- **Dimensions / curve (L10):** `Modularforms/DimensionFormulas.lean` with
  `Modularforms/DimGenCongLevels/*` (`dim_gen_cong_levels` — general-level
  finite-dimensionality by the norm-map route, the content being upstreamed as the Mathlib Sturm
  stack #39000; `cuspform_weight_lt_12_zero`); the general-level analytic
  cusp/compactification theory and the general dimension formula are **new** here.
- **Trace formula (L11):** no AINTLIB source — entirely **new**; route B's substrate is the
  `ModularSymbols` subtree above.

The two structural audits `.mathlib-quality/{newforms,eigenforms-smo}-overview-2026-05-31.md`
catalogue the redundancy to collapse during migration.

## References

- F. Diamond, J. Shurman, *A First Course in Modular Forms* (GTM 228): Ch. 3 (dimension formulas,
  the genus, the analytic theory of `Γ\ℍ*`), Ch. 5 (Hecke operators, newforms, Thm 5.8.2, Props
  5.8.4–5.8.5, §5.9 L-functions).
- T. Miyake, *Modular Forms*: §4.5–4.6 (the integral structure, the conductor theorem, and strong
  multiplicity one Thm 4.6.12) — the numbering the AINTLIB code follows; Ch. 6 (the trace
  formula: §§6.1–6.8, Thm 6.8.4 — Layer 11's kernel route, and the general-level scope wall).
- D. Zagier, *The Eichler–Selberg trace formula on SL₂(ℤ)*, appendix to S. Lang, *Introduction to
  Modular Forms* — the level-one normalization of Layer 11. ⚠ **Must be read with** D. Zagier,
  *Correction to "The Eichler–Selberg trace formula on SL₂(ℤ)"*, in *Modular Functions of One
  Variable VI*, Lecture Notes in Mathematics **627** (Springer, 1977), 171–173
  ([doi:10.1007/BFb0065300](https://doi.org/10.1007/BFb0065300)): the appendix's Case 3
  (p. 53) unfolds a non-absolutely-convergent expression by interchanging a sum and an
  integral, and carries a sign error; the final formula is right, the printed derivation is
  not. A. Popa, D. Zagier, *A simple proof
  of the Eichler–Selberg trace formula*
  ([arXiv:1711.00327](https://arxiv.org/abs/1711.00327)) — the period-polynomial route of record.
- G. Shimura, *Introduction to the Arithmetic Theory of Automorphic Functions*: Ch. 3 (the Hecke
  algebra and its integral structure, Thms 3.48/3.51/3.52).
- K. Buzzard, *On the eigenvalues of the Hecke operator T₂*, J. Number Theory **57** (1996) — the
  weight-60 non-solvable coefficient-field example (worked examples).
- J. Sturm, *On the congruence of modular forms*, in *Number Theory* (New York 1984–85), Springer
  LNM **1240** — the Sturm bound (Layer 10), heading into Mathlib via the modular norm map
  (#38993 merged, #39000 in review).
- N. Hungerbühler, M. Wasem, *Non-integer valued winding numbers and a generalized Residue
  Theorem*, arXiv:1808.00997 — the contour-integration result behind the valence formula's
  elliptic-point weights (see the [Contour Integration roadmap](../ContourIntegration/README.md)).
- A. Atkin, J. Lehner, *Hecke operators on Γ₀(m)*; A. Atkin, W. Li, *Twists of newforms and
  pseudo-eigenvalues of W-operators*, Invent. Math. **48** (1978) — Layer 6's sign theory at
  general nebentypus; W. Stein, *Modular Forms: A Computational
  Approach* (the small-level dimension tables). The **LMFDB** (`https://www.lmfdb.org`) knowls
  fixed by the target definitions.

## Acknowledgements

The body of theory is **migrated and cleaned** from the AINTLIB `LeanModularForms` project
([github.com/CBirkbeck/AINTLIB](https://github.com/CBirkbeck/AINTLIB)), where the headline results
are already `sorry`-free; thanks to its authors. The target definitions discharge a large set of
"def-wanted" specifications from the [LeanBridge](https://github.com/CBirkbeck/LeanBridge)
project: issues #13, #18, #19, #30–#35, #37, #38, #42, #54, #55. The contour-integration results the valence
formula depends on come from the sibling
[Contour Integration roadmap](../ContourIntegration/README.md).
