import Mathlib
import Mathlib.RepresentationTheory.Invariants

/-!
# Automorphic representations of `GL_n`, quaternionic inner forms, and attached Galois representations

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The statements here suggest Lean forms for particular milestones, so that
contributors and reviewers converge on names and signatures; discharging all of them
finishes neither a layer nor the roadmap. `sorry` is allowed in this human-owned roadmap
library.

Only targets expressible using the pinned Mathlib API appear here. The roadmap has a shared
automorphic track, a split `GL_n` track, a quaternionic track, and a Galois track; it does not make
arbitrary inner forms `GL_m(D)` a completion requirement. In particular, the attached-system
declaration is not represented by empty `Prop` placeholders: it will be added after
the genuine automorphic-representation, relative-cohomology, Hecke-rationality, and compatible-
system structures exist. See `README.md` for the dependency graph and exact target contract.
-/

namespace TauCetiRoadmap.AutomorphicRepresentations

open IsDedekindDomain NumberField Polynomial Representation
open scoped TensorProduct

universe u v w

/-! ## Layer 0: algebraic inputs -/

/-- A quaternion algebra is intrinsically a central simple algebra of rank four. This is a
predicate, not a class exporting `IsSimpleRing D`: Mathlib deliberately keeps the central and simple
hypotheses separate because the center field cannot be inferred from `D`. -/
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

/-! ## Layer 1: split and quaternionic local/adelic groups -/

section SplitGroups

variable (F : Type u) [Field F] [NumberField F]

/-- The algebraic `GL_n` over the full adèle ring. The production topology is compared with the
restricted product based at `GL_n(𝒪_v)`; this abbreviation alone does not assert that comparison. -/
abbrev SplitAdeleGroup (n : ℕ) := GL (Fin n) (NumberField.AdeleRing (𝓞 F) F)

/-- The split general linear group at a finite completion. -/
abbrev SplitFiniteLocalGroup (n : ℕ) (v : HeightOneSpectrum (𝓞 F)) :=
  GL (Fin n) (v.adicCompletion F)

end SplitGroups

section Adeles

variable (F : Type u) [Field F] [NumberField F]
  (D : Type v) [Ring D] [Algebra F D]

/-- The scalar extension of `D` to the full adèle ring. -/
abbrev QuaternionAdeleAlgebra := NumberField.AdeleRing (𝓞 F) F ⊗[F] D

/-- The finite-dimensional module topology on the adelic scalar extension. Layer 1 proves that the
resulting ring topology is independent of coordinates and compares its unit topology with the
idelic restricted product. -/
@[reducible] noncomputable def quaternionAdeleTopology :
    TopologicalSpace (QuaternionAdeleAlgebra F D) :=
  moduleTopology (NumberField.AdeleRing (𝓞 F) F) (QuaternionAdeleAlgebra F D)

/-- With the module topology, the adelic scalar extension is a topological ring. -/
example (hD : IsQuaternionAlgebra F D) :
    letI : TopologicalSpace (QuaternionAdeleAlgebra F D) := quaternionAdeleTopology F D
    IsTopologicalRing (QuaternionAdeleAlgebra F D) := by
  sorry

/-- The adelic points of `Dˣ`, algebraically constructed as units. The production topological group
must use the idelic restricted-product topology specified in `README.md`, not assume the subtype
topology inherited from the adèle algebra. -/
abbrev QuaternionAdeleGroup := (QuaternionAdeleAlgebra F D)ˣ

/-- The scalar extension of `D` to the completion at a finite place. -/
abbrev QuaternionFiniteLocalAlgebra (v : HeightOneSpectrum (𝓞 F)) :=
  v.adicCompletion F ⊗[F] D

/-- Its finite-dimensional module topology. -/
@[reducible] noncomputable def quaternionFiniteLocalTopology
    (v : HeightOneSpectrum (𝓞 F)) : TopologicalSpace (QuaternionFiniteLocalAlgebra F D v) :=
  moduleTopology (v.adicCompletion F) (QuaternionFiniteLocalAlgebra F D v)

/-- Finite local points of `Dˣ` are locally compact and totally disconnected. -/
example (hD : IsQuaternionAlgebra F D) (v : HeightOneSpectrum (𝓞 F)) :
    letI : TopologicalSpace (QuaternionFiniteLocalAlgebra F D v) :=
      quaternionFiniteLocalTopology F D v
    LocallyCompactSpace (QuaternionFiniteLocalAlgebra F D v)ˣ ∧
      TotallyDisconnectedSpace (QuaternionFiniteLocalAlgebra F D v)ˣ := by
  sorry

end Adeles

/-! ## Layer 2: smooth and admissible representations -/

/-- A subgroup bundled with proofs that it is compact and open. This should be reconciled with a
Mathlib bundled object if one is introduced. -/
structure CompactOpenSubgroup (G : Type u) [Group G] [TopologicalSpace G]
    extends OpenSubgroup G where
  isCompact_carrier : IsCompact (carrier : Set G)

section SmoothRepresentation

variable {k : Type u} [Field k] {G : Type v} [Group G] [TopologicalSpace G]
  {V : Type w} [AddCommGroup V] [Module k V]

/-- The vectors fixed by a subgroup, using Mathlib's invariant-submodule construction. -/
noncomputable def fixedVectors (ρ : Representation k G V) (K : Subgroup G) : Submodule k V :=
  Representation.invariants (ρ.comp K.subtype)

/-- Algebraic smoothness for a representation of a locally profinite group: every vector has an
open stabilizer. Later APIs should compare this with continuity for the discrete topology on `V`. -/
def IsSmooth (ρ : Representation k G V) : Prop :=
  ∀ x : V, ∃ K : OpenSubgroup G, x ∈ fixedVectors ρ K.toSubgroup

/-- Admissibility: every compact-open fixed-vector space is finite-dimensional. -/
def IsAdmissible (ρ : Representation k G V) : Prop :=
  ∀ K : CompactOpenSubgroup G,
    Module.Finite k (fixedVectors ρ K.toOpenSubgroup.toSubgroup)

end SmoothRepresentation

/-! ## Layer 6: the pinned good-place Hecke polynomial -/

/-- The good-place polynomial in the arithmetic-Frobenius, classical `T_v,S_v` normalization. -/
noncomputable def goodHeckePolynomial {E : Type u} [Field E] (Nv : ℕ) (av sv : E) : E[X] :=
  X ^ 2 - C av * X + C (Nv : E) * C sv

/-! ## Layers 7--8: the coefficient shape of a compatible family -/

/-- A framed continuous `d`-dimensional Galois representation. The topology on `GL_d(A)` is
Mathlib's matrix/unit topology; the basis-free module formulation and its equivalence are Layer 7
targets. -/
def FramedGaloisRepresentation (K : Type u) [Field K]
    (A : Type v) [CommRing A] [TopologicalSpace A] (d : ℕ) :=
  Field.absoluteGaloisGroup K →ₜ* GL (Fin d) A

/-- A `d`-dimensional `Q̄_p`-valued family indexed by primes and embeddings of its rationality
field. Good-place compatibility is added only after Layer 7 supplies local Frobenius and inertia. -/
def PadicGaloisFamily (K : Type u) [Field K]
    (E : Type v) [Field E] [NumberField E] (d : ℕ) : Type _ :=
  ∀ (p : ℕ) [Fact p.Prime], (E →+* AlgebraicClosure ℚ_[p]) →
    FramedGaloisRepresentation K (AlgebraicClosure ℚ_[p]) d

end TauCetiRoadmap.AutomorphicRepresentations
