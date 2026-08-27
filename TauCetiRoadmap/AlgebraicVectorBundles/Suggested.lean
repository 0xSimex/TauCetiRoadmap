import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Functor
import Mathlib.RingTheory.Grassmannian
import TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf.Basic

/-!
# Algebraic vector bundles and characteristic classes: proposed definitions + target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is `README.md`.
The statements here suggest Lean forms for particular milestones, so that contributors and reviewers
converge on names and signatures; discharging all of them finishes neither a layer nor the roadmap.

The narrative roadmap (Mathlib substrate, definitions, generality bar, conventions, Layers L0--L5,
worked instances, and sibling relations) is in `README.md`.

At the pinned revisions Mathlib can already express the finite-locally-free sheaf stratum and its
affine finite-projective model. The later milestone types depend on infrastructure built by earlier
layers: quasi-coherent algebras and relative Spec (L1), graded and geometric vector bundles (L2),
relative projective/Grassmann/flag bundles (L3), and operational Chow groups (L4). Following the
honest-`sorry` rule, those signatures enter this file once their types exist; they are stated
unambiguously in `README.md` now rather than encoded by empty `Prop` fields.

The imports pin the existing APIs consumed immediately:

* `SheafOfModules.IsQuasicoherent`, `IsFinitePresentation`, `IsLocallyFree`, and
  `AlgebraicGeometry.tildeEquiv`;
* `AlgebraicGeometry.ProjectiveSpectrum`;
* `Module.Grassmannian.functor`;
* Tau Ceti's `InvertibleSheaf` and `FinitelyPresentedSheaf` packaging.
-/

namespace TauCetiRoadmap.AlgebraicVectorBundles

open CategoryTheory

universe u v

/-! ## L0: finite locally free sheaves -/

variable (X : Scheme.{u})

/-- The finite locally free stratum inside `X.Modules`.

Mathlib's `IsLocallyFree` permits infinite local bases. Intersecting it with finite presentation is
the base-change-stable finite-rank condition used by the roadmap; L0 proves its equivalent stalkwise,
affine finite-projective, finitely-presented-flat, and dualizable formulations. -/
def isFiniteLocallyFree : ObjectProperty X.Modules :=
  fun E => E.IsLocallyFree ∧ E.IsFinitePresentation

/-- Finite locally free sheaves on a scheme, with the morphisms already used by `X.Modules`. -/
abbrev FiniteLocallyFreeSheaf :=
  (isFiniteLocallyFree X).FullSubcategory

variable {X}

/-- A finite locally free sheaf is quasi-coherent. This sanity check makes the inclusion
`FinLocFree(X) → QCoh(X)` explicit at the existing API level. -/
example (E : FiniteLocallyFreeSheaf X) : E.obj.IsQuasicoherent := by
  letI : E.obj.IsLocallyFree := E.property.1
  infer_instance

section AffineModel

variable (R : Type u) [CommRing R]
variable (M : Type v) [AddCommGroup M] [Module R M]

/-- **L0 affine milestone:** finite projective modules are reflexive. The scheme-level theorem is
the corresponding double-dual isomorphism for finite locally free sheaves, compatible with
`AlgebraicGeometry.tildeEquiv` and pullback. -/
example [Module.Finite R M] [Module.Projective R M] :
    Nonempty (M ≃ₗ[R] ((M →ₗ[R] R) →ₗ[R] R)) := by
  sorry

end AffineModel

/-!
## Later target shapes

These become compiled `sorry`-goals when the preceding layers have introduced their types.

* **L1:** the relative-spectrum functor is an equivalence
  `QCAlg(X)ᵒᵖ ≌ AffSchOver(X)`, natural under base change.
* **L2:** `linearSpec` gives `QCoh(X)ᵒᵖ ≌ GradedVectorBundle(X)`; after restricting to finite
  locally free objects and dualizing, `totalSpace` gives
  `FiniteLocallyFreeSheaf(X) ≌ GeometricVectorBundle(X)`.
* **L3:** the scheme `Gr_X(r,E)` represents `Module.Grassmannian.functor` and carries the
  universal finite locally free quotient.
* **L4:** pullback and powers of `c₁(O(1))` give the projective bundle formula on Chow groups.
* **L5:** Chern operations satisfy normalization, pullback naturality, Whitney sum, and the splitting
  principle, and factor through the L2 equivalence.

The precise universal properties, grading shifts, signs, hypotheses, and companion API are the
corresponding layer specifications in `README.md`.
-/

end TauCetiRoadmap.AlgebraicVectorBundles
