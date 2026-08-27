# Roadmap: algebraic vector bundles and characteristic classes

This roadmap builds the scheme-theoretic bridge from quasi-coherent modules to geometric vector
bundles and follows it through projective and Grassmann bundles to **Chern classes in operational
Chow cohomology**. Its summit is the construction and characterization of the total Chern class,
with the sheaf-theoretic and geometric presentations proved to agree. `Suggested.lean` records
representative Lean signatures; this `README.md` is the definitive specification.

The organizing correspondence is

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X),
```

whose finite locally free part becomes, after dualization,

```math
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X).
```

The roadmap develops the complete API around these equivalences rather than treating them as
object-level bijections. The geometric constructions then supply the projective bundle formula and
splitting principle from which the Chern operations are defined.

Suggested library home: `TauCeti/AlgebraicGeometry/VectorBundle/`, with the relative-spectrum and
intersection-theory foundations under `TauCeti/AlgebraicGeometry/RelativeSpec/` and
`TauCeti/AlgebraicGeometry/Chow/`.

## Prior art and Mathlib substrate

The implementation starts from the repository's pinned Mathlib and Tau Ceti revisions. The
following declarations are existing inputs, not names to reproduce.

### Sheaves of modules

- `Scheme.Modules` and `SheafOfModules` provide the ambient categories of modules over a scheme's
  structure sheaf.
- `SheafOfModules.IsQuasicoherent` and `SheafOfModules.isQuasicoherent`, in
  `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`, provide quasi-coherence and its
  full subcategory.
- `SheafOfModules.IsFinitePresentation`, in the same file, is the finite-presentation condition
  used under arbitrary base change.
- `SheafOfModules.IsLocallyFree`, in
  `Mathlib/Algebra/Category/ModuleCat/Sheaf/LocallyFree.lean`, records local free presentations.
  Its local bases may be infinite and their cardinalities may vary, so L0 adds the
  finite-locally-free refinement and its locally constant finite rank.
- `AlgebraicGeometry.tilde` and `AlgebraicGeometry.tildeEquiv`, in
  `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`, give the affine model

  ```math
  R\text{-}\mathsf{Mod}
  \simeq
  \mathsf{QCoh}(\mathrm{Spec}(R)).
  ```

  Affine computations and descent in L0--L2 reduce to this equivalence.

### Algebraic and scheme-theoretic constructions

- Mathlib's tensor products, symmetric algebras, exterior algebras, linear duals, finite projective
  modules, localization, and stalks provide the affine algebra used in L0.
- `Scheme.Spec`, affine schemes, affine morphisms, scheme pullbacks, open immersions, and gluing
  provide the scheme substrate for relative spectrum.
- `AlgebraicGeometry.ProjectiveSpectrum` provides Proj for graded rings and its scheme structure.
  L3 builds the relative sheaf-level Proj interface and its base-change theorem from this affine
  substrate.
- `Module.Grassmannian` and `Module.Grassmannian.functor`, in
  `Mathlib/RingTheory/Grassmannian.lean`, already encode the quotient convention: an `A`-point is
  a quotient of `A ⊗[R] M` which is finite locally free of the specified rank. The file leaves
  affine charts, scheme-level Grassmannians, and representability as future work; those are L3
  targets here.

Mathlib at the pin has no relative spectrum for quasi-coherent sheaves of algebras, no category of
Stacks-style graded vector bundles over a scheme, no equivalence with quasi-coherent modules, no
scheme-level representability theorem for `Module.Grassmannian.functor`, and no Chow groups or
Chern classes of algebraic vector bundles. These are the new layers of this roadmap.

### Existing Tau Ceti objects

- `TauCeti.AlgebraicGeometry.LineBundle.Basic` packages
  `TauCeti.SheafOfModules.IsInvertible` as `AlgebraicGeometry.InvertibleSheaf X` and supplies the
  trivial invertible sheaf.
- `TauCeti.AlgebraicGeometry.FinitelyPresentedSheaf.Basic` packages
  `SheafOfModules.IsFinitePresentation` over a scheme and supplies the inclusion of invertible
  sheaves into finitely presented sheaves.

These rank-one and finite-presentation objects are imported and extended; the general finite
locally free category in L0 is built compatibly with them.

## Core definitions

The sheaf conditions form successive, non-identical strata.

| Condition | Mathematical role in this roadmap |
| --- | --- |
| quasi-coherent | ambient module and degree-one datum of a graded vector bundle |
| finite presentation | base-change-stable finiteness condition |
| coherent on a locally Noetherian scheme | finite-type/finite-presentation stratum used by coherent cohomology |
| finite locally free | dualizable stratum corresponding to finite geometric vector bundles |
| invertible | rank-one finite locally free stratum corresponding to geometric line bundles |

For a quasi-coherent module `F` on `X`, follow Stacks Project §27.6 and define the contravariant
linear scheme

```math
\mathbf V_{\mathrm{lin}}(\mathcal F)
=
\mathrm{Spec}_X
\left(
  \mathrm{Sym}_{\mathcal O_X}(\mathcal F)
\right).
```

Its universal property is

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

A **graded vector bundle** over `X`, in the Stacks/EGA sense, is an affine morphism `p : V → X`
with a grading

```math
p_*\mathcal O_V
=
\bigoplus_{n \ge 0}\mathcal A_n
```

such that `A₀ = O_X` and every canonical map `Symⁿ(A₁) → Aₙ` is an isomorphism. Morphisms
preserve the grading. The degree-one summand recovers the quasi-coherent module.

For a finite locally free module `E`, define the geometric total space by dualizing before applying
the Stacks construction:

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

Dualizability changes the functor of points into the section-valued form

```math
\mathrm{Hom}_X
\left(
  T,\mathbf V(\mathcal E)
\right)
\simeq
\Gamma(T,f^*\mathcal E).
```

Thus `F ↦ V_lin(F)` is contravariant, whereas `E ↦ V(E)` is covariant. The two constructions
have separate names and separate functors throughout the API.

## Generality bar

- L0--L3 work over an arbitrary scheme `X` and for finite locally free modules whose rank is a
  locally constant function on `X`.
- Statements about a fixed rank `r` carry that hypothesis explicitly, component by component.
- The quasi-coherent correspondence is stated for arbitrary quasi-coherent modules; finite
  presentation and finite local freeness are restrictions of that correspondence.
- L4--L5 use the Stacks Project Chow setup: a locally Noetherian universally catenary base scheme
  `S` equipped with a dimension function, and schemes locally of finite type over `S`.
- Chow groups have integral coefficients. Chern classes are operational bivariant classes, so they
  act on every `Y → X`; evaluation on `[X]` gives ordinary Chow-ring classes when available.

## Conventions (pinned)

- Relative Spec is contravariant in quasi-coherent algebras and commutes with arbitrary base change.
- `P(E)` uses the quotient convention

  ```math
  \mathbf P(\mathcal E)
  =
  \mathrm{Proj}_X
  \left(
    \mathrm{Sym}_{\mathcal O_X}(\mathcal E)
  \right),
  ```

  and represents invertible quotients of pullbacks of `E`; its tautological map is
  `p*E → O(1)`.
- `Gr_X(r,E)` represents rank-`r` finite locally free quotients of pullbacks of `E`, matching
  `Module.Grassmannian.functor`.
- The first Chern class of an invertible sheaf agrees with intersection by the corresponding
  Cartier divisor.
- The projective-bundle relation uses `xi = c₁(O(1))` and the signs displayed in L5.

## Layers

The ordering is the dependency order. Each layer has a principal theorem, together with the API
needed to make that theorem usable.

### L0 — finite locally free sheaves and their algebra

Build tensor products, symmetric and exterior powers, duals, internal Hom, determinants, evaluation,
coevaluation, and the double-dual map for scheme-valued sheaves of modules. Prove restriction,
stalk, affine-local, and pullback formulas and state the exact finiteness hypotheses for every
preservation theorem.

Define finite local freeness as a refinement of `SheafOfModules.IsLocallyFree`, construct the
locally constant finite rank, and prove the affine-local and stalkwise equivalences among finite
locally free, finitely presented flat, finite projective on affine opens, and dualizable
quasi-coherent modules.

**Milestone:** finite locally free modules are exactly the dualizable objects of `QCoh(X)`, with
dual given by internal Hom into `O_X`.

**Companions:** locally split exact sequences with finite locally free quotient; compatibility of
dual, tensor, internal Hom, exterior/symmetric powers, and determinant with pullback; agreement with
the existing `InvertibleSheaf` in rank one.

### L1 — relative spectrum and affine morphisms

For a quasi-coherent `O_X`-algebra `A`, construct `Spec_X(A) → X` by affine-local spectra and
gluing. Prove the functor-of-points universal property, recovery of `A` from the pushforward of the
structure sheaf, restriction to affine opens, functoriality, and arbitrary base change.

**Milestone:** construct the anti-equivalence

```math
\mathsf{QCAlg}(X)^{\mathrm{op}}
\simeq
\mathsf{AffSch}_{/X}
```

with explicit functors, unit, counit, and naturality under change of base.

### L2 — the module-to-vector-bundle correspondence

Apply relative Spec to `Sym(F)`. Construct the grading, zero section, addition, and scalar
multiplication on `V_lin(F)` and prove their affine-local formulas and base-change compatibility.

**First milestone:** recover the Stacks Project anti-equivalence

```math
\mathsf{QCoh}(X)^{\mathrm{op}}
\simeq
\mathsf{GradedVB}(X).
```

Restrict to finite locally free modules and graded vector bundles which are Zariski-locally affine
space with linear transition maps.

**Second milestone:** dualization gives the covariant equivalence

```math
\mathsf{FinLocFree}(X)
\simeq
\mathsf{GeomVB}(X).
```

**Companions:** prove the section-valued universal property and every row of the following table as
a natural isomorphism.

| Sheaf side | Geometric side |
| --- | --- |
| pullback `f*E` | base change `Y ×_X V(E)` |
| section of `E` | section `X → V(E)` |
| fibre `E ⊗ k(x)` | scheme fibre over `x` |
| direct sum | fibre product over `X` |
| dual, tensor, internal Hom | corresponding geometric bundles |
| exterior and symmetric powers | corresponding geometric bundles |
| determinant | determinant line bundle |
| locally split exact sequence | fibrewise exact sequence of geometric bundles |

### L3 — projective, Grassmann, and flag bundles

Complete the relative Proj interface needed for symmetric algebras, including `O(1)`, affine
charts, functoriality, and arbitrary base change. Prove that `P(E)` represents invertible quotients
of pullbacks of `E`.

Represent `Module.Grassmannian.functor` by `Gr_X(r,E)`. Construct the standard affine charts,
universal quotient `p*E → Q`, tautological kernel `S`, universal exact sequence, and base change.

**Milestone:** prove the natural classifying equivalence

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

**Companions:** projective bundles as the rank-one case; flag bundles as iterated Grassmann or
projective bundles; tautological filtrations; a full flag bundle on which the pullback of `E` has
invertible successive quotients.

### L4 — Chow homology and operational Chow cohomology

Construct dimension-graded cycles, proper pushforward, flat pullback with its dimension shift,
rational equivalence, and Chow homology in the pinned Stacks generality. Prove functoriality,
proper/flat base change, localization, and the projection formula.

Consume the scheme-theoretic Cartier divisors and divisor--invertible-sheaf dictionary from
`JacobianChallenge`. Construct intersection with Cartier divisors, first Chern operations for
invertible sheaves, bivariant classes, and operational Chow cohomology.

**Milestone:** for a rank-`r` finite locally free module `E`, pullback and powers of
`xi = c₁(O(1))` give the projective bundle isomorphism

```math
\bigoplus_{i=0}^{r-1}
\mathrm{CH}_{k-i}(X)
\simeq
\mathrm{CH}_k(\mathbf P(\mathcal E)).
```

The summand `CH_{k-i}(X)` maps by flat pullback followed by capping with `xi^(r-1-i)`; construct
the inverse by proper pushforward and prove the projective-space computation for a trivial bundle.

### L5 — Chern classes and the splitting principle

Define the Chern operations of a rank-`r` finite locally free module by the unique
projective-bundle relation

```math
\sum_{i=0}^{r}
(-1)^i
c_1(\mathcal O_{\mathbf P(\mathcal E)}(1))^i
\cap
p^*c_{r-i}(\mathcal E)
=0.
```

Construct the operations as central bivariant classes and prove normalization, invariance under
isomorphism, pullback naturality, the Whitney sum formula, and the splitting principle using the
full flag bundle from L3. Derive the Chern-root formulas for duals, tensor products, internal Hom,
exterior powers, symmetric powers, and determinants.

**Milestone:** the Chern-class assignment factors through
`FinLocFree(X) ≌ GeomVB(X)` and is uniquely characterized there by pullback naturality,
line-bundle normalization, and the Whitney sum formula. The sheaf and geometric total-space
presentations therefore produce the same operational Chow classes.

## Worked instances

- On `Spec(R)`, the construction agrees through `tildeEquiv` with finite projective `R`-modules
  and `Spec(Sym_R(M^∨))`.
- A free rank-`r` sheaf gives affine `r`-space, and its total space represents `r`-tuples of
  sections.
- The existing trivial invertible sheaf gives the trivial geometric line bundle.
- `P(O_X^r)` is projective `(r-1)`-space over `X`, with the tautological quotient.
- `Gr_X(r,O_X^N)` represents `Module.Grassmannian.functor` and carries its universal quotient.
- Chern classes of a trivial bundle vanish in positive degree; for an invertible sheaf, `c₁`
  agrees with its Cartier-divisor action.

## Relation to sibling roadmaps

### Jacobian challenge

`JacobianChallenge` supplies the rank-one and divisor inputs used here: invertible sheaves,
finitely presented sheaves, scheme-theoretic Weil and Cartier divisors, and the
divisor--invertible-sheaf dictionary. This roadmap imports those objects. L0 identifies invertible
sheaves as the rank-one part of the general finite locally free theory; L2 constructs their
geometric total spaces; L4 uses the Cartier-divisor action to normalize `c₁`.

The Picard group and Picard functor, coherent cohomology and base change, degree on curves, `Pic⁰`,
the Picard scheme, and the Jacobian are targets of `JacobianChallenge`. Their definitions are not
duplicated here. The common interface is `InvertibleSheaf` and its first Chern class.

### Algebraic curves

`AlgebraicCurves` builds function-field places and divisors, Riemann--Roch, and the comparison with
scheme-theoretic divisors. Its scheme comparison consumes the Cartier-divisor and Chow interfaces
used here. This roadmap works with the general scheme-theoretic cycle and Chern operations rather
than a second curve-specific degree theory.

### Hodge structures

`HodgeStructures` builds pure, mixed, and polarized Hodge structures. The Chern classes here are
algebraic classes in operational Chow cohomology. The cohomological realization below specifies
their Betti and de Rham comparison; for a smooth projective complex scheme, the resulting classes
have Hodge type `(i,i)`. `HodgeStructures` packages the linear-algebraic structure carried by those
realizations rather than constructing the realization functors themselves.

## Cohomological realization

The word *geometric* in `GeomVB(X)` refers to an algebraic vector bundle presented by its total
space as a scheme over `X`. Passing from an algebraic scheme over `ℂ` to its analytic space, and
from an algebraic vector bundle to a complex topological vector bundle, is a second comparison.
For a smooth complex scheme `X`, its central map is the cycle-class homomorphism

```math
\mathrm{cl}_X^p :
\mathrm{CH}^p(X)
\longrightarrow
H^{2p}(X^{\mathrm{an}},\mathbf Z(p)).
```

The class of an integral codimension-`p` subscheme is sent to its analytic fundamental class in
Borel--Moore homology and then, when `X` is smooth, to cohomology by Poincaré duality. Rational
equivalence must map to zero so that this construction descends to the Chow group.

The first precise comparison target is stated for a smooth projective scheme `X` over `ℂ` and a
finite locally free module `E` on `X`:

```math
\mathrm{cl}_X^i
\left(
  c_i^{\mathrm{CH}}(\mathcal E)
\right)
=
c_i^{\mathrm{top}}
\left(
  \mathcal E^{\mathrm{an}}
\right).
```

Together with the de Rham--Betti comparison

```math
H^n_{\mathrm{dR}}(X/\mathbf C)
\simeq
H^n(X^{\mathrm{an}},\mathbf C),
```

this identifies algebraic Chern classes with integral cohomological characteristic classes and
places their complexifications in Hodge type `(i,i)`.

Mathlib already supplies the singular set, the singular chain-complex functor, singular homology,
and its homotopy invariance in `Mathlib/AlgebraicTopology/SingularHomology/`. The comparison
programme requires the multiplicative cohomology API, cup products, fundamental and Thom classes,
Borel--Moore homology, Poincaré duality, complex topological Chern classes, analytification of
schemes and finite locally free sheaves, the cycle-class map, and the comparison theorem above.
The generic topological constructions are natural Mathlib contributions; analytification and the
algebraic-to-Betti comparison belong in Tau Ceti.

This cohomology is distinct from `Scheme.Modules.Cohomology M q`, the Zariski sheaf cohomology used
by `JacobianChallenge` for coherent sheaves, Riemann--Roch, and the Picard/Jacobian construction.
The two theories meet later through algebraic de Rham cohomology and comparison theorems, not by
identifying their definitions.

## Cross-cutting acceptance criteria

- Every construction has restriction, affine-local computation, pullback, and base-change theorems.
- Every equivalence includes functors, unit, counit, and naturality; an object-level bijection is
  insufficient.
- The two variances `F ↦ V_lin(F)` and `E ↦ V(E)` remain visible in names and theorem statements.
- Universal objects are characterized by represented functors, with quotient conventions matching
  `Module.Grassmannian.functor`.
- Fiberwise algebra and section-level operations have extensionality and simp lemmas usable without
  unfolding affine covers or descent data.
- Chow grading shifts and signs agree across the projective bundle formula, Chern relation, Whitney
  sum formula, and splitting principle.
- The worked instances above exercise the public API.

## Downstream

This library supplies algebraic vector bundles, tautological bundles, and characteristic classes to
roadmaps for stability and moduli of sheaves, algebraic gauge theory, Higgs bundles, comparison with
topological or de Rham Chern classes, and intersection-theoretic calculations on moduli spaces.

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
- A. Grothendieck, *La théorie des classes de Chern*.

## Motivation

The longer-term programme is to formalize the reusable geometry connecting algebraic vector
bundles, complex and smooth vector bundles, connections and curvature, gauge theory and
Yang--Mills equations, Higgs bundles, and their moduli spaces. These subjects repeatedly use the
same structural operations developed here: pullback, duals, tensor and Hom bundles, determinants,
tautological bundles, characteristic classes, projective and Grassmann bundles, and deformation
data expressed through cohomology.

There are two complementary routes out of this foundation. On the algebraic and complex-geometric
side, finite locally free sheaves lead to stability, moduli of bundles and sheaves, Higgs fields,
Higgs-bundle moduli, the Hitchin fibration, and integrable systems. On the differential-geometric
side, complex vector bundles lead to connections, curvature, Chern--Weil theory, unitary gauge
groups, and Yang--Mills moduli. Analytification and the comparison of characteristic classes form
the first compatibility layer between these routes.

Over a compact Riemann surface the later bridge theorems include Narasimhan--Seshadri, relating
stable degree-zero bundles to irreducible unitary representations, and the
Hitchin--Simpson/Donaldson--Corlette
correspondence among Higgs bundles, harmonic bundles, and reductive flat connections. Their moduli
spaces support the Atiyah--Bott gauge-theoretic picture, the Hitchin integrable system, and further
directions toward nonabelian Hodge theory and geometric Langlands.

This roadmap is the first self-contained foundation in that programme. The theories just listed
motivate its choice of definitions, naturality statements, and comparison theorems; each requires
its own focused successor roadmap and is not an additional completion criterion here.
