import Mathlib.AlgebraicGeometry.AffineSpace
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.AlgebraicGeometry.Morphisms.Affine
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Functor
import Mathlib.CategoryTheory.EssentialImage
import Mathlib.CategoryTheory.Monoidal.CommMon_
import Mathlib.CategoryTheory.Monoidal.Rigid.Basic
import Mathlib.RingTheory.Grassmannian
import TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf.Basic

/-!
# Algebraic vector bundles: proposed definitions and target signatures

`README.md` is the definitive roadmap. The declarations below record representative definitions
for the four layers and their principal universal properties. Each `sorry` marks a theorem or
construction targeted by the roadmap.

The types which already exist at the repository pins are used directly: `Scheme.Modules`, the
quasi-coherent/finite-presentation/locally-free predicates, `tildeEquiv`, affine morphisms,
`ProjectiveSpectrum`, `Module.Grassmannian.functor`, `InvertibleSheaf`, and
`FinitelyPresentedSheaf`. The roadmap adds the monoidal structure, relative Spec, total-space functors, and classifying
schemes on top of these pinned APIs.
-/

namespace TauCetiRoadmap.AlgebraicVectorBundles

open CategoryTheory AlgebraicGeometry Opposite

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
example (E : FiniteLocallyFreeSheaf X) : E.obj.IsQuasicoherent := by infer_instance

end FiniteLocallyFreeSheaf

/-- The fully faithful inclusion into quasi-coherent sheaves. -/
abbrev finiteLocallyFreeToQuasicoherent (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ QuasicoherentSheaf X :=
  ObjectProperty.ιOfLE fun E hE => by
    letI : E.IsLocallyFree := hE.1
    infer_instance

/-- The fully faithful inclusion into Tau Ceti's finitely presented sheaves. -/
abbrev finiteLocallyFreeToFinitelyPresented (X : Scheme.{u}) :
    FiniteLocallyFreeSheaf X ⥤ TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf X :=
  ObjectProperty.ιOfLE fun _ hE => hE.2

/-- Tau Ceti's invertible sheaves form the rank-one input to the general theory. -/
noncomputable def invertibleToFiniteLocallyFree (X : Scheme.{u}) :
    TauCeti.AlgebraicGeometry.InvertibleSheaf X ⥤ FiniteLocallyFreeSheaf X := by
  apply ObjectProperty.ιOfLE
  intro E hE
  letI : TauCeti.SheafOfModules.IsInvertible (R := X.ringCatSheaf) E := hE
  exact ⟨inferInstance,
    TauCeti.SheafOfModules.IsInvertible.isFinitePresentation (M := E)⟩

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

noncomputable def modulesMonoidalCategory (X : Scheme.{u}) : MonoidalCategory X.Modules := by
  sorry

attribute [local instance] modulesMonoidalCategory

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

/-- Schemes affine over `X`, expressed with Mathlib's existing morphism property. -/
abbrev AffineSchemeOver (X : Scheme.{u}) :=
  MorphismProperty.Over @IsAffineHom ⊤ X

/-- The forgetful functor from affine `X`-schemes to all `X`-schemes. -/
abbrev affineSchemeOverForget (X : Scheme.{u}) : AffineSchemeOver X ⥤ Over X :=
  MorphismProperty.Over.forget @IsAffineHom ⊤ X

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

/-! ## L3: projective, Grassmann, and flag bundles -/

/-- The projective bundle in the quotient convention. -/
noncomputable def projectiveBundle {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) :
    Over X := by
  sorry

/-- The tautological quotient line `O(1)` on `P(E)`. -/
noncomputable def projectiveOOne {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) :
    TauCeti.AlgebraicGeometry.InvertibleSheaf (projectiveBundle E).left := by
  sorry

/-- The tautological quotient `p^*E ⟶ O(1)`. -/
noncomputable def projectiveTautologicalQuotient {X : Scheme.{u}}
    (E : FiniteLocallyFreeSheaf X) :
    (Scheme.Modules.pullback (projectiveBundle E).hom).obj E.obj ⟶
      (projectiveOOne E).obj := by
  sorry

/-- The tautological map is an epimorphism of sheaves. -/
example {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X) :
    Epi (projectiveTautologicalQuotient E) := by
  sorry

/-- The relative Grassmannian of rank-`r` quotients. -/
noncomputable def grassmannBundle {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X)
    (r : ℕ) : Over X := by
  sorry

/-- A quotient family classified by `Gr_X(r,E)`. -/
structure QuotientFamily {X : Scheme.{u}} (T : Over X)
    (E : FiniteLocallyFreeSheaf X) (r : ℕ) where
  quotient : FiniteLocallyFreeSheaf T.left
  map : (Scheme.Modules.pullback T.hom).obj E.obj ⟶ quotient.obj
  map_epi : Epi map
  rank_eq : HasConstantRank quotient r

/-- Two quotient families are equivalent when their quotient sheaves are compatibly isomorphic. -/
def QuotientFamily.Rel {X : Scheme.{u}} {T : Over X}
    {E : FiniteLocallyFreeSheaf X} {r : ℕ}
    (A B : QuotientFamily T E r) : Prop :=
  ∃ e : A.quotient ≅ B.quotient, A.map ≫ e.hom.hom = B.map

/-- The compatible-isomorphism relation is an equivalence relation. -/
noncomputable instance quotientFamilySetoid {X : Scheme.{u}} {T : Over X}
    {E : FiniteLocallyFreeSheaf X} {r : ℕ} : Setoid (QuotientFamily T E r) := by
  refine ⟨QuotientFamily.Rel, ?_⟩
  sorry

/-- Isomorphism classes of quotient families, the set represented by the Grassmannian. -/
abbrev QuotientFamilyIsoClass {X : Scheme.{u}} (T : Over X)
    (E : FiniteLocallyFreeSheaf X) (r : ℕ) :=
  Quotient (quotientFamilySetoid (T := T) (E := E) (r := r))

/-- **L3 milestone:** the Grassmannian represents rank-`r` finite locally free quotients. -/
noncomputable def grassmannHomEquiv {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X)
    (r : ℕ) (T : Over X) :
    (T ⟶ grassmannBundle E r) ≃ QuotientFamilyIsoClass T E r := by
  sorry

/-- Projective bundles are the rank-one Grassmannians. -/
noncomputable def projectiveIsoGrassmannOne {X : Scheme.{u}}
    (E : FiniteLocallyFreeSheaf X) :
    projectiveBundle E ≅ grassmannBundle E 1 := by
  sorry

/-- The full flag bundle of a constant-rank vector bundle, with the rank hypothesis recorded
explicitly over an arbitrary base. -/
noncomputable def fullFlagBundle {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X)
    (r : ℕ) (hr : HasConstantRank E r) : Over X := by
  sorry

/-- The universal successive quotient lines on the full flag bundle. -/
noncomputable def fullFlagQuotientLine {X : Scheme.{u}} (E : FiniteLocallyFreeSheaf X)
    (r : ℕ) (hr : HasConstantRank E r) (i : Fin r) :
    TauCeti.AlgebraicGeometry.InvertibleSheaf (fullFlagBundle E r hr).left := by
  sorry

end TauCetiRoadmap.AlgebraicVectorBundles
