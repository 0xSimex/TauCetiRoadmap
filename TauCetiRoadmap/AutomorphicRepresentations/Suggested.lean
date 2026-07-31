import Mathlib
import Mathlib.RepresentationTheory.Invariants

/-!
# Quaternionic automorphic representations and attached Galois representations: target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The statements here suggest Lean forms for particular milestones, so that
contributors and reviewers converge on names and signatures; discharging all of them
finishes neither a layer nor the roadmap. `sorry` is allowed in this human-owned roadmap
library.

Only targets expressible using the pinned Mathlib API appear here. In particular, the summit
attached-system declaration is not represented by empty `Prop` placeholders: it will be added after
the genuine automorphic-representation, relative-cohomology, Hecke-rationality, and compatible-
system structures exist. See `README.md` for the dependency graph and exact summit contract.
-/

namespace TauCetiRoadmap.AutomorphicRepresentations

open IsDedekindDomain NumberField Polynomial Representation
open scoped TensorProduct

universe u v w

/-! ## Layer 0: quaternion algebras -/

/-- A quaternion algebra is intrinsically a central simple algebra of rank four.
The production declaration should ultimately live in Tau Ceti or Mathlib, not this namespace. -/
class IsQuaternionAlgebra (F : Type u) [Field F] (D : Type v) [Ring D] [Algebra F D] : Prop where
  isSimpleRing : IsSimpleRing D
  isCentral : Algebra.IsCentral F D
  rank_eq_four : Module.rank F D = 4

namespace IsQuaternionAlgebra

variable (F : Type u) [Field F] (D : Type v) [Ring D] [Algebra F D]
  [IsQuaternionAlgebra F D]

attribute [instance low] isSimpleRing isCentral

/-- A quaternion algebra is finite-dimensional over its center. -/
example : Module.Finite F D := by
  exact FiniteDimensional.of_rank_eq_nat rank_eq_four

/-- Its finite dimension is four. -/
example : Module.finrank F D = 4 := by
  exact Module.finrank_eq_of_rank_eq rank_eq_four

end IsQuaternionAlgebra

/-! ## Layer 1: the concrete adelic group -/

section Adeles

variable (F : Type u) [Field F] [NumberField F]
  (D : Type v) [Ring D] [Algebra F D]

/-- The scalar extension of `D` to the full adèle ring. -/
abbrev QuaternionAdeleAlgebra := NumberField.AdeleRing (𝓞 F) F ⊗[F] D

/-- The adelic points of `Dˣ`, algebraically constructed as units. The production topological group
must use the idelic restricted-product topology specified in `README.md`, not assume the subtype
topology inherited from the adèle algebra. -/
abbrev QuaternionAdeleGroup := (QuaternionAdeleAlgebra F D)ˣ

end Adeles

/-! ## Layer 2: smooth and admissible representations -/

/-- A subgroup bundled with proofs that it is compact and open. This should be reconciled with a
Mathlib bundled object if one is introduced. -/
structure CompactOpenSubgroup (G : Type u) [Group G] [TopologicalSpace G]
    extends Subgroup G where
  isCompact_carrier : IsCompact (carrier : Set G)
  isOpen_carrier : IsOpen (carrier : Set G)

section SmoothRepresentation

variable (k : Type u) [Field k] (G : Type v) [Group G] [TopologicalSpace G]
  (V : Type w) [AddCommGroup V] [Module k V]

/-- The vectors fixed by a subgroup, using Mathlib's invariant-submodule construction. -/
noncomputable def fixedVectors (ρ : Representation k G V) (K : Subgroup G) : Submodule k V :=
  Representation.invariants (ρ.comp K.subtype)

/-- Algebraic smoothness for a representation of a locally profinite group: every vector has an
open stabilizer. Later APIs should compare this with continuity for the discrete topology on `V`. -/
def IsSmooth (ρ : Representation k G V) : Prop :=
  ∀ x : V, ∃ K : Subgroup G, IsOpen (K : Set G) ∧ x ∈ fixedVectors k G V ρ K

/-- Admissibility: every compact-open fixed-vector space is finite-dimensional. -/
def IsAdmissible (ρ : Representation k G V) : Prop :=
  ∀ K : CompactOpenSubgroup G, Module.Finite k (fixedVectors k G V ρ K.toSubgroup)

end SmoothRepresentation

/-! ## Layer 6: the pinned good-place Hecke polynomial -/

/-- The good-place polynomial in the arithmetic-Frobenius, classical `T_v,S_v` normalization. -/
noncomputable def goodHeckePolynomial {E : Type u} [Field E] (Nv : ℕ) (av sv : E) : E[X] :=
  X ^ 2 - C av * X + C (Nv : E) * C sv

/-! ## Layers 7--8: the coefficient shape of a compatible family -/

/-- A continuous linear Galois representation, using the module topology on endomorphisms.
Local restriction, unramifiedness, and Frobenius are Layer 7 targets. -/
def GaloisRepresentation (K : Type u) [Field K]
    (A : Type v) [CommRing A] [TopologicalSpace A]
    (M : Type w) [AddCommGroup M] [Module A M] :=
  letI := moduleTopology A (Module.End A M)
  Field.absoluteGaloisGroup K →ₜ* Module.End A M

/-- A `d`-dimensional `Q̄_p`-valued family indexed by primes and embeddings of its rationality
field. Weak compatibility is added only after Layer 7 supplies local Frobenius and inertia. -/
def PadicGaloisFamily (K : Type u) [Field K]
    (E : Type v) [Field E] [NumberField E] (d : ℕ) : Type _ :=
  ∀ {p : ℕ} (_ : Fact p.Prime) (_φ : E →+* AlgebraicClosure ℚ_[p]),
    GaloisRepresentation K (AlgebraicClosure ℚ_[p])
      (Fin d → AlgebraicClosure ℚ_[p])

end TauCetiRoadmap.AutomorphicRepresentations
