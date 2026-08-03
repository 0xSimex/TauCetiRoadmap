import Mathlib

/-!
# Weight-two automorphic forms on quaternionic inner forms of `PGL₂`

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The statements here suggest Lean forms for particular milestones, so that
contributors and reviewers converge on names and signatures; discharging all of them
finishes neither a layer nor the roadmap. `sorry` is allowed in this human-owned roadmap
library.

Only targets expressible using the current Mathlib API appear here. In particular,
`ParallelWeightTwoInfinityType`, `WeightTwoAutomorphicForm`,
`WeightTwoAutomorphicEigenpacket`, `WeightTwoGoodPlaceHeckeDatum`, and the final attachment
theorem must be added only after their genuine analytic and Hecke-theoretic inputs exist.
They are not represented here by empty `Prop` placeholders.
-/

namespace TauCetiRoadmap.WeightTwoAutomorphicForms

open IsDedekindDomain NumberField Polynomial
open scoped TensorProduct

universe u v

/-! ## Layer 0: quaternion algebras -/

/-- A quaternion algebra is intrinsically a central simple algebra of rank four. This is a
predicate rather than a class exporting `IsSimpleRing D`: the center field cannot be inferred
from `D`. -/
def IsQuaternionAlgebra (F : Type u) [Field F] (D : Type v) [Ring D] [Algebra F D] : Prop :=
  Algebra.IsCentral F D ∧ IsSimpleRing D ∧ Module.rank F D = 4

namespace IsQuaternionAlgebra

variable (F : Type u) [Field F] (D : Type v) [Ring D] [Algebra F D]

/-- A quaternion algebra is finite-dimensional over its center. -/
example (hD : IsQuaternionAlgebra F D) : Module.Finite F D := by
  exact FiniteDimensional.of_rank_eq_nat hD.2.2

/-- Its finite dimension is four. -/
example (hD : IsQuaternionAlgebra F D) : Module.finrank F D = 4 := by
  exact Module.finrank_eq_of_rank_eq hD.2.2

/-- The split matrix algebra is the first inhabitation test. -/
example : IsQuaternionAlgebra F (Matrix (Fin 2) (Fin 2) F) := by
  sorry

/-- Hamilton's quaternions are the ramified real inhabitation test. -/
example : IsQuaternionAlgebra ℝ (Quaternion ℝ) := by
  sorry

end IsQuaternionAlgebra

/-! ## Layer 1: local and adelic quaternionic groups -/

section Adeles

variable (F : Type u) [Field F] [NumberField F]
  (D : Type v) [Ring D] [Algebra F D]

/-- The scalar extension of `D` to the full adèle ring. Layer 1 compares this algebra with
the restricted product of the local scalar extensions. -/
abbrev QuaternionAdeleAlgebra := NumberField.AdeleRing (𝓞 F) F ⊗[F] D

/-- The finite-dimensional module topology on the adelic scalar extension. Layer 1 proves
that the induced ring topology is coordinate-independent. -/
@[reducible] noncomputable def quaternionAdeleTopology :
    TopologicalSpace (QuaternionAdeleAlgebra F D) :=
  moduleTopology (NumberField.AdeleRing (𝓞 F) F) (QuaternionAdeleAlgebra F D)

/-- With the module topology, the adelic scalar extension is a topological ring. -/
example (hD : IsQuaternionAlgebra F D) :
    letI : TopologicalSpace (QuaternionAdeleAlgebra F D) := quaternionAdeleTopology F D
    IsTopologicalRing (QuaternionAdeleAlgebra F D) := by
  sorry

/-- The algebraic units of the adelic scalar extension. The production topology on this group
is the restricted-product topology specified in `README.md`. -/
abbrev QuaternionAdeleMultiplicativeGroup := (QuaternionAdeleAlgebra F D)ˣ

/-- The scalar extension of `D` to the completion at a finite place. -/
abbrev QuaternionFiniteLocalAlgebra (v : HeightOneSpectrum (𝓞 F)) :=
  v.adicCompletion F ⊗[F] D

/-- Its finite-dimensional module topology. -/
@[reducible] noncomputable def quaternionFiniteLocalTopology
    (v : HeightOneSpectrum (𝓞 F)) : TopologicalSpace (QuaternionFiniteLocalAlgebra F D v) :=
  moduleTopology (v.adicCompletion F) (QuaternionFiniteLocalAlgebra F D v)

/-- Finite local quaternionic units are locally compact and totally disconnected. -/
example (hD : IsQuaternionAlgebra F D) (v : HeightOneSpectrum (𝓞 F)) :
    letI : TopologicalSpace (QuaternionFiniteLocalAlgebra F D v) :=
      quaternionFiniteLocalTopology F D v
    LocallyCompactSpace (QuaternionFiniteLocalAlgebra F D v)ˣ ∧
      TotallyDisconnectedSpace (QuaternionFiniteLocalAlgebra F D v)ˣ := by
  sorry

end Adeles

/-! ## Layer 4: the pinned weight-two good-place polynomial -/

/-- The good-place polynomial for a parallel-weight-two `PGL₁(D)` eigenpacket in the
classical `T_v` and arithmetic-Frobenius normalization. -/
noncomputable def weightTwoGoodHeckePolynomial
    {E : Type u} [Field E] (Nv : ℕ) (av : E) : E[X] :=
  X ^ 2 - C av * X + C (Nv : E)

/-- The constant eigenpacket regression: `a_v=N(v)+1` gives the roots `1` and `N(v)`. -/
example {E : Type u} [Field E] (Nv : ℕ) :
    weightTwoGoodHeckePolynomial (E := E) Nv (Nv + 1 : ℕ) =
      (X - C 1) * (X - C (Nv : E)) := by
  sorry

/-! ## Layer 5: two-dimensional Galois families -/

/-- A framed continuous two-dimensional Galois representation. Layer 5 also supplies the
basis-free formulation and proves the comparison after choosing a basis. -/
def TwoDimensionalGaloisRepresentation (K : Type u) [Field K]
    (A : Type v) [CommRing A] [TopologicalSpace A] [IsTopologicalRing A] :=
  Field.absoluteGaloisGroup K →ₜ* GL (Fin 2) A

/-- A two-dimensional `Q̄_p`-valued family indexed by primes and embeddings of its coefficient
field. Semisimplicity and good-place compatibility are genuine Layer 5 predicates added after
local inertia and Frobenius exist. -/
structure TwoDimensionalPadicGaloisFamily (K : Type u) [Field K]
    (E : Type v) [Field E] [NumberField E] where
  representation :
    ∀ (p : ℕ) [Fact p.Prime], (E →+* AlgebraicClosure ℚ_[p]) →
      TwoDimensionalGaloisRepresentation K (AlgebraicClosure ℚ_[p])

end TauCetiRoadmap.WeightTwoAutomorphicForms
