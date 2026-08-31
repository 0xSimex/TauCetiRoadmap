import Mathlib.AlgebraicGeometry.AffineSpace
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.AlgebraicGeometry.Morphisms.Affine
import Mathlib.CategoryTheory.EssentialImage
import Mathlib.CategoryTheory.Monoidal.CommMon_
import Mathlib.CategoryTheory.Monoidal.Rigid.Basic
import Mathlib.Topology.LocallyConstant.Basic
import TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf.Basic

/-!
# Algebraic vector bundles: proposed definitions and target signatures

`README.md` is the definitive roadmap. The declarations below record representative definitions
for the three layers and their principal universal properties. Each `sorry` marks a theorem or
construction targeted by the roadmap.

The types which already exist at the repository pins are used directly: `Scheme.Modules`, the
quasi-coherent/finite-presentation/locally-free predicates, `tildeEquiv`, affine morphisms,
`InvertibleSheaf`, and `FinitelyPresentedSheaf`. The roadmap adds the monoidal structure,
relative Spec, and total-space functors on top of these pinned APIs.
-/

namespace TauCetiRoadmap.AlgebraicVectorBundles

open CategoryTheory AlgebraicGeometry Opposite
open scoped MonoidalCategory

universe u v

/-! ## L0: finite locally free sheaves and monoidal algebra -/

/-- Quasi-coherent sheaves on `X`, using Mathlib's existing object property. -/
abbrev QuasicoherentSheaf (X : Scheme.{u}) :=
  (SheafOfModules.isQuasicoherent X.ringCatSheaf).FullSubcategory

/-- The finite locally free stratum at the current API boundary.

Finite presentation refines `IsLocallyFree` to finite local rank and supplies the base-change
stability used throughout the roadmap. -/
def isFiniteLocallyFree (X : Scheme.{u}) : ObjectProperty X.Modules :=
  fun E => E.IsLocallyFree ∧ E.IsFinitePresentation

/-- Finite locally free sheaves on a scheme. -/
abbrev FiniteLocallyFreeSheaf (X : Scheme.{u}) :=
  (isFiniteLocallyFree X).FullSubcategory

/-- Transport finite local freeness across an isomorphism, extending Tau Ceti's rank-one API. -/
noncomputable instance (X : Scheme.{u}) :
    (isFiniteLocallyFree X).IsClosedUnderIsomorphisms := by
  sorry

namespace FiniteLocallyFreeSheaf

variable {X : Scheme.{u}}

instance (E : FiniteLocallyFreeSheaf X) : E.obj.IsLocallyFree := E.property.1

instance (E : FiniteLocallyFreeSheaf X) : E.obj.IsFinitePresentation := E.property.2

/-- A finite locally free sheaf is quasi-coherent, through Mathlib's existing instance. -/
example (E : FiniteLocallyFreeSheaf X) : E.obj.IsQuasicoherent := by
  sorry

end FiniteLocallyFreeSheaf

/-- The fully faithful inclusion into quasi-coherent sheaves. -/
abbrev finiteLocallyFreeToQuasicoherent (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ QuasicoherentSheaf X := by
  sorry

/-- The fully faithful inclusion into Tau Ceti's finitely presented sheaves. -/
abbrev finiteLocallyFreeToFinitelyPresented (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf X :=
  ObjectProperty.ιOfLE fun _ hE => hE.2

/-- Tau Ceti's invertible sheaves form the rank-one input to the general theory. -/
noncomputable def invertibleToFiniteLocallyFree (X : Scheme.{u}) :
    TauCeti.AlgebraicGeometry.InvertibleSheaf X ⥤ FiniteLocallyFreeSheaf X := by
  sorry

/-- The finite rank of a finite locally free sheaf at a point. L0 constructs it from a finite local
basis and proves independence from every choice. -/
noncomputable def rank {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) (x : X) : ℕ := by
  sorry

/-- The rank is locally constant; fixed-rank APIs use `HasConstantRank` below. -/
example {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) :
    IsLocallyConstant (rank E) := by
  sorry

/-- Constant-rank hypotheses record the common rank across all connected components. -/
def HasConstantRank {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) (r : ℕ) : Prop :=
  ∀ x, rank E x = r

/-- Pullback preserves finite local freeness. This target should reuse the API of
mathlib4#39989 if it lands. -/
noncomputable def pullback {X Y : Scheme.{u}} (f : Y ⟶ X) :
    FiniteLocallyFreeSheaf X ⥤ FiniteLocallyFreeSheaf Y := by
  sorry

/-- The proposed pullback functor has Mathlib's `Scheme.Modules.pullback` as underlying functor. -/
noncomputable def pullbackObjIso {X Y : Scheme.{u}} (f : Y ⟶ X)
    (E : FiniteLocallyFreeSheaf X) :
    ((pullback f).obj E).obj ≅ (Scheme.Modules.pullback f).obj E.obj := by
  sorry

/-- Identity coherence for finite-locally-free pullback. -/
example (X : Scheme.{u}) : pullback (𝟙 X) ≅ 𝟭 (FiniteLocallyFreeSheaf X) := by
  sorry

/-- Composition coherence for finite-locally-free pullback. -/
example {X Y Z : Scheme.{u}} (f : Y ⟶ X) (g : Z ⟶ Y) :
    pullback (g ≫ f) ≅ pullback f ⋙ pullback g := by
  sorry

/-- Finite projective modules, the affine model for finite locally free sheaves. -/
def isFiniteProjectiveModule (R : Type u) [CommRing R] : ObjectProperty (ModuleCat.{u} R) :=
  fun M => Module.Finite R M ∧ Module.Projective R M

abbrev FiniteProjectiveModule (R : Type u) [CommRing R] :=
  (isFiniteProjectiveModule R).FullSubcategory

/-- **Affine L0 target:** the restriction of `tildeEquiv` to finite projective modules. -/
noncomputable def tildeFiniteProjectiveEquiv (R : Type u) [CommRing R] :
    FiniteProjectiveModule R ≌ FiniteLocallyFreeSheaf (Spec (.of R)) := by
  sorry

/-!
The next two instances specify the L0 monoidal structures. The tensor unit is `O_X`, tensor is the
sheaf tensor product, and the symmetry and coherence maps satisfy the restriction and pullback
properties in `README.md`.
-/

@[instance_reducible]
noncomputable def modulesMonoidalCategory (X : Scheme.{u}) : MonoidalCategory X.Modules := by
  sorry

attribute [local instance] modulesMonoidalCategory

@[instance_reducible]
noncomputable def modulesSymmetricCategory (X : Scheme.{u}) : SymmetricCategory X.Modules := by
  sorry

attribute [local instance] modulesSymmetricCategory

/-- The tensor unit supplied by L0 agrees with the existing structure sheaf as a module. -/
noncomputable def tensorUnitIso (X : Scheme.{u}) :
    𝟙_ X.Modules ≅ SheafOfModules.unit X.ringCatSheaf := by
  sorry

/-- Internal Hom for sheaves of modules. -/
noncomputable def internalHom (X : Scheme.{u}) :
    X.Modulesᵒᵖ ⥤ X.Modules ⥤ X.Modules := by
  sorry

/-- Tensor product restricts to finite locally free sheaves. -/
noncomputable def tensorFiniteLocallyFree (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X × FiniteLocallyFreeSheaf X ⥤ FiniteLocallyFreeSheaf X := by
  sorry

/-- Dualization on finite locally free sheaves. -/
noncomputable def dual (X : Scheme.{u}) :
    (FiniteLocallyFreeSheaf X)ᵒᵖ ⥤ FiniteLocallyFreeSheaf X := by
  sorry

/-- The canonical double-dual isomorphism. -/
noncomputable def doubleDualIso {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) :
    E ≅ (dual X).obj (op ((dual X).obj (op E))) := by
  sorry

/-- Symmetric powers preserve finite local freeness. -/
noncomputable def symmetricPower (X : Scheme.{u}) (n : ℕ) :
    FiniteLocallyFreeSheaf X ⥤ FiniteLocallyFreeSheaf X := by
  sorry

/-- Exterior powers preserve finite local freeness. -/
noncomputable def exteriorPower (X : Scheme.{u}) (n : ℕ) :
    FiniteLocallyFreeSheaf X ⥤ FiniteLocallyFreeSheaf X := by
  sorry

/-- The determinant of a finite locally free sheaf, with locally constant rank. -/
noncomputable def determinant (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ TauCeti.AlgebraicGeometry.InvertibleSheaf X := by
  sorry

/-- The symmetric monoidal structure restricts from modules to quasi-coherent modules. -/
@[instance_reducible]
noncomputable def quasicoherentMonoidalCategory (X : Scheme.{u}) :
    MonoidalCategory (QuasicoherentSheaf X) := by
  sorry

attribute [local instance] quasicoherentMonoidalCategory

/-- **L0 milestone:** the dualizable quasi-coherent objects are exactly the finite locally free
ones. `HasLeftDual` contains evaluation, coevaluation, and both triangle identities. -/
example {X : Scheme.{u}} (E : QuasicoherentSheaf X) :
    (∃ E' : FiniteLocallyFreeSheaf X, Nonempty (E'.obj ≅ E.obj)) ↔
      Nonempty (HasLeftDual E) := by
  sorry

/-! ## L1: relative Spec and affine schemes over a base -/

/-- Quasi-coherent commutative algebras, using the L0 symmetric monoidal structure. -/
def isQuasicoherentAlgebra (X : Scheme.{u}) : ObjectProperty (CommMon X.Modules) :=
  fun A => A.X.IsQuasicoherent

abbrev QuasicoherentAlgebra (X : Scheme.{u}) :=
  (isQuasicoherentAlgebra X).FullSubcategory

/-- The property of an `X`-scheme that its structure morphism is affine. -/
def isAffineSchemeOver (X : Scheme.{u}) : ObjectProperty (Over X) :=
  fun T => IsAffineHom T.hom

/-- Schemes affine over `X`. -/
abbrev AffineSchemeOver (X : Scheme.{u}) :=
  (isAffineSchemeOver X).FullSubcategory

/-- The forgetful functor from affine `X`-schemes to all `X`-schemes. -/
abbrev affineSchemeOverForget (X : Scheme.{u}) : AffineSchemeOver X ⥤ Over X :=
  ObjectProperty.ι (isAffineSchemeOver X)

/-- **L1 milestone:** quasi-coherent algebras are anti-equivalent to affine schemes over `X`. -/
noncomputable def relativeSpecEquiv (X : Scheme.{u}) :
    (QuasicoherentAlgebra X)ᵒᵖ ≌ AffineSchemeOver X := by
  sorry

/-! ## L2: the two vector-bundle equivalences -/

/-- The symmetric algebra functor on quasi-coherent sheaves. -/
noncomputable def symmetricAlgebra (X : Scheme.{u}) :
    QuasicoherentSheaf X ⥤ QuasicoherentAlgebra X := by
  sorry

/-- `F ↦ Spec_X(Sym(F))`, contravariant in `F`. -/
noncomputable def linearSpec (X : Scheme.{u}) :
    (QuasicoherentSheaf X)ᵒᵖ ⥤ AffineSchemeOver X :=
  (symmetricAlgebra X).op ⋙ (relativeSpecEquiv X).functor

/-- A concrete first model for graded vector bundles. L2 must additionally prove that this
essential image agrees with the intrinsic grading definition in `README.md`. -/
abbrev GradedVectorBundle (X : Scheme.{u}) :=
  (linearSpec X).EssImageSubcategory

/-- **First L2 milestone:** the degree-one and linear-Spec functors are quasi-inverse. -/
noncomputable def linearSpecEquiv (X : Scheme.{u}) :
    (QuasicoherentSheaf X)ᵒᵖ ≌ GradedVectorBundle X := by
  sorry

/-- `E ↦ Spec_X(Sym(Eᵛ))`, covariant after dualization. -/
noncomputable def totalSpace (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ AffineSchemeOver X := by
  sorry

/-- Geometric finite vector bundles, initially modeled as the essential image of `totalSpace`.
L2 identifies this with the intrinsic locally-linear affine-space definition. -/
abbrev GeometricVectorBundle (X : Scheme.{u}) :=
  (totalSpace X).EssImageSubcategory

/-- **Second L2 milestone:** finite locally free sheaves and geometric vector bundles agree. -/
noncomputable def totalSpaceEquiv (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ≌ GeometricVectorBundle X := by
  sorry

/-- **Section-valued universal property.** A section of a sheaf `M` is expressed categorically as
`O_T ⟶ M`. -/
noncomputable def totalSpaceHomEquiv {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X)
    (T : Over X) :
    (T ⟶ (affineSchemeOverForget X).obj ((totalSpace X).obj E)) ≃
      (SheafOfModules.unit T.left.ringCatSheaf ⟶
        (Scheme.Modules.pullback T.hom).obj E.obj) := by
  sorry

end TauCetiRoadmap.AlgebraicVectorBundles
