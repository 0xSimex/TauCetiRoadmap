# Roadmap: local fields and ramification

This roadmap owns the local-field substrate: normalized valuations, unit filtrations,
unramified extensions, lower and upper ramification groups, Herbrand functions, wild inertia,
and tame quotients. It stops before local reciprocity and before the arithmetic structure of the
maximal pro-`p` quotient of the absolute Galois group.

The boundary is deliberate. The **Class Field Theory** roadmap consumes these objects to build
finite-group Tate cohomology, class formations, local reciprocity, and duality. The **Local
Galois Groups** roadmap consumes them, together with abstract pro-`p` group theory, to determine
`G_K(p)` and its Demushkin presentation.

## Scope and exported contract

The accepted roadmap exports one canonical vocabulary for finite extensions of
nonarchimedean local fields, their normalized valuations and unit filtrations, unramified
extensions and Frobenius, the ramification filtrations and Herbrand transition, wild inertia,
the tame character, and the Iwasawa presentation of the tame quotient. Downstream roadmaps
import those declarations directly; they do not reconstruct private local-field toolkits.

Conventions are fixed throughout: valuations are normalized additively by `v_K(π) = 1`;
arithmetic Frobenius is primary and geometric Frobenius is its inverse; upper numbering is the
one functorial under quotients; and `G_K^t` means the quotient by wild inertia, not the maximal
pro-`p` quotient.

## The build, in layers

### Layer 0: local fields and their finite extensions

- **`ℚ_p` is a local field.** Prove `IsValuativeTopology ℚ_[p]`, that is, the valuation topology
  is the norm topology, and derive `IsNonarchimedeanLocalField ℚ_[p]`, for every prime `p`. ⚠
  Instance hygiene: `ℚ_[p]` carries a metric `UniformSpace`. Its compatibility with
  `IsTopologicalAddGroup.rightUniformSpace` must be a lemma, and not an accident of unification,
  or the `CompleteSpace` instances will not fire.
  - *Prerequisites:*
    - `Mathlib: Padic.mulValuation` and the instances of
      `Mathlib/NumberTheory/Padics/ValuativeRel.lean`;
    - `Mathlib: IsNonarchimedeanLocalField`.
  - *API:*
    - the instance itself;
    - the compatibility lemma for the two uniformities;
    - agreement of `Padic.valuation` with the normalized valuation of the next milestone;
    - `IsNonarchimedeanLocalField ℤ_[p]`-facing corollaries, that is `CompactSpace ℤ_[p]` and
      `IsAdicComplete`;
    - the same instance for a finite extension of `ℚ_[p]`, through Layer 0.III.
- **The normalized valuation.** Define `v_K^× : Kˣ →* Multiplicative ℤ` through
  `valueGroupWithZeroIsoInt` and `WithZero.log`, and extend it across zero with `ℤᵐ⁰`. Prove the
  uniformizer equation `v_K^×(π) = Multiplicative.ofAdd 1`, surjectivity, and that `v_K^×(x) = 1`
  holds exactly on `𝒪[K]ˣ`. Decode with `v_K(x) := Multiplicative.toAdd (v_K^× x)` when an integer
  is wanted. Define the absolute value `‖x‖_K = q^{−v_K(x)}` with `q = Nat.card 𝓀[K]`, with values
  in `ℚ≥0`, and prove that it agrees with the `Padic` norm on `ℚ_[p]`. ⚠ The canonical valuation
  of Mathlib has `v(π) = exp(−1)`, so the integers are the elements with `v ≤ 1`, and the additive
  normalization carries a minus sign. Every statement that mixes the two cites the one named
  `−log` translation lemma.
  - *Prerequisites:* `Mathlib: valueGroupWithZeroIsoInt`, `WithZero.log`,
    `Padic.norm_eq_zpow_neg_valuation`.
  - *API:*
    - the two constructors, `v_K^×` and `‖·‖_K`, and the translation lemma between them;
    - `v_K^×` is a monoid homomorphism, and `‖·‖_K` is multiplicative and ultrametric;
    - the value on a uniformizer, on a unit, and on a root of unity;
    - monotonicity against divisibility in `𝒪[K]`;
    - the point-set consequences, namely `𝒪[K]` open and compact, the family `𝓂[K]^i` a
      neighbourhood basis of `0`, and `Kˣ` locally compact with `𝒪[K]ˣ` compact open;
    - naturality along a finite extension, which is the characteristic property of `e` below;
    - the worked values on `ℚ_2` in the examples section.
- **Finite extensions, I: construction of the valuation.** Let `[Field L] [Algebra K L]
  [Module.Finite K L]`, with no valuative structure assumed on `L`. Construct a valuation
  `w : Valuation L ℤᵐ⁰` whose restriction along `algebraMap K L` is equivalent to `valuation K`.
  Use the spectral norm. The output type is fixed: a `Valuation L ℤᵐ⁰`, a `ValuativeRel L` built
  from it as a definition and not as a global instance, the compatibility `Valuation.Compatible`,
  `IsValuativeTopology L` for the induced topology, and `ValuativeExtension K L`. A definition
  rather than an instance keeps a field that already carries a `ValuativeRel` free of a diamond.
  - *Prerequisites:*
    - `Mathlib: Mathlib/RingTheory/Valuation/Extension.lean`;
    - `Mathlib: spectralNorm` and `Mathlib/Analysis/Normed/Field/Krasner.lean`;
    - `Mathlib: Mathlib/RingTheory/Valuation/AlgebraInstances.lean`.
  - *Source:* Neukirch ANT II §6 and II §8, for a complete discretely valued base. The hypotheses
    used are completeness of `K` and finiteness of `L/K`. *False generalization:* a valuation on
    an incomplete field has several inequivalent extensions to a finite extension, so completeness
    is not a convenience here.
- **Finite extensions, II: uniqueness.** Any two valuations on `L` that restrict to the valuation
  class of `K` are equivalent, in the sense of `Valuation.IsEquiv`. Any two `ValuativeRel L`
  structures for which `ValuativeExtension K L` holds are equal. Corollary: every `K`-algebra
  automorphism of `L` preserves the valuation, and therefore acts on `𝒪[L]`, `𝓂[L]`, and `𝓀[L]`.
  The corollary is stated here because Layers 2 and 3 use it many times.
  - *Prerequisites:*
    - `Layer 0: finite extensions, I`;
    - `Mathlib: Valuation.IsEquiv`.
  - *API:*
    - uniqueness in both forms above;
    - the action of `L ≃ₐ[K] L` on `𝒪[L]`, on `𝓂[L]`, and on `𝓀[L]`, with functoriality in the
      extension;
    - invariance of `v_L` under that action;
    - the induced map `Gal(L/K) → Gal(𝓀[L]/𝓀[K])`, whose kernel Layer 3 names the inertia group.
- **Finite extensions, III: consequences.** From I and II derive `IsNonarchimedeanLocalField L`,
  completeness of `L`, the instances `Algebra 𝒪[K] 𝒪[L]` and `Algebra 𝓀[K] 𝓀[L]`, and freeness of
  `𝒪[L]` as a finite `𝒪[K]`-module.
  - *Prerequisites:*
    - `Layer 0: finite extensions, I`;
    - `Layer 0: finite extensions, II`;
    - `Mathlib: IsNonarchimedeanLocalField`.
  - *API:*
    - the four instances;
    - transitivity in a tower `M/L/K`;
    - the comparison of `𝒪[L]` with the integral closure of `𝒪[K]` in `L`;
    - a basis of `𝒪[L]` over `𝒪[K]` in the unramified case and in the totally ramified case, which
      Layers 2 and 3 use.
- **`e` and `f`, intrinsically.** Define `ramificationIndex K L : ℕ` as the index of the image of
  the normalized value group. Equivalently, it is the unique positive integer `e` with
  `v_L(algebraMap K L x) = e * v_K(x)` for all `x : Kˣ`. Positivity is part of the
  characterization. Define `inertiaDegree K L := Module.finrank 𝓀[K] 𝓀[L]`, which Layer 0.III
  makes available. Prove `v_L(algebraMap K L π_K) = e` for **every** uniformizer `π_K` of `K`, so
  that no statement below has to choose one; `0 < e`; `0 < f`; `e * f = Module.finrank K L`;
  multiplicativity of each in a tower; and the comparison lemmas with `Ideal.ramificationIdx` and
  `Ideal.inertiaDeg`. The comparison needs one bridging fact, proved once: at a local field
  `primesOver 𝓂[K] 𝒪[L]` is the singleton `{𝓂[L]}`. Do not re-derive the Dedekind theory here, and
  do not force a consumer through the `sSup` in `Ideal.ramificationIdx`.
  - *Prerequisites:*
    - `Layer 0: the normalized valuation`;
    - `Layer 0: finite extensions, III`;
    - `Mathlib: Ideal.ramificationIdx`, `Ideal.inertiaDeg`, `sum_ramification_inertia`.
  - *API:*
    - the two definitions and their characteristic properties;
    - positivity;
    - the product formula;
    - multiplicativity in towers;
    - the values in the unramified case and in the totally ramified case;
    - the comparison lemmas with the Dedekind-level pair;
    - the singleton lemma for `primesOver`;
    - the worked values for `ℚ_2(√2)/ℚ_2` in the examples section.
  - *Source:* Serre LF I §4 and Neukirch ANT II §6, for `e · f = [L:K]` over a complete discretely
    valued base. *False generalization:* over an incomplete base, or with more than one prime
    above `𝓂[K]`, the identity becomes `∑_P e_P f_P = [L:K]`, which is `sum_ramification_inertia`
    and is a different theorem.
- **The absolute ramification index.** Define `absoluteRamificationIndex K p : ℕ`, for a natural
  number `p`, as the decoded valuation `v_K(p)` of the image of `p` in `K`. Its characteristic
  property is `v_K^×(p) = Multiplicative.ofAdd (e_K(p))`, which carries the hypothesis
  `(p : K) ≠ 0` and, since the exponent is a natural number, also says that `p` lies in `𝒪[K]`.
  For `p` prime and `K/ℚ_p` finite this is the ramification index of `K/ℚ_p`, and it is the `e`
  that the two deep-unit milestones of Layer 1 are stated with, at the residue characteristic and
  at `p = 2` respectively. It is `0` exactly when `p` is a unit of `𝒪[K]`, that is when `p` is not
  the residue characteristic; the relative `e(L/K)` above is a different invariant, and neither
  name is used for the other. ⚠ In equal characteristic `p` the image of `p` in `K` is `0` and
  there is no such invariant, so the definition takes the junk value `0` there, as
  `Ideal.ramificationIdx` does in its degenerate case. The hypothesis `(p : K) ≠ 0` on every
  statement is what separates the two cases.
  - *Prerequisites:*
    - `Layer 0: the normalized valuation`;
    - `Layer 0: e and f, intrinsically`, for the comparison below.
  - *API:*
    - the definition and its characteristic equation;
    - the vanishing criterion, `e_K(p) = 0` if and only if `p` is a unit of `𝒪[K]`;
    - the comparison `absoluteRamificationIndex K p = ramificationIndex ℚ_[p] K` for `K/ℚ_p`
      finite, with `e_K(p) · f = [K : ℚ_p]` as a corollary of the product formula above;
    - multiplicativity along a finite extension `L/K`, that is
      `absoluteRamificationIndex L p = ramificationIndex K L * absoluteRamificationIndex K p`;
    - the values `e_{ℚ_p}(p) = 1`, `e_{ℚ_p}(2) = 0` for odd `p`, and `e_K(2) = 2` for
      `K = ℚ_2(√2)`, in the examples section.
  - *Source:* Serre LF II §1; Neukirch ANT II §6, for `e_K(p) · f = [K : ℚ_p]`. The hypothesis
    used there is that `K` is a finite extension of `ℚ_p`. *False generalization:* the vanishing
    criterion is false without `(p : K) ≠ 0`. At `K = 𝔽_p((t))` the left-hand side is `0`, from
    the junk branch, while `p` is not a unit of `𝒪[K]`, because it is `0`.

### Layer 1: units, the filtration, and the multiplicative group

- **The unit filtration as an object.** Define `unitFiltration K i : Subgroup Kˣ` for `i : ℕ`,
  with the depth-zero case explicit: `U(K,0)` is the image of `𝒪[K]ˣ → Kˣ`, and for `i ≥ 1`,
  `U(K,i) = {x : Kˣ | x ∈ 𝒪[K] ∧ v_K(x − 1) ≥ i}`. State membership in the two forms that are
  used, namely the congruence `x ≡ 1 mod 𝓂[K]^i` inside `𝒪[K]` and the valuation inequality on
  `x − 1`, and prove that they agree. Indices are natural numbers throughout. Layers 3 and 7
  compare `U(K,i)` with a ramification group `G_j`. Each such statement writes out the shift
  between the two index conventions.
  - *Prerequisites:*
    - `Layer 0: the normalized valuation`;
    - `Mathlib: Subgroup`, `Valuation`.
  - *API:*
    - the definition with both membership forms;
    - `U(K,0) = 𝒪[K]ˣ` as a subgroup of `Kˣ`;
    - antitonicity in `i`;
    - `⋂_i U(K,i) = 1`;
    - each `U(K,i)` open and compact in `Kˣ`;
    - the family a neighbourhood basis of `1`;
    - stability under every `K`-automorphism of a Galois extension, which Layer 3 uses;
    - the index `[U(K,i) : U(K,i+1)]`, which is `q − 1` at `i = 0` and `q` otherwise;
    - naturality along a finite extension, which is the norm package of Layer 3.
- **Graded pieces.** Prove `U(K,0)/U(K,1) ≃* 𝓀[K]ˣ` by reduction, and, for `i ≥ 1`,
  `U(K,i)/U(K,i+1) ≃* 𝓀[K]⁺` through `1 + x ↦ x mod 𝓂^{i+1}`. The counts `q − 1` and `q` are
  corollaries. ⚠ The depth-zero piece is multiplicative and the deeper pieces are additive. The
  two isomorphisms stay separate, and do not combine into one statement.
  - *Prerequisites:*
    - `Layer 1: the unit filtration as an object`;
    - `Layer 0: the normalized valuation`.
  - *API:*
    - the two isomorphisms;
    - independence of the choice of uniformizer in the second, up to the induced automorphism of
      `𝓀[K]⁺`;
    - naturality in `i`;
    - the two counts;
    - the compatibility of the second isomorphism with the embeddings `θ_i` of Layer 3, which is
      where the choice of uniformizer is fixed again.
  - *Source:* Serre LF IV §2; Neukirch ANT II §3 and II §5.
- **Teichmüller.** Define the multiplicative section `ω : 𝓀[K]ˣ →* 𝒪[K]ˣ` of the reduction map.
  Characterize it as the unique section whose image consists of `(q−1)`-torsion elements, and
  prove `μ_{q−1}(K) ≅ 𝓀[K]ˣ`. That characterization is the public statement. Whether the proof
  uses `Perfection.teichmuller₀`, since a finite field is perfect and `𝒪[K]` is `𝓂[K]`-adically
  complete, or Hensel's lemma applied to `X^{q−1} − 1`, is an implementation note.
  - *Prerequisites:*
    - `Mathlib: Perfection.teichmuller₀`, `HenselianLocalRing`, `IsAdicComplete 𝓂[K] 𝒪[K]`;
    - `Layer 1: graded pieces`.
  - *API:*
    - the definition, the section property, and the uniqueness characterization;
    - `ω` is a monoid homomorphism and is injective;
    - `ω(1) = 1`;
    - the image is exactly `μ_{q−1}(K)`;
    - naturality along an unramified extension, which Layer 2 uses for the Frobenius;
    - the values on `ℚ_2` and on `ℚ_5` in the examples section.
- **Structure of `Kˣ`.** Prove the topological isomorphism `Kˣ ≃ ℤ × 𝒪[K]ˣ` attached to a choice
  of uniformizer, and `𝒪[K]ˣ ≃ μ_{q−1} × U(K,1)`. Prove that `U(K,1)` is pro-`p`, as the inverse
  limit of the `p`-groups `U(K,1)/U(K,i)`. State it in quotient form: every continuous finite
  quotient of `U(K,1)` is a `p`-group. That is the shape `Supplied.IsProP` unfolds to, so the two
  statements are the same statement and not two rephrasings. Prove that the torsion subgroup
  `μ(K)` is finite.
  - *Prerequisites:*
    - `Layer 1: the unit filtration as an object`;
    - `Layer 1: Teichmüller`;
    - `Mathlib: OpenNormalSubgroup`, `IsPGroup`.
  - *API:*
    - the two isomorphisms, with their inverses and their continuity;
    - the dependence on the uniformizer, which is an isomorphism of the two splittings;
    - finiteness of `μ(K)` and its order;
    - the `p`-part and the prime-to-`p` part of `μ(K)`;
    - the projection `Kˣ → ℤ`, which is `v_K`, and its splitting.
  - *Source:* Serre LF II §§4–5; Neukirch ANT II §5.
- **Deep units in mixed characteristic.** Let `K/ℚ_p` be finite of degree `N`, with absolute
  ramification index `e = absoluteRamificationIndex K p`. Let `i : ℕ` satisfy the integer
  inequality `(p − 1) * i > e`. Then the logarithm is an isomorphism of topological groups
  `U(K,i) ≃ (𝓂[K]^i, +)`, with `exp` as its inverse, and therefore `U(K,i) ≃ ℤ_p^N` as
  `ℤ_p`-modules. State the threshold as that integer inequality, and never as `i > e/(p−1)`, so
  that no division of natural numbers occurs.
  - *Prerequisites:*
    - `Layer 1: the unit filtration as an object`;
    - `Layer 0: the absolute ramification index`;
    - `Layer 0: finite extensions, III`;
    - `Mathlib: exp` and `log` for a `p`-adic field.
  - *Source:* NSW (7.4.4); Neukirch ANT II §5. The hypotheses used are `char K = 0` and the
    integer inequality. *False generalization:* at `(p − 1) * i = e` the series `log` still
    converges, but it is not injective on `U(K,i)`, since a `p`-th root of unity can lie there.
- **Power classes, the primary statement.** For `n : ℕ` with `n ≠ 0`, the primary theorem is an
  equality of natural numbers:

  ```text
  Nat.card (Kˣ ⧸ (powMonoidHom n).range) = n * Nat.card (μ_n(K)) * q ^ v_K(n),
  ```

  where `μ_n(K)` is the group of `n`-th roots of unity in `K`, and `v_K(n) : ℕ` is the normalized
  valuation of the image of `n` in `K`. In regime 1 the hypothesis `IsUnit (n : 𝒪[K])` gives
  `v_K(n) = 0` as a named lemma, and the formula becomes `n · #μ_n(K)`; that case holds in either
  characteristic. In regime 2, with `K/ℚ_p` finite, the formula holds for every `n ≠ 0`, including
  `p ∣ n`; the deep-unit logarithm supplies the `p`-primary factor. Finiteness of the quotient
  follows from the formula, and is not a separate theorem.
  - *Prerequisites:*
    - `Layer 1: structure of Kˣ`;
    - `Layer 1: deep units in mixed characteristic` (regime 2 only);
    - `Layer 0: the normalized valuation`;
    - `Layer 0: the absolute ramification index`, which is the `v_K(n)` of the formula.
  - *API:*
    - the count in each regime, named `card_powerClasses_of_isUnit` and `card_powerClasses_mixed`,
      with `v_K(n) = 0` under `IsUnit (n : 𝒪[K])` as a named lemma;
    - finiteness of `Kˣ/(Kˣ)ⁿ`, which the formula gives and which is not a separate theorem;
    - the two specializations at `n = 2`, which is where the dyadic factor of two appears:
      `card_squareClasses_of_isUnit`,
      which is `4` when `2` is a unit of `𝒪[K]`, and `card_squareClasses_dyadic`, which is
      `4 · q^e` with `q = Nat.card 𝓀[K]` and `e = absoluteRamificationIndex K 2` for `K/ℚ_2`
      finite. The second reads `2^{N+2}` for `[K : ℚ_2] = N`, since `q^e = #(𝒪[K]/2𝒪[K]) = 2^N`.
      ⚠ Their hypotheses are exclusive, and neither is an instance of the other;
    - the identification `Subgroup.square Kˣ = (powMonoidHom 2).range` of the two spellings of the
      square classes, Mathlib's subgroup of squares and the range this formula is stated at. It is
      what lets the count at `n = 2`, and the Kummer isomorphism of Layer 5, be read on
      `Subgroup.square Kˣ`;
    - the dyadic instance `#(ℚ_2ˣ/(ℚ_2ˣ)²) = 8` of the examples section.
  - *Source:* the formula follows from the structure of `Kˣ` above, with the logarithm in regime
    2; compare NSW VII §3. *False generalization:* at `K = 𝔽_q((t))`, `n = p`, the left side is
    infinite, so the equation fails in equal characteristic when `p ∣ n`. The hypothesis
    `IsUnit (n : 𝒪[K])` excludes that case in regime 1, and `char K = 0` excludes it in regime 2.
- **Power classes, the absolute-value form.** After the theorem in `ℕ`, derive
  `#(Kˣ/(Kˣ)ⁿ) = n · #μ_n(K) · ‖n‖_K⁻¹` as an equality in `ℚ≥0`, with the coercion `ℕ → ℚ≥0` named
  in the statement. This form makes the comparison with the Euler characteristic of Layer 8
  possible. It is the only place in this layer where the absolute value occurs.
  - *Prerequisites:*
    - `Layer 1: power classes, the primary statement`;
    - `Layer 0: the normalized valuation`.
- **The power subgroup is open.** For `n : ℕ` with `n ≠ 0`, the primary theorem is

  ```text
  IsOpen ((powMonoidHom n : Kˣ →* Kˣ).range).
  ```

  The name is `isOpen_range_powMonoidHom`. It holds in regime 1 for either characteristic, and in
  regime 2 for every `n`. ⚠ This does **not** follow from the count above. Finiteness of an
  abstract quotient of a topological group says nothing about the topology of the kernel: the
  additive group `ℚ_p` with the discrete topology has finite quotients by non-open subgroups. The
  proof exhibits an open subgroup inside the range:
  - in regime 1, `U(K,1) ⊆ (Kˣ)^n`, by Hensel's lemma applied to `X^n − u` at the approximate
    root `1`. The derivative `n X^{n−1}` is a unit there, because `n` is a unit in `𝒪[K]`, and
    `1 − u ∈ 𝓂[K]` for `u ∈ U(K,1)`;
  - in regime 2, take `i` with `(p − 1) · i > e`. The logarithm of the deep-unit milestone carries
    `x ↦ x^n` on `U(K,i)` to `y ↦ n · y` on `𝓂[K]^i`, and `n · 𝓂[K]^i = 𝓂[K]^{i + v_K(n)}`. So
    `(U(K,i))^n = U(K, i + v_K(n))`, which is open. This covers the `p`-primary case, where the
    argument of regime 1 is unavailable.

  A subgroup of a topological group that contains an open subgroup is open, and is then also
  closed and of finite index.
  - *Prerequisites:*
    - `Layer 1: the unit filtration as an object`;
    - `Layer 1: deep units in mixed characteristic` (regime 2 only);
    - `Mathlib: Hensel's lemma in Mathlib/RingTheory/Henselian.lean` (regime 1 only);
    - `Mathlib: Subgroup.isOpen_of_isOpen_subgroup_le`.
  - *API:*
    - the openness statement in each regime;
    - the containment `U(K,1) ⊆ (Kˣ)^n` in regime 1, and `U(K, i + v_K(n))` inside the range in
      regime 2, as named lemmas, because Layer 7 uses the containment and not only the openness;
    - closedness and finite index of the range;
    - the corollary that every subgroup of `Kˣ` of finite index whose exponent satisfies the
      regime hypothesis is open, which is what Layer 7 consumes.
  - *Source:* Serre LF V §3 and Neukirch ANT II §5. The hypotheses are the regime hypotheses.
    *False generalization:* at `K = 𝔽_q((t))` and `n = p` the range is not open, because
    `1 + t^m` is not a `p`-th power for `p ∤ m` and those elements accumulate at `1`.
- **The dyadic square-class count.** Prove `#(ℚ_2ˣ/(ℚ_2ˣ)²) = 8`. This is an instance of the
  primary statement, and not a separate theorem.
  - *Prerequisites:* `Layer 1: power classes, the primary statement`.
- **Deep units are squares, in mixed characteristic.** Let `K/ℚ_2` be finite, and let
  `e = absoluteRamificationIndex K 2`, that is `e = v_K(2)`. Then `U(K, 2e+1) ⊆ (Kˣ)²`, named
  `unitFiltration_le_range_powMonoidHom_two`. ⚠ This is **not** an instance
  of the cardinality count, which decides how many square classes there are and not which
  subgroup lies inside the squares. The proof is Hensel's lemma applied to `X² − u`, or the
  deep-unit logarithm with the fact that multiplication by `2` carries the logarithmic lattice at
  depth `2e+1` into the lattice at depth `e+1`. ⚠ The hypothesis is mixed characteristic. In
  equal characteristic `2` the element `2` is zero, there is no such `e`, the definition takes
  its junk value there, and the displayed statement is a different assertion.

  The threshold is sharp, and sharp over every such `K` and not only over `ℚ_2`:
  `U(K, 2e) ⊄ (Kˣ)²`, named `not_unitFiltration_le_range_powMonoidHom_two`. This is a milestone
  of its own, because a containment with no matching failure leaves a consumer free to use a
  weaker depth and discover later that its bound is not attained. The obstruction is
  Artin–Schreier: `℘(t) = t² + t` is `𝔽_2`-linear on `𝓀[K]` with kernel `𝔽_2`, so its image has
  index `2`. Since `𝓂[K]^{2e} = 4·𝒪[K]`, a unit `1 + 4c` is `(1 + 2t)²` exactly when
  `c = t + t²`, so `1 + 4c` is a square exactly when the residue of `c` lies in the image of `℘`,
  and any `c` outside it is a witness. At `K = ℚ_2` the witness is `5`: `U(K,3) = 1 + 8ℤ_2`
  consists of squares while `U(K,2) = 1 + 4ℤ_2` does not.
  - *Prerequisites:*
    - `Layer 1: deep units in mixed characteristic`;
    - `Layer 1: the unit filtration as an object`;
    - `Layer 1: graded pieces`, for the residue-field computation behind the sharpness;
    - `Layer 0: the absolute ramification index`;
    - `Mathlib: Hensel's lemma in Mathlib/NumberTheory/Padics/Hensel.lean`.
  - *API:*
    - the containment at depth `2e+1` and its failure at depth `2e`;
    - the two-sided consequence, that `U(K,n) ⊆ (Kˣ)²` holds exactly for `n ≥ 2e+1`, which is
      antitonicity of the filtration applied to the two above.
  - *Source:* Serre, *A Course in Arithmetic*, II §3, for `ℚ_2`; Neukirch ANT II §5 in general.
    The hypotheses used are that `K/ℚ_2` is finite, for both halves. *False generalization:* in
    equal characteristic `2` the sharpness says nothing about the threshold, because `e` is the
    junk value and the statement collapses to `U(K,0) ⊄ (Kˣ)²`, a different assertion.

### Layer 2: unramified extensions and Frobenius

- **The arithmetic predicate.** Define `IsUnramified K L` for a finite extension of local fields:
  the map of value groups is bijective, equivalently `ramificationIndex K L = 1`, and the residue
  extension `𝓀[L]/𝓀[K]` is separable. Separability is automatic for finite residue fields. Carry
  it in the definition, so that the statement matches the general definition for valued fields and
  survives generalization. Compare the predicate once, as a theorem, with `Algebra.IsUnramifiedAt`
  and `Algebra.FormallyUnramified` over `𝒪[K]`, so that the étale library becomes usable. Do not
  redefine those notions.
  - *Prerequisites:*
    - `Layer 0: e and f, intrinsically`;
    - `Mathlib: Algebra.IsUnramifiedAt`, `Algebra.FormallyUnramified`.
  - *API:*
    - the definition;
    - the equivalence with `e = 1`;
    - stability in towers, in both directions;
    - stability under composita and under base change to an unramified extension;
    - the comparison theorem with the étale notions;
    - the negative instance `ℚ_2(√2)/ℚ_2`, which is ramified.
- **Residue correspondence.** For `L/K` unramified and Galois, prove `Gal(L/K) ≃* Gal(𝓀[L]/𝓀[K])`
  through the machinery of `Mathlib/RingTheory/Invariant/`, with trivial inertia group. Define the
  **Frobenius element** `Frob L/K ∈ Gal(L/K)` as the preimage of `x ↦ x^q`, named
  `frobeniusAlgEquiv`, and prove that `Gal(L/K)` is cyclic of order `f`, generated by it. The
  equation that fixes it is `valuation_frobeniusAlgEquiv_sub_pow`, that is `σ(y) ≡ y^q mod 𝓂[L]`
  for `y ∈ 𝒪[L]`, stated on the valuation of `σ(y) − y^q` so that it needs no separate name for
  the induced action on the residue field. Every later statement about Frobenius is stated at
  that declaration, and never at an arbitrary generator of `Gal(L/K)`: a cyclic group of order
  `f > 2` has generators that are not Frobenius, so `θ(π) = Frob` of Layer 6 would be a strictly
  weaker claim about one.
  - *Prerequisites:*
    - `Layer 2: the arithmetic predicate`;
    - `Layer 0: finite extensions, II`;
    - `Mathlib: Ideal.inertia`, `stabilizer G Q ⧸ inertia G Q ≃* Gal(residue extension)`;
    - `Mathlib: GaloisField` and the Frobenius of a finite field.
  - *API:*
    - the isomorphism and its inverse;
    - `Frob` and its order, with the congruence that characterizes it;
    - functoriality in a tower, that is, restriction of `Frob` to a subextension is `Frob`;
    - compatibility with the Teichmüller section of Layer 1;
    - the action of `Frob` on `μ_{q^f−1}`;
    - the worked case `ℚ_2(√5)/ℚ_2` in the examples section.
- **Existence and uniqueness, stated precisely.** These four statements together replace the
  informal phrase "the unramified extension of degree `f`".
  1. *Inside a fixed algebraic closure.* For every `f ≥ 1` there is exactly one unramified
     intermediate field `K_f` of `AlgebraicClosure K` with `[K_f : K] = f`, namely the splitting
     field of `X^{q^f} − X`, equivalently `K(μ_{q^f−1})`.
  2. *Abstract extensions.* Reduction is an equivalence between the finite unramified extensions
     of `K` and the finite extensions of `𝓀[K]`.
  3. *After a choice of residue data.* A chosen `𝓀[K]`-isomorphism of the residue extensions lifts
     to a unique `K`-isomorphism of the unramified extensions. Without that choice the lift is not
     unique.
  4. *Automorphisms.* `Gal(K_f/K)` is cyclic of order `f`, generated by the arithmetic Frobenius.
     So `K_f` has exactly `f` automorphisms over `K`. The condition of commuting with Frobenius
     selects none of them, because an abelian group is centralized by its own elements. Statement
     3, which fixes the map on residue fields, is the correct rigidity statement.

  Prove also that a compositum of unramified extensions is unramified. Prove that the finite
  unramified subextensions of `K` inside the fixed closure, ordered by inclusion, form a lattice.
  That lattice is isomorphic to the positive integers ordered by divisibility. The statement is
  about the finite subextensions: the maximal unramified extension has infinite intermediate
  fields as well.
  - *Prerequisites:*
    - `Layer 2: residue correspondence`;
    - `Mathlib: GaloisField` and the classification of finite extensions of a finite field;
    - `Mathlib: IntermediateField`.
  - *Source:* Serre LF III §5; Neukirch ANT II §7. *False generalization:* uniqueness of the
    isomorphism holds only after statement 3 fixes the residue map. The phrase "the unique
    unramified extension of degree `f`, with its unique `K`-isomorphism" is false for `f > 1`.
- **The maximal unramified extension.** Define `K^{ur} ⊆ AlgebraicClosure K` as the union of the
  `K_f`. Prove `Gal(K^{ur}/K) ≅ Ẑ`, carrying Frobenius to the canonical topological generator `1`,
  with `Ẑ ≅ lim ℤ/n` built on the completion API of `ProfiniteGrp`. Every unramified coordinate
  below is expressed through this isomorphism, whose target is `Ẑ` and never `ℤ`.
  - *Prerequisites:*
    - `Layer 2: existence and uniqueness`;
    - `Mathlib: profiniteCompletion`, `Mathlib/Topology/Algebra/Category/ProfiniteGrp/`.
  - *API:*
    - the intermediate field `K^{ur}`;
    - the isomorphism to `Ẑ` and its inverse;
    - the image of `Frob`;
    - compatibility with the finite levels;
    - the induced surjection `G_K → Ẑ`, which Layer 4 names;
    - the fixed field of a closed subgroup, in the two directions.
- **Norms.** Name the image of the field norm: `normGroup L/K := (N_{L/K})(Lˣ) : Subgroup Kˣ`,
  which is the object Layer 7 item 1 goes on to study. For `L/K` unramified prove
  `N_{L/K}(𝒪[L]ˣ) = 𝒪[K]ˣ`, named `map_norm_unitFiltration_zero` and stated on the depth-zero
  step `U(L,0)` of the unit filtration, and `N_{L/K}(Lˣ) = π^{fℤ} × 𝒪[K]ˣ`. State the second in
  **norm-equation form**, as `mem_normGroup_iff_dvd_normalizedValuation`: `x ∈ normGroup L/K` if
  and only if `f` divides `v_K(x)`. That is the shape a consumer applies, since it decides one
  element at a time when the equation `N_{L/K}(y) = x` is solvable, and it needs no chosen
  uniformizer, where the product description does. Both come from `e = 1`, which makes
  `v_K(N_{L/K} y) = f · v_L(y)`, together with surjectivity on units. This is the concrete form
  of the statement that units are universal norms in the unramified direction. Layer 5 and
  Layer 7 both use it. ⚠ `f` here is the residue degree `inertiaDegree K L` of Layer 0, and the
  letter is never reused for a conductor.
  - *Prerequisites:*
    - `Layer 2: residue correspondence`;
    - `Layer 1: graded pieces`;
    - `Layer 1: the unit filtration as an object`;
    - `Layer 0: e and f, intrinsically`;
    - `Layer 0: finite extensions, III`.
  - *API:*
    - the norm group as a named subgroup of `Kˣ`;
    - surjectivity of the norm on units, in the filtration form above;
    - the norm-equation criterion, and the valuation identity `v_K(N_{L/K} y) = f · v_L(y)` that
      it rests on;
    - the two worked `ℚ_2(√5)/ℚ_2` cases of the examples section, one solvable and one not.
  - *Source:* Serre LF V §2. The proof is surjectivity on each graded piece, plus completeness.
    *False generalization:* for a ramified extension the norm of a unit is a unit, but the image
    is a proper subgroup: at `L = ℚ_2(√2)` the image of `𝒪[L]ˣ` has index `2` in `ℤ_2ˣ`, so the
    norm-equation criterion is false there in both directions.

### Layer 3: ramification, the tame and wild cases, and the filtration

- **Totally ramified is equivalent to Eisenstein.** Prove that `e = [L:K]` holds if and only if
  `L = K(π_L)` for a root `π_L` of an Eisenstein polynomial over `𝒪[K]`. Prove also that an
  Eisenstein polynomial is irreducible, and that it generates a totally ramified extension in
  which its root is a uniformizer. Prove the factorization of an arbitrary finite `L/K` as
  `L/L_0/K`, where `L_0/K` is the maximal unramified subextension and `L/L_0` is totally ramified
  of degree `e`.
  - *Prerequisites:*
    - `Layer 0: e and f, intrinsically`;
    - `Layer 2: existence and uniqueness`;
    - `Mathlib: Polynomial.IsEisensteinAt` and its irreducibility results.
  - *API:*
    - the equivalence in both directions;
    - the uniformizer produced by the Eisenstein polynomial;
    - the factorization `L/L_0/K` and its uniqueness;
    - the degree of `L_0/K`, which is `f`;
    - the behaviour of the factorization in a tower.
- **Tame and wild.** Define `IsTamelyRamified K L` by `p ∤ e`, and the totally wildly ramified
  case by `e` a power of `p`. The public theorem about tame extensions is:

  ```text
  If L/K is finite, totally ramified, and tamely ramified of degree e,
  then there are a uniformizer π of K and α ∈ L with α^e = π and L = K(α).
  ```

  The corollaries carry their own hypotheses. `L/K` is Galois exactly when `μ_e ⊆ K`, and then
  `Gal(L/K) ↪ μ_e` by `σ ↦ σ(α)/α`. The proof may enlarge the residue field, prove the statement
  over `K^{ur}`, and descend. That belongs to the proof, and not to the public statement.
  - *Prerequisites:*
    - `Layer 3: totally ramified is equivalent to Eisenstein`;
    - `Layer 2: the maximal unramified extension`;
    - `Layer 1: graded pieces`.
  - *API:*
    - the two predicates;
    - the theorem above;
    - the Galois criterion;
    - the embedding into `μ_e`;
    - stability of tameness in towers and under composita;
    - the degree of the maximal tamely ramified subextension.
  - *Source:* Serre LF IV §2; Neukirch ANT II §7. *False generalization:* in residue
    characteristic `2` every totally ramified quadratic extension is wild. Keep the dyadic
    examples in the test suite, so that a hypothesis `p ∤ e` cannot enter a statement about the
    tame case that is later applied at `p = 2`.
- **The lower-numbering filtration.** For `L/K` finite Galois with group `G`, define `G_i = {σ | ∀
  x : 𝒪[L], v_L(σ x − x) ≥ i + 1}` for `i : ℤ`. The function is total, with `G_i = ⊤` for
  `i ≤ −1`. Equivalently, `σ` acts trivially on `𝒪[L]/𝓂[L]^{i+1}`. Prove that each `G_i` is a
  normal subgroup of `G`, and that the family is antitone. Prove that `G_0` is the inertia group,
  with one comparison lemma to `ValuationSubring.inertiaSubgroup` and one to `Ideal.inertia`.
  Prove that `G_i = 1` for large `i`. Extend to a real index by `G_u := G_{⌈u⌉}` for `u : ℝ` with
  `u ≥ −1`, and prove that the two definitions agree at integers. The Herbrand integral below
  needs `G_t` for real `t`. Prove compatibility with subgroups: `H_i = H ∩ G_i` for
  `H = Gal(L/K')`.
  - *Prerequisites:*
    - `Layer 0: finite extensions, II`;
    - `Layer 0: the normalized valuation`;
    - `Mathlib: ValuationSubring.inertiaSubgroup`, `Ideal.inertia`.
  - *API:*
    - the definition at integer and at real index, with the agreement lemma;
    - normality;
    - antitonicity;
    - the two comparison lemmas at `i = 0`;
    - the finiteness statement `G_i = 1` for large `i`, and the largest jump as a definition;
    - compatibility with subgroups;
    - the failure of compatibility with quotients, which is the next milestone;
    - the computation for `ℚ_2(μ_8)/ℚ_2` in the examples section.
  - *Source:* Serre LF IV §1.
- **Lower numbering is not compatible with quotients.** State this as a theorem with a witness,
  and not as a warning. In `L = ℚ_2(ζ_8)` over `K = ℚ_2`, with `G = (ℤ/8)ˣ` and `H = ⟨σ_7⟩` the
  subgroup generated by `ζ ↦ ζ^{-1}`, so that `L^H = ℚ_2(√2)`, one has `G_3 = ⟨σ_5⟩` and therefore
  `G_3H/H = G/H`, while `(G/H)_3 = 1`, because `v_{ℚ_2(√2)}(σ(√2) − √2) = v_{ℚ_2(√2)}(2√2) = 3`.
  The upper numbering repairs this failure.
  - *Prerequisites:* `Layer 3: the lower-numbering filtration`.
- **The quotient embeddings.** One formula covers every level:
  `θ_i : G_i/G_{i+1} ↪ U(L,i)/U(L,i+1)` by `σ ↦ σ(π_L)/π_L`. Prove injectivity and independence of
  the uniformizer. Composed with the graded pieces of Layer 1 this reads `θ_0 : G_0/G_1 ↪ 𝓀[L]ˣ`,
  the tame character, so `G_0/G_1` is cyclic of order prime to `p`; and
  `θ_i : G_i/G_{i+1} ↪ 𝓀[L]⁺` for `i ≥ 1`, by `σ ↦ (σ(π_L) − π_L)/π_L^{i+1}`, so those quotients
  are elementary abelian `p`-groups. Prove the consequences: `G_1` is the unique `p`-Sylow
  subgroup of `G_0` and is normal, which is wild inertia at finite level; and `G_0` has the cyclic
  tame quotient `G_0/G_1`. Prove the action formula: for `σ ∈ G_0` and `τ ∈ G_i/G_{i+1}`,
  `στσ⁻¹ = θ_0(σ)^i · τ`. This is the finite-level form of the twist in the tame sequence of Layer
  4, and `θ_t` is the constant in the norm computation below.
  - *Prerequisites:*
    - `Layer 3: the lower-numbering filtration`;
    - `Layer 1: graded pieces`.
  - *API:*
    - the embeddings at every level, with injectivity and independence of the uniformizer;
    - the two composed forms;
    - the group-theoretic consequences above;
    - the action formula;
    - naturality under passage to a subgroup `H ≤ G`.
  - *Source:* Serre LF IV §2.
- **Herbrand functions and the upper numbering.** Define `φ_{L/K}(u) = ∫_0^u dt/[G_0 : G_t]` for
  `u ≥ −1`, with the usual convention that the integrand is `[G_t : G_0]` on `[−1, 0]`. Prove the
  analytic facts as milestones: `φ` is continuous, piecewise linear with an explicit finite-sum
  formula, strictly increasing and concave, `φ(0) = 0`, and `φ(u) = u` for `−1 ≤ u ≤ 0`. Define
  `ψ_{L/K} : ℝ → ℝ` as its inverse on `[−1, ∞)`, with `φ ∘ ψ = id` and `ψ ∘ φ = id` there. Prove
  that `ψ` carries the jumps of the upper filtration to the jumps of the lower one. The upper
  numbering is `G^u := G_{ψ(u)}`, with the real-index groups above. Two theorems justify it:
  **Herbrand's theorem** `(G/H)^u = G^u H/H`, and transitivity in a tower `M/L/K`, which is
  `φ_{M/K} = φ_{L/K} ∘ φ_{M/L}` for `φ` and `ψ_{M/K} = ψ_{M/L} ∘ ψ_{L/K}` for `ψ`. State both
  orders: inverting a composite reverses it, and the two orders differ as soon as one step of the
  tower is wild. The upper numbering is defined here because Layer 7 needs it for the conductor
  and for the compatibility with reciprocity.
  - *Prerequisites:*
    - `Layer 3: the lower-numbering filtration`;
    - `Mathlib: intervalIntegral` and the API for piecewise linear monotone functions.
  - *API:*
    - the two functions;
    - continuity, monotonicity, concavity, and the values at `0`;
    - the finite-sum formula at integers;
    - the inverse relations;
    - the image of a jump;
    - the upper numbering as a filtration, with normality and antitonicity;
    - Herbrand's theorem;
    - the two transitivity statements;
    - the computation for `ℚ_2(μ_8)/ℚ_2` in the examples section.
  - *Source:* Serre LF IV §3.
- **Herbrand values as unit depths.** `φ` takes non-integral values at integers: in `ℚ_2(μ_8)/ℚ_2`
  below, `φ(2) = 3/2`. Its inverse does not. Prove that `ψ_{L/K}(n)` is a natural number for every
  `n : ℕ`, and package the proof as `ψℕ_{L/K} : ℕ → ℕ`, with the characterizing lemma
  `(ψℕ_{L/K} n : ℝ) = ψ_{L/K} n`. This is the only conversion from a Herbrand value to a unit
  depth in this roadmap. Every index of `U(K, −)` and of `U(L, −)` below is a literal natural
  number or a value of `ψℕ`, and `φ` never indexes a unit group. The proof is the piecewise
  formula with Lagrange's theorem: write `g_i = #G_i`, and take `t` to be the largest jump with
  `φ(t) ≤ n`; then `ψ(n) = t + (g_0·n − ∑_{i=1}^{t} g_i) / g_{t+1}`, and `g_{t+1}` divides `g_0`
  and every `g_i` with `i ≤ t`, because the filtration is decreasing.
  - *Prerequisites:* `Layer 3: Herbrand functions and the upper numbering`.
  - *API:*
    - the function `ψℕ`;
    - the characterizing lemma;
    - `ψℕ 0 = 0`;
    - monotonicity;
    - `n ≤ ψℕ n`;
    - transitivity `ψℕ_{M/K} = ψℕ_{M/L} ∘ ψℕ_{L/K}`, in the order inherited from the real-valued
      statement;
    - the closed form in the cyclic prime-degree case, which is `ψℕ v = v` for `v ≤ t` and
      `ψℕ v = t + ℓ(v − t)` for `v ≥ t`.
- **The norm on the unit filtration.** ⚠ `N_{L/K}(U(L,i)) ⊆ U(K,i)` is **false** for a ramified
  extension `L/K`. In a tame quadratic extension in residue characteristic `3`, the norm of an
  element of `U(L,2)` is outside `U(K,2)`; the examples section has the computation. The true
  inclusion carries a Herbrand shift, which no milestone may remove. Each item names its consumer.
  1. *The norm on valuations and on units, for any finite `L/K`.* `v_K(N_{L/K}(x)) = f · v_L(x)`
     for `x : Lˣ`. Therefore `N_{L/K}(𝒪[L]ˣ) ⊆ 𝒪[K]ˣ`, which is `N_{L/K}(U(L,0)) ⊆ U(K,0)`. If
     `L/K` is totally ramified, `N_{L/K}(π_L)` is a uniformizer of `K`. This is the basic API of
     the norm at a local field. The last part fixes the coordinate on the target of the graded
     maps in item 4.
  2. *The Herbrand-shifted inclusion, for `L/K` finite Galois.*
     `N_{L/K}(U(L, ψℕ_{L/K}(i))) ⊆ U(K, i)` for every `i : ℕ`. Both depths are natural numbers,
     because `ψℕ` is. The unshifted corollary is `N_{L/K}(U(L,i)) ⊆ U(K, ⌊φ_{L/K}(i)⌋)`, which
     follows from `ψ(⌊φ(i)⌋) ≤ i`. The conductor of Layer 7, and its compatibility statement
     `Art_K(U(K,n)) = (G_K^{ab})^{(n)}`, consume the shifted form.
  3. *Unramified `L/K`.* `N_{L/K}(U(L,i)) = U(K,i)` for every `i : ℕ`, an equality, and here `ψℕ`
     is the identity. The case `i = 0` is the norm surjectivity of Layer 2. The vanishing
     `Hⁱ(Gal(L/K), 𝒪[L]ˣ) = 0` of Layer 5 is the cohomological form of the same computation.
  4. *Cyclic totally ramified of prime degree `ℓ`: the graded maps.* Write `G = ⟨σ⟩`, and let
     `t ≥ 0` be the unique jump, so that `G_i = G` for `i ≤ t` and `G_i = 1` for `i > t`. Then
     `t = 0` holds exactly in the tame case `ℓ ≠ p`, where the Galois hypothesis forces `μ_ℓ ⊆ K`
     and therefore `ℓ ∣ q − 1`. Coordinatize the graded pieces by a uniformizer `π_L` and by
     `π_K = N_{L/K}(π_L)`. The norm induces `gr_v N : U(L, ψℕ v)/U(L, ψℕ v + 1) → U(K, v)/U(K,
     v+1)`. The milestone is the computation of that map in the four cases that occur:
     - `v = t = 0`, the tame case: `y ↦ y^ℓ` on `𝓀ˣ`, with kernel and cokernel `μ_ℓ(𝓀)` of order
       `ℓ`, by `ℓ ∣ q − 1`;
     - `v = 0 < t`, so `ℓ = p`: `y ↦ y^p` on `𝓀ˣ`, the Frobenius of a finite field, bijective;
     - `0 < v < t`, which again forces `ℓ = p`: `y ↦ y^p` on `𝓀⁺`, Frobenius again, bijective;
     - `v = t > 0`: the additive map `y ↦ y^ℓ − c^{ℓ−1}·y` on `𝓀⁺`, where `c = θ_t(σ) ∈ 𝓀ˣ` is the
       value at a generator `σ` of `G` of the level-`t` embedding `θ_t` above. The map is
       `𝔽_ℓ`-linear, with kernel the line `𝔽_ℓ·c` and cokernel of order `ℓ`.

     ⚠ The exponent on `c` is not a slip. The element `c` changes when the generator `σ` changes,
     and `c^{ℓ−1}` does not, because `λ^{ℓ−1} = 1` for `λ ∈ 𝔽_ℓˣ`. A version with a bare `c` would
     make the kernel depend on the choice of `σ`, which the norm map cannot see. In summary:
     `gr_v N` is bijective for `v ≠ t`, and at `v = t` its kernel and its cokernel both have order
     `ℓ`.
  5. *The consequences of item 4, for the same extensions.* `N_{L/K}(U(L, ψℕ v)) = U(K,v)` for
     every `v > t`, by successive approximation from item 4 and completeness. `[U(K,v) :
     N_{L/K}(U(L, ψℕ v)) · U(K,v+1)] = ℓ` for `v = t`, and `= 1` for `v ≠ t`. Multiplication up
     the filtration then gives `[𝒪[K]ˣ : N_{L/K}(𝒪[L]ˣ)] = ℓ`. The induction for Hasse–Arf
     consumes item 4 and these indices, and the conductor of a cyclic extension of prime degree is
     `c(L/K) = t + 1`.
  - *Prerequisites:*
    - `Layer 3: Herbrand values as unit depths`;
    - `Layer 3: the quotient embeddings`;
    - `Layer 1: graded pieces`;
    - `Layer 2: norms` (for item 3);
    - `Layer 0: e and f, intrinsically`.
  - *Source:* Serre LF V §2 for item 3, Serre LF V §3 for item 4, and Serre LF V §6 for item 2.
    *False generalization:* the unshifted inclusion in item 2, which the counterexample in the
    examples section refutes.
- **Hasse–Arf.** For `G` abelian, the jumps of the upper-numbering filtration are integers.
  - *Prerequisites:*
    - `Layer 3: the norm on the unit filtration` (items 4 and 5);
    - `Layer 3: Herbrand functions and the upper numbering` (transitivity of `φ`, which reduces
      the general abelian case to the cyclic case of prime degree).
  - *Source:* Serre LF V §7. The hypothesis is that `G` is abelian. *False generalization:* for
    `G` non-abelian the jumps of the upper numbering need not be integers; the quaternion
    extension in Serre LF IV §3, exercise 3, is the standard witness.
- **The different and the discriminant.** Let `L/K` be finite separable. Define the different
  `𝔡_{L/K} ⊆ 𝒪[L]` from the trace form, as the inverse of the trace dual of `𝒪[L]`. Compare it
  with `differentIdeal` of Mathlib. Define the discriminant `𝔩_{L/K} = N_{L/K}(𝔡_{L/K}) ⊆ 𝒪[K]`,
  which is an ideal of the base. The two are not to be conflated. Prove: `𝔡_{L/K} = 𝒪[L]` if and
  only if `L/K` is unramified; for `L/K` Galois, `v_L(𝔡_{L/K}) = ∑_{i≥0} (#G_i − 1)`; and in the
  tame case `v_L(𝔡_{L/K}) = e − 1`. The trace-dual definition comes before the valuation formula,
  which needs `L/K` Galois.
  - *Prerequisites:*
    - `Mathlib: differentIdeal`, `Mathlib/RingTheory/Trace/`;
    - `Layer 3: the lower-numbering filtration`;
    - `Layer 0: finite extensions, III`.
  - *API:*
    - the two ideals;
    - the comparison lemma with `differentIdeal`;
    - multiplicativity in a tower;
    - the unramified criterion;
    - the valuation formula in the Galois case;
    - the tame value;
    - the value for `ℚ_2(√2)/ℚ_2`, which is `3`.
  - *Source:* Serre LF III §§3–6 for the different and the discriminant, and Serre LF IV §1 for
    the valuation formula, which needs `L/K` Galois.

### Layer 4: the tame quotient of the absolute Galois group

- **The ambient model, fixed once.** Use `G_K := Field.absoluteGaloisGroup K` with the Krull
  topology, in every public statement and in every characteristic. Prove once, as a comparison
  theorem, that the restriction `Gal(AlgebraicClosure K / K) → Gal(separableClosure K / K)`, that
  is `separableClosure.algEquivOfAlgEquiv`, is an isomorphism of topological groups. A proof that
  is more convenient over a separable closure may then transport along it. No theorem below
  chooses its own model. Every infinite subextension, that is `K^{ur}`, `K^{t}`, and `K^{ab}`, is
  an `IntermediateField K (AlgebraicClosure K)`. Inertia, wild inertia, and the unramified
  quotient are the corresponding closed subgroups and quotients, and are named as such.
  - *Prerequisites:* `Mathlib: Field.absoluteGaloisGroup`, `separableClosure.algEquivOfAlgEquiv`,
    `Mathlib/FieldTheory/KrullTopology.lean`.
  - *API:*
    - the comparison isomorphism, with continuity in both directions;
    - the transport lemmas for subgroups and for quotients;
    - the profinite structure;
    - the correspondence between closed subgroups and intermediate fields, specialized to the
      three named fields.
- **Inertia.** Define `I_K = Gal(Kˢ/K^{ur})`, and prove that it is closed and normal. Prove the
  exact sequence `1 → I_K → G_K → Ẑ → 1`, with the surjection of Layer 2, and construct the
  arithmetic Frobenius lifts.
  - *Prerequisites:*
    - `Layer 2: the maximal unramified extension`;
    - `Layer 4: the ambient model`.
  - *API:*
    - the subgroup and its properties;
    - the exact sequence;
    - existence of a Frobenius lift and the description of the set of lifts as a coset of `I_K`;
    - functoriality in a finite extension of `K`;
    - the image of `I_K` in a finite quotient, which is `G_0` of Layer 3.
- **Wild inertia.** Define `P_K = Gal(Kˢ/K^{t})`, where `K^{t} = ⋃_{p ∤ m} K^{ur}(π^{1/m})` is the
  maximal tamely ramified extension. Prove that `P_K` is the inverse limit of the finite-level
  `G_1`. Prove that it is a closed normal pro-`p` subgroup of `G_K`. Prove that it is the unique
  maximal such subgroup of `I_K`, that is, its pro-`p` Sylow subgroup. Sylow theory for profinite
  groups is free of Galois vocabulary, and this roadmap does not restate it in that vocabulary.
  What is proved here is the identification of that Sylow subgroup with `Gal(Kˢ/K^t)`.
  - *Prerequisites:*
    - `Layer 3: tame and wild`;
    - `Layer 4: inertia`;
    - `Mathlib: Subgroup.normalClosure`, `OpenNormalSubgroup`.
  - *Pro-`p` inputs:* the four Sylow theorems of `Supplied.ProPOps`, that is existence, the
    containment of every closed pro-`p` subgroup in one, uniqueness of a normal one, and the image
    under a continuous surjection. The predicate `Supplied.IsProPSylow` is a definition and not a
    hypothesis.
  - *API:*
    - the field `K^{t}` and the subgroup `P_K`;
    - the pro-`p` property;
    - the limit description;
    - the Sylow identification;
    - the image of `P_K` in a finite quotient, which is `G_1` of Layer 3.
- **The tame character and the twist.** Prove `I_K/P_K ≅ lim_{p∤m} μ_m(Kˢ) = Ẑ^{(p')}(1)`, by
  `σ ↦ (σ(π^{1/m})/π^{1/m})_m`. Prove independence of the choices, and `G_K`-equivariance:
  conjugation acts through the cyclotomic action on the right-hand side. ⚠ The notation
  `Ẑ^{(p')}(1)` is *defined* here, as the prime-to-`p` Tate module of `μ`. As a profinite group it
  is `∏_{ℓ ≠ p} ℤ_ℓ`, and the `(1)` is the equivariance statement.
  - *Prerequisites:*
    - `Layer 4: wild inertia`;
    - `Layer 3: the quotient embeddings`;
    - `Mathlib: rootsOfUnity`, `Mathlib/Topology/Algebra/Category/ProfiniteGrp/Limits.lean`.
  - *API:*
    - the object `Ẑ^{(p')}(1)`;
    - the isomorphism and its inverse;
    - independence of the choice of `π` and of the compatible system of roots;
    - the equivariance statement;
    - the finite-level form, which is the action formula of Layer 3;
    - the specialization at one prime `ℓ ≠ p`.
- **The Iwasawa presentation.** Prove that the tame quotient `G_K^{t} = G_K/P_K` sits in a split
  exact sequence `1 → Ẑ^{(p')}(1) → G_K^{t} → Ẑ → 1`; that a Frobenius lift `σ` and a topological
  generator `τ` of the kernel satisfy `σ τ σ⁻¹ = τ^q`; and that `G_K^t` is the profinite group on
  `σ` and `τ` with that single relation. State the presentation through its universal property. It
  is a continuous surjection from the free profinite group on two generators. Its kernel is the
  closed normal closure of the relator. That is, state it as `presentedProfiniteGroup (Fin 2) {σ τ
  σ⁻¹ τ^{−q}}`, with `σ` and `τ` the images of `freeProfiniteGroup.of 0` and
  `freeProfiniteGroup.of 1`. ⚠ The object needed here is the **profinite** one. The presented
  pro-`p` group of the same shape is its pro-`p` quotient, which forgets the prime-to-`p` tame
  inertia that this presentation is about, so it is a different group.
  - *Prerequisites:*
    - `Layer 4: the tame character and the twist`;
    - `Mathlib: ProfiniteGrp.profiniteCompletion`, `FreeGroup`, `Subgroup.normalClosure`, and
      `Subgroup.topologicalClosure`. `Supplied.freeProfiniteGroup` and
      `Supplied.presentedProfiniteGroup` are definitions built from these, with no `sorry`.
  - *Pro-`p` inputs:* the universal property of the free profinite group,
    `ProPOps.freeProfiniteGroupLift`, with its uniqueness clause.
  - *Source:* NSW (7.5.2) and (7.5.3), after Iwasawa. The hypotheses are that `K` is a
    nonarchimedean local field with finite residue field of order `q`. *False generalization:* the
    analogous presentation of `G_K` itself is false; `G_K` is not 2-generated, and Layer 9
    computes its rank as `[K:ℚ_p] + 2`.
- **Translation lemmas.** Prove the presentation with a geometric `σ`, through `σ ↦ σ⁻¹`. Prove
  the finite-level compatibility: the restriction of the sequence to a finite tame quotient
  recovers the twist formula of Layer 3. Two statements face reciprocity: units land in inertia,
  and a uniformizer maps to the Frobenius coordinate. Both are theorems of Layer 7, and neither is
  an assumption here. This layer supplies only the group-theoretic frame in which they are stated.
  - *Prerequisites:*
    - `Layer 4: the Iwasawa presentation`;
    - `Layer 3: the quotient embeddings`.

## Worked examples

The acceptance suite includes `ℚ_2`, its unramified quadratic extension, the totally ramified
quadratic extension generated by `√2`, and the dyadic cyclotomic tower generated by `μ_8`.
These examples must exercise normalization, norm groups, lower and upper numbering, and the
tame quotient; they are regression tests for conventions rather than substitutes for the
generic theorems.

## Dependency order

The intended order is Layer 0 → Layer 1 → Layer 2 → Layer 3 → Layer 4. Later work may proceed
against explicit hypotheses, but the accepted exports use the canonical objects produced by
the preceding layers.

## Material extracted from the former local-fields portfolio

Finite-group Tate cohomology, local class formations, reciprocity, and Tate duality now belong
to **Class Field Theory**. The maximal pro-`p` quotient `G_K(p)`, its generator rank, the
roots-of-unity dichotomy, and its Demushkin presentation now belong to **Local Galois Groups**.
This roadmap retains the local arithmetic and ramification inputs on which both depend.

## References

The mathematical spine is Serre, *Local Fields*; Neukirch, *Algebraic Number Theory*;
Neukirch–Schmidt–Wingberg, *Cohomology of Number Fields*; and Ribes–Zalesskii,
*Profinite Groups*. Exact source and implementation-survey details are recorded in
[`PROVENANCE.md`](PROVENANCE.md).
