import Mathlib

/-!
# Arithmetic Dirichlet series and Tauberian methods: target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is `README.md`.
These declarations pin the carriers and conventions most likely to drift. Proving them does not
by itself complete a layer.
-/

namespace TauCetiRoadmap.ArithmeticDirichletSeries

open Complex Filter NumberField Topology Asymptotics
open IsDedekindDomain (HeightOneSpectrum)

noncomputable section

universe u

variable (K : Type u) [Field K] [NumberField K]

/-- Layer 0: a completely multiplicative degree-one character-like function on ideals. The
zero-ideal law is data, not a consequence of multiplicativity. This is not a carrier for an
arbitrary Euler product: higher-dimensional Artin coefficients require independent prime-power
local data. -/
structure IdealWeight where
  toFun : Ideal (𝓞 K) → ℂ
  bad : Set (HeightOneSpectrum (𝓞 K))
  bad_finite : bad.Finite
  map_mul : ∀ I J, toFun (I * J) = toFun I * toFun J
  norm_eq_one : ∀ 𝔭 ∉ bad, ‖toFun 𝔭.asIdeal‖ = 1
  eq_zero_bad : ∀ 𝔭 ∈ bad, toFun 𝔭.asIdeal = 0
  eq_zero_bot : toFun ⊥ = 0

namespace IdealWeight

instance : CoeFun (IdealWeight K) (fun _ ↦ Ideal (𝓞 K) → ℂ) := ⟨toFun⟩

@[ext]
theorem ext {χ ψ : IdealWeight K} (h : χ.toFun = ψ.toFun) (hbad : χ.bad = ψ.bad) : χ = ψ :=
  sorry

theorem constantOne_rejected :
    ¬ ∃ χ : IdealWeight K, χ.toFun = fun _ ↦ 1 := sorry

noncomputable def one : IdealWeight K := sorry
noncomputable def conj (χ : IdealWeight K) : IdealWeight K := sorry
noncomputable def pointwiseMul (χ ψ : IdealWeight K) : IdealWeight K := sorry

/-- A good ideal is nonzero and prime to the finite bad set. The explicit nonzero condition is
needed even when the bad set is empty. -/
def IsGood (χ : IdealWeight K) (I : Ideal (𝓞 K)) : Prop :=
  I ≠ ⊥ ∧ ∀ 𝔭 ∈ χ.bad, ¬ 𝔭.asIdeal ∣ I

/-- The boundary twist `χ * N^(it)`. -/
noncomputable def normTwist (χ : IdealWeight K) (t : ℝ) : IdealWeight K := sorry

/-- Pointwise square, kept distinct from ideal convolution. -/
noncomputable def sq (χ : IdealWeight K) : IdealWeight K := pointwiseMul K χ χ

def IsNormTwistOnGood (χ : IdealWeight K) (u : ℝ) : Prop :=
  ∀ I : Ideal (𝓞 K), IsGood K χ I →
    χ I = ((Ideal.absNorm I : ℝ) : ℂ) ^ (Complex.I * (u : ℂ))

def IsTrivialOnGood (χ : IdealWeight K) : Prop :=
  ∀ I : Ideal (𝓞 K), IsGood K χ I → χ I = 1

end IdealWeight

/-- Layer 1: sum a weight over the finite fibre of the absolute norm. -/
noncomputable def normCoeff (χ : IdealWeight K) (n : ℕ) : ℂ := sorry

theorem normCoeff_zero (χ : IdealWeight K) : normCoeff K χ 0 = 0 := sorry

theorem normCoeff_one (χ : IdealWeight K) : normCoeff K χ 1 = 1 := sorry

/-- The exact abscissa contract for the trivial ideal weight, formerly stated for the named
Dedekind-zeta coefficient. -/
theorem abscissaOfAbsConv_normCoeff_one :
    LSeries.abscissaOfAbsConv (normCoeff K (IdealWeight.one K)) = 1 := sorry

/-- The partial-sum estimate that supplies continuation into a strip. It is analytic input, not a
consequence of the coefficient values lying in a finite group. -/
def HasCancellation (χ : IdealWeight K) : Prop :=
  (fun X : ℝ ↦ ∑ᶠ I : {I : Ideal (𝓞 K) // (Ideal.absNorm I : ℝ) ≤ X}, χ I)
    =O[atTop] fun X : ℝ ↦ X ^ (1 - 1 / (Module.finrank ℚ K : ℝ))

/-- The named continuation determined by Abel summation and uniqueness. -/
noncomputable def continuedLFunctionOfWeight (χ : IdealWeight K) : ℂ → ℂ := sorry

theorem continuedLFunctionOfWeight_eq (χ : IdealWeight K) {s : ℂ} (hs : 1 < s.re) :
    continuedLFunctionOfWeight K χ s = LSeries (normCoeff K χ) s := sorry

theorem analyticOnNhd_continuedLFunctionOfWeight
    (χ : IdealWeight K) (hχ : HasCancellation K χ) :
    AnalyticOnNhd ℂ (continuedLFunctionOfWeight K χ)
      {s : ℂ | 1 - 1 / (Module.finrank ℚ K : ℝ) < s.re} := sorry

/-- Layer 1: regroup an absolutely summable ideal series by norm into Mathlib's `LSeries`. -/
theorem regroupByNorm (χ : IdealWeight K) (s : ℂ)
    (h : Summable fun I : Ideal (𝓞 K) ↦ χ I / (Ideal.absNorm I : ℂ) ^ s) :
    (∑' I : Ideal (𝓞 K), χ I / (Ideal.absNorm I : ℂ) ^ s) =
      LSeries (normCoeff K χ) s := sorry

/-- Layer 2: ideal convolution, kept separate from pointwise multiplication. -/
noncomputable def idealConvolution (χ ψ : IdealWeight K) (I : Ideal (𝓞 K)) : ℂ := sorry

/-- Layer 2: the von Mangoldt transform supported on prime powers. -/
noncomputable def idealVonMangoldt (χ : IdealWeight K) (I : Ideal (𝓞 K)) : ℂ := sorry

/-- Layer 3: the canonical local-factor package of an ideal weight. -/
structure EulerProductData (χ : IdealWeight K) where
  localFactor : HeightOneSpectrum (𝓞 K) → ℂ → ℂ
  localFactor_eq : ∀ 𝔭 s, localFactor 𝔭 s =
    ∑' m : ℕ, χ (𝔭.asIdeal ^ m) / (Ideal.absNorm 𝔭.asIdeal : ℂ) ^ (m * s)
  converges : ∀ s : ℂ, 1 < s.re →
    Summable fun 𝔭 : HeightOneSpectrum (𝓞 K) ↦ localFactor 𝔭 s - 1
  product_eq : ∀ s : ℂ, 1 < s.re →
    ∏' 𝔭 : HeightOneSpectrum (𝓞 K), localFactor 𝔭 s = LSeries (normCoeff K χ) s

/-- Layer 4: logarithmically weighted counting of a set of nonzero prime ideals. -/
noncomputable def primeTheta (S : Set (HeightOneSpectrum (𝓞 K))) (x : ℝ) : ℝ := sorry

/-- Layer 4: unweighted counting of a set of nonzero prime ideals. -/
noncomputable def primeCount (S : Set (HeightOneSpectrum (𝓞 K))) (x : ℝ) : ℕ := sorry

/-- Layer 7: the prime Dirichlet sum of a set of nonzero prime ideals. -/
noncomputable def primeDirichletSum (S : Set (HeightOneSpectrum (𝓞 K))) (s : ℝ) : ℝ := sorry

/-- Layer 7: Dirichlet density is normalized by the all-prime sum. -/
def HasDirichletDensity (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ) : Prop :=
  Tendsto
    (fun s : ℝ ↦ primeDirichletSum K S s /
      primeDirichletSum K Set.univ s)
    (𝓝[>] 1) (𝓝 δ)

/-- Layer 7: natural density is normalized by the all-prime counting function. -/
def HasNaturalDensity (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ) : Prop :=
  Tendsto
    (fun x : ℝ ↦ (primeCount K S x : ℝ) /
      (primeCount K Set.univ x : ℝ))
    atTop (𝓝 δ)

/-- Layer 7: an epsilon-neighborhood spelling of lower Dirichlet density. -/
def LowerDirichletDensity (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ η : ℝ, 0 < η ∧ ∀ s : ℝ,
    1 < s → s < 1 + η →
      δ - ε ≤ primeDirichletSum K S s / primeDirichletSum K Set.univ s

/-- Layer 7: an epsilon-neighborhood spelling of upper Dirichlet density. -/
def UpperDirichletDensity (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ η : ℝ, 0 < η ∧ ∀ s : ℝ,
    1 < s → s < 1 + η →
      primeDirichletSum K S s / primeDirichletSum K Set.univ s ≤ δ + ε

theorem hasDirichletDensity_of_finite
    (S : Set (HeightOneSpectrum (𝓞 K))) (hS : S.Finite) :
    HasDirichletDensity K S 0 := sorry

theorem hasDirichletDensity_of_symmDiff_finite
    (S T : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ)
    (h : ((S \ T) ∪ (T \ S)).Finite) (hS : HasDirichletDensity K S δ) :
    HasDirichletDensity K T δ := sorry

theorem hasDirichletDensity_of_upper_of_lower
    (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ)
    (hu : UpperDirichletDensity K S δ) (hl : LowerDirichletDensity K S δ) :
    HasDirichletDensity K S δ := sorry

/-- Layer 7: lower-density bounds for a finite partition squeeze to exact densities when the
bounds exhaust the density of the union. -/
theorem hasDirichletDensity_of_squeeze {i : Type*} [Fintype i]
    (S : i → Set (HeightOneSpectrum (𝓞 K))) (c : i → ℝ)
    (hdisj : Pairwise (Function.onFun Disjoint S))
    (hunion : HasDirichletDensity K (⋃ j, S j) 1)
    (hlow : ∀ j, LowerDirichletDensity K (S j) (c j))
    (hsum : ∑ j, c j = 1) :
    ∀ j, HasDirichletDensity K (S j) (c j) := sorry

/-- Layer 7: transfer Dirichlet density through a constant finite fibre of residue-degree-one
primes. The coverage and residue-degree hypotheses are explicit because they are what identify
the two norm sums. -/
theorem hasDirichletDensity_contraction
    (E : Type u) [Field E] [NumberField E] [Algebra K E]
    (S : Set (HeightOneSpectrum (𝓞 E)))
    (T : Set (HeightOneSpectrum (𝓞 K))) (k : ℕ) (hk : 0 < k) (δ : ℝ)
    (hfibre : ∀ 𝔭 ∈ T, Nat.card {𝔓 : HeightOneSpectrum (𝓞 E) //
      𝔓 ∈ S ∧ 𝔓.asIdeal.under (𝓞 K) = 𝔭.asIdeal} = k)
    (hdeg : ∀ 𝔓 ∈ S,
      Ideal.inertiaDeg (𝔓.asIdeal.under (𝓞 K)) 𝔓.asIdeal = 1)
    (hover : ∀ 𝔓 ∈ S, ∃ 𝔭 ∈ T, 𝔓.asIdeal.under (𝓞 K) = 𝔭.asIdeal) :
    HasDirichletDensity E S δ ↔
      HasDirichletDensity K T (δ / (k : ℝ)) := sorry

theorem hasDirichletDensity_of_hasNaturalDensity
    (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ)
    (h : HasNaturalDensity K S δ) :
    HasDirichletDensity K S δ := sorry

/-- Layer 6: exact Abel summation for finite sequences. The interval is inclusive at the upper
endpoint; the displayed difference counts each boundary exactly once. -/
theorem abelSummation (a : ℕ → ℂ) (f : ℕ → ℂ) (N : ℕ) :
    ∑ n ∈ Finset.Icc 1 N, a n * f n =
      (∑ n ∈ Finset.Icc 1 N, a n) * f N -
        ∑ n ∈ Finset.Ico 1 N, (∑ k ∈ Finset.Icc 1 n, a k) * (f (n + 1) - f n) := sorry

/-- Layer 6: the truncated Perron kernel away from its endpoint. -/
theorem perronFormula (x c T : ℝ) (hx : 0 < x) (hx1 : x ≠ 1) (hc : 0 < c) (hT : 1 ≤ T) :
    ∃ E : ℂ,
      (2 * Real.pi * Complex.I)⁻¹ *
          (∫ t in (-T)..T, (x : ℂ) ^ (c + t * Complex.I) /
            (c + t * Complex.I)) =
        (if 1 < x then 1 else 0) + E ∧
      ‖E‖ ≤ x ^ c / (T * |Real.log x|) := sorry

theorem perronFormula_endpoint (c T : ℝ) (hc : 0 < c) (hT : 0 ≤ T) :
    (2 * Real.pi * Complex.I)⁻¹ *
        (∫ t in (-T)..T, (c + t * Complex.I)⁻¹) =
      (Real.arctan (T / c) / Real.pi : ℝ) := sorry

/-- Layer 8: Landau's singularity theorem for nonnegative Dirichlet coefficients. -/
theorem landau {a : ℕ → ℝ} (ha : ∀ n, 0 ≤ a n) {σ : ℝ}
    (hsum : ∀ s : ℂ, σ < s.re → LSeriesSummable (fun n ↦ (a n : ℂ)) s) :
    ¬ ∃ F : ℂ → ℂ, AnalyticAt ℂ F σ ∧
      ∀ᶠ s : ℂ in 𝓝[ {z : ℂ | σ < z.re} ] (σ : ℂ),
        F s = LSeries (fun n ↦ (a n : ℂ)) s := sorry

/-- Layer 9: Wiener–Ikehara with a separately named continuous boundary remainder. -/
theorem wienerIkehara (a : ℕ → ℝ) (F G : ℂ → ℂ) (κ : ℝ)
    (ha : ∀ n, 0 ≤ a n)
    (hF : ∀ s : ℂ, 1 < s.re → F s = LSeries (fun n ↦ (a n : ℂ)) s)
    (hG : ContinuousOn G {s : ℂ | 1 ≤ s.re})
    (hFG : ∀ s : ℂ, 1 < s.re → G s = F s - (κ : ℂ) / (s - 1)) :
    Tendsto (fun x : ℝ ↦ (∑ n ∈ Finset.range ⌊x⌋₊.succ, a n) / x)
      atTop (𝓝 κ) := sorry

/-- Layer 10: the generic transfer from a von Mangoldt asymptotic to prime counting. -/
theorem primeNumberTheoremTransfer
    (S : Set (HeightOneSpectrum (𝓞 K))) (δ : ℝ)
    (hθ : Tendsto (fun x : ℝ ↦ primeTheta K S x / x) atTop (𝓝 δ)) :
    Tendsto
      (fun x : ℝ ↦ (primeCount K S x : ℝ) / (x / Real.log x))
      atTop (𝓝 δ) := sorry

end

end TauCetiRoadmap.ArithmeticDirichletSeries
