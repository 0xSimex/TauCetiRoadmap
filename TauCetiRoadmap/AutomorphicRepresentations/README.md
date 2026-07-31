# Galois representations attached to quaternionic automorphic representations

## Summit and boundary

This roadmap builds enough reusable Lean infrastructure to state the following target without
undefined mathematical nouns or vacuous predicates.

> **Target statement.** Let `F` be a totally real number field, let `D` be a quaternion
> algebra over `F`, and let `π` be a cuspidal cohomological automorphic representation of
> `Dˣ(𝔸_F)` which is not a character factoring through reduced norm. There are a number field `E`,
> Hecke polynomials `P_v ∈ E[X]` at all but finitely many
> finite places `v` of `F`, and a semisimple good-place compatible family of continuous
> two-dimensional representations
> `ρ_{p,φ} : Gal(F̄/F) → GL₂(Q̄_p)`, indexed by primes `p` and embeddings
> `φ : E → Q̄_p`, such that, whenever `v` is good and its residue characteristic differs from
> `p`, `ρ_{p,φ}` is unramified at `v` and
> `charpoly(ρ_{p,φ}(Frob_v^arith)) = φ(P_v)`.

At a split unramified place the normalization target is

```text
P_v(X) = X² - a_v X + N(v) s_v,
```

where `a_v` and `s_v` are the eigenvalues of the standard spherical operators `T_v` and `S_v`,
the Haar measure gives the standard maximal compact subgroup volume one, and Frobenius is
**arithmetic** Frobenius. This is the convention in Taylor's Hilbert-modular formulation and in the
current FLT good-place compatibility predicate.

The summit is a *statement*, not a proof of the conjecture. In particular, this roadmap does not
formalize Jacquet--Langlands, the construction of the Galois representations, or the proof of local--
global compatibility. Those are later roadmaps. Everything needed to typecheck every term and
hypothesis above, including “cohomological,” “automorphic representation,” the local Hecke
polynomial, and “good-place compatible,” is in scope here.

The roadmap deliberately specializes the group to `Dˣ`. It consumes the general foundations in
the [reductive-groups roadmap](../ReductiveGroups/README.md) where they are already available, but
does not wait for the entire classification of reductive groups. In particular, after scalar
extension to an archimedean completion, `D` is a finite-dimensional real normed algebra and its
group of units already has a concrete manifold/Lie-group route. General analytification of smooth
schemes is therefore not a prerequisite for the target statement. Algebraic coefficient systems
on the critical path are constructed explicitly from archimedean weight data and differentiated on
these concrete groups; comparison with the eventual group-scheme/comodule construction is not used
to define “cohomological.”

## Decisions pinned here, and decisions needing sign-off

The following choices are part of this roadmap.

1. A quaternion algebra means a four-dimensional central simple algebra, not a particular Hilbert
   symbol presentation.
2. Global automorphic representations are irreducible admissible constituents, expressed as
   subquotients of the cuspidal automorphic spectrum. The finite part is smooth; the infinite part
   is a Harish--Chandra `(𝔤,K)`-module.
3. Cohomological means nonvanishing relative Lie-algebra cohomology with coefficients in a
   finite-dimensional algebraic representation.
4. Compatibility records common Frobenius polynomials at almost all finite places. The coefficient
   representations live over `Q̄_p` and are indexed by embeddings `E → Q̄_p`; they are not required
   to descend to `GL₂(E_λ)`.
5. The family is semisimple and uses arithmetic Frobenius.

Three points need an expert to confirm before the summit declaration is frozen. They are marked
`SIGN-OFF` again at the layer where they arise.

- **SIGN-OFF A — cuspidality and one-dimensional representations.** The Zulip formulation says
  “cohomological automorphic representation,” without saying “cuspidal.” For split `D`, the usual
  theorem takes cuspidal representations and excludes Eisenstein constituents. For division `D`,
  there are no proper `F`-parabolics, so the standard constant-term definition of cuspidality is
  vacuous and still includes the characters `χ ∘ Nrd`. The provisional summit therefore requires
  both cuspidality and “not a reduced-norm character.” A reviewer should confirm that restriction or
  specify the larger statement and its reducible systems for characters/Eisenstein constituents.
- **SIGN-OFF B — cohomological normalization.** For even-rank groups, the passage between
  cohomological/C-algebraic and L-algebraic normalizations involves a half-Tate shift. The displayed
  polynomial follows Taylor's classical `T_v,S_v` convention. A specialist must check that the
  chosen `W`-versus-`W^∨` convention, central character, Satake normalization, and reciprocity
  convention produce exactly that polynomial. This roadmap separately pins the relative pair to the
  full Lie algebra and a genuine maximal compact, without adjoining the split real center.
- **SIGN-OFF C — strength of compatibility.** Carayol proves a strictly compatible system with
  local Weil representations, while the FLT development currently asks only for good-place
  characteristic polynomials. Some modern literature also builds de Rham/crystalline conditions
  and embedding-independent Hodge--Tate weights into the term “weakly compatible system.” The
  summit below intentionally uses the narrower name `GoodPlaceCompatible`. If the intended
  challenge includes either the p-adic Hodge conditions or strict local compatibility, this roadmap
  needs further layers for p-adic Hodge theory and/or Weil--Deligne/local Langlands data; that is not
  a renaming of the current summit.

## Ground floor: existing material and coordination

Before claiming work in a layer, recheck Mathlib, Tau Ceti, the FLT repository, and the linked open
work. APIs in this area are moving.

Mathlib already supplies number fields and their finite, infinite, and full adèle rings; restricted
products; completions at finite and infinite places; Haar measure; absolute Galois groups; algebraic
closures of `ℚ_p`; ordinary representation theory; universal enveloping algebras; and the manifold
structure on units of suitable normed algebras. It does not yet supply the full objects required
here: quaternion algebras as central simple algebras, local Galois maps/inertia/Frobenius, smooth
admissible representations of locally profinite groups, Harish--Chandra modules, relative
`(𝔤,K)`-cohomology, automorphic representations, or good-place compatible systems.

The [reductive-groups roadmap](../ReductiveGroups/README.md) is the shared source for affine group
schemes, Hopf algebras, algebraic representations, and Lie algebras. This roadmap consumes the
landed interfaces from its Layers 0--2 at the concrete `Dˣ` boundary described in the reuse table;
the unlanded comparison work in Layers 1--2 is not a summit prerequisite. It must not create a
second incompatible representation/comodule dictionary. The open Mathlib work on
[affine analytification](https://github.com/leanprover-community/mathlib4/pull/34626) remains
important for the general theory but is not on this summit's critical path. The convolution source
from [mathlib4#39281](https://github.com/leanprover-community/mathlib4/pull/39281) is present at the
pinned Mathlib revision but still uses `suppress_compilation`, so it is not yet a compiled
foundation. Also track the quaternion reorganization in
[mathlib4#41538](https://github.com/leanprover-community/mathlib4/pull/41538) and check the
finite-dimensional general-linear-group work in
[mathlib4#40380](https://github.com/leanprover-community/mathlib4/pull/40380) before opening the
relevant Tau Ceti PRs.

FLT contains substantial prototypes. **Tau Ceti must never import FLT.** Coordinate with the FLT
authors before moving code, submit self-contained Tau Ceti PRs against this roadmap, preserve
authorship and the Apache-2.0 notices, and then change FLT to import the resulting Tau Ceti API.
The provenance table near the end is an aid to migration, not a specification of the final API.

### Exact reuse map from other Tau Ceti roadmaps

These are interface dependencies, not dependencies on completion of an entire roadmap.

| Existing roadmap target | Consumed here | Work still owned here |
|---|---|---|
| [Semisimple algebras, Layer 4](../RepresentationTheory/SemisimpleAlgebras/README.md#layer-4-central-simple-algebras-and-their-tensor-products): central simple algebras, tensor products, degree | intrinsic `IsQuaternionAlgebra`, scalar-extension dimension and simplicity | reduced trace/norm, involution, local ramification, and the quaternion split/division API |
| [Semisimple algebras, Layers 5--6](../RepresentationTheory/SemisimpleAlgebras/README.md#layer-5-skolem-noether-and-the-centralizer-theorem): Skolem--Noether, base change, splitting fields, `ℍ` | independence up to inner conjugacy of chosen splittings `D_v ≃ M₂(F_v)`; real split/ramified examples | compatible topological and integral local models and their Hecke comparisons |
| [Reductive groups, Layer 0](../ReductiveGroups/README.md#layer-0-the-functor-of-points-and-the-three-way-dictionary): Hopf algebra ↔ affine group scheme ↔ functor of points, and base change | the three synchronized models for `Dˣ` | its explicit reduced-norm localization, adèlic/restricted-product points, and comparison with concrete units |
| [Reductive groups, Layer 1](../ReductiveGroups/README.md#layer-1-representations--comodules): finite-dimensional comodules and algebraic representations | the later comparison between intrinsic algebraic representations and the explicit coefficient systems used here | the summit uses explicit highest-weight coefficient systems, so this unlanded layer is not a critical-path dependency |
| [Reductive groups, Layer 2](../ReductiveGroups/README.md#layer-2-lie-algebra-and-the-adjoint-representation): algebraic `Lie(G)` and `Ad` | comparison with the Lie algebra obtained from real points | the analytic differentiation comparison for each `D_vˣ` |
| [Lie groups, Layers 0--2](../RepresentationTheory/LieGroups/README.md#the-build-in-layers): units of normed algebras, tangent Lie algebra, `Ad`, and the closed-subgroup theorem | the concrete Lie groups `D_vˣ`, Lie algebras of closed compact subgroups, and differentiated actions | explicit maximal compact subgroups of `GL₂(ℝ)` and `ℍˣ`, plus their conjugacy/comparison lemmas |
| [Lie groups, Layer 5](../RepresentationTheory/LieGroups/README.md#layer-5-simply-connected-covers-and-the-enveloping-algebra): universal enveloping algebra and PBW | the `U(𝔤_ℂ)` action on a Harish--Chandra module | `K`-finite compatibility and relative `(𝔤,K)` cohomology |
| [Lie groups, Layer 9](../RepresentationTheory/LieGroups/README.md#layer-9-the-cartan-iwasawa-and-kak-decompositions): Cartan involution and the compact factor `K` | the general real-reductive comparison and conjugacy theory | concrete `D_vˣ` instances may land earlier and must not wait for all Iwasawa/KAK theory |
| [Compact groups, Layers 0--2](../RepresentationTheory/CompactGroups/README.md#the-build-in-layers): normalized Haar measure, unitarization, complete reducibility | finite-dimensional `K_v`-types and invariant complements | locally finite `K_v`-actions and their compatibility with the noncompact Lie algebra |
| [Lie highest weight, Layers 7 and 9](../RepresentationTheory/LieHighestWeight/README.md#layer-7-the-center-of-ul-and-harish-chandra-freudenthal-and-serres-relations): `Z(U(𝔤))`, Harish--Chandra isomorphism, reductive `gl₂` weights | the algebra acting in the `Z(𝔤_ℂ)`-finite condition and the split-real weight calculation | infinite-dimensional Harish--Chandra modules; the existing roadmap treats finite-dimensional highest-weight modules |
| [Classical groups, Layers 0--3](../RepresentationTheory/ClassicalGroups/README.md#the-build-in-layers): algebraic `GL₂` representations and highest weights | split coefficient-system examples | descent and inner forms for general `Dˣ` |

The representation-theory index explicitly stops before infinite-dimensional representations of
noncompact groups. Its induction/restriction roadmap is for finite groups. Consequently smooth
induction for `D_vˣ`, admissibility, Harish--Chandra modules, and automorphic spectra are not silently
delegated there: Layers 2--5 below own them. Conversely, this roadmap must reuse its algebraic,
compact, and Lie-group interfaces rather than rebuild them.

Finite-separable Weil restriction belongs to the relative theory in the reductive-groups roadmap
and is too large a prerequisite for this summit. Here a coefficient system is constructed directly
from a highest weight at each embedding `F → ℝ`, using a complex splitting of the local quaternion
algebra and proving independence by Skolem--Noether. Once Weil restriction and comodules land, a
comparison theorem belongs at the boundary between the two roadmaps; no definition here waits for it.

### Dependency-closure audit

A reference to another roadmap means **landed Tau Ceti code implementing the cited target**, not the
mere existence of that roadmap. If that code has not landed, the contributor must claim the cited
target separately or coordinate a prerequisite PR. No PR against this roadmap may hide a new local
notion behind an implementation detail just because the corresponding prerequisite is still absent.

The following table is the step-by-step entry contract. The last column records prerequisites that
are easy to skip over; they have been promoted to explicit work in the layer descriptions below.

| Layer | Inputs that must already compile | Formerly hidden work explicitly owned by this roadmap |
|---|---|---|
| 0 | Mathlib number fields, completions, tensor products; cited central-simple-algebra targets | reduced characteristic polynomial/trace/norm, quaternion involution, local splitting, ramification and finiteness of the ramified set |
| 1 | Layer 0; reductive-groups Layer 0 where landed; Mathlib adèles and Haar topology | topology on finite-dimensional scalar extensions, the idelic restricted-product topology (not the adèle-subspace topology), noncommutative orders and their completions, compact-open unit groups and congruence bases, concrete parabolics of `Dˣ` |
| 2 | Layer 1 topological groups; Mathlib invariant submodules | locally profinite interfaces, smooth-representation category and exact operations, smooth/compact induction function spaces, smooth dual, and restricted tensor products with local factors carried as data |
| 3 | Layer 1 archimedean groups; cited Lie-groups and compact-groups targets | complexification of the analytic Lie algebra, differentiation of finite-dimensional compact-group actions, disconnected maximal compacts, and the category of Harish--Chandra pairs/modules |
| 4 | Layers 1--3 | smooth/local-constant function space, right differential operators, an adelic height for moderate growth, central-character quotient, constant-term integrals and their Haar measures, and an algebraic spectrum model not relying on an unbuilt Hilbert decomposition |
| 5 | Layers 0, 1, 3, 4; highest-weight interfaces for `gl₂`; Mathlib chain complexes and alternating maps | full Chevalley--Eilenberg differential and signs, relative cochains for disconnected `K`, explicit coefficient-system base change/duals, cohomology and Künneth comparisons |
| 6 | Layers 1, 2, 4; Mathlib Haar measure | locally constant compact support, convolution integrability, finite double-coset sums, `GL₂` Cartan/Satake theory, the spherical fixed-line theorem, and a rationality *data structure* whose existence remains in the summit conclusion |
| 7 | Mathlib absolute Galois groups, completions, module topology and `Q̄_p` | chosen embeddings of algebraic closures, local-to-global maps, inertia/Frobenius exact sequences, independence of Frobenius lifts, continuity of matrix realizations, and basis-independent characteristic polynomials |
| 8 | Layer 7 | finite-place/residue-characteristic bookkeeping, monic exact-degree common polynomials, coefficient-field enlargement/equivalence, and semisimplicity as a predicate rather than an assumed semisimplification construction |
| 9 | Layers 4, 5, 6, 8 | one declaration joining the actual automorphic model, coefficient system, Hecke rationality model, and compatible family; no proxy predicates |

Each layer PR states which row inputs it consumes and demonstrates the named constructions with the
layer's acceptance examples. Discovering another missing prerequisite requires a roadmap amendment
or an explicitly linked prerequisite target before implementation continues; it is not left as
unreviewed contributor glue.

## Dependency graph

```text
0 quaternion algebras ──▶ 1 adelic/local groups ──▶ 2 smooth representations
                                │                           │
                                ▼                           ▼
                    3 archimedean (𝔤,K) ──────────▶ 4 automorphic spectrum
                                │                           │
                                └──────────────┬────────────┤
                                               ▼            ▼
                                      5 cohomological   6 spherical Hecke

7 local Galois theory ──▶ 8 good-place compatible systems

             4 automorphic + 5 cohomological + 6 Hecke + 8 Galois ──▶ 9 statement
```

After Layer 1, the general smooth finite-place work in Layer 2 and the concrete archimedean work in
Layer 3 may advance in parallel. Layer 4 consumes both. Layer 5 consumes Layers 3--4 and the Layer 0
coefficient algebra; Layer 6's abstract convolution work can start after Layers 1--2, but its
π-attached rationality interface also consumes Layer 4. Layers 7--8 are independent of automorphic
forms. Layer 9 starts only when its four incoming interfaces have executable examples and stable
names.

## Layer 0: conventions and quaternion algebras

### 0.1 Quaternion algebras

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

This layer is closed only when the scalar-extension theorem can be applied to `F_v`, reduced norm
detects units, the split comparison produces `M₂(F_v)` with reduced norm equal to determinant, and a
finite set containing every nonsplit finite place is available to Layer 1.

### 0.2 Global conventions

Create one documented namespace for conventions used by every later layer:

- arithmetic Frobenius;
- geometric Artin reciprocity or arithmetic Artin reciprocity, chosen so its relation to arithmetic
  Frobenius is a named theorem;
- Haar normalization `vol(K_v)=1` at unramified finite places;
- left versus right actions (automorphic forms use right translation);
- normalized versus unnormalized induction and Satake transforms;
- `T_v`, `S_v`, and `X²-a_vX+N(v)s_v`;
- the relative-cohomology pair uses the full real Lie algebra and a genuine maximal compact
  `K_v` (`O(2)` for `GL₂(ℝ)`, `Sp(1)` for `ℍˣ`), without adjoining the real split center to `K_v`;
- embeddings of the rationality field into `ℂ` and `Q̄_p`.

Two later acceptance tests enforce these conventions without assuming an unbuilt classical-to-
adelic dictionary: Layer 6 computes the polynomial of an explicit unramified principal series, and
Layer 8 proves that the cyclotomic family has polynomial `X-N(v)`. The latter is the
Frobenius-direction test; replacing arithmetic by geometric Frobenius makes it fail.

## Layer 1: `Dˣ` locally and adelically

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

Acceptance examples are `F=ℚ,D=M₂(ℚ)` and a totally definite quaternion division algebra. Both must
compute the expected local groups, standard compact subgroups, center, and diagonal action.
Layer 1 is closed only when every finite local group and the finite adèlic group are actually locally
compact totally disconnected topological groups, the standard compact opens form the required
restricted-product datum, and Layers 2 and 4 can use the quotient and parabolic objects without
choosing bases, orders, or splittings afresh.

## Layer 2: smooth admissible representations at finite places

Build the algebraic definitions for a locally profinite group `G` over a field `k`, and use `k=ℂ`
for the automorphic summit. Every Schur-lemma, central-character, or multiplicity-one theorem states
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

Test the API on characters, finite-dimensional representations of compact groups, unramified
principal series of `GL₂(F_v)`, and their transport to split `D_vˣ`. The construction of principal
series includes the normalized modulus character and proves its smoothness and admissibility; it is
not an unexplained example imported from the literature. Layer 2 is closed when these examples,
subquotients, smooth duals, and restricted tensor products use one common category. The
one-dimensional spherical fixed-line theorem is deferred to Layer 6, where its Cartan/Satake proof
lives.

The general Flath factorization theorem—from an abstract irreducible admissible representation of a
restricted product to local factors—is not needed to type the summit and is outside this statement
roadmap. Layer 4 defines an automorphic representation with its local restricted-tensor-product data
and occurrence witness together. A future local--global-compatibility roadmap may prove that this
bundling is equivalent to starting from an abstract global constituent.

## Layer 3: the archimedean `(𝔤,K)` interface

For each infinite place `v`, construct the complexified Lie algebra `𝔤_v` of `D_vˣ`, use the
Layer 0 maximal-compact convention, and prove independence under conjugacy. Develop Harish--Chandra
modules as compatible data:

- comparison between the algebraic Lie algebra from reductive-groups Layer 2, the tangent Lie
  algebra of the real unit group, and its scalar extension to `ℂ`;
- explicit maximal compacts `O(2) ⊆ GL₂(ℝ)` and `Sp(1) ⊆ ℍˣ`, their closed Lie-subgroup structures,
  maximality, and conjugacy of choices; retain component-group data because `O(2)` is disconnected;
- differentiation of finite-dimensional continuous `K_v`-representations, including automatic
  smoothness, functoriality, and agreement with the Lie algebra of the closed subgroup;
- a Harish--Chandra pair and its module category: a complex `𝔤_v`-module and a locally finite
  continuous `K_v`-action;
- both compatibility axioms: the differentiated `K_v`-action agrees with the restricted
  Lie-algebra action, and conjugating the `𝔤_v`-action by `k` agrees with `Ad(k)`;
- `K_v`-finite vectors, the universal-enveloping-algebra action, and the action of its center;
- finite generation over `U(𝔤_v)`, finite multiplicity of irreducible `K_v`-types, and the standard
  admissibility conditions, with subobjects, quotients, tensor products by finite-dimensional
  modules, contragredients, and equivalences under conjugate choices of `K_v`;
- finite products over all archimedean places and compatibility with algebraic representations.

This layer should consume the Lie group and universal-enveloping-algebra work in the representation-
theory roadmap. Concrete matrix and quaternion unit groups are mandatory tests; the API must not
assume every maximal compact group is connected.
Layer 3 is closed only when the `(𝔤,K)` module attached to smooth functions on the real group can be
constructed in Layer 4 and relative cochains can restrict its actions without additional analytic
or differentiation machinery.

## Layer 4: automorphic forms and automorphic representations

Define complex-valued automorphic forms on `Dˣ(F)\Dˣ(𝔸_F)` with all standard conditions stated as
real predicates:

- the ambient function space: smooth in the archimedean variables and locally constant in the
  finite-adèlic variable, with a proved equivalence to invariance under some compact open at the
  finite part;
- left invariance by the diagonal rational points;
- the differentiated right action of `𝔤_ℂ` and `U(𝔤_ℂ)` on that function space, compatibility with
  right translation, and `K_∞`-finiteness;
- `Z(𝔤_ℂ)`-finiteness, pinned as annihilation by a finite-codimensional ideal (and compared with a
  finite-dimensional center orbit under the hypotheses where they agree);
- a basis-independent adelic norm/height from a faithful algebraic representation, comparison of
  two choices, and moderate growth in that height on the quotient modulo center;
- a continuous central character on `Fˣ\𝔸_Fˣ` and its transformation law where one is specified;
- Haar measure on each compact quotient `N(F)\N(𝔸_F)`, the constant-term integral, its convergence
  and independence of normalization for the zero condition, and cuspidality as vanishing along
  every proper parabolic from Layer 1;
- reduced-norm characters `χ ∘ Nrd` as a separately recognized class of one-dimensional
  automorphic representations.

For `Dˣ`, prove the expected simplifications in anisotropic/totally definite cases instead of
baking those simplifications into the general definition. In particular, prove that cuspidality is
vacuous when `D` is division, rather than claiming that it excludes characters. In the split case
prove that the concrete constant term is the usual upper-unipotent integral and is independent of
the chosen splitting.
Construct the right regular action and prove it preserves every condition.

Use the algebraic space of `K_∞`- and center-finite cuspidal automorphic forms for this summit. Define
the cuspidal automorphic spectrum as its finite-adèlic representation together with its
archimedean `(𝔤,K)` action. Do not appeal to a Hilbert-space direct-integral or spectral-decomposition
theorem that has not been built; an `L²` comparison may be proved later as a separate interface.

An automorphic representation is bundled as commuting archimedean Harish--Chandra and finite-
adèlic restricted-tensor-product actions, irreducible and admissible in that product category,
together with a subquotient witness in this spectrum. Thus its local components are data, not the
output of an unstated Flath theorem. Keep the witness: later theorems need to transport Hecke
eigenvalues and cohomology along it. Define isomorphisms of these bundles and prove independence of
the chosen occurrence model. Once a full factorization theorem exists, prove comparison with the
unbundled “irreducible global constituent” definition.

**SIGN-OFF A occurs here.** Keep `IsCuspidal` as the standard constant-term predicate and keep
`IsReducedNormCharacter` separate. If the summit is to include reduced-norm characters,
noncuspidal discrete constituents, or Eisenstein constituents, introduce those spectra distinctly
and state their reducible conclusions. Do not redefine “cuspidal” case-wise to conceal the
anisotropic phenomenon, and do not silently broaden `IsAutomorphic`.

Tests:

- when `D=M₂(F)`, compare the definitions with the standard adelic `GL₂` definitions;
- when `D` is totally definite, identify fixed-level weight-two forms with functions on the finite
  double quotient and recover the current FLT-style model after migration;
- check that right translation, central character, and local-component conventions agree in both
  examples.

### Inhabitation track

Before the summit is accepted, construct one non-character object satisfying its automorphic
hypotheses. Use Mathlib's nonzero weight-12 modular discriminant and the theorem that the level-one
weight-12 cusp-form space has rank one. Build, rather than assume, the required bridge:

- strong approximation and the classical-to-adelic quotient at level `GL₂(ℤ̂)`;
- adelization of the discriminant, with classical cusp decay implying the adelic constant-term
  condition and weight 12 giving the archimedean `K`-type;
- the commuting finite-adèlic and archimedean actions generated by this form, an irreducible
  admissible restricted-tensor-product subquotient, and proof that it is not a determinant/reduced-
  norm character.

Layer 5 then proves this representation cohomological in the expected degree. This track is an
inhabitation proof, not the normalization test of Layer 6, and every bridge named above is part of
the work; the existence of a classical cusp form alone does not manufacture an automorphic
representation.

Layer 4 is closed only when the automorphic-form space itself carries the Layer 2 and Layer 3
actions, constant terms are actual integrals, and the witness that `π` is a subquotient transports
local components and Hecke actions without a new choice of model.

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
- explicit finite-dimensional coefficient systems: for every real embedding of `F`, use a complex
  splitting of `D` and the `GL₂` representation `Sym^n ⊗ det^m` prescribed by an integral highest
  weight, tensor these over the embeddings, and prove independence of splittings by Skolem--Noether;
  include rational structures, duals, tensor products, differentiation to the concrete real Lie
  groups, and the comparison with the comodule/Weil-restriction formulation once that separate
  reductive-groups interface exists;
- the predicate that `π` is cohomological when some relative cohomology group of
  `π_∞ ⊗ W` is nonzero, recording the coefficient system `W` and degree;
- the classification/computation for `GL₂(ℝ)` and `ℍˣ`, enough to recover the familiar parallel and
  nonparallel weight conditions.

Do not replace the cohomology definition by a weight predicate. The weight classification is a
theorem and a critical test, while relative cohomology is the invariant definition used at the
summit.

**SIGN-OFF B occurs here.** Confirm whether `W` or its dual appears and the C-algebraic/L-algebraic
twist. The treatment of the real split center is already pinned in Layer 0; changing it changes the
cohomological degrees as well as the predicate and requires a roadmap amendment. The finite-place
polynomial in Layer 6 and the Galois representation in Layer 9 must be adjusted together if the
algebraicity normalization changes.

Layer 5 is closed only when `π.IsCohomological` returns or contains an honest coefficient
representation, cohomological degree, and nonzero class in a defined cohomology object, and when the
split `GL₂(ℝ)` and ramified `ℍˣ` computations use that same definition.

## Layer 6: spherical Hecke algebras and rationality

At every split unramified finite place `v`, construct the spherical Hecke algebra of compactly
supported, bi-`K_v`-invariant functions with convolution. Normalize Haar measure by `vol(K_v)=1`.
Develop:

- locally constant compactly supported functions, closure and integrability of convolution, the
  algebra laws, and comparison of convolution with the finite double-coset sum acting on smooth
  representations and global automorphic forms;
- finiteness of `K_v\K_vgK_v`, characteristic functions of double cosets, the `GL₂` Cartan
  decomposition, the spherical Hecke algebra calculation, and the normalized Satake transform;
- the standard operators `T_v` and `S_v`, including their matrix representatives and independence
  from the choice `D_v ≃ M₂(F_v)`;
- the action on `K_v`-fixed vectors and the theorem that this fixed space is one-dimensional for an
  irreducible unramified admissible local representation; only then define its scalar eigenvalues
  `a_v,s_v`;
- compatibility with restricted tensor products and with global right translation;
- the finite bad set combining ramification of `D`, ramification of the representation, and places
  where the chosen integral/spherical data are unavailable;
- a rationality-field *data structure* containing a number field `E`, an embedding `ι∞ : E → ℂ`,
  the finite bad set, and polynomials `P_v=X²-a_vX+N(v)s_v ∈ E[X]`, together with the assertion that
  mapping by `ι∞` gives the complex Hecke polynomial;
- invariance of this package under isomorphism of automorphic representations and enlargement of
  the bad set, and comparison of any two rationality models after embedding their coefficient
  fields in a common overfield; in particular the good polynomial is an invariant of `π`, not free
  data that can be chosen to fit an unrelated Galois family.

Use a record carrying the field and embeddings rather than asserting that all eigenvalues literally
belong to a predetermined subfield of `ℂ`. Prove comparison theorems with classical Hilbert Hecke
operators and with the migrated totally definite FLT operators. Coordinate with the open FLT work
on commutativity of its `U` operators and Hecke algebra
([FLT#584](https://github.com/ImperialCollegeLondon/FLT/issues/584),
[FLT#585](https://github.com/ImperialCollegeLondon/FLT/issues/585)); the summit itself only uses good
spherical operators.

The roadmap does not assume or separately prove a rationality theorem for every cohomological `π`:
existence of `E` and of this rationality model is part of the attached-system statement. Layer 6
builds the type and its comparison laws so that this existential conclusion has mathematical
content. It is closed when the unramified-principal-series and totally definite examples produce
the exact displayed polynomial and a change of local splitting or Haar presentation provably
leaves it unchanged.

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
before it is used by the operations library but is not smuggled into the summit merely by writing
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
places. Neither stronger meaning is claimed by the summit theorem.

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
- a rationality field and good-place Hecke polynomials;
- two-dimensional continuous semisimple representations for every `(p,φ)`;
- a finite bad set, unramifiedness away from it and `p`, and arithmetic-Frobenius characteristic-
  polynomial equality.

## Acceptance suite

The roadmap is complete only when all of the following compile as examples or theorems.

1. `D=M₂(F)` produces the standard `GL₂(𝔸_F)` local and global interfaces.
2. An explicit unramified principal series of `GL₂(F_v)` yields
   `(X-α_v)(X-β_v)` from its Satake parameters under the pinned normalization, including the stated
   formulas for `T_v`, `S_v`, and the norm factor.
3. Over an even-degree totally real field, a totally definite quaternion algebra unramified at
   every finite place, at parallel weight two and trivial central character, recovers the migrated
   FLT automorphic-form and good `T_v` interfaces; its conjectural polynomial has trace `T_v` and
   determinant `N(v)`.
4. With the full Lie algebra and genuine-maximal-compact convention, the relative cohomology has
   the expected algebraic weights and degrees: degrees `1,2` for the cohomological `GL₂(ℝ)` discrete
   series and degrees `0,1` for `ℍˣ` when the infinitesimal central characters cancel (and it
   vanishes for a mismatched central action).
5. The cyclotomic characters satisfy the rank-one good-place-compatibility predicate with
   `P_v(X)=X-N(v)` for arithmetic Frobenius.
6. Enlarging the coefficient field or bad set does not change the represented good-place compatible
   system.
7. No Tau Ceti file imports `FLT`; the Tau Ceti code repository's human-owned CI carries a check for
   this architectural boundary.
8. The summit declaration elaborates with no proxy `Prop`, no suppressed compilation, and no
   hypotheses that merely name missing mathematics.
9. The adelized modular discriminant supplies a concrete `π` satisfying the cuspidal,
   non-reduced-norm-character, and cohomological hypotheses, so the challenge statement's input
   class is provably inhabited.
10. A `RationalityModel` for `π` proves that its embedded polynomials equal `π`'s Hecke
    polynomials, and two such models compare in a common overfield; unrelated polynomials and the
    family `1 ⊕ χ_cyc` cannot witness the conclusion for an arbitrary `π`.

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
