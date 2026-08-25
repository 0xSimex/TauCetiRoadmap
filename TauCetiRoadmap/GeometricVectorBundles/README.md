# Roadmap: geometric vector bundles, connections, Higgs bundles, and moduli

This roadmap builds the differential- and complex-geometric infrastructure that turns a vector
bundle from a locally trivial family of vector spaces into an object carrying differential
operators, curvature, holomorphic structure, Higgs fields, and moduli.  The main geometric target
is the moduli theory of Higgs bundles on a compact Riemann surface.  The intermediate APIs are
independent library targets: smooth bundle algebra and bundle-valued forms should also support
gauge theory, characteristic classes, Riemannian geometry, variations of Hodge structure, and
elliptic complexes.

The work is divided into seven subordinate roadmaps.  Each has a precise interface and can be
implemented and reviewed independently, but the dependency order below is part of the
specification.  The lowest layers make direct contact with Mathlib's existing vector-bundle and
manifold APIs; no layer assumes an informal notion of a bundle-valued form, connection, quotient,
or moduli space.

Suggested homes are `TauCeti/Geometry/VectorBundle/`, `TauCeti/Geometry/Manifold/Connection/`,
`TauCeti/Geometry/ComplexManifold/`, and `TauCeti/Geometry/HiggsBundle/`.  When Mathlib supplies one
of these definitions, replace the Tau Ceti implementation by an import while preserving the public
mathematical interface.

## Scope and boundaries

The smooth theory is for finite-rank real and complex vector bundles over finite-dimensional smooth
manifolds.  The complex theory is for finite-rank complex vector bundles over finite-dimensional
complex manifolds.  The geometric moduli theory specializes to compact connected Riemann surfaces
and fixes rank and degree.

This roadmap owns:

- smooth dual, hom, tensor, and exterior-power bundles and their section-level operations;
- differential forms with values in a smooth vector bundle;
- connections on general smooth vector bundles, their induced operators, curvature, and gauge
  action;
- holomorphic structures described by integrable Dolbeault operators, together with holomorphic
  bundle maps and sections;
- Higgs bundles, their morphisms and standard constructions;
- the groupoid and family-valued moduli problems for bundles and Higgs bundles; and
- stable Higgs bundles on compact Riemann surfaces, their deformation theory, coarse moduli space,
  and Hitchin map.

The following neighbouring roadmaps keep their existing ownership.

- [Hodge structures](../HodgeStructures/README.md) owns pure, mixed, and polarized Hodge structures
  and period-domain points.  Its variations-of-Hodge-structure successor consumes the holomorphic
  bundle and connection APIs built here.
- [Hopf--Rinow](../HopfRinow/README.md) owns the Levi--Civita connection, covariant differentiation
  along curves, geodesics, and the exponential map.  It consumes the general connection API here
  when that API is available.
- [Geometric topology](../GeometricTopology/README.md) owns tubular neighbourhoods, normal bundles
  as used in surgery, and Riemannian curvature and volume.  It consumes general bundle operations
  and connections from this roadmap.
- [Algebraic curves](../AlgebraicCurves/README.md) owns divisors, Riemann--Roch, and the algebraic
  theory of curves.  [The Jacobian challenge](../JacobianChallenge/README.md) owns invertible
  sheaves, the Picard functor, the Picard scheme, and the Jacobian.

General principal bundles, characteristic classes, higher-dimensional moduli of coherent sheaves,
derived moduli, the Hitchin equations, and the nonabelian Hodge correspondence are not targets of
this roadmap.  The final section records the interfaces that separate roadmaps for those subjects
must consume.

## Inventory: what exists

### Mathlib

The implementation must consume the following existing APIs rather than restating them.

- `VectorBundle`, `VectorBundleCore`, local trivializations, trivial bundles, product bundles, and
  pullbacks provide the topological bundle substrate.
- `Bundle.ContinuousLinearMap` provides fiberwise continuous linear maps.
- `ContMDiffVectorBundle`, `ContMDiffSection`, smooth bundle maps, smooth local frames, and smooth
  pullbacks provide the smooth bundle substrate.
- `CovariantDerivative` and `ContMDiffCovariantDerivative` provide covariant derivatives on smooth
  vector bundles.  Their API includes addition by a one-form, the tensorial difference of two
  covariant derivatives, torsion for tangent-bundle connections, and metric compatibility.
- `TangentBundle`, `TangentSpace`, `VectorField`, `ModelWithCorners`, `IsManifold`, `ContMDiff`, and
  manifold charts provide the ambient differential geometry.
- Alternating maps, exterior algebras, tensor products, continuous multilinear maps, and
  finite-dimensional continuous linear equivalences provide the fiberwise algebra.
- Differential forms and `extDeriv` on normed vector spaces provide the local model for exterior
  calculus.  This is not yet a bundle-valued exterior calculus on manifolds.
- Complex manifolds and holomorphic functions provide the analytic base category.  They do not yet
  provide a complete API for holomorphic vector bundles, Dolbeault operators, or bundle-valued
  `(p,q)`-forms.
- Scheme-valued modules, quasi-coherent sheaves, and the relevant Grothendieck topologies provide
  part of the algebraic substrate consumed by the algebraic-curves and Jacobian roadmaps.

### Tau Ceti

Tau Ceti already contains Hodge-theoretic base change and conjugation, smooth two-forms used by the
symplectic developments, and algebraic `LineBundle`, `InvertibleSheaf`, and
`FinitelyPresentedSheaf` infrastructure.  These are consumers or algebraic neighbours, not reasons
to introduce parallel smooth or holomorphic bundle notions here.

### Missing infrastructure

There is no integrated API for smooth dual, tensor, hom, and exterior-power bundles; manifold
differential forms valued in a bundle; the covariant exterior derivative and curvature of a
general bundle connection; holomorphic vector bundles or Dolbeault operators; Higgs bundles; or
their moduli groupoids and spaces.  Those omissions determine the subordinate roadmaps below.

Before settling public names, search current Mathlib pull requests and the Lean Zulip for active
work on vector bundles, differential forms, connections, and complex manifolds.  Implement the
required interface in Tau Ceti without waiting for upstream work.

## Pinned conventions

- A manifold is a type with Mathlib's topology, model-with-corners, and smooth-manifold instances,
  not a new bundled record.
- A smooth vector bundle uses Mathlib's existing `VectorBundle` and `ContMDiffVectorBundle`
  structures.  New constructions supply those instances and compatible local trivializations.
- Bundle-valued `k`-forms are smooth sections of the bundle of alternating continuous `k`-linear
  maps from the tangent bundle to the coefficient bundle.  Degree-zero forms are smooth sections.
- A connection satisfies
  `∇_X (f • s) = X(f) • s + f • ∇_X s`, in the convention already used by Mathlib's
  `CovariantDerivative`.
- Curvature uses
  `R∇(X,Y)s = ∇_X(∇_Y s) - ∇_Y(∇_X s) - ∇_[X,Y] s`.
- A holomorphic structure on a smooth complex vector bundle is an integrable Dolbeault operator
  `dbar_E : Ω^(0,0)(E) → Ω^(0,1)(E)` satisfying the Leibniz rule and `dbar_E^2 = 0` through its
  covariant extension.  Transition-function and Dolbeault descriptions are related by explicit
  equivalences rather than conflated definitionally.
- A Higgs field is a holomorphic section
  `θ : Ω^(1,0)(End E)` satisfying `θ ∧ θ = 0`.  A Higgs-bundle morphism intertwines the two Higgs
  fields.
- Moduli is first a groupoid or a functor of families.  An orbit set is called a set of
  isomorphism classes, not a moduli space.  A coarse moduli space comes with its universal property;
  no quotient topology is installed by fiat.
- The degree of a holomorphic vector bundle on a compact Riemann surface is normalized to agree
  with the degree of its determinant line bundle.  Slope is `degree / rank`.

## Dependency order

| Sub-roadmap | Principal output | Direct dependencies |
| --- | --- | --- |
| A | Smooth bundle algebra | Mathlib vector bundles and fiberwise multilinear algebra |
| B | Bundle-valued differential forms | A and Mathlib manifold calculus |
| C | Connections and curvature | A--B and Mathlib `CovariantDerivative` |
| D | Holomorphic bundles and Dolbeault calculus | A--C and Mathlib complex manifolds |
| E | Higgs bundles | B--D |
| F | Moduli groupoids and families | D--E |
| G | Stable Higgs moduli and the Hitchin map | E--F, Algebraic Curves, and Jacobian Challenge |

## Sub-roadmap A: smooth bundle algebra

Build smooth dual, continuous-hom, tensor-product, and exterior-power bundles for finite-rank
vector bundles.  Each construction must include:

- a fiber identification with the corresponding linear-algebra construction;
- smooth local trivializations and transition maps;
- functoriality for smooth bundle maps, identities, composition, and pullback;
- evaluation, coevaluation, currying, contraction, tensor permutation, and exterior alternation;
- section-level operations with smoothness theorems;
- canonical equivalences for trivial bundles and compatibility with restriction and pullback; and
- hom-bundle composition and the identification `End(E) = Hom(E,E)`.

The design must state whether tensor products and exterior powers use completed topological tensor
products or the finite-dimensional algebraic construction equipped with its canonical topology.
For this roadmap's finite-rank bundles, use the latter and prove independence from choices.

Acceptance is witnessed by the tangent and cotangent bundles, exterior powers of the cotangent
bundle, endomorphism bundles, and pullbacks of each construction, with the expected fiberwise maps
computing under a local trivialization.

## Sub-roadmap B: bundle-valued differential forms

Define smooth `E`-valued differential `k`-forms on a manifold as specified above.  Build the full
basic calculus:

- coercion to fiberwise alternating maps, extensionality, zero, addition, scalar multiplication,
  restriction, pullback, and evaluation on vector fields;
- the wedge product
  `Ω^p(E) × Ω^q(F) → Ω^(p+q)(E ⊗ F)` with associativity, graded commutativity in the scalar case,
  and compatibility with pullback;
- wedge products with a specified bilinear coefficient pairing, including composition-valued wedge
  products for endomorphism forms;
- local-coordinate and local-frame expressions and an extensionality theorem reducing equality to
  a bundle atlas;
- scalar-valued manifold forms and their exterior derivative, agreeing in charts with Mathlib's
  normed-space `extDeriv`; and
- `d^2 = 0`, the graded Leibniz rule, naturality under pullback, and agreement with the differential
  of functions in degree zero.

The scalar manifold exterior derivative is part of this sub-roadmap because connections and
Dolbeault operators cannot be specified without it.  It must not be replaced by a chart-dependent
placeholder.

Acceptance is witnessed by ordinary scalar forms, forms valued in a trivial bundle, the canonical
identity section of `End(E)`, and the wedge-commutator of endomorphism-valued forms.

## Sub-roadmap C: connections, induced operators, and curvature

Reconcile the form-valued interface with Mathlib's `CovariantDerivative`; do not introduce an
unrelated second notion of connection.  Build:

- the equivalence between covariant derivatives expressed on vector fields and first-order
  operators `Ω^0(E) → Ω^1(E)` satisfying the Leibniz rule;
- affine-space operations on connections and the identification of their difference with an
  `End(E)`-valued one-form;
- pullback connections and induced connections on dual, hom, tensor, exterior-power, determinant,
  and endomorphism bundles;
- the covariant exterior derivative `d∇ : Ω^k(E) → Ω^(k+1)(E)`, including the graded Leibniz rule
  for coefficient pairings and functoriality for parallel bundle maps;
- curvature both as `d∇ ∘ d∇` on sections and as an `End(E)`-valued two-form, with equality of the
  two descriptions;
- the local connection one-form and formula `F∇ = dA + A ∧ A`, with change-of-frame law;
- the first and second Bianchi identities in their general connection form;
- flat connections, parallel sections, and preservation of tensor constructions; and
- the smooth gauge group of a bundle, its action on connections and curvature, stabilizers, and
  compatibility with composition.

This sub-roadmap supplies general curvature only.  Torsion, Levi--Civita uniqueness, sectional and
Ricci curvature, and geodesics remain in the Hopf--Rinow and Geometric Topology roadmaps.

Acceptance is witnessed by the trivial connection, the connection `d + A` on a trivial bundle, a
line-bundle connection, pullback compatibility, gauge covariance of curvature, and vanishing
curvature for the trivial connection.

## Sub-roadmap D: holomorphic bundles and Dolbeault calculus

Build complexified forms and their type decomposition on a complex manifold before defining
bundle-valued Dolbeault operators.  The targets are:

- the splitting of complexified cotangent vectors and forms into types `(p,q)`, conjugation,
  projections, wedge bidegrees, and pullback by holomorphic maps;
- scalar `∂` and `dbar`, the decomposition `d = ∂ + dbar`, the bidegree identities, and
  `∂^2 = dbar^2 = ∂ dbar + dbar ∂ = 0`;
- holomorphic vector bundles given by holomorphic local trivializations and transition functions;
- Dolbeault operators on smooth complex vector bundles, their extension to bundle-valued
  `(p,q)`-forms, curvature `(0,2)`, and integrability;
- the equivalence between holomorphic structures and integrable Dolbeault operators in finite rank;
- holomorphic sections and bundle maps, kernels of `dbar` in degree zero, and local holomorphic
  frames;
- holomorphic dual, hom, tensor, exterior-power, determinant, and pullback bundles; and
- Chern connections for Hermitian holomorphic bundles, characterized by compatibility with the
  metric and holomorphic structure, together with curvature type `(1,1)`.

The equivalence between integrable Dolbeault operators and holomorphic local trivializations is the
Koszul--Malgrange theorem and requires its analytic hypotheses and proof.  It is a milestone, not a
definitional shortcut.

Acceptance is witnessed by trivial holomorphic bundles, holomorphic line bundles, pullbacks,
holomorphic bundle maps as `dbar`-closed sections of a hom bundle, and the Chern connection on a
trivial Hermitian holomorphic bundle.

## Sub-roadmap E: Higgs bundles

Define Higgs bundles over a complex manifold using the pinned convention.  Build:

- Higgs fields and the equivalent square-zero Higgs complex
  `E → E ⊗ Ω^1 → E ⊗ Ω^2 → ...`;
- Higgs-bundle morphisms, isomorphisms, automorphisms, subobjects, and quotients when the underlying
  bundle map has constant rank;
- direct sums, duals, homs, tensor products, determinant, and holomorphic pullback;
- the induced Higgs field on `End(E)` and the deformation differential `[θ,-]`;
- invariant subbundles and the relation between Higgs morphisms and invariant graphs; and
- the category of Higgs bundles over a fixed base, with forgetful functors to holomorphic and
  smooth vector bundles.

Acceptance is witnessed by zero Higgs fields, Higgs line bundles, direct sums, tensor products,
duals, pullbacks, and the proof that the induced Higgs differential squares to zero exactly because
`θ ∧ θ = 0`.

## Sub-roadmap F: moduli groupoids and families

Separate three levels that are often blurred in informal accounts.

1. For a fixed smooth complex vector bundle `E`, define the smooth complex gauge group and its
   action on integrable Dolbeault operators and Higgs pairs.  Construct the action groupoid and
   identify its connected components with isomorphism classes of holomorphic or Higgs structures
   on `E`.
2. For varying bundles on a fixed base, define the groupoid of holomorphic bundles and the groupoid
   of Higgs bundles.  Relate fixed-topological-type components to the fixed-bundle gauge
   presentation.
3. For families parametrized by a complex analytic space or scheme `S`, define bundles on
   `X × S`, fiberwise Higgs fields, base change, isomorphisms of families, and descent.  Formulate
   the resulting groupoid-valued moduli functor.

Build stabilizers and automorphism groups, functoriality under pullback, and the distinction between
a fine moduli object, a coarse moduli object, and the set of isomorphism classes.  Prove that a
universal family represents the family functor when one exists and that a coarse moduli map has the
required universal property.  Do not install a topology or analytic structure on an orbit set
without constructing and proving the corresponding quotient property.

Acceptance is witnessed by line bundles, the trivial bundle, the zero-Higgs-field inclusion, and
the equality between gauge orbits and isomorphism classes for a fixed underlying smooth bundle.

## Sub-roadmap G: stable Higgs bundles and the Hitchin map

Specialize to a compact connected Riemann surface `X`.  Consume the degree, determinant, divisor,
and cohomological infrastructure of the Algebraic Curves and Jacobian Challenge roadmaps.  Build:

- rank, degree, slope, Higgs-invariant holomorphic subbundles, and stability, semistability, and
  polystability;
- Jordan--Hölder filtrations for semistable Higgs bundles and S-equivalence;
- boundedness and the construction of the coarse moduli space of S-equivalence classes of
  semistable Higgs bundles of fixed rank and degree, with the stable locus as a geometric quotient;
- the two-term deformation complex
  `End(E) → End(E) ⊗ K_X`, its hypercohomology, and the identification of infinitesimal
  automorphisms, tangent vectors, and obstructions;
- smoothness criteria at stable simple points, the expected dimension, and the natural holomorphic
  symplectic form on the smooth locus;
- characteristic coefficients of a Higgs field, the Hitchin base, and the Hitchin map;
- spectral curves in the total space of the canonical line bundle, the spectral correspondence on
  the locus where the spectral curve is smooth, and the description of Hitchin fibers by Picard
  varieties; and
- properness of the Hitchin map in the algebraic setting under the stated hypotheses.

The construction may use a GIT presentation or an equivalent analytic construction, but the chosen
route must build every quotient and representability input it uses or cite an explicit Tau Ceti
roadmap that owns it.  The public result must characterize the same coarse moduli problem and must
not expose presentation-dependent choices.

Acceptance is witnessed in rank one, where the Higgs moduli space is identified with the cotangent
bundle of the Picard variety and the Hitchin map is the projection to holomorphic one-forms, and on
the stable simple locus, where the deformation complex gives the stated tangent space and
symplectic pairing.

## Cross-cutting acceptance criteria

The roadmap is complete only when all of the following hold.

- Every public construction is compatible with restriction and pullback, and its local expression
  is related to the intrinsic definition by proved equivalences.
- Fiberwise algebra and section-level operations have extensionality, simp lemmas, and worked
  trivial-bundle examples sufficient to use them without unfolding local trivializations.
- The connection, curvature, Dolbeault, and Higgs sign conventions are fixed in theorem statements
  and agree across all subordinate roadmaps.
- Each quotient-like object states and proves its universal property.  Orbit sets, topological
  quotients, analytic spaces, schemes, and stacks remain distinct types of objects.
- The examples listed in each subordinate roadmap are formalized and exercise the public API.
- `lake exe cache get` and `lake build` succeed in the Tau Ceti roadmap repository for every
  accompanying prototype file, and the resulting Tau Ceti implementation builds at its pinned
  Mathlib revision.

## Roadmaps-for-roadmaps: adjacent geometric theories

The following subjects require roadmaps of their own.  Contributors should not attempt to infer
their statements from this section.  Their roadmaps consume the named interfaces here.

- A characteristic-classes roadmap consumes smooth bundle algebra, connections, curvature, and
  invariant-polynomial forms.
- A gauge-theory roadmap consumes bundle-valued forms, gauge actions, elliptic deformation
  complexes, and Sobolev completions that it must build.
- A variations-of-Hodge-structure roadmap consumes flat connections, holomorphic filtrations,
  period-domain points from the Hodge Structures roadmap, and Griffiths transversality expressed by
  the covariant exterior derivative.
- A Hitchin-equations and nonabelian-Hodge roadmap consumes stable Higgs moduli, Hermitian metrics,
  Chern connections, gauge theory, elliptic regularity, and harmonic-map analysis.
- A derived-moduli roadmap consumes the Higgs deformation complex and a separate derived and
  higher-categorical foundation.

## References

- S. Kobayashi, *Differential Geometry of Complex Vector Bundles*, for connections, curvature,
  holomorphic bundles, Hermitian metrics, and Chern connections.
- R. O. Wells, *Differential Analysis on Complex Manifolds*, for complex differential forms and
  Dolbeault calculus.
- N. Hitchin, "The self-duality equations on a Riemann surface", for stable Higgs bundles and the
  Hitchin system.
- C. Simpson, "Higgs bundles and local systems", for Higgs bundles, moduli, and deformation
  theory.
- P. Newstead, *Introduction to Moduli Problems and Orbit Spaces*, for the distinction between
  moduli functors, orbit spaces, and coarse moduli spaces.
- The Stacks Project, chapters on quotients, descent, and moduli, for the algebraic family-valued
  formulation.
