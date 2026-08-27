# Roadmap: algebraic vector bundles and Chow-theoretic characteristic classes

This roadmap builds the scheme-theoretic bridge from quasi-coherent modules to geometric vector
bundles and carries it through projective and Grassmann bundles to Chern classes in operational
Chow cohomology. The definitions and dependency order follow the Stacks Project: relative spectrum,
graded vector bundles, finite locally free modules, projective bundles, Chow homology, and Chern
classes are separate layers, connected by explicit equivalences and universal properties.

The principal outputs are:

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X),
```

```math
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X),
```

and the Chern-class operations

```math
c_i(\mathcal E) : \mathrm{CH}_k(Y)
\longrightarrow
\mathrm{CH}_{k-i}(Y)
```

for every morphism `Y → X` in the bivariant Chow theory and every finite locally free module
`E` on `X`.

## Conventions

For a quasi-coherent module `F` on `X`, use the Stacks Project convention

```math
\mathbf V_{\mathrm{lin}}(\mathcal F)
=
\mathrm{Spec}_X
\left(
  \mathrm{Sym}_{\mathcal O_X}(\mathcal F)
\right).
```

It represents linear functionals:

```math
\mathrm{Hom}_X
\left(
  T,\mathbf V_{\mathrm{lin}}(\mathcal F)
\right)
\simeq
\mathrm{Hom}_{\mathcal O_T}
\left(
  f^*\mathcal F,\mathcal O_T
\right).
```

A Stacks-style graded vector bundle over `X` is an affine morphism `p : V → X` together with a
grading

```math
p_*\mathcal O_V
=
\bigoplus_{n \ge 0}\mathcal A_n
```

such that `A₀ = O_X` and every canonical map `Symⁿ(A₁) → Aₙ` is an isomorphism. Morphisms preserve
the grading. This definition applies to arbitrary quasi-coherent modules and does not assert finite
local triviality.

For a finite locally free module `E`, its geometric total space is

```math
\mathbf V(\mathcal E)
=
\mathbf V_{\mathrm{lin}}(\mathcal E^\vee)
=
\mathrm{Spec}_X
\left(
  \mathrm{Sym}_{\mathcal O_X}(\mathcal E^\vee)
\right).
```

Dualizability gives the section-valued universal property

```math
\mathrm{Hom}_X
\left(
  T,\mathbf V(\mathcal E)
\right)
\simeq
\Gamma(T,f^*\mathcal E).
```

Projective bundles use the quotient convention

```math
\mathbf P(\mathcal E)
=
\mathrm{Proj}_X
\left(
  \mathrm{Sym}_{\mathcal O_X}(\mathcal E)
\right),
```

so `P(E)` classifies invertible quotients of pullbacks of `E` and carries the universal quotient
`p*E → O(1)`. Grassmannians likewise classify finite locally free quotients, matching
`Module.Grassmannian`.

For Chow theory, fix a locally Noetherian universally catenary base scheme `S` equipped with a
dimension function, and work with schemes locally of finite type over `S`, as in Stacks Project
Situation 42.7.1. Coefficients are integral. Chern classes are bivariant operations, not merely
classes attached to a chosen fundamental cycle. When `X` is smooth over `S`, evaluation on `[X]`
recovers classes in the usual Chow ring.

## Existing substrate

The implementation consumes the following APIs at the repository's pinned revisions.

| Layer | Existing API | Use here |
| --- | --- | --- |
| Sheaves of modules | `Scheme.Modules`, `SheafOfModules` | ambient module categories |
| Quasi-coherence | `SheafOfModules.IsQuasicoherent`, `SheafOfModules.isQuasicoherent` | objects of `QCoh(X)` |
| Finite presentation | `SheafOfModules.IsFinitePresentation` | base-independent finiteness condition |
| Local freeness | `SheafOfModules.IsLocallyFree` | local free presentations, refined here by finite rank |
| Affine sheafification | `AlgebraicGeometry.tilde`, `AlgebraicGeometry.tildeEquiv` | affine-local model `R-Mod ≌ QCoh(Spec R)` |
| Projective spectrum | `AlgebraicGeometry.ProjectiveSpectrum` | affine graded-ring Proj substrate |
| Grassmannian functor | `Module.Grassmannian`, `Module.Grassmannian.functor` | quotient convention and affine functor of points |
| Rank one | `TauCeti.SheafOfModules.IsInvertible`, `AlgebraicGeometry.InvertibleSheaf` | line-bundle specialization |
| Finite-presentation packaging | `AlgebraicGeometry.FinitelyPresentedSheaf` | compatibility with existing scheme-level objects |

Relative spectrum of a quasi-coherent algebra, symmetric algebras in sheaves of modules,
scheme-level finite locally free rank, the relative sheaf-level Proj interface, representability of
the Grassmannian functor, and Chow theory are construction targets rather than assumed APIs.

The sheaf conditions play different roles and remain distinct throughout the API.

| Condition on an `O_X`-module | Role |
| --- | --- |
| quasi-coherent | ambient algebraic module and the degree-one datum of a graded vector bundle |
| finite presentation | finiteness condition stable under arbitrary base change |
| coherent on a locally Noetherian scheme | finite-type/finite-presentation stratum consumed by coherent cohomology |
| finite locally free | dualizable stratum corresponding to finite geometric vector bundles |
| invertible | rank-one finite locally free stratum corresponding to geometric line bundles |

The coherent row interfaces with `JacobianChallenge`; the finite locally free and geometric rows are
the bridge built here.

## Milestone 1: quasi-coherent algebra and finite locally free calculus

Build symmetric, exterior, tensor, dual, and internal-Hom constructions for scheme-valued sheaves of
modules. Prove their restriction, stalk, affine-local, and pullback formulas. State the precise
finiteness hypotheses for each preservation theorem.

Refine Mathlib's variable-rank `IsLocallyFree` predicate to finite local freeness and construct its
locally constant rank function. Prove the affine-local and stalkwise equivalences among:

- finite locally free modules;
- finitely presented flat modules;
- finite projective modules on affine opens; and
- dualizable quasi-coherent modules.

Construct evaluation and coevaluation, the double-dual isomorphism, determinant, and compatibility
of all these operations with pullback. Exact sequences used below are short exact sequences of
quasi-coherent modules; local splitting for a finite locally free quotient must be a theorem.

The milestone theorem is that finite locally free modules are exactly the dualizable objects in
`QCoh(X)`, with dual given by internal Hom into `O_X`.

## Milestone 2: relative spectrum and affine morphisms

For a quasi-coherent `O_X`-algebra `A`, construct the relative spectrum

```math
\mathrm{Spec}_X(\mathcal A) \longrightarrow X
```

by affine-local spectra and descent. Prove its functor-of-points universal property, recovery of
`A` from the pushforward of the structure sheaf, compatibility with restriction to affine opens,
and arbitrary base change.

Package quasi-coherent algebras contravariantly and affine morphisms over `X` categorically. The
milestone theorem is the anti-equivalence

```math
\mathsf{QCAlg}(X)^{\mathrm{op}}
\simeq
\mathsf{AffSch}_{/X},
```

with explicit unit, counit, action on morphisms, and naturality under change of base.

## Milestone 3: the algebraic-geometric vector-bundle bridge

Apply relative spectrum to `Sym(F)`. Construct the grading, zero section, addition, and scalar
multiplication on `V_lin(F)`, and prove their affine-local formulas and base-change compatibility.

Define `GradedVB(X)` by the pinned Stacks-style graded-affine condition. Recover a quasi-coherent
module from the degree-one summand of `p_*O_V`. The first milestone theorem is

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X).
```

Restrict to finite locally free modules and to graded vector bundles which are Zariski-locally
isomorphic, as linear schemes, to affine space over the base. Dualization converts the preceding
anti-equivalence into the covariant milestone theorem

```math
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X).
```

Prove the section-valued universal property of `V(E)` and the following comparison results.

| Module side | Geometric side |
| --- | --- |
| pullback `f*E` | base change `Y ×_X V(E)` |
| section of `E` | section `X → V(E)` |
| fibre `E ⊗ k(x)` | scheme fibre over `x` |
| direct sum | fibre product over `X` |
| dual, tensor, internal Hom | corresponding geometric bundles |
| exterior and symmetric powers | corresponding geometric bundles |
| determinant | determinant line bundle |
| short exact sequence with locally free quotient | locally split sequence of geometric bundles |

Every row is a natural isomorphism with identity, composition, restriction, and base-change
coherence lemmas. The existing `InvertibleSheaf` and trivial line bundle are the rank-one acceptance
instances.

## Milestone 4: projective, Grassmann, and flag bundles

Construct relative Proj for the symmetric algebras needed here, including `O(1)`, affine charts,
functoriality, and arbitrary base change. Prove that `P(E)` represents invertible quotients of
pullbacks of `E` and that its universal quotient agrees under Milestone 3 with the tautological
geometric line quotient.

Represent `Module.Grassmannian.functor` for a finite locally free module `E` by a scheme
`Gr_X(r,E)`. Construct its standard affine charts, universal quotient `p*E → Q`, tautological kernel
`S`, universal exact sequence, and base change. The milestone theorem is the natural equivalence

```math
\mathrm{Hom}_X
\left(
  T,\mathrm{Gr}_X(r,\mathcal E)
\right)
\simeq
\left\{
  f^*\mathcal E\twoheadrightarrow\mathcal Q
  \;\middle|\;
  \mathcal Q\text{ finite locally free of rank }r
\right\}/\simeq.
```

Construct flag bundles by iterated Grassmann or projective bundles, their tautological filtrations,
and a full flag bundle on which the pullback of `E` has an exhaustive filtration with invertible
successive quotients. These objects supply the geometric input to the projective bundle formula and
splitting principle.

## Milestone 5: Chow homology and operational Chow cohomology

Following Stacks Project Chapter 42, construct dimension-graded cycles, proper pushforward, flat
pullback with relative-dimension shift, rational equivalence, and Chow homology groups. Prove
functoriality, base change for proper/flat squares, localization, and the projection formula in the
generality used below.

Consume the scheme-theoretic Cartier divisors and divisor--invertible-sheaf dictionary from
`JacobianChallenge`. Construct their intersection action and the first Chern class operations for
invertible modules. Package bivariant classes and operational Chow cohomology, including
compatibility with proper pushforward, flat pullback, and refined Gysin operations.

For a finite locally free module `E` of rank `r`, prove the projective bundle formula for
`p : P(E) → X`. In operational form, pullback and powers of
`xi = c₁(O(1))` give the milestone isomorphism

```math
\bigoplus_{i=0}^{r-1}
\mathrm{CH}_{k-i}(X)
\simeq
\mathrm{CH}_{k}(\mathbf P(\mathcal E)).
```

The summand `CH_{k-i}(X)` maps by flat pullback followed by capping with `xi^(r-1-i)`.

The statement includes the inverse described by proper pushforward, compatibility with arbitrary
base change allowed by the Chow formalism, and the trivial-bundle computation for projective space.

## Milestone 6: Chern classes and the splitting principle

Define the Chern operations of a rank-`r` finite locally free module by the unique projective-bundle
relation

```math
\sum_{i=0}^{r}
(-1)^i
c_1(\mathcal O_{\mathbf P(\mathcal E)}(1))^i
\cap
p^*c_{r-i}(\mathcal E)
=0.
```

Construct them as central bivariant classes and prove:

- `c₀(E) = 1` and `cᵢ(E) = 0` outside `0 ≤ i ≤ rank(E)`;
- invariance under isomorphism and compatibility with restriction and pullback;
- `c₁(L)` agrees with the divisor/line-bundle first Chern class;
- normalization on trivial bundles;
- the Whitney sum formula for every short exact sequence of finite locally free modules;
- the splitting principle using the flag bundle from Milestone 4, with injective pullback on Chow
  groups after every base change;
- the Chern-root formulas for duals, tensor products, internal Hom, exterior powers, symmetric
  powers, and determinants; and
- agreement of Chern operations under the equivalence
  `FinLocFree(X) ≌ GeomVB(X)` from Milestone 3.

The summit theorem states that the Chern-class assignment factors through the equivalence
`FinLocFree(X) ≌ GeomVB(X)` and is uniquely characterized there by pullback naturality, the
line-bundle normalization, and the Whitney sum formula. Thus the module presentation and geometric
total-space presentation produce the same operational Chow classes, naturally in the base scheme
and compatibly with the splitting principle.

## Relations to adjacent roadmaps

| Area | Ownership contract |
| --- | --- |
| Mathlib | Tau Ceti builds every target here using Mathlib's current vocabulary. If Mathlib supplies an API, the Tau Ceti implementation is replaced by the import and the comparison theorems are retained. |
| `JacobianChallenge` | Owns scheme-theoretic Weil and Cartier divisors, the divisor--invertible-sheaf dictionary, invertible sheaves as the input to the Picard group and Picard functor, coherent cohomology and base change, degree on curves, `Pic⁰`, the Picard scheme, and the Jacobian. This roadmap consumes its divisor and rank-one objects and supplies their Chow action, total spaces, projective bundles, and Chern classes. |
| `AlgebraicCurves` | Owns function-field divisors and Riemann--Roch and its comparison with scheme-theoretic divisors. This roadmap supplies general Chow and Chern operations; it does not redefine the curve-specific divisor or degree theories. |
| `HodgeStructures` | The algebraic Chern classes here are inputs to later comparison theorems with cohomological characteristic classes. The Hodge-structure definitions and period-domain data remain there. |

## Cross-cutting acceptance criteria

- Every construction has restriction, affine-local computation, pullback, and base-change theorems.
- Every equivalence includes functors, unit, counit, and naturality; an object-level bijection is not
  a substitute.
- The two variances `F ↦ V_lin(F)` and `E ↦ V(E)` are visible in names and theorem statements.
- Rank is locally constant and may vary between connected components; fixed-rank results state the
  rank hypothesis explicitly.
- Universal objects are characterized by represented functors, and quotient conventions agree with
  `Module.Grassmannian`.
- Chow grading shifts and signs are fixed in public theorem statements and used consistently by the
  projective bundle relation, Whitney sum formula, and splitting principle.
- The trivial bundle, line bundle, affine scheme, projective space, and universal Grassmannian
  quotient are formalized as worked acceptance instances.
- Public definitions have extensionality and simp lemmas sufficient for use without unfolding the
  chosen affine cover or descent data.

## References

- The Stacks Project, [Relative spectrum as a functor](https://stacks.math.columbia.edu/tag/01LQ),
  [Vector bundles](https://stacks.math.columbia.edu/tag/01M1),
  [Projective bundles](https://stacks.math.columbia.edu/tag/01OA), and
  [Grassmannians](https://stacks.math.columbia.edu/tag/089R).
- The Stacks Project, [Chow Homology and Chern Classes](https://stacks.math.columbia.edu/tag/02P3),
  especially the [projective bundle formula](https://stacks.math.columbia.edu/tag/02TX),
  [Chern classes](https://stacks.math.columbia.edu/tag/02TZ), and
  [splitting principle](https://stacks.math.columbia.edu/tag/02UK).
- W. Fulton, *Intersection Theory*, Chapters 1--3 and 17.
- A. Grothendieck, *La théorie des classes de Chern*, for the projective-bundle construction of
  characteristic classes.
