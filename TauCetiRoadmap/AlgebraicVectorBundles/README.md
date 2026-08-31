# Roadmap: algebraic vector bundles

This roadmap builds a single coherent theory of **algebraic vector bundles over schemes**. Its
summit is the equivalence between the sheaf-theoretic and geometric presentations of a vector
bundle:

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X),
\qquad
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X).
```

The first equivalence is the Stacks/EGA correspondence between quasi-coherent modules and affine
linear schemes. The second restricts to finite locally free modules and dualizes. The resulting geometric total
space represents sections, while the first construction represents linear functionals. The equivalences are
categorical: they include morphisms, units and counits, base change, and the standard algebra of
bundles. `Suggested.lean` records representative definitions and milestone signatures;
this `README.md` is the definitive specification.

The final section records the successor chain through classifying bundles, Chow groups and
characteristic classes, and cohomological realization.

Suggested library home: `TauCeti/AlgebraicGeometry/VectorBundle/`, with the relative affine
geometry under `TauCeti/AlgebraicGeometry/RelativeSpec/`.

## Pinned inventory

This inventory uses the exact repository pins:

- Mathlib [`05ae010`](https://github.com/leanprover-community/mathlib4/commit/05ae0103f49b1ad1248f6039bbbad43d8aeb52a9);
- Tau Ceti [`e8af08d`](https://github.com/TauCetiProject/TauCeti/commit/e8af08d0aeda4012832880bd56edfc88af061691).

### What Mathlib already supplies

- `Scheme.Modules` is the abelian category of modules over a scheme's structure sheaf. It has all
  limits and colimits used below, as well as `Scheme.Modules.pullback`, the
  pullback--pushforward adjunction, and identity/composition isomorphisms for pullback.
- `SheafOfModules.IsQuasicoherent`, `IsFinitePresentation`, and `IsLocallyFree` are already present.
  `IsFinitePresentation` implies quasi-coherence and finite type. `IsLocallyFree` is expressed by
  local free presentations and also implies quasi-coherence, but its indexing types may be infinite
  and may vary from chart to chart.
- `AlgebraicGeometry.tilde` and `AlgebraicGeometry.tildeEquiv` give

  ```math
  R\text{-}\mathsf{Mod}
  \simeq
  \mathsf{QCoh}(\operatorname{Spec} R).
  ```

  This is the affine comparison on which the scheme-level descent proofs must be based.
- At the ring/module level Mathlib has tensor products, linear duals, symmetric and exterior
  algebras, `ModuleCat.exteriorPower.functor`, finite projective modules, localization, and stalks.
  L0 lifts these constructions to a monoidal theory of sheaves of modules.
- Mathlib has affine schemes and morphisms, pullbacks, open immersions, gluing,
  `AlgebraicGeometry.IsAffineHom`, and `Scheme.Spec`. L1 develops relative `Spec_X` for
  quasi-coherent sheaf algebras from this affine substrate.

### What Tau Ceti already supplies

- `TauCeti.AlgebraicGeometry.InvertibleSheaf X` packages rank-one locally free sheaves and provides
  free and trivial examples.
- `TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf X` packages finite presentation, with a fully
  faithful inclusion `InvertibleSheaf.toFinitelyPresented`.
- The line-bundle source identifies a monoidal structure on sheaves of modules as the foundation
  for tensor products and the Picard group. L0 supplies the corresponding tensor/dual API.
- Tau Ceti's anti-equivalence between commutative Hopf algebras and affine group schemes over an
  affine base is useful implementation precedent for essential-image categories and base change.

The roadmap begins at this boundary by constructing general algebraic vector bundles, their
geometric total spaces, and the sheaf/geometric equivalence.

### Active Mathlib work to coordinate with

These pull requests describe compatible interfaces under active development. The Tau Ceti
implementation should follow their theorem shapes and naming so that the corresponding Mathlib
results can be adopted directly when they land.

| Pull request | Relevance and coordination rule |
| --- | --- |
| [mathlib4#27098](https://github.com/leanprover-community/mathlib4/pull/27098) | An earlier `VectorBundleData` proposal. Reconcile the finite-locally-free wrapper with that discussion and the current `IsLocallyFree` API. |
| [mathlib4#39553](https://github.com/leanprover-community/mathlib4/pull/39553) | Proves that `IsLocallyFree` is local. L0 should match its theorem shape and use the Mathlib result directly once available. |
| [mathlib4#39989](https://github.com/leanprover-community/mathlib4/pull/39989) | Proves pullback preserves quasi-coherent and locally free sheaves. Its pullback--restriction isomorphism and naming should shape L0. |
| [mathlib4#40194](https://github.com/leanprover-community/mathlib4/pull/40194) | Develops locally free sheaves on `Spec R` and their affine comparison. L0 should use this affine API as the basis for the finite-projective equivalence. |

## Definitions and pinned conventions

### The sheaf strata

The following conditions form the sheaf-theoretic hierarchy used by the roadmap:

| Condition | Role here |
| --- | --- |
| quasi-coherent | arbitrary degree-one datum for an affine linear scheme |
| finite presentation | base-change-stable finiteness condition |
| finite locally free | dualizable quasi-coherent objects and finite geometric bundles |
| invertible | constant rank one, agreeing with Tau Ceti's existing object |

Define a finite locally free sheaf at the present API boundary by

```math
\operatorname{IsFiniteLocallyFree}(\mathcal E)
\;:\!\!\Longleftrightarrow\;
\mathcal E\text{ is locally free and finitely presented}.
```

L0 proves that this is equivalent to being locally free on a Zariski cover with finite bases, to
being finitely presented and flat, to having finite-projective affine modules, and to being
dualizable in `QCoh(X)`. Its rank is a locally constant function `X \to \mathbb N`; fixed-rank
theorems carry an explicit hypothesis `rank(E)=r`, allowing arbitrary base schemes.

### Two related total-space constructions

For a quasi-coherent module `F`, follow Stacks Project §27.6 and define

```math
\mathbf V_{\mathrm{lin}}(\mathcal F)
=
\operatorname{Spec}_X
\operatorname{Sym}_{\mathcal O_X}(\mathcal F).
```

It is contravariant in `F` and represents linear functionals:

```math
\operatorname{Hom}_X(T,\mathbf V_{\mathrm{lin}}(\mathcal F))
\simeq
\operatorname{Hom}_{\mathcal O_T}(f^*\mathcal F,\mathcal O_T).
```

A graded vector bundle is intrinsically an affine morphism `p : V \to X` together with a grading

```math
p_*\mathcal O_V = \bigoplus_{n\geq 0}\mathcal A_n
```

such that `A_0 \cong O_X` and each canonical map `Sym^n(A_1) \to A_n` is an isomorphism. Morphisms
preserve the grading. The implementation may initially use the essential image of `V_lin`, but it
must also construct this intrinsic structure and prove that the two definitions agree.

For a finite locally free sheaf of sections `E`, define the geometric total space

```math
\mathbf V(\mathcal E)
=
\mathbf V_{\mathrm{lin}}(\mathcal E^\vee)
=
\operatorname{Spec}_X
\operatorname{Sym}_{\mathcal O_X}(\mathcal E^\vee).
```

It is covariant in `E`, Zariski-locally an affine space with linear transition functions, and
represents sections:

```math
\operatorname{Hom}_X(T,\mathbf V(\mathcal E))
\simeq
\Gamma(T,f^*\mathcal E).
```

The names `linearSpec` and `totalSpace` record the variance and the dualization directly in the
public API.

### Relative-Spec convention

Relative Spec is contravariant in quasi-coherent commutative algebras and commutes with arbitrary
base change.

## Layers

Each layer has one discharge-gated milestone and the companion API needed to make it usable.

### L0 — finite locally free sheaves and monoidal algebra

Construct the symmetric monoidal closed structure on `X.Modules` and prove that it restricts to
`QCoh(X)`. Build tensor products, internal Hom, duals, evaluation and coevaluation, symmetric and
exterior powers, and determinants. Provide restriction, stalk, and pullback comparison isomorphisms
with simp and reassociation lemmas.

Package `FiniteLocallyFreeSheaf X`, prove closure under isomorphism and arbitrary pullback, construct
the locally constant rank, and identify rank one with the existing `InvertibleSheaf X`. On affine
schemes, restrict `tildeEquiv` to finite projective modules and make the restriction natural under
base change.

**Milestone:** a quasi-coherent sheaf is finite locally free if and only if it has a left/right dual
in the symmetric monoidal category `QCoh(X)`; the categorical dual agrees with
`Hom(E,O_X)`, and the canonical double-dual map is an isomorphism.

**Companion results:** tensor, dual, internal Hom, symmetric/exterior powers, and determinant
preserve finite local freeness and commute with pullback; locally split exact sequences with finite
locally free quotient; rank formulas for direct sum, tensor, dual, exterior powers, and determinant.

### L1 — relative Spec and affine schemes over a base

Define quasi-coherent commutative `O_X`-algebras using the L0 monoidal structure. Construct
`Spec_X(A) \to X` by affine-local spectra and gluing. Prove the functor-of-points universal
property, recover `A` from the pushforward of the structure sheaf, and prove compatibility with
restriction to opens and arbitrary base change.

**Milestone:** construct the anti-equivalence

```math
\mathsf{QCAlg}(X)^{\mathrm{op}}
\simeq
\mathsf{AffSch}_{/X}
```

with explicit functors, unit, counit, and pseudofunctorial compatibility under `Y \to X`.

**Companion results:** relative spectra of symmetric algebras, affine localization, products and
fiber products of affine `X`-schemes, and affine computations through `tildeEquiv`.

### L2 — sheaves versus geometric vector bundles

Apply relative Spec to the symmetric algebra. On `V_lin(F)`, construct the grading, zero section,
addition, and scalar multiplication and prove their affine formulas. Define geometric vector
bundles intrinsically as schemes over `X` which are Zariski-locally affine spaces with linear
transition maps, equivalently as the finite locally free part of the graded theory.

**First milestone:** the degree-one functor and `linearSpec` are quasi-inverse equivalences

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X).
```

**Second milestone:** restricting to finite locally free sheaves and dualizing gives

```math
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X).
```

Both equivalences are natural under base change. Prove the section-valued universal property and
the following dictionary as natural isomorphisms:

| Sheaf side | Geometric side |
| --- | --- |
| pullback `f^*E` | base change `Y\times_X V(E)` |
| global section | section of `V(E)\to X` |
| fibre `E\otimes k(x)` | scheme fibre over `x` |
| direct sum | fibre product over `X` |
| zero and addition | zero section and fibrewise addition |
| dual, tensor, internal Hom | corresponding geometric bundles |
| exterior/symmetric powers, determinant | corresponding geometric bundles and determinant line |

## Worked instances

- Through `tildeEquiv`, a finite projective `R`-module `M` gives
  `Spec(Sym_R(M^\vee)) \to Spec R`.
- The free sheaf on `Fin r` gives affine `r`-space and represents `r`-tuples of sections.
- `InvertibleSheaf.trivial X` gives the trivial geometric line bundle.

## Cross-cutting acceptance criteria

- Every construction has restriction, affine-local computation, pullback, and arbitrary-base-change
  theorems.
- Every equivalence exposes its functors, unit, counit, and naturality, and identifies its
  essential-image model with the intrinsic target category.
- The variance distinction `F \mapsto V_lin(F)` versus `E \mapsto V(E)` is visible in names and
  theorem statements.
- Fixed-rank statements explicitly assume constant rank; otherwise rank remains locally constant.
- Public APIs have extensionality and simp lemmas that keep covers, gluing data, and affine
  equivalences behind the implementation boundary.
- The worked instances above compile against the public interface.

## Relations to existing roadmaps

`JacobianChallenge` supplies the present rank-one object `InvertibleSheaf`, finitely presented
sheaves, and later the divisor--line-bundle dictionary. This roadmap generalizes its sheaf object to
all finite ranks and supplies the tensor/dual and geometric-total-space infrastructure that its
Picard theory needs. The Picard scheme and Jacobian remain governed by `JacobianChallenge`.

`AlgebraicCurves` supplies curve-specific divisors and Riemann--Roch. The vector-bundle theory here works over arbitrary schemes; `AlgebraicCurves` supplies the
curve-specific degree theory.

## Successor roadmaps — motivation only

The completion of L0--L2 supplies the algebraic vector-bundle theory required by three natural
successors.

### 1. Projective, Grassmann, and flag bundles

A separate roadmap should construct relative projective bundles, Grassmann bundles, and flag
bundles together with their quotient-classifying universal properties. Its main geometric outputs
are the universal quotient bundles and the flag-bundle input for the splitting principle.

### 2. Chow groups and characteristic classes

Building on those classifying constructions, a further roadmap should construct cycles, rational
equivalence, Chow homology/cohomology, Cartier-divisor actions, and the projective bundle formula;
then define Chern classes and prove naturality, the Whitney sum formula, and the splitting
principle.

### 3. Cohomological realization and the Hodge Conjecture interface

A further roadmap should construct analytification, topological vector bundles and Chern classes,
Betti and algebraic de Rham cohomology, the cycle-class map

```math
\operatorname{cl}_X^p :
\operatorname{CH}^p(X)
\longrightarrow
H^{2p}(X^{\mathrm{an}},\mathbb Z(p)),
```

and compatibility between algebraic and topological Chern classes. For a smooth projective complex
scheme it should prove that algebraic cycle classes have Hodge type `(p,p)`.

Together with the merged [Hodge structures roadmap
#49](https://github.com/TauCetiProject/TauCetiRoadmap/pull/49) (merged 13 August 2026), this supplies
the interfaces for the following formulation of the Hodge Conjecture:

```math
\operatorname{im}\!\left(
  \operatorname{cl}_X^p : \operatorname{CH}^p(X)\otimes\mathbb Q
  \longrightarrow H^{2p}(X^{\mathrm{an}},\mathbb Q(p))
\right)
=
\operatorname{Hdg}^p(X),
```

where `Hdg^p(X)` is the rational subspace of Hodge classes: type `(0,0)` after the Tate twist,
equivalently type `(p,p)` in untwisted degree `2p`. The Hodge-structures roadmap provides the
linear-algebraic target; the future realization roadmap builds the geometric cohomology,
comparisons, and cycle-class map that populate it. The present roadmap supplies the algebraic
vector-bundle input to that programme.

## References

- The Stacks Project, [Relative spectrum as a functor](https://stacks.math.columbia.edu/tag/01LQ)
  and [Vector bundles](https://stacks.math.columbia.edu/tag/01M1).
- EGA II, §1; EGA I, the affine-morphism/quasi-coherent-algebra correspondence.
- R. Hartshorne, *Algebraic Geometry*, II.5.
- D. Huybrechts and M. Lehn, *The Geometry of Moduli Spaces of Sheaves*, §2.2.
