# Automorphic representations of `GL_n` and quaternionic inner forms

## Targets and boundary

This roadmap has two connected outputs. First, it builds reusable foundations for automorphic
representations of split `GL_n` over a number field, with `GL_n` as the principal concrete test of
every group-generic interface. Second, it builds the genuinely quaternionic material needed to
state the following target without undefined mathematical nouns or vacuous predicates.

> **Attached-system target.** Let `F` be a totally real number field, let `D` be a quaternion
> algebra over `F`, and let `π` be a cuspidal cohomological automorphic representation of
> `Dˣ(𝔸_F)` which is not a character factoring through reduced norm. There are a number field `E`,
> a finite set `S` of finite places containing every place where `D` is nonsplit or `π` is
> ramified, Hecke polynomials `P_v ∈ E[X]` for every `v ∉ S`, and a semisimple family of continuous
> two-dimensional representations
> `ρ_{p,φ} : Gal(F̄/F) → GL₂(Q̄_p)`, indexed by primes `p` and embeddings
> `φ : E → Q̄_p`, such that, for `v ∉ S` whose residue characteristic differs from `p`,
> `ρ_{p,φ}` is unramified at `v` and
> `charpoly(ρ_{p,φ}(Frob_v^arith)) = φ(P_v)`.

Thus `IsGoodPlace π D S v` means that `v ∉ S`, with the record carrying proofs that this entails
the split and unramified hypotheses needed to define the spherical operators. The condition that
`v` does not lie over `p` is separate because it depends on the member of the Galois family. At a
good place the normalization target is

```text
P_v(X) = X² - a_v X + N(v) s_v,
```

where `a_v` and `s_v` are the eigenvalues of the standard unnormalized spherical operators `T_v`
and `S_v`, the Haar measure gives the standard maximal compact subgroup volume one, and Frobenius
is **arithmetic** Frobenius. This is the convention in Taylor's Hilbert-modular formulation and in
the current FLT good-place compatibility predicate.

The endpoint is a *statement*, not its proof. In particular, this roadmap does not formalize
Jacquet--Langlands, construct the Galois representations, or prove local--global compatibility.
Everything needed to typecheck every term and hypothesis above is in scope.

### One roadmap, three automorphic tracks

```text
shared automorphic foundations
          │
          ├── split GL_n ───────────┐
          │                         │
          └── quaternionic Dˣ ──────┼──▶ attached-system target
                                    │
local Galois/compatible systems ────┘
```

The shared track owns smooth and admissible representations, Harish--Chandra modules, automorphic
forms, relative Lie-algebra cohomology, restricted tensor products, and the abstract-to-convolution
Hecke interface. The split track owns `GL_n` points, standard compact subgroups and parabolics,
principal series, archimedean instances, and Satake theory. The quaternionic track owns quaternion
algebras, orders and ramification, reduced norm, `ℍˣ`, the restricted-product topology, and
independence of splittings. The target uses the shared track, the `n=2` split instance at good
places, and the quaternionic track.

This is deliberately **not** a roadmap for every inner form `GL_m(D)` of every `GL_n`. Definitions
should be parametrized generally when that costs nothing, and APIs must not obstruct that later
extension, but arbitrary-degree central simple algebras, flags of right `D`-spaces, and
`GL_m(ℍ)` are not completion requirements here. Likewise Whittaker theory, multiplicity one,
Rankin--Selberg, Godement--Jacquet, Eisenstein/spectral decomposition, and local or global
Jacquet--Langlands are successor roadmaps. Their analytic prerequisites—additive characters,
Schwartz--Bruhat spaces, Poisson summation, reduction theory, and rapid decay—are not smuggled into
the foundations below.

## Decisions pinned here, and decisions needing sign-off

1. Shared definitions are group-generic; split `GL_n` is their primary concrete instance and
   quaternionic `Dˣ` is a sibling instance, not an encoding of `Dˣ` as `GL₂` at ramified places.
2. A quaternion algebra means a four-dimensional central simple algebra, not a Hilbert-symbol
   presentation.
3. Global automorphic representations are bundled irreducible admissible subquotients of the
   algebraically defined cuspidal automorphic space. Their local restricted-tensor-product data and
   occurrence witness are fields, so the definition does not invoke an unstated Flath theorem.
4. Cohomological means nonvanishing relative Lie-algebra cohomology with a finite-dimensional
   algebraic coefficient representation.
5. Good-place compatibility records common Frobenius polynomials outside a named finite set. The
   representations live over `Q̄_p`, indexed by `E → Q̄_p`, and need not descend to `GL₂(E_λ)`.
6. The Galois family is semisimple and uses arithmetic Frobenius.

Three points still need expert sign-off before the attached-system declaration is frozen.

- **SIGN-OFF A — cuspidality and one-dimensional representations.** For split `D`, the intended
  theorem uses cuspidal representations. For division `D`, there are no proper `F`-parabolics, so
  the standard constant-term predicate is vacuous and still includes `χ ∘ Nrd`. The provisional
  target requires both cuspidality and “not a reduced-norm character.” Confirm that scope or state
  the larger character/Eisenstein conclusions separately.
- **SIGN-OFF B — cohomological normalization.** For `GL_n`, a C-algebraic representation is moved
  to the L-algebraic normalization by the norm twist `|det|^{(n-1)/2}`; its exponent is
  half-integral exactly when `n` is even. For the quaternionic inner form of `GL₂`, determinant is
  replaced by reduced norm. The displayed polynomial follows Taylor's classical `T_v,S_v`
  convention. Confirm that the chosen `W` versus `W^∨`, central character, the `|Nrd|^{1/2}`
  normalization, Satake normalization, and reciprocity convention produce exactly that polynomial.
  The relative pair itself is pinned to the full Lie algebra and a genuine maximal compact, without
  adjoining the split real center.
- **SIGN-OFF C — strength of compatibility.** Carayol proves strict compatibility with local Weil
  representations, while the FLT predicate asks only for good-place characteristic polynomials.
  Some modern uses of “weakly compatible” also require de Rham/crystalline and Hodge--Tate data.
  This roadmap uses the narrower `GoodPlaceCompatible`; stronger meanings require further layers.

## Ground floor: existing material and coordination

Before claiming work in a layer, recheck Mathlib, Tau Ceti, the FLT repository, and linked open
work. APIs in this area are moving.

Mathlib supplies matrix general linear groups, number fields and their adèle rings, restricted
products, completions, Haar measure, absolute Galois groups, algebraic closures of `ℚ_p`, ordinary
representation theory, universal enveloping algebras, and manifolds on units of suitable normed
algebras. It does not yet supply the smooth/automorphic stack, relative `(𝔤,K)`-cohomology, the
quaternionic arithmetic interfaces, local Galois inertia/Frobenius, or compatible systems required
here.

The [Modular Forms roadmap, PR #47](https://github.com/TauCetiProject/TauCetiRoadmap/pull/47)
owns the integral abstract double-coset Hecke ring at general `GL_n`, including the local--global
comparison of structure constants and localization at the central coset. After it merges, its
[Layer 2](../ModularForms/README.md#layer-2-hecke-operators-and-the-hecke-algebra) is an explicit
input to Layer 6 below. At this repository's current Mathlib pin, `NumberTheory/HeckeRing` is not
yet present: the roadmap PR follows the Mathlib #41251 and #41253--#41328 stack. Until compatible
code lands and the pin advances, this is a planned dependency rather than a compiled foundation.

The [reductive-groups roadmap](../ReductiveGroups/README.md) supplies affine group schemes, Hopf
algebras, algebraic representations, and Lie algebras. Consume only landed interfaces and do not
create a second representation/comodule dictionary. General affine analytification
([mathlib4#34626](https://github.com/leanprover-community/mathlib4/pull/34626)) is important but not
on this target's critical path: matrix groups and units of finite-dimensional real algebras have
concrete topological and manifold routes. The convolution source from
[mathlib4#39281](https://github.com/leanprover-community/mathlib4/pull/39281) is present at the pin
but uses `suppress_compilation`; it is not a compiled foundation. Also coordinate with the
quaternion reorganization [mathlib4#41538](https://github.com/leanprover-community/mathlib4/pull/41538)
and finite-dimensional general-linear-group work
[mathlib4#40380](https://github.com/leanprover-community/mathlib4/pull/40380).

FLT contains substantial prototypes. **Tau Ceti must never import FLT.** Migrate only through
self-contained Tau Ceti PRs, preserving attribution and Apache-2.0 notices, then change FLT to
consume the Tau Ceti API. The provenance table is a coordination aid, not the final namespace plan.

### Exact reuse map from other Tau Ceti roadmaps

These are interface dependencies, not dependencies on completion of an entire roadmap.

| Existing roadmap target | Consumed here | Work still owned here |
|---|---|---|
| [Modular Forms, PR #47](https://github.com/TauCetiProject/TauCetiRoadmap/pull/47), [Layer 2](../ModularForms/README.md#layer-2-hecke-operators-and-the-hecke-algebra): abstract Hecke triples/rings, the integral `GL_n` diagonal-coset calculation, the `ℤ_p/ℚ_p` local comparison, and localization at the central coset | the abstract basis and multiplication and the rational-prime worked model | extension to arbitrary `𝒪_v/F_v`, locally constant convolution, Haar and opposite-ring conventions, normalized Satake, and adelic actions |
| [Semisimple algebras, Layer 4](../RepresentationTheory/SemisimpleAlgebras/README.md#layer-4-central-simple-algebras-and-their-tensor-products): central simple algebras, tensor products, degree | intrinsic `IsQuaternionAlgebra`, scalar-extension dimension and simplicity | reduced trace/norm, involution, local ramification, and the quaternion split/division API |
| [Semisimple algebras, Layers 5--6](../RepresentationTheory/SemisimpleAlgebras/README.md#layer-5-skolem-noether-and-the-centralizer-theorem): Skolem--Noether, base change, splitting fields, `ℍ` | independence up to inner conjugacy of chosen splittings `D_v ≃ M₂(F_v)`; real split/ramified examples | compatible topological and integral local models and their Hecke comparisons |
| [Reductive groups, Layer 0](../ReductiveGroups/README.md#layer-0-the-functor-of-points-and-the-three-way-dictionary): Hopf algebra ↔ affine group scheme ↔ functor of points, and base change | the synchronized models for split `GL_n` and `Dˣ` | concrete local/adèlic points, determinant/reduced-norm localization, and comparison with units |
| [Reductive groups, Layer 1](../ReductiveGroups/README.md#layer-1-representations--comodules): finite-dimensional comodules and algebraic representations | later comparison with the explicit coefficient systems used here | explicit highest-weight systems are the critical-path definitions, so the unlanded comodule comparison is not a blocker |
| [Reductive groups, Layer 2](../ReductiveGroups/README.md#layer-2-lie-algebra-and-the-adjoint-representation): algebraic `Lie(G)` and `Ad` | comparison with the Lie algebra of real/complex matrix groups and quaternion units | analytic differentiation for the concrete groups |
| [Lie groups, Layers 0--2](../RepresentationTheory/LieGroups/README.md#the-build-in-layers): units of normed algebras, tangent Lie algebra, `Ad`, and the closed-subgroup theorem | `GL_n(ℝ)`, `GL_n(ℂ)` as a real group, `D_vˣ`, and differentiated actions | the standard maximal compacts `O(n)`, `U(n)`, and `Sp(1)`, with their comparison and conjugacy lemmas |
| [Lie groups, Layer 5](../RepresentationTheory/LieGroups/README.md#layer-5-simply-connected-covers-and-the-enveloping-algebra): universal enveloping algebra and PBW | the `U(𝔤_ℂ)` action on a Harish--Chandra module | `K`-finite compatibility and relative `(𝔤,K)` cohomology |
| [Lie groups, Layer 9](../RepresentationTheory/LieGroups/README.md#layer-9-the-cartan-iwasawa-and-kak-decompositions): Cartan involution, Iwasawa, and the compact factor `K` | the general real-reductive interface | concrete Gram--Schmidt/Iwasawa results for matrix groups and quaternion units may land earlier |
| [Compact groups, Layers 0--2](../RepresentationTheory/CompactGroups/README.md#the-build-in-layers): normalized Haar measure, unitarization, complete reducibility | finite-dimensional `K_v`-types and invariant complements | locally finite `K_v`-actions and their compatibility with the noncompact Lie algebra |
| [Lie highest weight, Layers 7 and 9](../RepresentationTheory/LieHighestWeight/README.md#layer-7-the-center-of-ul-and-harish-chandra-freudenthal-and-serres-relations): `Z(U(𝔤))`, Harish--Chandra isomorphism, reductive `gl_n` weights | the center acting in the `Z(𝔤_ℂ)`-finite condition and split archimedean weight calculations | infinite-dimensional Harish--Chandra modules |
| [Classical groups, Layers 0--3](../RepresentationTheory/ClassicalGroups/README.md#the-build-in-layers): algebraic `GL_n` representations and highest weights | split coefficient systems and the `n=2` systems transported to quaternionic groups over `ℂ` | archimedean tensor products, rational structures, and independence of quaternion splittings |

The representation-theory index explicitly stops before infinite-dimensional representations of
noncompact groups. Its induction/restriction roadmap is for finite groups. Consequently smooth
induction, admissibility, Harish--Chandra modules, and automorphic spaces are not silently delegated
there: Layers 2--5 below own them for both tracks. Conversely, this roadmap reuses its algebraic,
compact, and Lie-group interfaces rather than rebuilding them.

Finite-separable Weil restriction belongs to the relative theory in the reductive-groups roadmap
and is too large a prerequisite for the attached-system target. Split coefficient systems are
constructed from `GL_n` highest weights; quaternionic systems use the `n=2` construction after a
complex splitting and prove independence by Skolem--Noether. Once Weil restriction and comodules
land, their comparison belongs at the boundary between the roadmaps; no definition here waits for it.

### Dependency-closure audit

A reference to another roadmap means **landed Tau Ceti code implementing the cited target**, not the
mere existence of that roadmap. If that code has not landed, the contributor must claim the cited
target separately or coordinate a prerequisite PR. No PR against this roadmap may hide a new local
notion behind an implementation detail just because the corresponding prerequisite is still absent.

The following table is the step-by-step entry contract. The last column records prerequisites that
are easy to skip over; they have been promoted to explicit work in the layer descriptions below.

| Layer | Inputs that must already compile | Formerly hidden work explicitly owned by this roadmap |
|---|---|---|
| 0 | Mathlib matrix groups, number fields, completions and tensor products; cited central-simple-algebra targets | standard `GL_n` parabolics and integral models; reduced characteristic polynomial/trace/norm, quaternion involution, local splitting, ramification and finiteness of the ramified set |
| 1 | Layer 0; landed reductive-group interfaces; Mathlib adèles and restricted products | local and adelic `GL_n` with standard compact opens; finite-dimensional scalar-extension topologies; the idelic topology on quaternionic units; noncommutative orders, completions, compact opens and congruence bases |
| 2 | Layer 1 locally profinite groups; Mathlib invariant submodules | the shared smooth-representation category and exact operations, normalized induction with its modulus character, smooth dual, and restricted tensor products carrying spherical data |
| 3 | Layer 1 archimedean groups; cited Lie/compact-group targets | shared Harish--Chandra pairs/modules, analytic-versus-algebraic Lie comparisons, differentiation, disconnected maximal compacts, and explicit `O(n)`, `U(n)`, `Sp(1)` instances |
| 4 | Layers 0--3 | a shared automorphic-function space; right differential operators; a height seeing both `g` and `g⁻¹`; parabolic constant terms and compact quotient measures; the algebraic cuspidal space; occurrence witnesses without exhaustiveness claims |
| 5 | Layers 0, 1, 3, 4; `gl_n` highest weights; Mathlib chain complexes and alternating maps | full Chevalley--Eilenberg signs, relative cochains for disconnected `K`, split `GL_n` coefficient systems, quaternionic splitting independence, cohomology and Künneth comparisons |
| 6 | Layers 1, 2, 4; Modular Forms Layer 2 once landed; Mathlib Haar measure | extension of its `ℤ_p/ℚ_p` model to every `𝒪_v/F_v`; comparison with convolution (including inverse/opposite conventions); varying-level actions; general `GL_n` Cartan/Satake with exact `q_v` powers; the spherical-line theorem; quaternionic comparison; and a nonvacuous rationality model |
| 7 | Mathlib absolute Galois groups, completions, module topology and `Q̄_p` | chosen embeddings of algebraic closures, local-to-global maps, inertia/Frobenius exact sequences, independence of Frobenius lifts, continuity of matrix realizations, and basis-independent characteristic polynomials |
| 8 | Layer 7 | finite-place/residue-characteristic bookkeeping, monic exact-degree common polynomials, coefficient-field enlargement/equivalence, and semisimplicity as a predicate rather than an assumed semisimplification construction |
| 9 | Layers 4, 5, 6, 8 | one declaration joining the actual automorphic model, coefficient system, Hecke rationality model, and compatible family; no proxy predicates |

Each layer PR states which row inputs it consumes and demonstrates the named constructions with the
layer's acceptance examples. Discovering another missing prerequisite requires a roadmap amendment
or an explicitly linked prerequisite target before implementation continues; it is not left as
unreviewed contributor glue.

## Dependency graph

```text
0 conventions and algebraic input
             │
             ├──▶ 1G split GL_n local/adelic ──┐
             │                                  ├──▶ 2 shared smooth representations
             └──▶ 1D quaternion local/adelic ──┘
                         │                                  │
                         └────▶ 3 shared archimedean ◀─────┘
                                          │                 │
                                          └──▶ 4 automorphic forms
                                                     │
                                             ┌───────┴───────┐
                                             ▼               ▼
                                      5 cohomological   6 GL_n Satake /
                                                           Dˣ Hecke

7 local Galois theory ──▶ 8 good-place compatible systems

             4 automorphic + 5 cohomological + 6 Hecke + 8 Galois ──▶ 9 statement
```

The `1G` and `1D` tracks run in parallel and meet only through shared interfaces and explicit split
comparisons. Layers 2 and 3 can also advance in parallel once their concrete groups exist. Layer 4
consumes both; Layer 5 consumes Layers 3--4; Layer 6 can begin with the split `GL_n` and abstract
Hecke inputs, while its `π`-attached rationality interface consumes Layer 4. Layers 7--8 are
independent. Layer 9 starts only when all four incoming interfaces have executable examples and
stable names.

## Layer 0: conventions and algebraic group inputs

### 0.1 Split `GL_n`

For a positive natural number `n`, synchronize the concrete matrix group, the units of the matrix
algebra, the determinant-localized affine group scheme, and the functor of points. Use Mathlib's
`Matrix.GeneralLinearGroup`; do not create a second `GL_n`. Build the exact input later layers use:

- base change over a commutative algebra and comparison between `GL_n(R)` and `(M_n(R))ˣ`;
- determinant, inverse, center, scalar matrices, diagonal torus, upper-triangular Borel, and their
  behavior under base change;
- standard parabolics indexed by compositions of `n`, their block Levi factors and unipotent
  radicals, inclusions under refinement, and conjugacy with parabolics of `GL_n` over a field;
- the maximal-parabolic criterion for cuspidality: a constant term along an arbitrary proper
  standard parabolic factors through one along a containing maximal standard parabolic;
- the standard integral model `GL_n(𝒪_v)` inside `GL_n(F_v)` and its principal-congruence
  subgroups, with no choice of basis beyond the defining `Fin n` matrix coordinates;
- a faithful representation and a height input which later sees both a matrix and its inverse.

The combinatorics of compositions, block matrices, dominant coweights, and the dominance order are
shared with Cartan and Satake theory in Layer 6. They are implemented once, not separately for
parabolics and double cosets. General parabolic conjugacy must not be assumed merely because the
standard representatives have been defined.

### 0.2 Quaternion algebras

Introduce `IsQuaternionAlgebra F D` as the proposition that `D` is a central simple `F`-algebra of
rank four. Establish the complete elementary API rather than tying the notion to one use:

Keep this as an explicit predicate or hypothesis, not a typeclass which tries to export
`IsSimpleRing D`: Mathlib's central-algebra documentation explains that the center field `F` cannot
be inferred from `D`, so such instance search is ill-founded. Theorems which need centrality,
simplicity, or finite-dimensionality take Mathlib's separate hypotheses or install them locally
from an explicit proof.

- finite-dimensionality and `finrank F D = 4`;
- center and scalar-map lemmas, opposite algebra, and transport across algebra equivalence;
- scalar extension, with the required finite-dimensional and central-simple hypotheses stated
  accurately;
- the reduced characteristic polynomial for a central simple algebra, then reduced trace, reduced
  norm, the degree-two standard involution, and their compatibility with algebra equivalence and
  scalar extension; these are new targets, not consequences obtained by unfolding `Matrix.det`;
- the split/division dichotomy and the equivalence between splitting and an algebra equivalence
  with `M₂(F)`;
- scalar extension along a number-field embedding into each finite or infinite completion, with a
  named local quaternion algebra independent of tensor-factor order;
- ramification at real and finite places; an arithmetic order/discriminant or equivalent spreading-
  out argument proving that the finite ramified set is finite, rather than assuming “almost all”;
- concrete comparisons with Mathlib's quaternion/Hilbert-symbol presentations.

Coordinate the concrete comparison work with the active Mathlib quaternion PRs. The intrinsic notion
belongs in Tau Ceti until Mathlib accepts an equivalent definition; downstream code must depend on
the intrinsic interface, not on its temporary location.

The quaternionic part is closed only when scalar extension applies to `F_v`, reduced norm detects
units, the split comparison produces `M₂(F_v)` with reduced norm equal to determinant, and a finite
set containing every nonsplit finite place is available to Layer 1. The whole layer closes when the
split `GL_n` parabolics and integral models use the same matrix-group API consumed by Layers 1, 4,
and 6.

### 0.3 Global conventions

Create one documented namespace for conventions used by every later layer:

- arithmetic Frobenius;
- geometric Artin reciprocity or arithmetic Artin reciprocity, chosen so its relation to arithmetic
  Frobenius is a named theorem;
- Haar normalization `vol(K_v)=1` at unramified finite places;
- left versus right actions (automorphic forms use right translation);
- normalized versus unnormalized induction and Satake transforms;
- for normalized Satake over `ℂ`, the positive square root of the residue cardinality; over a
  general coefficient ring, the chosen square root or coefficient extension is explicit;
- `T_v`, `S_v`, and `X²-a_vX+N(v)s_v`;
- the relative-cohomology pair uses the full real Lie algebra and a genuine maximal compact `K_v`
  (`O(n)` for `GL_n(ℝ)`, `U(n)` for `GL_n(ℂ)`, and `Sp(1)` for `ℍˣ`), without adjoining the real
  split center to `K_v`;
- embeddings of the rationality field into `ℂ` and `Q̄_p`.

Later acceptance tests enforce these conventions without assuming an unbuilt classical-to-adèlic
dictionary: Layer 6 computes the Satake parameters of an explicit `GL_n` principal series and its
`n=2` polynomial, and Layer 8 proves that the cyclotomic family has polynomial `X-N(v)`. The latter
is the Frobenius-direction test; replacing arithmetic by geometric Frobenius makes it fail.

## Layer 1: split `GL_n` and quaternionic groups locally and adelically

### 1G. Split `GL_n`

For every finite place `v`, construct `GL_n(F_v)` as a locally compact totally disconnected group
with standard compact open `GL_n(𝒪_v)` and a neighborhood basis of principal-congruence subgroups.
Then build:

- the finite adèlic group as the restricted product of `GL_n(F_v)` with respect to
  `GL_n(𝒪_v)`, and its homeomorphic comparison with units of the matrix algebra over the finite
  adèles; this comparison must track the topology on units through both `g` and `g⁻¹`;
- the full `GL_n(𝔸_F)`, its finite/infinite product decomposition, diagonal embedding of
  `GL_n(F)`, global-to-local maps, center, determinant, and quotient topologies;
- closedness and discreteness of the rational diagonal, and the measurable quotient structures
  needed for automorphic forms;
- local and adèlic points of the standard parabolics, Levis, and unipotent radicals from Layer 0,
  including the compact quotient `U_P(F)\U_P(𝔸_F)` and its probability Haar measure;
- comparison of the restricted-product construction with the functor of points of the determinant-
  localized affine group scheme, without waiting for general scheme analytification.

At archimedean places, construct `GL_n(ℝ)` and `GL_n(ℂ)` (the latter as a real Lie group) from
matrix-algebra units. Their detailed maximal compact and Lie interfaces belong to Layer 3.

### 1D. Quaternionic `Dˣ`

For every `F`-algebra `R`, define the functor of points as `(R ⊗[F] D)ˣ` and reconcile it with the
affine group scheme represented by localization of the coordinate algebra at reduced norm. Build:

- finite free affine space attached to `D`, the polynomial law representing reduced norm, its
  coordinate-ring localization, the resulting Hopf operations, and only then the coordinate Hopf
  algebra/functor-of-points equivalence for `Dˣ` and base change;
- the diagonal algebra map and induced group map `Dˣ → (𝔸_F ⊗[F] D)ˣ`, with injectivity;
- a canonical topology on `R ⊗[F] D` when `R` is a local completion or an adèle ring, constructed
  from finite-dimensional coordinates and proved independent of a basis; continuity of algebra
  operations and, for each local factor, openness of the unit group;
- the global group `Dˣ(𝔸_F)`, algebraically identified with the units of the adelic scalar extension
  but equipped with the **idelic restricted-product topology**, not automatically with the subspace
  topology from the adèle algebra; compare it with Mathlib's topology on `Rˣ` induced by
  `u ↦ (u,u⁻¹)` and upgrade `RestrictedProduct.unitsEquiv` from a multiplicative equivalence to the
  needed homeomorphic group equivalence; construct its finite and infinite factors;
- local groups `D_vˣ` at every finite and infinite place, their topologies, local compactness at
  finite places, and the global-to-local projections;
- orders in a finite-dimensional noncommutative `F`-algebra, existence of global maximal orders,
  localization and completion of orders, local conjugacy of maximal orders over a nonarchimedean
  local field, their unit groups as compact opens, and a neighborhood basis of congruence subgroups;
- at a split finite place, a chosen-independent comparison with `GL₂(F_v)` and with
  `GL₂(𝒪_v)` for unramified integral data; use Skolem--Noether to show changes of splitting act by
  inner conjugation;
- the fact that only finitely many places are ramified, so the restricted product is based at the
  standard compact subgroup almost everywhere; prove that changing the global maximal order changes
  only finitely many local compact opens and gives the same restricted-product topology;
- the center `𝔸_Fˣ → Dˣ(𝔸_F)`, the quotient by `Dˣ(F)`, and the quotient modulo the center used in
  growth and volume statements, including closedness/discreteness of the diagonal rational points
  and the resulting quotient topologies and measurable structures;
- the proper `F`-parabolics and unipotent radicals needed for cuspidality: prove there are none when
  `D` is division, and transport the standard Borel/unipotent description through a splitting when
  `D ≃ M₂(F)`, independently of that splitting.

At an infinite place, equip `F_v ⊗[F] D` with a finite-dimensional real normed-algebra structure and
use the left regular representation to construct a submultiplicative norm. Its units are an open
submanifold of the underlying finite-dimensional real vector space. Prove that the resulting smooth
and Lie-group structures are independent of the auxiliary norm and agree with `GL₂(ℝ)` at split
real places and `ℍˣ` at ramified real places. This concrete path is the reason general scheme
analytification is not a blocker.

Acceptance examples are split `GL_n` for general positive `n`, `F=ℚ,D=M₂(ℚ)`, and a totally
definite quaternion division algebra. Layer 1 closes only when the finite local and finite adèlic
groups in both tracks are locally compact totally disconnected topological groups, their standard
compact opens form the restricted-product data, `D=M₂(F)` agrees with the `GL₂` construction, and
Layers 2 and 4 can use quotient and parabolic objects without choosing bases, orders, or splittings
afresh.

## Layer 2: smooth admissible representations at finite places

Build the algebraic definitions for a locally profinite group `G` over a field `k`, and use `k=ℂ`
for the automorphic tracks. Every Schur-lemma, central-character, or multiplicity-one theorem states
the algebraic-closure/cardinality hypotheses it actually needs; characteristic zero alone is not a
substitute. Build:

- an unbundled Mathlib-compatible locally profinite hypothesis, compact-open subgroups, and for the
  groups of Layer 1 the required compact-open neighborhood basis; do not introduce a second
  topological-group hierarchy;
- smooth vectors and smooth representations: every vector is fixed by an open subgroup;
- the category of smooth representations, fixed-vector submodules `V^K`, restriction,
  intertwiners, kernels, images, subrepresentations, quotients, and exactness properties needed for
  subquotients;
- admissibility: `V^K` is finite-dimensional for every compact open `K`;
- irreducibility and semisimplicity interfaces using Mathlib's representation vocabulary;
- smooth induction and compact induction as equivariant function spaces, including support modulo a
  subgroup, translation actions, transitivity, and Frobenius reciprocity; the finite-group induction
  roadmap supplies patterns but not these objects;
- the smooth contragredient (smooth vectors in the algebraic dual), central characters, twists, and
  restricted tensor products of representations with specified spherical vectors at almost every
  place;
- a bundled restricted-tensor-product representation carrying its local components and
  unramified/spherical vectors at almost every place, with change-of-spherical-vector and
  isomorphism laws.

Do not encode smoothness as continuity of an action on a discrete vector space unless the exact
equivalence has been proved. Use Mathlib's invariant-submodule construction after restricting to a
subgroup, rather than introducing a second notion of fixed vectors.

Test the API on characters, finite-dimensional representations of compact groups, normalized and
unnormalized principal series of `GL_n(F_v)`, their `n=2` transport to split `D_vˣ`, and
representations of division `D_vˣ`. Parabolic induction carries the explicit modulus character and
chosen square root and proves the smoothness/admissibility statements it uses. For division
`D_vˣ`, “irreducible representations are finite-dimensional” is a theorem only after the required
admissibility and central-character/Schur hypotheses are available; it is not built into the
definition merely because `D_vˣ` is compact modulo center.

The Bernstein--Zelevinsky classification, Jacquet-module exactness, distributions on ℓ-spaces, and
Gelfand--Kazhdan theory are not used by the attached-system statement. Do not take them as unnamed
black boxes. They belong to later local-representation or Whittaker roadmaps if a downstream theorem
needs them.

Layer 2 closes when the examples, subquotients, smooth duals, normalized induction, and restricted
tensor products use one common category. The spherical fixed-line theorem is deferred to Layer 6,
where its Cartan/Satake proof lives.

The general Flath factorization theorem—from an abstract irreducible admissible representation of a
restricted product to local factors—is not needed to type the target and is outside this statement
roadmap. Layer 4 defines an automorphic representation with its local restricted-tensor-product data
and occurrence witness together. A future local--global-compatibility roadmap may prove that this
bundling is equivalent to starting from an abstract global constituent.

## Layer 3: the shared archimedean `(𝔤,K)` interface

Develop Harish--Chandra pairs and modules once, then instantiate them for `GL_n(ℝ)`, `GL_n(ℂ)`
treated as a real group, and the two quaternionic groups `GL₂(ℝ)` and `ℍˣ`. For each infinite
place construct the complexified Lie algebra, use the Layer 0 maximal-compact convention, and prove
independence under conjugacy:

- comparison between the algebraic Lie algebra from reductive-groups Layer 2, the tangent Lie
  algebra of the real unit group, and its scalar extension to `ℂ`;
- explicit maximal compacts `O(n) ⊆ GL_n(ℝ)`, `U(n) ⊆ GL_n(ℂ)`, and
  `Sp(1) ⊆ ℍˣ`, their closed Lie-subgroup structures, maximality, and conjugacy of choices; retain
  component-group data because `O(n)` may be disconnected;
- differentiation of finite-dimensional continuous `K_v`-representations, including automatic
  smoothness, functoriality, and agreement with the Lie algebra of the closed subgroup;
- a Harish--Chandra pair and its module category: a complex `𝔤_v`-module and a locally finite
  `K_v`-action, meaning every vector lies in a finite-dimensional continuous `K_v`-stable subspace;
  do not silently put an unspecified topology on the whole algebraic module;
- both compatibility axioms: the differentiated `K_v`-action agrees with the restricted
  Lie-algebra action, and conjugating the `𝔤_v`-action by `k` agrees with `Ad(k)`;
- `K_v`-finite vectors, the universal-enveloping-algebra action, and the action of its center;
- finite generation over `U(𝔤_v)`, finite multiplicity of irreducible `K_v`-types, and the standard
  admissibility conditions, with subobjects, quotients, tensor products by finite-dimensional
  modules, contragredients, and equivalences under conjugate choices of `K_v`;
- finite products over all archimedean places and compatibility with algebraic representations.

This layer should consume the Lie group and universal-enveloping-algebra work in the representation-
theory roadmap. Concrete matrix and quaternion unit groups are mandatory tests; the API must not
assume every maximal compact group is connected, and the noncompact center is retained explicitly.
Casselman--Wallach globalization, continuous Fréchet contragredients, the unitary dual, and
Harish--Chandra's admissibility theorem for irreducible unitary representations are outside this
algebraic layer. They must be added as named analytic prerequisites before any later roadmap uses
them.

Layer 3 closes only when the `(𝔤,K)` modules attached to the archimedean action on automorphic
functions can be constructed in Layer 4, and relative cochains can restrict their actions without
additional differentiation or globalization machinery.

## Layer 4: automorphic forms and automorphic representations

Define the shared automorphic-form interface for a concrete adelic group equipped with rational
points, center, archimedean Lie data, parabolics, and a height. Instantiate it for `GL_n` and
quaternionic `Dˣ`; do not write two definitions which merely happen to have the same fields. The
standard conditions are real predicates:

- the ambient function space: smooth in the archimedean variables and locally constant in the
  finite-adèlic variable, with a proved equivalence to invariance under some compact open at the
  finite part;
- left invariance by the diagonal rational points;
- the differentiated right action of `𝔤_ℂ` and `U(𝔤_ℂ)` on that function space, compatibility with
  right translation, and `K_∞`-finiteness;
- `Z(𝔤_ℂ)`-finiteness, pinned as annihilation by a finite-codimensional ideal (and compared with a
  finite-dimensional center orbit under the hypotheses where they agree);
- a basis-independent adelic height from a faithful representation which sees both `g` and `g⁻¹`,
  comparison of two choices, quasi-submultiplicativity with its archimedean constants retained, and
  moderate growth in that height on the quotient modulo center; determinant and reduced norm alone
  are not heights because they miss directions such as `diag(t,t⁻¹,1,…)`;
- a continuous central character on `Fˣ\𝔸_Fˣ` and its transformation law where one is specified;
- Haar measure on each compact quotient `U_P(F)\U_P(𝔸_F)`, including a filtration of `U_P` by
  additive quotients, the cocompactness theorem ultimately reduced to `F\𝔸_F`, and the Fubini and
  quotient-measure comparisons which make iterated constant terms agree; define the integral and
  prove independence of Haar normalization for its vanishing;
- cuspidality as vanishing along every proper parabolic, with the maximal-standard-parabolic
  criterion for `GL_n` proved from factorization of constant terms;
- determinant characters `χ ∘ det` for `GL_n` and reduced-norm characters `χ ∘ Nrd` for `Dˣ` as
  separately recognized one-dimensional automorphic representations.

Construct the right regular action and prove that it preserves every condition. For split `GL_n`,
prove that the concrete block-unipotent integrals are the constant terms attached to the Layer 0
parabolics. For `Dˣ`, prove the expected simplifications rather than baking them into the shared
definition: cuspidality is vacuous when `D` is division; in the split case the constant term is the
usual `GL₂` upper-unipotent integral and is independent of the splitting.

Use the algebraic space of `K_∞`- and center-finite cuspidal automorphic forms. Define the cuspidal
automorphic space as its finite-adèlic representation together with its
archimedean `(𝔤,K)` action. Do not appeal to a Hilbert-space direct-integral or spectral-decomposition
theorem that has not been built; an `L²` comparison may be proved later as a separate interface.
In particular, make no assertion that the discrete spectrum is only cuspidal representations plus
characters: residual representations already invalidate that pattern in higher rank. Eisenstein
series, residual spectra, rapid decay, finite covolume, and spectral decomposition are out of scope.

An automorphic representation is bundled as commuting archimedean Harish--Chandra and finite-
adèlic restricted-tensor-product actions, irreducible and admissible in that product category,
together with a subquotient witness in this space. Thus its local components are data, not the
output of an unstated Flath theorem. Keep the witness: later theorems need to transport Hecke
eigenvalues and cohomology along it. Define isomorphisms of these bundles and prove independence of
the chosen occurrence model. This bundling does **not** prove that such objects exhaust all
irreducible constituents, nor may admissibility be inferred from the proposed local factors without
the relevant finiteness theorem. Those comparisons require Flath and Harish--Chandra results and
belong to a later roadmap.

**SIGN-OFF A occurs here.** Keep `IsCuspidal` as the standard constant-term predicate and keep
`IsReducedNormCharacter` separate. If the target is to include reduced-norm characters,
noncuspidal discrete constituents, or Eisenstein constituents, introduce those spectra distinctly
and state their reducible conclusions. Do not redefine “cuspidal” case-wise to conceal the
anisotropic phenomenon, and do not silently broaden `IsAutomorphic`.

Tests:

- `GL₁` recovers algebraic Hecke characters at the level of definitions;
- for general `n`, the standard parabolics give the usual `GL_n` constant terms;
- when `D=M₂(F)`, compare the quaternionic definitions with the same `GL₂` interfaces, rather than
  with a second copy of them;
- when `D` is totally definite, identify fixed-level weight-two forms with functions on the finite
  double quotient and recover the current FLT-style model after migration;
- check that right translation, central character, and local-component conventions agree in both
  examples.

### Inhabitation track

Before the attached-system target is accepted, construct one non-character object satisfying its
automorphic hypotheses. Use Mathlib's nonzero weight-12 modular discriminant and the theorem that
the level-one weight-12 cusp-form space has rank one. Build, rather than assume, the required bridge:

- additive strong approximation for `F ⊂ 𝔸_F^S`, strong approximation for `SL₂`, and the separate
  determinant fibration over the idele class group needed for the classical-to-adèlic quotient at
  level `GL₂(ℤ̂)`; strong approximation for `SL₂` alone is not the dictionary;
- adelization of the discriminant, with classical cusp decay implying the adelic constant-term
  condition and weight 12 giving the archimedean `K`-type;
- the commuting finite-adèlic and archimedean actions generated by this form, an irreducible
  admissible restricted-tensor-product subquotient, and proof that it is not a determinant/reduced-
  norm character.

Layer 5 then proves this representation cohomological in the expected degree. This track is an
inhabitation proof, not the normalization test of Layer 6, and every bridge named above is part of
the work; the existence of a classical cusp form alone does not manufacture an automorphic
representation.

Do not reuse this strong-approximation argument for a totally definite quaternion norm-one group:
its archimedean factors are compact and the relevant strong approximation statement fails. The
finite double-coset model there instead uses compactness modulo center.

Layer 4 closes only when the same automorphic-form structure works for split `GL_n` and `Dˣ`, its
constant terms are actual integrals, the Layer 2 and Layer 3 actions are defined, and an occurrence
witness transports local components and Hecke actions without a new choice of model. No closure
criterion invokes reduction theory, rapid decay, an `L²` decomposition, or exhaustiveness.

## Layer 5: relative Lie-algebra cohomology and “cohomological”

Mathlib presently has only low-degree Lie cochains, not the required theory. Build the full
Chevalley--Eilenberg theory from Mathlib's alternating maps/exterior powers and homological algebra:
the graded cochain objects, all sign and reindexing lemmas, the differential with proved `d²=0`, the
bundled cochain complex, cocycles/coboundaries/cohomology, functoriality, long exact sequences, and
comparison with the existing degree-zero/degree-one API. Then construct relative
`(𝔤,K)`-cohomology, including:

- the `K`-action on `𝔤/𝔨`, exterior powers, and Hom spaces, and relative cochains as invariants; for
  disconnected `K`, invariance is under the whole group while the differential uses its Lie algebra;
- the relative differential, its preservation of `K`-invariants, and the comparison with the usual
  `K`-equivariant alternating-map formula;
- independence of equivalent Harish--Chandra models and conjugate maximal compact subgroups;
- products over archimedean places and Künneth statements needed for global coefficient systems;
- explicit split coefficient systems for `GL_n`: construct the algebraic representation prescribed
  by an integral dominant highest weight at each archimedean embedding, including rational
  structures, scalar extension, duals, tensor products, and differentiation to `GL_n(ℝ)` or
  `GL_n(ℂ)` as appropriate;
- quaternionic coefficient systems: at every real embedding use a complex splitting of `D` and the
  `GL₂` representation `Sym^r ⊗ det^m`, tensor over the embeddings, and prove independence of the
  splittings by Skolem--Noether; compare with the comodule/Weil-restriction formulation only after
  that separate reductive-groups interface exists;
- the predicate that `π` is cohomological when some relative cohomology group of
  `π_∞ ⊗ W` is nonzero, recording the coefficient system `W` and degree;
- the defining examples for general split `GL_n`, and the classification/computation for
  `GL₂(ℝ)` and `ℍˣ` needed to recover the familiar parallel and nonparallel weight conditions.

Do not replace the cohomology definition by a weight predicate. The weight classification is a
theorem and a critical test, while relative cohomology is the invariant definition used at the
target.

**SIGN-OFF B occurs here.** Confirm whether `W` or its dual appears. For `GL_n`, record explicitly
that the C-to-L-algebraic change is `|det|^{(n-1)/2}`; for quaternionic `Dˣ` it is the `n=2`
reduced-norm analogue. The treatment of the real split center is already pinned in Layer 0;
changing it changes the cohomological degrees as well as the predicate. The finite-place polynomial
in Layer 6 and the Galois representation in Layer 9 must change together if this normalization
changes.

Layer 5 closes only when `π.IsCohomological` contains an honest coefficient representation,
cohomological degree, and nonzero class in a defined cohomology object; the split `GL_n`
coefficient systems elaborate uniformly; and the `GL₂(ℝ)` and `ℍˣ` computations use that same
definition.

## Layer 6: double cosets, `GL_n` Satake theory, and quaternionic rationality

### 6.1 Shared Hecke interface

Consume the abstract double-coset ring and integral `GL_n` calculations from the
[Modular Forms roadmap](../ModularForms/README.md#layer-2-hecke-operators-and-the-hecke-algebra)
once they have landed. Do not define a rival basis or multiplication. For a locally profinite group
`G` and compact open `K`, construct the complex spherical Hecke algebra of compactly supported,
locally constant, bi-`K`-invariant functions with convolution and `vol(K)=1`. Prove:

- closure and integrability of convolution and the algebra laws;
- finiteness of the relevant coset decompositions and comparison with the finite double-coset sum;
- an explicit isomorphism from the scalar extension of the integral double-coset ring to the
  convolution algebra, tracking whether `g ↦ g⁻¹` introduces an opposite ring;
- compatible actions on `K`-fixed vectors and automorphic forms, transition maps when the level
  changes, and compatibility with restricted tensor products and global right translation.

The Modular Forms hand-off is proved first for `ℤ_p ⊂ ℚ_p`. Generalize the elementary-divisor and
lattice-counting comparison to the valuation ring `𝒪_v ⊂ F_v` at an arbitrary number-field place,
including existence and change of uniformizer, residue-cardinality bookkeeping, and preservation of
structure constants. None of those results follows merely by renaming `p` to `v`.

The full nonunital algebra `C_c^∞(G)=⋃_K H(G⫽K)` may be packaged from these levels, but an
equivalence between all smooth representations and nondegenerate modules over it is not required by
the attached-system target and must not be assumed. Iwahori calculations are likewise downstream.

### 6.2 Split `GL_n` and Satake

For `K_v=GL_n(𝒪_v)`, build the Cartan decomposition indexed by dominant coweights, its finiteness
and convolution structure constants, and the Satake isomorphism. The implementation shares the
composition/dominance combinatorics from Layer 0 and the localized integral ring from Modular Forms
Layer 2. Pin both normalizations:

- the normalized transform uses `δ_B^{1/2}` and, over `ℂ`, the positive square root of the residue
  cardinality `q_v`; over other coefficients the required square root or extension is data;
- the characteristic function of
  `K_v diag(ϖ,…,ϖ,1,…,1) K_v` maps to the precisely stated `q_v`-power multiple of the corresponding
  elementary symmetric polynomial, not to a bare generator;
- the unnormalized transform and its twisted Weyl action are separately named.

Prove that an irreducible admissible spherical `GL_n(F_v)` representation has a one-dimensional
`K_v`-fixed space, relate its eigencharacter to the unordered Satake parameter, and test the formula
on explicit unramified principal series. At `n=2`, recover the standard unnormalized `T_v,S_v` and

```text
P_v(X)=X²-a_vX+N(v)s_v.
```

### 6.3 Quaternionic good places and rationality

At a split finite place, transport the `n=2` construction to `D_vˣ` and prove independence of
`D_v ≃ M₂(F_v)` by inner conjugacy. Package a `RationalityModel π E` containing:

- an embedding `ι∞ : E → ℂ` and a finite set `S` containing every nonsplit place, every place where
  `π_v` is not spherical, and every place where the required integral data are unavailable;
- a predicate `IsGoodPlace v := v ∉ S` together with the split/unramified consequences;
- polynomials `P_v=X²-a_vX+N(v)s_v ∈ E[X]` for good `v`, and a proof that mapping by `ι∞` gives the
  actual complex Hecke polynomial of `π`, not merely a polynomial with the desired shape;
- invariance under isomorphism of automorphic representations and enlargement of `S`, and comparison
  of two rationality models after embedding their coefficient fields in a common overfield.

Use a record carrying the field and embeddings rather than asserting that all eigenvalues literally
belong to a predetermined subfield of `ℂ`. Compare with the classical arithmetic normalization in
Modular Forms PR #47 and with the migrated totally definite FLT operators. Coordinate with
[FLT#584](https://github.com/ImperialCollegeLondon/FLT/issues/584) and
[FLT#585](https://github.com/ImperialCollegeLondon/FLT/issues/585); the target uses only spherical
good-place operators.

Existence of a rationality model for every relevant `π` is not assumed: it is part of the
attached-system conclusion. Layer 6 closes when the general `GL_n` principal-series test has the
exact normalized `q_v` powers, the `n=2` and totally definite examples produce the displayed
polynomial, and changes of level presentation, Haar presentation, or quaternionic splitting leave
the represented Hecke data unchanged.

## Layer 7: local Galois theory at finite places

Build the general number-field infrastructure on top of Mathlib's absolute Galois group:

- functorial maps on absolute Galois groups induced by field embeddings, with explicit accounting
  for chosen algebraic-closure embeddings and conjugacy independence where appropriate;
- embeddings of a global algebraic closure into an algebraic closure of a completion, decomposition
  groups, and continuous local-to-global maps, with comparison under a change of embedding;
- inertia, wild inertia, tame inertia, residue Galois groups, and exact sequences;
- arithmetic and geometric Frobenius classes and the relation between them; a chosen lift may be an
  implementation device, but all unramified characteristic-polynomial statements prove
  independence of the lift;
- the topological field structure used on `AlgebraicClosure ℚ_[p]`, module topologies on finite
  powers and endomorphisms, continuous finite-dimensional representations, and equivalence with
  continuous homomorphisms into `GL_d` after choosing a basis;
- restriction to a local decomposition group, unramifiedness, characteristic polynomials of
  Frobenius, determinant, trace, conjugation, scalar extension, and semisimplification.

Every construction involving a chosen embedding or Frobenius lift must either carry that choice or
prove that the invariant later used is choice-independent. The polynomial comparison uses arithmetic
Frobenius.

Test cases include the trivial representation, finite characters, the cyclotomic character, direct
sums, conjugate representations, and base change along a number-field embedding.

For this roadmap, semisimplicity is a predicate on a representation. A general continuous
semisimplification construction, including proof that it preserves continuity over `Q̄_p`, is built
before it is used by the operations library but is not smuggled into the target merely by writing
`ρᵐˢˢ`. Layer 7 is closed when unramified arithmetic-Frobenius characteristic polynomials are
basis-, lift-, and local-embedding-independent and can be mapped along a coefficient embedding.

## Layer 8: good-place compatible systems

Define a `d`-dimensional family over a number field `E` as representations over `Q̄_p` indexed by a
prime `p` and a field embedding `φ : E → Q̄_p`. A good-place-compatibility witness consists of:

- a finite set `S` of finite places of `F`;
- a monic polynomial `P_v ∈ E[X]` of exact degree `d` for every `v ∉ S`;
- for every `(p,φ)` and every `v ∉ S` whose residue characteristic is not `p`, unramifiedness at `v`
  and equality of the arithmetic-Frobenius characteristic polynomial with `P_v.map φ`;
- semisimplicity of every member of the family.

Define finite places, the map to their residue characteristic, and the condition “`v` does not lie
over `p`” once, and prove its equivalence with the corresponding ideal-membership and residue-field
formulations already used in Mathlib. The family structure records its dimension and continuity; the
compatibility witness must not recover either from the polynomial equality.

Supply transport under coefficient-field extension and embeddings, conjugacy, semisimplification,
direct sums, tensor products, duals, Tate twists, restriction to finite field extensions, and
enlargement of the bad set. Define equivalence of systems so that coefficient fields may be enlarged
without changing the mathematical family.

Do **not** require descent to `GL_d(E_λ)`: an irreducible representation whose Frobenius polynomials
lie in `E` can have a nontrivial Schur obstruction and descend only to a central division algebra.
The `Q̄_p`-valued, embedding-indexed design avoids making a false descent assertion; this issue was
encountered in [FLT#410](https://github.com/ImperialCollegeLondon/FLT/pull/410).

The canonical acceptance test, requested in [FLT#23](https://github.com/ImperialCollegeLondon/FLT/issues/23),
is that the `p`-adic cyclotomic characters form a rank-one good-place compatible system with the stated
arithmetic-Frobenius polynomial. Further tests are finite-order algebraic Hecke characters and the
behavior of good polynomials under sums, duals, and Tate twists.

**SIGN-OFF C occurs here.** Record explicitly that neither de Rham/crystalline behavior nor
Hodge--Tate weights are fields of `GoodPlaceCompatible`. “Strict compatibility” is another stronger
structure, requiring local Weil--Deligne representations and a common local parameter even at bad
places. Neither stronger meaning is claimed by the attached-system target.

Equivalence of systems carries explicit pointwise intertwiners after a common coefficient-field
extension; it is not defined as equality of good polynomials, which would hide Chebotarev and
Brauer--Nesbitt. Those uniqueness theorems are outside this statement roadmap. Layer 8 is closed
when the cyclotomic example compiles and coefficient-field and bad-set enlargement produce explicit
equivalences with the expected common polynomials.

## Layer 9: the attached-system declaration

Once the preceding APIs exist, add a declaration equivalent to the following. The exact universe
and bundling choices should follow the implemented structures.

```lean
/-- Galois representations attached to a cohomological quaternionic automorphic representation,
in the good-place Frobenius-polynomial form. -/
theorem exists_goodPlaceCompatibleSystem
    {F : Type*} [Field F] [NumberField F] [IsTotallyReal F]
    {D : Type*} [Ring D] [Algebra F D] (hD : IsQuaternionAlgebra F D)
    (π : QuaternionAutomorphicRepresentation F D)
    (hπauto : π.IsCuspidalAutomorphic)
    (hπnonchar : ¬ π.IsReducedNormCharacter)
    (hπcoh : π.IsCohomological) :
    ∃ (E : Type*) (_ : Field E) (_ : NumberField E)
      (rationality : π.RationalityModel E)
      (ρ : PadicGaloisFamily F E 2),
      ρ.IsSemisimple ∧ ρ.IsGoodPlaceCompatibleWith rationality.heckePolynomials := by
  sorry
```

This code block is intentionally not placed in `Suggested.lean` yet: the automorphic, cohomological,
and compatibility types do not exist in Mathlib or Tau Ceti, and inventing `Prop` placeholders would
make the signature compile while saying nothing. Add the theorem to `Suggested.lean` as soon as
Layers 4--8 make the genuine predicates expressible.

The final declaration must expose, directly or through documented structures:

- `F` totally real and `D` a quaternion algebra;
- the precise automorphic spectrum, the standard cuspidality predicate, and the separate exclusion
  of reduced-norm characters;
- the coefficient system witnessing cohomology;
- a rationality field, a finite bad set containing the nonsplit and nonspherical places, a named
  `IsGoodPlace`, and Hecke polynomials attached to the actual `π` at every good place;
- two-dimensional continuous semisimple representations for every `(p,φ)`;
- unramifiedness away from the named bad set and `p`, and arithmetic-Frobenius characteristic-
  polynomial equality.

## Acceptance suite

The roadmap is complete only when all of the following compile as examples or theorems.

1. For every positive `n`, `GL_n(F_v)` and `GL_n(𝔸_F)` carry the stated local, restricted-product,
   parabolic, quotient, and archimedean interfaces, with `GL₁` recovering the expected character
   definitions.
2. The scalar extension of `D=M₂(F)` produces the *same* `GL₂` local and global interfaces, up to
   named equivalences, rather than a parallel hierarchy.
3. The integral `GL_n` double-coset ring from Modular Forms Layer 2 maps to the `vol(K)=1`
   convolution algebra with matching structure constants and the pinned inverse/opposite convention.
4. An explicit unramified principal series of `GL_n(F_v)` gives the expected Satake parameter and
   exact `q_v`-scaled elementary symmetric eigenvalues. At `n=2` its polynomial is
   `(X-α_v)(X-β_v)=X²-a_vX+N(v)s_v` in the pinned unnormalized convention.
5. Over an even-degree totally real field, a totally definite quaternion algebra unramified at
   every finite place, at parallel weight two and trivial central character, recovers the migrated
   FLT automorphic-form and good `T_v` interfaces; its target polynomial has trace `T_v` and
   determinant `N(v)`.
6. With the full Lie algebra and genuine-maximal-compact convention, the relative cohomology has
   the expected algebraic weights and degrees: degrees `1,2` for cohomological `GL₂(ℝ)` discrete
   series and degrees `0,1` for `ℍˣ` when infinitesimal central characters cancel, vanishing for a
   mismatched central action.
7. The adelized modular discriminant supplies a concrete `GL₂` automorphic representation and,
   through the split quaternion comparison, an input satisfying the target's cuspidal,
   non-reduced-norm-character, and cohomological hypotheses. Its construction exhibits the additive,
   `SL₂`, and determinant/idele-class steps separately.
8. The cyclotomic characters satisfy good-place compatibility with `P_v(X)=X-N(v)` for arithmetic
   Frobenius; enlarging the coefficient field or bad set gives an explicit equivalent system.
9. A `RationalityModel` for `π` proves that its embedded polynomials equal `π`'s Hecke polynomials,
   and two models compare in a common overfield; unrelated polynomials and `1⊕χ_cyc` cannot witness
   the conclusion for arbitrary `π`.
10. No Tau Ceti file imports `FLT`; the human-owned CI checks this architectural boundary.
11. The attached-system declaration elaborates with no proxy `Prop`, suppressed compilation, or
    hypotheses which merely name missing mathematics.

## Migration and provenance from FLT

This table identifies candidate source material at FLT commit
[`bf70705a77242545d931db4923f2975cf7c9177d`](https://github.com/ImperialCollegeLondon/FLT/commit/bf70705a77242545d931db4923f2975cf7c9177d)
(2026-07-31). It does not authorize copying and does not prescribe Tau Ceti's final file structure.

| FLT source | Material to generalize or migrate | Destination layer |
|---|---|---|
| `FLT/Mathlib/Algebra/IsQuaternionAlgebra.lean` | central-simple rank-four notion and elementary API | 0 |
| `FLT/QuaternionAlgebra/NumberField.lean` | completions, rigidifications, compact opens, level data | 0, 1, 6 |
| `FLT/AutomorphicForm/QuaternionAlgebra/Basic.lean` | totally definite weight-two test model and finite double quotient | 4 acceptance model |
| `FLT/AutomorphicForm/QuaternionAlgebra/HeckeOperators/` | abstract/local/concrete Hecke actions and good operators | 6 |
| `FLT/Deformations/RepresentationTheory/AbsoluteGaloisGroup.lean` and `Frobenius.lean` | local maps, inertia, arithmetic Frobenius | 7 |
| `FLT/Deformations/RepresentationTheory/GaloisRep.lean` | continuous representations, local restriction, determinant, characteristic polynomial | 7 |
| `FLT/Deformations/RepresentationTheory/GaloisRepFamily.lean` | embedding-indexed good-place compatibility | 8 |
| `FLT/GaloisRepresentation/Automorphic.lean` | weight-two good-place trace/determinant comparison test | 6, 9 acceptance |
| `FLT/GlobalLanglandsConjectures/GLnDefs.lean` | design lessons only; currently suppresses compilation and is not a migration base | 2--5 |

Migration order follows the layers, with narrow PRs. Each PR records its FLT source commit and
authors, retains the source copyright and `Authors:` lines and any applicable `NOTICE` material as
required by Apache-2.0, reconciles naming with current Mathlib, adds general tests in Tau Ceti, and
leaves an FLT follow-up issue. If author coordination is not possible, follow the fallback in the
top-level roadmap rules: verify the licence and discuss the plan on Lean Zulip before proceeding.
Once an API lands in Tau Ceti, the corresponding FLT PR imports Tau Ceti and proves comparison
lemmas with the specialized FLT definitions before deleting duplication.

## References

- J. Getz and H. Hahn, [*An Introduction to Automorphic
  Representations*](https://services.math.duke.edu/~jgetz/aut_reps.pdf), GTM 300 (2024): adelic
  groups, Hecke algebras, automorphic forms, factorization, Satake theory, and `(𝔤,K)`-cohomology.
- B. Gross, [*On the Satake
  isomorphism*](https://people.math.harvard.edu/~gross/preprints/sat.pdf), in *Galois Representations in
  Arithmetic Algebraic Geometry* (1998): the dominance-triangular construction and normalization.
- G. Shimura, *Introduction to the Arithmetic Theory of Automorphic Functions*, Chapter 3: the
  integral double-coset Hecke rings consumed through the Modular Forms roadmap.
- R. Taylor, [*On Galois representations associated to Hilbert modular
  forms*](https://typo.iwr.uni-heidelberg.de/fileadmin/groups/arithgeo/templates/data/Hauptseminare/Literature-WS13/taylor_on_gal_reps_associated_to_HMF_1989__01.pdf),
  Invent. Math. 98 (1989), 265--280, Conjecture 1: the good-place `T_v,S_v` formulation and
  arithmetic target.
- H. Carayol, [*Sur les représentations ℓ-adiques associées aux formes modulaires de
  Hilbert*](https://archive.numdam.org/item/ASENS_1986_4_19_3_409_0/), Ann. Sci. ENS 19 (1986),
  409--468: strict compatibility and local Weil representations.
- K. Buzzard and T. Gee, [*The conjectural connections between automorphic representations and
  Galois representations*](https://arxiv.org/abs/1009.0785): cohomological/C-algebraic conventions
  and the normalization warning.
- T. Barnet-Lamb, T. Gee, D. Geraghty, and R. Taylor, [*Potential automorphy and change of
  weight*](https://arxiv.org/abs/1010.2561), §5.1: a modern “weakly compatible system” convention
  which also records p-adic Hodge and Hodge--Tate data, explaining why this roadmap uses the narrower
  name `GoodPlaceCompatible`.
- A. Borel and N. Wallach, *Continuous Cohomology, Discrete Subgroups, and Representations of
  Reductive Groups*, second edition: relative `(𝔤,K)`-cohomology and cohomological representations.
- H. Jacquet and R. Langlands, [*Automorphic Forms on GL(2)*](https://publications.ias.edu/node/60),
  LNM 114 (1970): local/global `GL₂` and quaternionic automorphic representations.
- The [Lean Zulip discussion motivating this
  roadmap](https://leanprover.zulipchat.com/#narrow/channel/416277-FLT/topic/Main.20blockers.20for.20a.20full.20proof.20of.20FLT.2E/near/613821903).

The references do not settle the three sign-offs automatically: they use differing Frobenius,
reciprocity, Satake, and algebraicity conventions. The formal comparison lemmas in Layers 0, 5, and
6 are the settlement mechanism.
