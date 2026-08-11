import Mathlib

set_option autoImplicit false

/-!
# Local fields and ramification: target signatures

The normative roadmap is `README.md`. This companion file pins representative Lean-facing
signatures for the local-field and ramification layers only. Class field theory, local
reciprocity, Tate duality, and the arithmetic structure of `G_K(p)` are owned by their new
supplier roadmaps and do not appear here.
-/

namespace TauCetiRoadmap.LocalFieldsRamification

open ValuativeRel
open scoped WithZero

universe u v

variable (K : Type u) [Field K] [ValuativeRel K] [TopologicalSpace K]
  [IsNonarchimedeanLocalField K]
variable (L : Type v) [Field L] [ValuativeRel L] [TopologicalSpace L]
  [IsNonarchimedeanLocalField L]

/-! ## Layer 0: local fields and their finite extensions -/

/-- **Layer 0, non-vacuity: `ℚ_p` is a nonarchimedean local field.** The pin has
`ValuativeRel ℚ_[p]` (via `Padic.mulValuation`) but neither `IsValuativeTopology ℚ_[p]` nor
this instance; producing them, with the metric/valuative uniformity compatibility as a
lemma rather than an accident, is the first milestone. The milestone is the general `p`;
`p = 2` is the case every downstream consumer of this roadmap uses. -/
example (p : ℕ) [Fact p.Prime] : IsNonarchimedeanLocalField ℚ_[p] :=
  sorry

/-- **Layer 0, the normalized valuation.** The valuation of a local field, written
additively but encoded as a homomorphism to `Multiplicative ℤ`. This is `WithZero.log` of
Mathlib's canonical valuation transported along `valueGroupWithZeroIsoInt`. ⚠ Sign trap:
Mathlib's multiplicative convention has `valuation K π = exp (−1) < 1` on uniformizers, so
the additive normalization carries a minus sign; keep that translation in one named lemma. -/
noncomputable def normalizedValuation : Kˣ →* Multiplicative ℤ :=
  sorry

/-- **Layer 0.** The normalized valuation is surjective: the value group is all of `ℤ`. -/
theorem normalizedValuation_surjective : Function.Surjective (normalizedValuation K) :=
  sorry

/-- **Layer 0.** `v_K^×(x) = 1` says the additive value is `0`, that is, `x` is a unit of
`𝒪[K]`. This is the equation reserved for the kernel condition; the uniformizer equation is
the next lemma, and the two must not be conflated. -/
theorem normalizedValuation_eq_one_iff (x : Kˣ) :
    normalizedValuation K x = 1 ↔ valuation K (x : K) = 1 :=
  sorry

/-- **Layer 0.** For a uniformizer the Lean-facing equation is
`v_K^×(π) = Multiplicative.ofAdd 1`, equivalently `v_K(π) = 1` after decoding with
`Multiplicative.toAdd`. -/
theorem normalizedValuation_irreducible (π : 𝒪[K]) (_hπ : Irreducible π) (hπ0 : (π : K) ≠ 0) :
    normalizedValuation K (Units.mk0 (π : K) hπ0) = Multiplicative.ofAdd 1 :=
  sorry

/-- **Layer 0, uniformizers generate the value group.** Any irreducible element of the
(discrete valuation) ring `𝒪[K]` has valuation a generator: every nonzero value is an
integer power of it. -/
example (π : 𝒪[K]) (_hπ : Irreducible π) :
    ∀ γ : (ValueGroupWithZero K)ˣ,
      ∃ n : ℤ, (γ : ValueGroupWithZero K) = valuation K (π : K) ^ n :=
  sorry

/-- **Layer 0.I, constructing the valuation on a finite extension.** For an abstract finite
extension `M/K` with *no* valuative structure assumed on `M`, there is a valuation on `M`,
with values in `ℤᵐ⁰`, restricting to the valuation class of `K`. This is the milestone the
spectral norm and `RingTheory/Valuation/Extension.lean` are for, and it is what makes the
`ValuativeRel M` instance of the next milestones exist at all; it is *not* prototyped by any
statement that hypothesizes that instance. -/
example (M : Type v) [Field M] [Algebra K M] [Module.Finite K M] :
    ∃ w : Valuation M ℤᵐ⁰, (w.comap (algebraMap K M)).IsEquiv (valuation K) :=
  sorry

/-- **Layer 0.II, uniqueness.** Any two valuations on a finite extension `M/K` restricting to
the valuation class of `K` are equivalent. (Completeness of `K` is what makes this true, and
it is part of `IsNonarchimedeanLocalField K`.) -/
example (M : Type v) [Field M] [Algebra K M] [Module.Finite K M]
    {Γ₁ Γ₂ : Type*} [LinearOrderedCommGroupWithZero Γ₁] [LinearOrderedCommGroupWithZero Γ₂]
    (w₁ : Valuation M Γ₁) (w₂ : Valuation M Γ₂)
    (_h₁ : (w₁.comap (algebraMap K M)).IsEquiv (valuation K))
    (_h₂ : (w₂.comap (algebraMap K M)).IsEquiv (valuation K)) :
    w₁.IsEquiv w₂ :=
  sorry

/-- **Layer 0.II, corollary: Galois invariance of the valuation.** Every `K`-algebra
automorphism of a finite extension `L/K` of local fields preserves the canonical valuation.
This is what makes `Gal(L/K)` act on `𝒪[L]`, `𝓂[L]`, and the residue field, and Layers 2
and 3 use it constantly. -/
example [Algebra K L] [ValuativeExtension K L] [Module.Finite K L]
    (σ : L ≃ₐ[K] L) (x : L) :
    valuation L (σ x) = valuation L x :=
  sorry

/-- **Layer 0.III, consequences.** Once the compatible valuation class and the valuative
topology are in place, a finite extension of a nonarchimedean local field is a nonarchimedean
local field. ⚠ This statement hypothesizes the structure, so it prototypes step III only;
steps I and II are the two milestones above. -/
example (M : Type v) [Field M] [ValuativeRel M] [TopologicalSpace M]
    [IsValuativeTopology M] [Algebra K M] [ValuativeExtension K M]
    [Module.Finite K M] :
    IsNonarchimedeanLocalField M :=
  sorry

/-- **Layer 0, the ramification index**, defined without choosing a uniformizer: the positive
integer by which the map of normalized value groups multiplies. Its characteristic property
is `normalizedValuation_algebraMap` below. -/
noncomputable def ramificationIndex [Algebra K L] [ValuativeExtension K L] [Module.Finite K L] :
    ℕ :=
  sorry

/-- **Layer 0, the residue degree.** Once Layer 0.III supplies `Algebra 𝓀[K] 𝓀[L]` this is
`Module.finrank 𝓀[K] 𝓀[L]`; that algebra instance does not exist at the pin, so the
definition is stated here by name and pinned down by `card_residueField` below. -/
noncomputable def inertiaDegree [Algebra K L] [ValuativeExtension K L] [Module.Finite K L] :
    ℕ :=
  sorry

/-- **Layer 0, the characteristic property of `e`.** The normalized valuation of `L`
restricted along `K` is the `e`-th power of that of `K`. Stated for all `x`, so no uniformizer
is chosen; specializing to a uniformizer of `K` gives `v_L(π_K) = e`. -/
theorem normalizedValuation_algebraMap [Algebra K L] [ValuativeExtension K L]
    [Module.Finite K L] (x : Kˣ) :
    normalizedValuation L (Units.map (algebraMap K L : K →+* L).toMonoidHom x)
      = normalizedValuation K x ^ ramificationIndex K L :=
  sorry

/-- **Layer 0, the characteristic property of `f`.** -/
theorem card_residueField [Algebra K L] [ValuativeExtension K L] [Module.Finite K L] :
    Nat.card 𝓀[L] = Nat.card 𝓀[K] ^ inertiaDegree K L :=
  sorry

/-- **Layer 0, `e · f = n`.** With positivity of both factors, and multiplicativity in towers,
this is the fundamental identity of the layer. The reconciliation with the Dedekind-level
`Ideal.ramificationIdx`/`Ideal.inertiaDeg` (at a local field `𝓂[K]` has the single prime
`𝓂[L]` above it) is a separate named milestone. -/
theorem ramificationIndex_mul_inertiaDegree [Algebra K L] [ValuativeExtension K L]
    [Module.Finite K L] :
    ramificationIndex K L * inertiaDegree K L = Module.finrank K L :=
  sorry

open Classical in
/-- **Layer 0, the absolute ramification index** `e_K(p) = v_K(p)`, the decoded normalized
valuation of the image of the natural number `p` in `K`. For `p` prime and `K/ℚ_p` finite it is
`ramificationIndex ℚ_[p] K`, and it is `0` exactly when `p` is a unit of `𝒪[K]`, that is when `p`
is not the residue characteristic. ⚠ In equal characteristic `p` the image of `p` in `K` is `0`
and there is no such invariant. That branch takes the junk value `0`, in the manner of
`Ideal.ramificationIdx`, so every statement below carries `(p : K) ≠ 0`; the hypothesis is what
separates the two cases, and it is not a convenience. -/
noncomputable def absoluteRamificationIndex (p : ℕ) : ℕ :=
  if h : (p : K) = 0 then 0
  else (Multiplicative.toAdd (normalizedValuation K (Units.mk0 (p : K) h))).toNat

/-- **Layer 0, the characteristic property of the absolute ramification index.** Its value is a
natural number, so the equation also carries the assertion that `p` lies in `𝒪[K]`. -/
theorem normalizedValuation_natCast (p : ℕ) (hp : (p : K) ≠ 0) :
    normalizedValuation K (Units.mk0 (p : K) hp)
      = Multiplicative.ofAdd (absoluteRamificationIndex K p : ℤ) :=
  sorry

/-- **Layer 0, the vanishing criterion.** `e_K(p) = 0` exactly when `p` is invertible in the
valuation ring, which for `p` prime says that `p` is not the residue characteristic. -/
theorem absoluteRamificationIndex_eq_zero_iff (p : ℕ) (_hp : (p : K) ≠ 0) :
    absoluteRamificationIndex K p = 0 ↔ IsUnit (p : ↥𝒪[K]) :=
  sorry

/-! ## Layer 1: units, the filtration, and the multiplicative group -/

/-- **Layer 1, the unit filtration** as an object: `U(K,0) = 𝒪[K]ˣ` and
`U(K,i) = 1 + 𝓂[K]^i` for `i ≥ 1`, a decreasing family of open compact subgroups of `Kˣ`
indexed by `ℕ`. The depth-zero branch is part of the definition, not a special case bolted on
afterwards. -/
def unitFiltration (i : ℕ) : Subgroup Kˣ :=
  sorry

/-- **Layer 1, membership at depth `0`:** the units of `𝒪[K]` inside `Kˣ`. -/
theorem mem_unitFiltration_zero (x : Kˣ) :
    x ∈ unitFiltration K 0 ↔ valuation K (x : K) = 1 :=
  sorry

/-- **Layer 1, membership at positive depth, congruence form:** `x ≡ 1 mod 𝓂[K]^i` for a unit
`x` of `𝒪[K]`. -/
theorem mem_unitFiltration_succ_congr (i : ℕ) (u : (↥𝒪[K])ˣ) :
    Units.map (Subring.subtype 𝒪[K]).toMonoidHom u ∈ unitFiltration K (i + 1) ↔
      (u : ↥𝒪[K]) - 1 ∈ 𝓂[K] ^ (i + 1) :=
  sorry

/-- **Layer 1, membership at positive depth, valuation form:** an inequality on `x − 1`,
measured against a uniformizer. Both forms get used; they are proved equivalent once. -/
theorem mem_unitFiltration_succ_valuation (i : ℕ) (x : Kˣ) (π : 𝒪[K]) (_hπ : Irreducible π) :
    x ∈ unitFiltration K (i + 1) ↔
      valuation K ((x : K) - 1) ≤ valuation K ((π : K) ^ (i + 1)) :=
  sorry

/-- **Layer 1, the filtration is decreasing.** -/
theorem unitFiltration_antitone : Antitone (unitFiltration K) :=
  sorry

/-- **Layer 1, the filtration separates points**, which with openness makes it a neighborhood
basis of `1` in `Kˣ`. -/
theorem iInf_unitFiltration : ⨅ i, unitFiltration K i = ⊥ :=
  sorry

/-- **Layer 1, reduction is surjective on units**, the depth-`0` graded piece
`𝒪[K]ˣ ↠ 𝓀[K]ˣ` of the unit filtration, whose kernel is `U(K,1)`. The deeper pieces
`U(K,i)/U(K,i+1) ≅ 𝓀[K]⁺` are stated once the quotient API is in `TauCeti/`. -/
example :
    Function.Surjective
      (Units.map (IsLocalRing.residue 𝒪[K]).toMonoidHom : (↥𝒪[K])ˣ →* (𝓀[K])ˣ) :=
  sorry

/-- **Layer 1, the Teichmüller section**: the canonical multiplicative section of reduction,
characterized by `teichmuller_section` below together with the uniqueness statement that its
image is the `(q−1)`-torsion of `𝒪[K]ˣ`, that is `μ_{q−1}(K)`. Whether the construction goes
through `Perfection.teichmuller₀` or through Hensel applied to `X^(q−1) − 1` is an
implementation note. -/
noncomputable def teichmuller : (𝓀[K])ˣ →* (↥𝒪[K])ˣ :=
  sorry

/-- **Layer 1.** The Teichmüller map is a section of reduction. -/
theorem teichmuller_section (x : (𝓀[K])ˣ) :
    Units.map (IsLocalRing.residue 𝒪[K]).toMonoidHom (teichmuller K x) = x :=
  sorry

/-- **Layer 1, the multiplicative decomposition.** A choice of uniformizer splits
`Kˣ ≅ ℤ × 𝒪[K]ˣ`: every element of `Kˣ` is uniquely `π^n · u` with `u ∈ 𝒪[K]ˣ`. (With the
Teichmüller milestone this refines to `Kˣ ≅ π^ℤ × μ_{q−1} × U(K,1)`, and `U(K,1)` is pro-`p`,
in the quotient form that `Supplied.IsProP` unfolds to.) -/
example (π : 𝒪[K]) (_hπ : Irreducible π) (x : Kˣ) :
    ∃! p : ℤ × (↥𝒪[K])ˣ, (x : K) = (π : K) ^ p.1 * ((p.2 : ↥𝒪[K]) : K) :=
  sorry

/-- **Layer 1, power classes in the prime-to-residue-characteristic regime.** If `n` is a unit
in the valuation ring, the count is exact and holds in either characteristic: the factor
`q ^ v_K(n)` of the general formula is `1`, which is where the hypothesis is used. -/
theorem card_powerClasses_of_isUnit (n : ℕ) (_hn : n ≠ 0) (_hn' : IsUnit (n : ↥𝒪[K])) :
    Nat.card (Kˣ ⧸ (powMonoidHom n : Kˣ →* Kˣ).range)
      = n * Nat.card (rootsOfUnity n K) :=
  sorry

/-- **Layer 1, power classes in the mixed-characteristic regime.** For `K/ℚ_p` finite the same
formula holds for every `n ≠ 0`, including `p ∣ n`, with the extra factor
`q ^ v_K(n) = ‖n‖_K⁻¹` written here as the (finite) cardinality of `𝒪[K]/n𝒪[K]`, which avoids
an integer-to-natural coercion. ⚠ This must not be generalized to equal characteristic: at
`K = 𝔽_q((t))` and `n = p` the left-hand side is infinite. -/
theorem card_powerClasses_mixed (p : ℕ) [Fact p.Prime] [Algebra ℚ_[p] K] [Module.Finite ℚ_[p] K]
    (n : ℕ) (_hn : n ≠ 0) :
    Nat.card (Kˣ ⧸ (powMonoidHom n : Kˣ →* Kˣ).range)
      = n * Nat.card (rootsOfUnity n K)
        * Nat.card (↥𝒪[K] ⧸ Ideal.span {(n : ↥𝒪[K])}) :=
  sorry

/-- **Layer 1, the square classes away from residue characteristic `2`.** The specialization of
`card_powerClasses_of_isUnit` at `n = 2`: the hypothesis makes `2` invertible in `𝒪[K]`, hence
in `K`, so `μ_2(K) = {±1}` has order `2` and the count is `2 · 2 · 1`. -/
theorem card_squareClasses_of_isUnit (_h2 : IsUnit (2 : ↥𝒪[K])) :
    Nat.card (Kˣ ⧸ (powMonoidHom 2 : Kˣ →* Kˣ).range) = 4 :=
  sorry

/-- **Layer 1, the square classes at residue characteristic `2`, in the `4 · q^e` form.** The
specialization of `card_powerClasses_mixed` at `p = n = 2`, with `q = Nat.card 𝓀[K]` and
`e = absoluteRamificationIndex K 2`. It is `2 · #μ_2(K) · q^e` with `#μ_2(K) = 2`, and
`q ^ e = Nat.card (𝒪[K] ⧸ 2𝒪[K])`. For `K/ℚ_2` of degree `N` it reads `2 ^ (N + 2)`, and at
`K = ℚ_2` it reads `8`. ⚠ The factor `q ^ e` is not `1` here, so this is not the count of
`card_squareClasses_of_isUnit` with a different proof; the two hypotheses are exclusive. -/
theorem card_squareClasses_dyadic [Algebra ℚ_[2] K] [Module.Finite ℚ_[2] K] :
    Nat.card (Kˣ ⧸ (powMonoidHom 2 : Kˣ →* Kˣ).range)
      = 4 * Nat.card 𝓀[K] ^ absoluteRamificationIndex K 2 :=
  sorry

/-- **Layer 1, the two spellings of the square classes.** Mathlib's `Subgroup.square Kˣ` is the
subgroup of squares, and the counts above are stated at the range of `powMonoidHom`. This is the
identification at `n = 2`, and it is what lets a consumer read the count of this layer, and the
Kummer isomorphism of Layer 5, on `Subgroup.square Kˣ`. -/
theorem square_eq_range_powMonoidHom :
    Subgroup.square Kˣ = (powMonoidHom 2 : Kˣ →* Kˣ).range :=
  sorry

/-- **Layer 1, worked example: `ℚ_2ˣ/(ℚ_2ˣ)²` has order 8** (the classes of `−1, 2, 5`
generate). The odd-`p` count is `4`; this factor-of-two dyadic difference is why no layer may
assume `p ≠ 2`. -/
example : Nat.card (ℚ_[2]ˣ ⧸ (powMonoidHom 2 : ℚ_[2]ˣ →* ℚ_[2]ˣ).range) = 8 :=
  sorry

/-- **Layer 1, the local square theorem, sharp form.** For `K/ℚ_2` finite and
`e = absoluteRamificationIndex K 2`, every unit of depth `2e+1` is a square. ⚠ This is **not** an
instance of the counts above, which decide how many square classes there are and not which
subgroup lies inside the squares. ⚠ The hypothesis is mixed characteristic: in equal
characteristic `2` the image of `2` is `0`, `absoluteRamificationIndex` takes its junk value, and
the displayed statement is a different assertion. -/
theorem unitFiltration_le_range_powMonoidHom_two [Algebra ℚ_[2] K] [Module.Finite ℚ_[2] K] :
    unitFiltration K (2 * absoluteRamificationIndex K 2 + 1)
      ≤ (powMonoidHom 2 : Kˣ →* Kˣ).range :=
  sorry

/-- **Layer 1, sharpness of the local square theorem.** The threshold `2e+1` cannot be lowered,
over any finite extension of `ℚ_2` and not only over `ℚ_2`: `U(K, 2e)` always meets the
complement of the squares. The obstruction is the Artin–Schreier map `t ↦ t² + t` of `𝓀[K]`,
which is `𝔽_2`-linear with kernel `𝔽_2` and therefore has image of index `2`; since
`𝓂[K]^{2e} = 4 · 𝒪[K]`, a unit `1 + 4c` is a square exactly when the residue of `c` is in that
image, so any `c` outside it is a witness. -/
theorem not_unitFiltration_le_range_powMonoidHom_two [Algebra ℚ_[2] K] [Module.Finite ℚ_[2] K] :
    ¬ unitFiltration K (2 * absoluteRamificationIndex K 2)
      ≤ (powMonoidHom 2 : Kˣ →* Kˣ).range :=
  sorry

/-- **Layer 1, worked example: the dyadic deep-square bound.** Units of `ℤ_2` congruent to
`1 mod 8` are squares (`U(K, 2e+1) ⊆ (Kˣ)²` at `K = ℚ_2`, `e = 1`), and `1 + 4ℤ_2` are not, so
the threshold is sharp there. -/
example (u : ℤ_[2]ˣ) (_hu : (8 : ℤ_[2]) ∣ ((u : ℤ_[2]) - 1)) : IsSquare u :=
  sorry

/-! ## Layer 2: unramified extensions and Frobenius -/

/-- **Layer 2, the Frobenius element** of a finite unramified extension: the preimage of the
arithmetic Frobenius `x ↦ x^q` of the residue extension under the residue correspondence
`Gal(L/K) ≃* Gal(𝓀[L]/𝓀[K])`. It generates `Gal(L/K)`, which is cyclic of order `f`. The
unramifiedness hypothesis is `ramificationIndex K L = 1`; separability of the residue extension,
which the general definition of an unramified extension of valued fields also carries, is
automatic here because `𝓀[K]` is finite. `IsGalois K L` is likewise automatic for an unramified
`L/K`, which is generated over `K` by the `(q^f − 1)`-st roots of unity and so is the splitting
field of a separable polynomial; it is carried because the residue correspondence is stated for
a Galois extension. ⚠ Arithmetic, never geometric: the inverse `(frobeniusAlgEquiv K L h)⁻¹` is
the geometric Frobenius, and no statement of this roadmap uses the unqualified word for it. -/
noncomputable def frobeniusAlgEquiv [Algebra K L] [ValuativeExtension K L] [Module.Finite K L]
    [IsGalois K L] (_h : ramificationIndex K L = 1) : L ≃ₐ[K] L :=
  sorry

/-- **Layer 2, the characteristic property of Frobenius:** `σ(y) ≡ y^q mod 𝓂[L]` on `𝒪[L]`,
with `q = Nat.card 𝓀[K]`. This is the equation that fixes `frobeniusAlgEquiv`, and it is stated
on the valuation rather than on the residue field so that it needs no separate name for the
induced action on `𝓀[L]`; `valuation L x < 1` is membership in `𝓂[L]`. -/
theorem valuation_frobeniusAlgEquiv_sub_pow [Algebra K L] [ValuativeExtension K L]
    [Module.Finite K L] [IsGalois K L] (h : ramificationIndex K L = 1) (y : ↥𝒪[L]) :
    valuation L (frobeniusAlgEquiv K L h (y : L) - (y : L) ^ Nat.card 𝓀[K]) < 1 :=
  sorry

/-- **The norm group** `N_{L/K}(Lˣ) : Subgroup Kˣ`, the image of the field norm. Layer 2 computes
it for `L/K` unramified, and Layer 7 item 1 studies it for `L/K` finite abelian: openness, the
index formula `[Kˣ : N_{L/K}Lˣ] = [L:K]`, and the lattice of norm groups. It is a definition and
not a placeholder; the milestones are the laws about it. -/
noncomputable def normGroup [Algebra K L] [Module.Finite K L] : Subgroup Kˣ :=
  (Units.map (Algebra.norm K : L →* K)).range

/-- **Layer 2, norms of units from an unramified extension.** `N_{L/K}(𝒪[L]ˣ) = 𝒪[K]ˣ`, written
on the depth-zero step of the unit filtration, which `mem_unitFiltration_zero` identifies with
the units of the valuation ring. ⚠ *False generalization:* for a ramified extension the norm of
a unit is still a unit, but the image is a proper subgroup; at `L = ℚ_2(√2)` it has index `2` in
`ℤ_2ˣ`. -/
theorem map_norm_unitFiltration_zero [Algebra K L] [ValuativeExtension K L] [Module.Finite K L]
    (_h : ramificationIndex K L = 1) :
    Subgroup.map (Units.map (Algebra.norm K : L →* K)) (unitFiltration L 0) = unitFiltration K 0 :=
  sorry

/-- **Layer 2, the unramified norm group in norm-equation form.** `N_{L/K}(Lˣ) = π^{fℤ} × 𝒪[K]ˣ`,
stated as the solvability criterion for the norm equation `N_{L/K}(y) = x`: with `e = 1` the
valuation of a norm is `f · v_L(y)`, and units are norms by the milestone above, so `x` is a norm
exactly when `f` divides `v_K(x)`. ⚠ `f` here is `inertiaDegree K L`, the residue degree of
Layer 0, and never a conductor. -/
theorem mem_normGroup_iff_dvd_normalizedValuation [Algebra K L] [ValuativeExtension K L]
    [Module.Finite K L] (_h : ramificationIndex K L = 1) (x : Kˣ) :
    x ∈ normGroup K L ↔
      (inertiaDegree K L : ℤ) ∣ Multiplicative.toAdd (normalizedValuation K x) :=
  sorry

/-- **Layer 2, worked example: the unramified quadratic extension of `ℚ_2`.** The adjoined set
is *all* cube roots of unity, so the intermediate field is the splitting field of `X³ − 1`
over `ℚ_2` and no primitive root is chosen; it equals `ℚ_2(√5) = ℚ_2(√−3)` and has residue
field `𝔽_4`. The general milestone is `[K(μ_{q^f−1}) : K] = f` with `Gal` isomorphic to the
Galois group of the residue extension, generated by arithmetic Frobenius. -/
example :
    Module.finrank ℚ_[2]
      (IntermediateField.adjoin ℚ_[2] {x : AlgebraicClosure ℚ_[2] | x ^ 3 = 1}) = 2 :=
  sorry

/-- **Layer 2, worked example: units of `ℚ_2` are norms from the unramified quadratic
extension** (`u = x² − 5y²` solvable over `ℤ_2`; norm surjectivity on units, Serre LF V §2,
the input to the fundamental-class layer). -/
example (u : ℤ_[2]ˣ) : ∃ x y : ℤ_[2], (u : ℤ_[2]) = x ^ 2 - 5 * y ^ 2 :=
  sorry

/-- **Layer 2, worked example: `2` is *not* a norm from the unramified quadratic extension**
(`N(ℚ_2(√5)ˣ) = ⟨4⟩ × ℤ_2ˣ` has index `2`; a uniformizer detects the unramified norm
group). -/
example : ¬ ∃ x y : ℚ_[2], (2 : ℚ_[2]) = x ^ 2 - 5 * y ^ 2 :=
  sorry

/-! ## Layer 3: ramification (worked examples; the filtration itself is README-only) -/

/-- **Layer 3, worked example: a totally ramified quadratic extension.** `ℚ_2(√2)/ℚ_2` has
degree `2` (Eisenstein `X² − 2`); the general milestone is the totally-ramified ↔ Eisenstein
correspondence. -/
example :
    Module.finrank ℚ_[2]
      (IntermediateField.adjoin ℚ_[2] {x : AlgebraicClosure ℚ_[2] | x ^ 2 = 2}) = 2 :=
  sorry

/-- **Layer 3, worked example: the dyadic cyclotomic tower is totally ramified.**
`[ℚ_2(μ_8) : ℚ_2] = φ(8) = 4`. Its ramification filtration `G = G_0 = G_1 ⊋ G_2 = G_3 ⊋
G_4 = 1`, the resulting Herbrand jumps, and the failure of lower-numbering quotient
compatibility that it witnesses are the README's Layer-3 acceptance computations, stated once
the filtration exists. -/
example :
    Module.finrank ℚ_[2]
      (IntermediateField.adjoin ℚ_[2] {x : AlgebraicClosure ℚ_[2] | x ^ 8 = 1}) = 4 :=
  sorry

end TauCetiRoadmap.LocalFieldsRamification
