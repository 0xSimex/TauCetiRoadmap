import Mathlib

/-!
# Ado–Iwasawa: target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The statements here suggest Lean forms for particular milestones, so that
contributors and reviewers converge on names and signatures; discharging all of them
finishes neither a layer nor the roadmap. `sorry` is allowed in this human-owned roadmap
library -- these are goals, not proofs.

Mathlib has the universal enveloping algebra and its universal property, Lie derivations,
the radical and maximal nilpotent ideal, Engel's theorem, Lie's theorem, and Krull-intersection
infrastructure. It has no concrete PBW basis, no injectivity theorem for the canonical map into
the enveloping algebra, no lift of Lie derivations to that algebra, no Ado theorem, and no
positive-characteristic central `p`-polynomial construction. See `README.md` for the full
dependency plan.
-/

namespace TauCetiRoadmap.RepresentationTheory.AdoIwasawa

open scoped Polynomial

universe u

attribute [local instance 100] LieRing.ofAssociativeRing

variable (K : Type u) [Field K]
variable (L : Type u) [LieRing L] [LieAlgebra K L]

/-! ## Layer 0: finite associative and enveloping targets -/

/-- A faithful embedding in a finite-dimensional associative algebra gives a faithful
finite-dimensional representation by left multiplication. -/
theorem ado_of_finiteAssociativeEmbedding {A : Type u} [Ring A] [Algebra K A]
    [FiniteDimensional K A] (f : L →ₗ⁅K⁆ A) (hf : Function.Injective f) :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := sorry

/-- The finite-target reduction through the universal enveloping algebra. -/
theorem ado_of_finiteEnvelopingTarget {A : Type u} [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (q : UniversalEnvelopingAlgebra K L →ₐ[K] A)
    (hq : Function.Injective
      (fun x : L ↦ q (UniversalEnvelopingAlgebra.ι K x))) :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := sorry

/-- A faithful finite-dimensional representation and a finite-dimensional associative target
of `U(L)` separating `L` are equivalent. -/
theorem faithfulRepresentation_iff_finiteEnvelopingTarget :
    (∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
        (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ) ↔
      ∃ (A : Type u) (_ : Ring A) (_ : Algebra K A) (_ : FiniteDimensional K A)
        (q : UniversalEnvelopingAlgebra K L →ₐ[K] A),
        Function.Injective
          (fun x : L ↦ q (UniversalEnvelopingAlgebra.ι K x)) := sorry

/-! ## Layers 1–3: PBW consequences, weighted nilpotent quotients, and derivations -/

/-- The canonical Lie map into the enveloping algebra is injective. This is a concrete PBW
consequence shared with `../LieHighestWeight`. -/
theorem ι_injective :
    Function.Injective (UniversalEnvelopingAlgebra.ι K (L := L)) := sorry

/-- The underlying linear map of the associative derivation extending a Lie derivation. The definitive
roadmap also requires packaging this in a reusable noncommutative derivation API; Mathlib's current
`Derivation` type is restricted to commutative algebras. -/
noncomputable def envelopingDerivation (D : LieDerivation K L L) :
    UniversalEnvelopingAlgebra K L →ₗ[K] UniversalEnvelopingAlgebra K L := sorry

/-- The extension satisfies the associative Leibniz rule. -/
theorem envelopingDerivation_mul (D : LieDerivation K L L)
    (a b : UniversalEnvelopingAlgebra K L) :
    envelopingDerivation K L D (a * b) =
      envelopingDerivation K L D a * b + a * envelopingDerivation K L D b := sorry

@[simp]
theorem envelopingDerivation_ι (D : LieDerivation K L L) (x : L) :
    envelopingDerivation K L D (UniversalEnvelopingAlgebra.ι K x) =
      UniversalEnvelopingAlgebra.ι K (D x) := sorry

/-- The characteristic-free Birkhoff checkpoint, obtained from a lower-central-series-weighted
PBW truncation: a finite-dimensional nilpotent Lie algebra has a faithful finite-dimensional
representation in which every element acts nilpotently. -/
theorem exists_faithful_nilpotentRepresentation [FiniteDimensional K L]
    [LieRing.IsNilpotent L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V),
      Function.Injective ρ ∧ ∀ x : L, IsNilpotent (ρ x) := sorry

/-! ## Layers 5–8: the two characteristic tracks -/

/-- Ado's theorem in characteristic zero, obtained from the derivation-stable extension
construction and Levi decomposition. -/
theorem adoCharZero [CharZero K] [FiniteDimensional K L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := sorry

/-- The load-bearing positive-characteristic construction: every `x` has a monic linearized
`p`-polynomial with zero constant term that is central in `U(L)`. The displayed indexing gives
the leading term exponent `p^e` and lower terms `p^i` for `i : Fin e`; it does not assert that
`e` is minimal. -/
theorem exists_pCentralPolynomial (p : ℕ) [Fact p.Prime] [CharP K p]
    [FiniteDimensional K L] (x : L) :
    ∃ (e : ℕ) (a : Fin e → K),
      ∀ y : UniversalEnvelopingAlgebra K L,
        ((UniversalEnvelopingAlgebra.ι K x) ^ (p ^ e) +
            ∑ i : Fin e, algebraMap K (UniversalEnvelopingAlgebra K L) (a i) *
              (UniversalEnvelopingAlgebra.ι K x) ^ (p ^ (i : ℕ))) * y =
          y * ((UniversalEnvelopingAlgebra.ι K x) ^ (p ^ e) +
            ∑ i : Fin e, algebraMap K (UniversalEnvelopingAlgebra K L) (a i) *
              (UniversalEnvelopingAlgebra.ι K x) ^ (p ^ (i : ℕ))) := sorry

/-- The positive-characteristic Ado theorem from the central ideal and Krull intersection. -/
theorem adoCharP (p : ℕ) [Fact p.Prime] [CharP K p] [FiniteDimensional K L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := sorry

/-! ## Layer 9: the arbitrary-field summit -/

/-- Hochschild's strengthening of Ado–Iwasawa: the faithful representation can preserve
nilpotence detected by the adjoint representation. -/
theorem exists_faithful_preserving_ad_nilpotence [FiniteDimensional K L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V),
      Function.Injective ρ ∧
        ∀ x : L, IsNilpotent (LieAlgebra.ad K L x) → IsNilpotent (ρ x) := sorry

/-- **Ado–Iwasawa.** Every finite-dimensional Lie algebra over an arbitrary field admits
a faithful finite-dimensional representation. -/
theorem adoIwasawa [FiniteDimensional K L] :
    ∃ (V : Type u) (_ : AddCommGroup V) (_ : Module K V) (_ : FiniteDimensional K V)
      (ρ : L →ₗ⁅K⁆ Module.End K V), Function.Injective ρ := sorry

end TauCetiRoadmap.RepresentationTheory.AdoIwasawa
