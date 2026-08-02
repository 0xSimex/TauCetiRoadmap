# Automorphic representations of `GL_n` and quaternionic inner forms

## Targets and boundary

This roadmap has two connected outputs. First, it builds reusable foundations for automorphic
representations of split `GL_n` over a number field, with `GL_n` as the principal concrete test of
every group-generic interface. Second, it builds the genuinely quaternionic material needed to
state the following target without undefined mathematical nouns or vacuous predicates.

> **Attached-system target.** Let `F` be a totally real number field, let `D` be a quaternion
> algebra over `F`, and let `π` be a cuspidal cohomological automorphic representation of
> `Dˣ(𝔸_F)` which is not a character factoring through reduced norm. Here “cohomological” means
> that `π` has the global algebraic coefficient-system witness of Layer 5; that witness determines
> the pinned L-algebraic/arithmetic normalization used below. There are a number field `E`,
> a finite set `S` of finite places containing every place where `D` is nonsplit or `π` is
> ramified, Hecke polynomials `P_v ∈ E[X]` for every `v ∉ S`, and a semisimple family of continuous
> two-dimensional representations
> `ρ_{p,φ} : Gal(F̄/F) → GL₂(Q̄_p)`, indexed by primes `p` and embeddings
> `φ : E → Q̄_p`, such that, for `v ∉ S` whose residue characteristic differs from `p`,
> `ρ_{p,φ}` is unramified at `v` and
> `charpoly(ρ_{p,φ}(Frob_v^arith)) = φ(P_v)`.

Thus `GoodPlaceHeckeDatum.IsGoodPlace v` means that `v ∉ S`, with the datum carrying proofs that
this entails the split and unramified hypotheses needed to define the spherical operators. The
condition that
`v` does not lie over `p` is separate because it depends on the member of the Galois family. At a
good place the normalization target is

```text
P_v(X) = X² - a_v X + N(v) s_v,
```

where `a_v` and `s_v` are the eigenvalues of the classical arithmetic operators `T_v` and `S_v`
on the L-algebraically normalized representation determined by the cohomological witness, and
Frobenius is **arithmetic** Frobenius. They are not, by definition, the eigenvalues of raw
convolution on an arbitrarily normalized automorphic representation. Layer 6 proves the comparison
with normalized Satake parameters and with Taylor's Hilbert-modular convention. For the weight-12
discriminant this must specialize to

```text
P_p(X) = X² - τ(p) X + p¹¹.
```

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
3. A global `QuaternionRepresentationDatum` bundles the commuting archimedean and finite
   restricted-tensor-product actions and their chosen local factors. A Type-valued
   `CuspidalAutomorphicWitness` adds irreducibility, admissibility, and an occurrence as a
   subquotient of the algebraic cuspidal space, so no name presupposes an unstated Flath theorem.
4. A cohomological witness is Type-valued data: a global finite-dimensional algebraic coefficient
   representation `W_alg`, a nonzero class in
   `H*(𝔤,K; π_∞ ⊗ W_alg^∨)`, and its rationality, central, and conjugation compatibilities.
5. Good-place compatibility records common Frobenius polynomials outside a named finite set. The
   representations live over `Q̄_p`, indexed by `E → Q̄_p`, and need not descend to `GL₂(E_λ)`.
6. The Galois family is semisimple and uses arithmetic Frobenius. Its good-place datum is shared
   literally with the normalized Hecke construction, rather than copied into a second record.
7. Fix one Haar measure on each local group. Level-`J` Hecke algebras are corners cut out by
   `e_J=1_J/μ(J)`; “`vol(J)=1`” versions are explicitly rescaled models, not subalgebras silently
   formed using incompatible measures.
8. Automorphic forms use the `A_G`-trivial normalization: `A_G` is the connected split-real central
   factor, prescribed central characters factor through `Z(𝔸)/(Z(F)A_G)`, and algebraic norm
   twists are separate data. Thus functions really descend to `G(F)A_G\G(𝔸)`.

Two scope points still need expert sign-off before the attached-system declaration is frozen. The
normalization itself is no longer an open choice: the table below and the discriminant regression
test pin it.

- **SIGN-OFF A — cuspidality and one-dimensional representations.** For split `D`, the intended
  theorem uses cuspidal representations. For division `D`, there are no proper `F`-parabolics, so
  the standard constant-term predicate is vacuous and still includes `χ ∘ Nrd`. The provisional
  target requires both cuspidality and “not a reduced-norm character.” Confirm that scope or state
  the larger character/Eisenstein conclusions separately.
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
| [Lie highest weight, Layers 7 and 9](../RepresentationTheory/LieHighestWeight/README.md#layer-7-the-center-of-ul-harish-chandra-freudenthal-and-serres-relations): `Z(U(𝔤))`, Harish--Chandra isomorphism, reductive `gl_n` weights | the center acting in the `Z(𝔤_ℂ)`-finite condition and split archimedean weight calculations | infinite-dimensional Harish--Chandra modules |
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
| 0 | Mathlib matrix groups, number fields, completions and tensor products; cited central-simple-algebra targets | standard `GL_n` parabolics and integral models; reduced characteristic polynomial/trace/norm, quaternion involution, local splitting, and the order→Azumaya→local-splitting proof that ramification is finite |
| 1 | Layer 0; landed reductive-group interfaces; Mathlib adèles and restricted products | local and adelic groups; discreteness/cocompactness of the additive diagonal; invariant measures on unipotent homogeneous spaces; nonarchimedean Iwasawa and finite `P\G/J`; idelic quaternionic units; orders, compact opens, splitting torsors; compactness modulo `A_G` and finite class sets |
| 2 | Layer 1 locally profinite groups; Mathlib invariant submodules | the shared smooth-representation category and exact compact-open invariants, normalized induction and admissibility, smooth dual, and restricted tensor products with genuinely chosen reference vectors |
| 3 | Layer 1 archimedean groups; cited Lie/compact-group targets | shared Harish--Chandra pairs/modules, exact invariants for disconnected compact groups, and explicit `O(n)`, `U(n)`, `Sp(1)` instances including the holomorphic/antiholomorphic `GL₂(ℝ)` discrete-series models |
| 4 | Layers 0--3 | distinct local-constancy and finite-level predicates; the `A_G` contract; uniform moderate growth under every `U(𝔤)` derivative; invariant quotient measures and constant terms; class-set models; occurrence and the complete discriminant factorization witness |
| 5 | Layers 0, 1, 3, 4; `gl_n` highest weights; Mathlib chain complexes and alternating maps | full relative Chevalley--Eilenberg theory; a Type-valued global coefficient witness; splitting-transport coherence; central-character/unit-theorem parity; and the pinned C-to-L normalization |
| 6 | Layers 1, 2, 4, 5; Modular Forms Layer 2 once landed; Mathlib Haar measure | one-measure level corners and idempotents; extension from `ℤ_p/ℚ_p` to `𝒪_v/F_v`; exact normalized Satake; simple spherical fixed lines; quaternionic transport; and one shared normalized `GoodPlaceHeckeDatum` |
| 7 | Mathlib absolute Galois groups, completions, module topology and `Q̄_p` | chosen embeddings of algebraic closures, local-to-global maps, inertia/Frobenius exact sequences, independence of Frobenius lifts, continuity of matrix realizations, and basis-independent characteristic polynomials |
| 8 | Layer 7 | finite-place/residue-characteristic bookkeeping, one compatibility predicate containing semisimplicity, coefficient-field enlargement/equivalence, and exact polynomial formulas for sums, duals, tensors, twists, and restriction of the source field |
| 9 | Layers 4, 5, 6, 8 | one declaration joining the actual automorphic witness, coefficient system, shared good-place Hecke datum, and compatible family; no proxy predicates |

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
                                             ▼
                                      5 cohomological
                                             │
                                             ▼
                                      6 GL_n Satake / Dˣ Hecke

7 local Galois theory ──▶ 8 good-place compatible systems

             4 automorphic + 5 cohomological + 6 normalized Hecke + 8 Galois ──▶ 9 statement
```

The `1G` and `1D` tracks run in parallel and meet only through shared interfaces and explicit split
comparisons. Layers 2 and 3 can also advance in parallel once their concrete groups exist. Layer 4
consumes both; Layer 5 consumes Layers 3--4. The measure/corner and abstract Satake portions of
Layer 6 can begin earlier, but its arithmetic Hecke normalization and `π`-attached datum consume the
Layer 5 cohomological witness. Layers 7--8 are independent. Layer 9 starts only when all four
incoming interfaces have executable examples and stable names.

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
- the purely algebraic fact that every proper standard parabolic is contained in a maximal one;
  the factorization of the corresponding integrals is deferred to Layer 4, after quotient measures
  and Fubini have been constructed;
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
- ramification at real and finite places, and the following named proof that the finite ramified
  set is finite: choose an order, show it is Azumaya away from a finite discriminant set, split its
  reduction over the finite residue field by the vanishing of the finite-field Brauer group, and
  lift the splitting over the henselian completion;
- the existence/classification theorem for quaternion algebras with a prescribed finite even set
  of ramified places, together with a concrete totally definite example: over an even-degree
  totally real field there is a quaternion algebra ramified at every real place and at no finite
  place (and over odd degree the parity condition forces an additional finite ramified place);
- concrete comparisons with Mathlib's quaternion/Hilbert-symbol presentations.

Coordinate the concrete comparison work with the active Mathlib quaternion PRs. The intrinsic notion
belongs in Tau Ceti until Mathlib accepts an equivalent definition; downstream code must depend on
the intrinsic interface, not on its temporary location.

The quaternionic part is closed only when scalar extension applies to `F_v`, reduced norm detects
units, the split comparison produces `M₂(F_v)` with reduced norm equal to determinant, the concrete
totally definite algebra above is inhabited, and a computed finite set contains every nonsplit
finite place. The whole layer closes when the split `GL_n` parabolics and integral models use the
same matrix-group API consumed by Layers 1, 4, and 6.

### 0.3 Global conventions

Create one documented namespace for conventions used by every later layer. It contains arithmetic
Frobenius (no global Artin-reciprocity API is required by this statement), right translation on
automorphic forms, normalized and unnormalized induction/Satake transforms, the positive real
square root of `q_v` over `ℂ` (or an explicit coefficient extension elsewhere), the full real Lie
algebra with a genuine maximal compact, and embeddings of rationality fields into `ℂ` and `Q̄_p`.
The maximal compacts are `O(n)` for `GL_n(ℝ)`, `U(n)` for `GL_n(ℂ)`, and `Sp(1)` for `ℍˣ`; the
split real center is not adjoined to them.

The following normalization table is part of the API, not prose left to a later theorem.

| Input/output | Pinned convention |
|---|---|
| automorphic occurrence | the `A_G`-trivial normalization of Layer 4, with right translation |
| algebraic coefficient | `W_alg` is the highest-weight representation; relative cohomology uses `W_alg^∨` |
| arithmetic representation | `π^L` is obtained from `(π_∞,W_alg,ω_π)` by the uniquely recorded determinant/reduced-norm twist which makes the parameter L-algebraic |
| normalized Satake parameter | the unordered tuple `z=(z₁,…,z_n)` for `π_v^L` with normalized induction |
| arithmetic roots | `α_i=q_v^{(n-1)/2}z_i` |
| `n=2` Hecke data | `a_v=α₁+α₂` and `N(v)s_v=α₁α₂`; equivalently `T_v=a_v` and `S_v=s_v` in Taylor's classical normalization |
| Galois comparison | `α_i` are the eigenvalues of `ρ(Frob_v^arith)`; neither inverses nor a contragredient are inserted |

For the original `A_G`-normalized `π`, raw convolution eigenvalues are separately named and a
comparison theorem computes the coefficient-system twist relating them to `a_v,s_v`. One Haar
measure `μ_v` is fixed on `G(F_v)`, normalized by `μ_v(K_v)=1` for the standard hyperspecial
`K_v` at a good place; smaller levels use `e_J=1_J/μ_v(J)` without changing `μ_v`. The comparison
tracks the right-action inverse/opposite-ring convention.

Three regression tests enforce the table: an explicit `GL_n` unramified principal series checks
every `q_v` exponent; the cyclotomic family has polynomial `X-N(v)` for arithmetic Frobenius; and
the adelized discriminant has `X²-τ(p)X+p¹¹`. Reversing Frobenius, dualizing `π`, replacing
`W_alg^∨` by `W_alg`, or using the raw unitary eigenvalue makes at least one of these tests fail.

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
- discreteness and cocompactness of `F ⊂ 𝔸_F`, including a compact fundamental set, and closedness
  and discreteness of the rational diagonal in `GL_n(𝔸_F)`, with the measurable quotient
  structures needed for automorphic forms;
- local and adèlic points of the standard parabolics, Levis, and unipotent radicals from Layer 0,
  including compactness of the homogeneous space `U_P(F)\U_P(𝔸_F)`; because `U_P(F)` need not be
  normal, do not call this a quotient group or its measure Haar measure;
- a central filtration of `U_P` with additive successive quotients, the invariant probability
  measure characterized by Weil's integration formula, and the quotient-measure/Fubini theorems
  used to compare iterated constant terms;
- nonarchimedean Iwasawa `G(F_v)=K_vP(F_v)` for every standard parabolic, the explicit modulus
  character `δ_P`, compactness of `P(F_v)\G(F_v)`, and finiteness of `P(F_v)\G(F_v)/J` for every
  compact open `J`;
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
- at a split finite place, the torsor of splittings with `GL₂(F_v)`; use Skolem--Noether to
  transport along its inner-conjugacy action rather than claiming a literal choice-independent
  map. For unramified integral data, prove existence of a splitting adapted to the chosen maximal
  order, identify its ambiguity by the appropriate normalizer, and show that conjugacy-invariant
  outputs are independent while intertwiners are determined only up to central scalar;
- the fact that only finitely many places are ramified, so the restricted product is based at the
  standard compact subgroup almost everywhere; prove that changing the global maximal order changes
  only finitely many local compact opens and gives the same restricted-product topology;
- the center `𝔸_Fˣ → Dˣ(𝔸_F)`, the quotient by `Dˣ(F)`, and the quotient modulo the center used in
  growth and volume statements, including closedness/discreteness of the diagonal rational points
  and the resulting quotient topologies and measurable structures;
- the connected split-real central factor `A_G` and, when `D` is division, compactness of
  `Dˣ(F)A_G\Dˣ(𝔸_F)`; for every compact open `K_f`, deduce finiteness of the double class set,
  finiteness of its arithmetic stabilizers modulo the prescribed center, and the fixed-level
  function-space equivalence consumed in Layer 4;
- the proper `F`-parabolics and unipotent radicals needed for cuspidality: prove there are none when
  `D` is division, and transport the standard Borel/unipotent description through a splitting when
  `D ≃ M₂(F)`, independently of that splitting.

At an infinite place, equip `F_v ⊗[F] D` with a finite-dimensional real normed-algebra structure and
use the left regular representation to construct a submultiplicative norm. Its units are an open
submanifold of the underlying finite-dimensional real vector space. Prove that the resulting smooth
and Lie-group structures are independent of the auxiliary norm and agree with `GL₂(ℝ)` at split
real places and `ℍˣ` at ramified real places. This concrete path is the reason general scheme
analytification is not a blocker.

Acceptance examples are split `GL_n` for general positive `n`, `F=ℚ,D=M₂(ℚ)`, and the concrete
totally definite quaternion division algebra from Layer 0. A separate `GL₃` example verifies that
`U(F)\U(𝔸_F)` for its nonabelian maximal unipotent is handled as a homogeneous space. Layer 1
closes only when the finite local and finite adèlic groups in both tracks are locally compact
totally disconnected topological groups, their standard compact opens form the restricted-product
data, `D=M₂(F)` agrees with the `GL₂` construction, and Layers 2 and 4 can use Iwasawa, quotient,
class-set, and parabolic objects without choosing bases, orders, or splittings afresh.

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
- for characteristic-zero coefficients, exactness of `K`-invariants for compact open `K`: reduce
  each finite collection of smooth vectors to an action of a finite quotient and average there;
  record the Reynolds idempotent and its compatibility with inclusions of compact opens;
- admissibility: `V^K` is finite-dimensional for every compact open `K`;
- irreducibility and semisimplicity interfaces using Mathlib's representation vocabulary;
- smooth induction and compact induction as equivariant function spaces whose members have one
  common compact-open right stabilizer (`HasFiniteLevel`), including support modulo a subgroup,
  translation actions, transitivity, and Frobenius reciprocity; the finite-group induction roadmap
  supplies patterns but not these objects;
- admissibility of normalized parabolic induction for `GL_n(F_v)`, proved using the Layer 1
  Iwasawa decomposition and finiteness of `P(F_v)\G(F_v)/J` before principal series are used as
  tests;
- the smooth contragredient (smooth vectors in the algebraic dual), central characters, twists, and
  restricted tensor products of representations with specified spherical vectors at almost every
  place;
- a bundled restricted-tensor-product representation carrying its local components and genuinely
  chosen nonzero reference vectors at almost every place. The construction depends on those
  vectors: maps must preserve them at almost every place, and rescaling gives a canonical
  comparison only when the rescaling is trivial almost everywhere (with the remaining finite
  tensor of scalars recorded). Independence from a choice of *line* is deduced only after Layer 6
  proves that the spherical fixed space is one-dimensional.

Do not encode smoothness as continuity of an action on a discrete vector space unless the exact
equivalence has been proved. Use Mathlib's invariant-submodule construction after restricting to a
subgroup, rather than introducing a second notion of fixed vectors.

Test the API on smooth quasicharacters of `F_vˣ`, finite-dimensional representations of compact
groups, normalized and unnormalized principal series of `GL_n(F_v)`, their `n=2` transport to
split `D_vˣ`, and representations of division `D_vˣ`. Parabolic induction carries the explicit
modulus character and chosen square root and proves the smoothness/admissibility statements it
uses. For division
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
- Reynolds operators on finite-dimensional `K_v`-stable subspaces, obtained from normalized Haar
  measure, and exactness of invariants for the full possibly disconnected compact group; this is
  needed before Layer 5 may take invariants in a long exact sequence;
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

For `GL₂(ℝ)`, construct explicit Harish--Chandra modules for the holomorphic and antiholomorphic
discrete series with the required lowest/highest `SO(2)`-types. Extend them across the
determinant-negative component, record the reflection action giving the full `O(2)`-module, and
compute the central and infinitesimal characters. These are constructions, not names imported from
the analytic classification. The `ℍˣ` test similarly constructs the finite-dimensional
`Sp(1)`-types and the action of the noncompact center.

This layer should consume the Lie group and universal-enveloping-algebra work in the representation-
theory roadmap. Concrete matrix and quaternion unit groups are mandatory tests; the API must not
assume every maximal compact group is connected, and the noncompact center is retained explicitly.
Casselman--Wallach globalization, continuous Fréchet contragredients, the unitary dual, and
Harish--Chandra's admissibility theorem for irreducible unitary representations are outside this
algebraic layer. They must be added as named analytic prerequisites before any later roadmap uses
them.

Layer 3 closes only when the `(𝔤,K)` modules attached to the archimedean action on automorphic
functions can be constructed in Layer 4, the holomorphic/antiholomorphic `GL₂(ℝ)` modules carry
the full `O(2)` action, and relative cochains can restrict exact sequences without additional
differentiation, averaging, or globalization machinery.

## Layer 4: automorphic forms and automorphic representations

Define the shared automorphic-form interface for a concrete adelic group equipped with rational
points, center, archimedean Lie data, parabolics, and a height. Instantiate it for `GL_n` and
quaternionic `Dˣ`; do not write two definitions which merely happen to have the same fields. The
standard conditions are real predicates:

- two distinct finite-adèlic regularity predicates: `IsLocallyConstant` and
  `HasFiniteLevel f := ∃ K_f` compact open such that `f(gk)=f(g)` for every `k∈K_f`. Prove finite
  level implies local constancy. Do not assert the converse without a compactness hypothesis: an
  explicit locally constant function on `ℚ_p`, built from clopen balls whose radii shrink while
  their centers escape to infinity, has no uniform open translation stabilizer;
- the automorphic-form and smooth-induction spaces use `HasFiniteLevel`, not mere local constancy;
  on each fixed level, compare with functions on the corresponding quotient;
- left invariance by the diagonal rational points;
- the differentiated right action of `𝔤_ℂ` and `U(𝔤_ℂ)` on that function space, compatibility with
  right translation, and `K_∞`-finiteness;
- `Z(𝔤_ℂ)`-finiteness, pinned as annihilation by a finite-codimensional ideal (and compared with a
  finite-dimensional center orbit under the hypotheses where they agree);
- the connected split-real central factor `A_G` from Layer 1 and the pinned normalization:
  functions are left invariant under `G(F)A_G`, while a prescribed central character is a
  character of `Z(𝔸_F)/(Z(F)A_G)`. Algebraic determinant/reduced-norm powers are stored as explicit
  twist data and transported into or out of this model, so no function transforming nontrivially
  under `A_G` is falsely said to descend through it;
- a basis-independent adelic height from a faithful representation which sees both `g` and `g⁻¹`,
  comparison of two choices, and quasi-submultiplicativity with its archimedean constants retained.
  Uniform moderate growth means that there is one exponent `N` such that for every
  `D∈U(𝔤_ℂ)` there is a constant `C_D` with
  `|(R_D f)(g)| ≤ C_D height(g)^N` on `G(F)A_G\G(𝔸_F)`. Prove that right translation and every
  right differential operator preserve this condition. Determinant and reduced norm alone are not
  heights because they miss directions such as `diag(t,t⁻¹,1,…)`;
- the invariant probability measure on each compact homogeneous space
  `U_P(F)\U_P(𝔸_F)`, constructed in Layer 1 from Weil integration rather than called a quotient
  Haar measure; use its central filtration and Fubini theorem to define the constant-term integral,
  prove iterated constant terms agree, and prove that vanishing is independent of a rescaling;
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

For totally definite `D`, consume compactness modulo `A_G` and class-set finiteness from Layer 1.
At compact open level `K_f`, identify automorphic forms with a finite product of invariant spaces
under the finite arithmetic stabilizers, including the central-character and weight actions. This
is the theorem behind the finite-function model and the level-Hecke action; neither finiteness nor
the stabilizer calculation is inferred from the words “totally definite.”

A `QuaternionRepresentationDatum` bundles commuting archimedean Harish--Chandra and finite-adèlic
restricted-tensor-product actions, with its local components and reference vectors as data. A
Type-valued `CuspidalAutomorphicWitness` adds irreducibility and admissibility in that product
category and an explicit subquotient occurrence in this space. Keep the witness: later theorems
transport Hecke eigenvalues and cohomology along it. Define isomorphisms and prove independence of
the chosen occurrence model. This structure does **not** prove that such objects exhaust all
irreducible constituents, nor may admissibility be inferred from the proposed local factors without
the relevant finiteness theorem. Those comparisons require Flath and Harish--Chandra results and
belong to a later roadmap.

**SIGN-OFF A occurs here.** Keep `IsCuspidal` as the standard constant-term predicate and keep
`IsReducedNormCharacter` separate. If the target is to include reduced-norm characters,
noncuspidal discrete constituents, or Eisenstein constituents, introduce those spectra distinctly
and state their reducible conclusions. Do not redefine “cuspidal” case-wise to conceal the
anisotropic phenomenon, and do not silently broaden `CuspidalAutomorphicWitness`.

Tests:

- `GL₁` recovers continuous adelic Hecke quasicharacters at the level of definitions, with
  algebraicity imposed only when a coefficient-system theorem needs it;
- for general `n`, the standard parabolics give the usual `GL_n` constant terms;
- when `D=M₂(F)`, compare the quaternionic definitions with the same `GL₂` interfaces, rather than
  with a second copy of them;
- when `D` is totally definite, identify fixed-level weight-two forms with functions on the finite
  double class set with its finite stabilizer conditions and recover the current FLT-style model
  after migration;
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
  condition for every proper rational parabolic, not just the standard upper unipotent, and weight
  12 giving the full `O(2)` archimedean module, including determinant-negative/reflection and
  holomorphic/antiholomorphic conventions;
- named local factors: the Layer 3 archimedean discrete-series module, an unramified admissible
  finite-place factor and nonzero spherical vector at every prime, and their restricted tensor
  product with those vectors as actual reference data;
- a right-equivariant map from that restricted tensor product to the automorphic orbit generated
  by the adelized discriminant, followed by the precise irreducible subquotient/occurrence witness,
  admissibility proof, and proof that it is not a determinant/reduced-norm character.

Layer 5 then proves this representation cohomological in the expected degree. This track is an
inhabitation proof, not the normalization test of Layer 6, and every bridge named above is part of
the work; the existence of a classical cusp form alone does not manufacture an automorphic
representation.

Do not reuse this strong-approximation argument for a totally definite quaternion norm-one group:
its archimedean factors are compact and the relevant strong approximation statement fails. The
finite double-coset model there instead uses compactness modulo center.

Layer 4 closes only when the same automorphic-form structure works for split `GL_n` and `Dˣ`,
finite level is not conflated with local constancy, its constant terms are actual integrals on
homogeneous spaces, the `A_G` and uniform-growth contracts are enforced, the Layer 2 and Layer 3
actions are defined, and an occurrence witness transports local components and Hecke actions
without a new choice of model. The discriminant track must reach the named factorization witness,
not merely an adelized function. No closure criterion invokes reduction theory, rapid decay, an
`L²` decomposition, or exhaustiveness.

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
  `GL₂` representation `W_alg=Sym^r ⊗ det^m` and tensor over the embeddings. Splittings form a
  torsor: store transport maps, prove the Skolem--Noether cocycle law, and state precisely that
  conjugacy-invariant coefficient systems are independent while a chosen intertwiner is only
  defined up to central scalar; compare with the comodule/Weil-restriction formulation only after
  that separate reductive-groups interface exists;
- a Type-valued `CohomologicalWitness π`, not a bare proposition. It carries the coefficient field,
  `W_alg` and its global/rational structure, archimedean embeddings and complex-conjugation
  compatibilities, coherent quaternion-splitting transports, the central-character compatibility,
  a degree, and a specified nonzero class in `H*(𝔤,K; π_∞ ⊗ W_alg^∨)`;
- the central-parity theorem: for the genuine global algebraic coefficient system and automorphic
  central character above, the unit theorem forces the archimedean central weights to be paritious
  and hence supplies the pinned L-algebraic determinant/reduced-norm twist. This theorem is what
  lets Layer 6 consume every `CohomologicalWitness`. A broader definition admitting mixed-parity
  W-algebraic data would instead require an explicit paritious hypothesis in Layer 9 and is not the
  definition pinned here;
- the defining examples for general split `GL_n`, and the classification/computation for
  `GL₂(ℝ)` and `ℍˣ` needed to recover the familiar parallel and nonparallel weight conditions.

Do not replace the cohomology definition by a weight predicate. The weight classification is a
theorem and a critical test, while relative cohomology is the invariant definition used at the
target.

The coefficient convention is fixed: `W_alg` is the highest-weight algebraic representation and
relative cohomology uses its dual. The central-parity theorem and the highest weight compute the
unique twist recorded in the Layer 0 normalization table; for `GL_n` its universal
C-to-L factor is `|det|^{(n-1)/2}`, and for quaternionic `Dˣ` it is the `n=2` reduced-norm
analogue, combined with the integral central twist coming from `W_alg`. The full Lie algebra and
genuine maximal compact remain fixed. Prove the table as a comparison theorem rather than
identifying coefficient-system-normalized operators with raw convolution by notation.

Layer 5 closes only when `CohomologicalWitness π` contains all of the data above, the
central-parity/L-algebraic-normalization theorem is proved, the split `GL_n` coefficient systems
elaborate uniformly, and the `GL₂(ℝ)` and `ℍˣ` computations use that same definition. For the
discriminant, the witness has `W_alg=Sym¹⁰` and produces the arithmetic twist used in Layer 6.

## Layer 6: double cosets, `GL_n` Satake theory, and quaternionic rationality

### 6.1 Shared Hecke interface

Consume the abstract double-coset ring and integral `GL_n` calculations from the
[Modular Forms roadmap](../ModularForms/README.md#layer-2-hecke-operators-and-the-hecke-algebra)
once they have landed. Do not define a rival basis or multiplication. For a locally profinite group
`G`, fix one left Haar measure `μ`. Construct `C_c^∞(G)` once and, for every compact open `J`,
the level-`J` algebra

```text
H(G⫽J; μ) = e_J * C_c^∞(G) * e_J,       e_J = 1_J / μ(J).
```

Reserve “spherical” for a hyperspecial/maximal compact. The abstract `vol(J)=1` double-coset
algebra is a rescaled presentation compared explicitly with this corner; it does not replace `μ`.
Prove:

- closure and integrability of convolution and the algebra laws;
- finiteness of the relevant coset decompositions and comparison with the finite double-coset sum;
- an explicit isomorphism from the scalar extension of the integral double-coset ring to the
  convolution algebra at the standard maximal compact, tracking all `μ(J)` factors and whether
  `g ↦ g⁻¹` introduces an opposite ring;
- `e_J*e_J=e_J`, identification of `e_JV` with `V^J`, exactness of this functor for smooth
  characteristic-zero representations, and the equivalence between simple unital modules over the
  corner and irreducible smooth representations generated by their `J`-fixed vectors;
- for `J'⊆J`, the fixed-measure inclusions/corner maps and their possibly nonunital units, with
  compatible actions on fixed vectors and automorphic forms; prove compatibility with restricted
  tensor products and global right translation.

The Modular Forms hand-off is proved first for `ℤ_p ⊂ ℚ_p`. Generalize the elementary-divisor and
lattice-counting comparison to the valuation ring `𝒪_v ⊂ F_v` at an arbitrary number-field place,
including existence and change of uniformizer, residue-cardinality bookkeeping, and preservation of
structure constants. None of those results follows merely by renaming `p` to `v`.

Package the full nonunital algebra `C_c^∞(G)=⋃_J H(G⫽J;μ)` with the inclusions just constructed.
An equivalence between all smooth representations and nondegenerate modules over it is not required
by the attached-system target and must not be assumed. Iwahori calculations are likewise
downstream.

### 6.2 Split `GL_n` and Satake

For `K_v=GL_n(𝒪_v)`, build the Cartan decomposition indexed by dominant coweights, its finiteness
and convolution structure constants, and the Satake isomorphism. The implementation shares the
composition/dominance combinatorics from Layer 0 and the localized integral ring from Modular Forms
Layer 2. Pin both normalizations:

- the normalized transform uses `δ_B^{1/2}` and, over `ℂ`, the positive square root of the residue
  cardinality `q_v`; over other coefficients the required square root or extension is data;
- if `c_i` is the characteristic function of
  `K_v diag(ϖ,…,ϖ,1,…,1) K_v` with `i` copies of `ϖ`, then the normalized transform is exactly
  `Sat(c_i)=q_v^{i(n-i)/2}e_i(z₁,…,z_n)`;
- the unnormalized transform and its twisted Weyl action are separately named.

Prove that an irreducible admissible spherical `GL_n(F_v)` representation has a one-dimensional
`K_v`-fixed space, relate its eigencharacter to the unordered normalized Satake parameter
`z=(z₁,…,z_n)`, and test the formula on explicit unramified principal series. Distinguish all four
objects in theorem names: normalized parameters `z_i`, arithmetic roots
`α_i=q_v^{(n-1)/2}z_i`, normalized/raw convolution eigenvalues, and classical arithmetic Hecke
operators after the coefficient-system twist.

At `n=2` the `π^L`-normalized level has
`T_v=q_v^{1/2}(z₁+z₂)=α₁+α₂` and `S_v=z₁z₂`, so

```text
P_v(X)=X²-a_vX+N(v)s_v.
```

For an `A_G`-normalized automorphic `π`, a separate comparison theorem uses its
`CohomologicalWitness` to calculate the twist from raw eigenvalues to these `T_v,S_v`. Its
`GL₂/ℚ` weight-12 instance proves `T_p=τ(p)`, `S_p=p¹⁰`, and hence
`P_p=X²-τ(p)X+p¹¹`.

### 6.3 Quaternionic good places and rationality

At a split finite place, transport the `n=2` construction to `D_vˣ` along the Layer 1 splitting
torsor. Prove that changing an adapted splitting conjugates the operators and hence leaves their
characteristic data invariant; do not claim the chosen intertwiner itself is canonical. For
`coh : CohomologicalWitness π` package one shared `GoodPlaceHeckeDatum π coh E` containing:

- an embedding `ι∞ : E → ℂ` and a finite set `S` containing every nonsplit place, every place where
  `π_v` is not spherical, and every place where the required integral data are unavailable;
- a predicate `IsGoodPlace v := v ∉ S` together with the split/unramified consequences;
- the pinned arithmetic twist `π^L` computed from `coh`, polynomials
  `P_v=X²-a_vX+N(v)s_v ∈ E[X]` for good `v`, and a proof that mapping by `ι∞` gives the actual
  coefficient-system-normalized complex Hecke polynomial of `π`, not raw convolution on `π` and
  not merely a polynomial with the desired shape;
- invariance under isomorphism of automorphic representations and enlargement of `S`, and comparison
  of two good-place data after embedding their coefficient fields in a common overfield.

Use a record carrying the field and embeddings rather than asserting that all eigenvalues literally
belong to a predetermined subfield of `ℂ`. Compare with the classical arithmetic normalization in
Modular Forms PR #47 and with the migrated totally definite FLT operators. Coordinate with
[FLT#584](https://github.com/ImperialCollegeLondon/FLT/issues/584) and
[FLT#585](https://github.com/ImperialCollegeLondon/FLT/issues/585); the target uses only spherical
good-place operators.

`GoodPlaceHeckeDatum` is the sole owner of `S`, `IsGoodPlace`, and `P_v`; Layers 8 and 9 consume
this very object. Existence for every relevant `π` is not assumed: it is part of the attached-system
conclusion. Layer 6 closes when the general `GL_n` principal-series test has the exact normalized
`q_v` powers, the `n=2` and totally definite examples produce the displayed polynomial, the
discriminant produces exactly `X²-τ(p)X+p¹¹`, and changes of level, fixed-measure presentation,
or quaternionic splitting leave the represented Hecke data invariant in the stated sense.

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
Frobenius. Do not overload “base change”: give different names and variance lemmas for scalar
extension of the coefficient field, restriction of a representation from `Gal(F̄/F)` to
`Gal(L̄/L)`, transport along an isomorphism of source fields, and changing/conjugating the chosen
algebraic-closure embedding. For `w|v` in `L/F`, the restriction theorem records the residue degree
`f(w/v)` and sends arithmetic `Frob_w` to the `f(w/v)`-th power of arithmetic `Frob_v`, up to
the stated conjugacy.

Test cases include the trivial representation, finite characters, the cyclotomic character, direct
sums, conjugate representations, coefficient scalar extension, and source-field restriction along
a number-field embedding.

For this roadmap, semisimplicity is a predicate on a representation. A general continuous
semisimplification construction, including proof that it preserves continuity over `Q̄_p`, is built
before it is used by the operations library but is not smuggled into the target merely by writing
`ρᵐˢˢ`. Layer 7 is closed when unramified arithmetic-Frobenius characteristic polynomials are
basis-, lift-, and local-embedding-independent and can be mapped along a coefficient embedding.

## Layer 8: good-place compatible systems

Define a positive-dimensional family over a number field `E` as continuous representations over
`Q̄_p` indexed by a prime `p` and a field embedding `φ : E → Q̄_p`. Given the
`GoodPlaceHeckeDatum` from Layer 6, a good-place-compatibility witness consists of:

- for every `(p,φ)` and every `v` satisfying that datum's `IsGoodPlace` whose residue
  characteristic is not `p`, unramifiedness at `v` and equality of the arithmetic-Frobenius
  characteristic polynomial with that same `P_v.map φ`;
- semisimplicity of every member of the family.

Define finite places, the map to their residue characteristic, and the condition “`v` does not lie
over `p`” once, and prove its equivalence with the corresponding ideal-membership and residue-field
formulations already used in Mathlib. The family structure records its dimension and continuity; the
compatibility witness must not recover either from the polynomial equality. Semisimplicity is stated
only in this compatibility witness; Layer 9 does not add a duplicate conjunction.

Supply transport under coefficient-field extension and embeddings, conjugacy, semisimplification,
direct sums, tensor products, duals, Tate twists, restriction to finite field extensions, and
enlargement of the bad set. Define equivalence of systems so that coefficient fields may be enlarged
without changing the mathematical family. These operations include exact root-free polynomial
formulas:

- direct sum uses multiplication of good polynomials;
- dual uses the normalized reverse polynomial, with the nonzero constant term supplied by
  invertibility;
- the `m`-th Tate twist scales roots by `N(v)^m`, with the coefficient-by-coefficient formula stated
  for positive and negative `m` over the appropriate coefficient field;
- tensor product is defined by a resultant formula whose roots are all pairwise products, without
  choosing or adjoining roots;
- restriction from `F` to `L` sends the datum at `v` to the polynomial whose roots are the
  `f(w/v)`-th powers at `w|v`, again implemented by a resultant/power-polynomial construction.

Every operation computes its new bad set, coefficient field, embeddings, degree, and exact monic
polynomial. The four different notions named in Layer 7 are not all called “base change.”

Do **not** require descent to `GL_d(E_λ)`: an irreducible representation whose Frobenius polynomials
lie in `E` can have a nontrivial Schur obstruction and descend only to a central division algebra.
The `Q̄_p`-valued, embedding-indexed design avoids making a false descent assertion; this issue was
encountered in [FLT#410](https://github.com/ImperialCollegeLondon/FLT/pull/410).

The canonical acceptance test, requested in [FLT#23](https://github.com/ImperialCollegeLondon/FLT/issues/23),
is that the `p`-adic cyclotomic characters form a rank-one good-place compatible system with
arithmetic-Frobenius polynomial `X-N(v)`. No global class-field-theory construction is imported for
this test. Further tests verify the exact polynomials for sums, duals, tensors, Tate twists, and
source-field restriction.

**SIGN-OFF C occurs here.** Record explicitly that neither de Rham/crystalline behavior nor
Hodge--Tate weights are fields of `GoodPlaceCompatible`. “Strict compatibility” is another stronger
structure, requiring local Weil--Deligne representations and a common local parameter even at bad
places. Neither stronger meaning is claimed by the attached-system target.

Equivalence of systems carries explicit pointwise intertwiners after a common coefficient-field
extension; it is not defined as equality of good polynomials, which would hide Chebotarev and
Brauer--Nesbitt. Those uniqueness theorems are outside this statement roadmap. Layer 8 is closed
when the cyclotomic example compiles, every operation above has its exact polynomial regression,
and coefficient-field and bad-set enlargement produce explicit equivalences with the expected
common polynomials.

## Layer 9: the attached-system declaration

Once the preceding APIs exist, add a declaration equivalent to the following. The exact universe
and bundling choices should follow the implemented structures.

```lean
/-- Galois representations attached to a cohomological quaternionic automorphic representation,
in the good-place Frobenius-polynomial form. -/
theorem exists_goodPlaceCompatibleSystem
    {F : Type*} [Field F] [NumberField F] [IsTotallyReal F]
    {D : Type*} [Ring D] [Algebra F D] (hD : IsQuaternionAlgebra F D)
    (π : QuaternionRepresentationDatum F D)
    (automorphic : π.CuspidalAutomorphicWitness hD)
    (nonchar : ¬ π.IsReducedNormCharacter automorphic)
    (coh : π.CohomologicalWitness automorphic) :
    ∃ (E : Type*) (_ : Field E) (_ : NumberField E)
      (hecke : GoodPlaceHeckeDatum π coh E)
      (ρ : PadicGaloisFamily F E 2),
      ρ.IsGoodPlaceCompatibleWith hecke := by
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
- the Type-valued coefficient system, degree, nonzero class, central-parity theorem, and pinned
  normalization witnessing cohomology;
- a rationality field, a finite bad set containing the nonsplit and nonspherical places, a named
  `IsGoodPlace`, and one `GoodPlaceHeckeDatum` whose polynomials are attached to the normalized
  actual `π` at every good place;
- two-dimensional continuous semisimple representations for every `(p,φ)`;
- unramifiedness away from the named bad set and `p`, and arithmetic-Frobenius characteristic-
  polynomial equality, including `X²-τ(p)X+p¹¹` in the discriminant regression.

The name `QuaternionRepresentationDatum` deliberately does not assert automorphic occurrence.
The Type-valued `CuspidalAutomorphicWitness` supplies that occurrence, its local factorization, and
admissibility; this avoids the previous contradictory combination of
`QuaternionAutomorphicRepresentation` with a separate proposition saying it is automorphic. The
proof `hD` is consumed by that witness and by every local quaternionic construction, so it is not a
decorative hypothesis.

## Acceptance suite

The roadmap is complete only when all of the following compile as examples or theorems.

1. For every positive `n`, `GL_n(F_v)` and `GL_n(𝔸_F)` carry the stated local,
   restricted-product, parabolic, quotient, and archimedean interfaces; the Lean-facing
   constructors reject `n=0`, and `GL₁` recovers smooth local quasicharacters and adelic Hecke
   quasicharacters.
2. `HasFiniteLevel f` implies `IsLocallyConstant f`. The explicit clopen-ball function on `ℚ_p` is
   locally constant but has no common open translation stabilizer, so the converse cannot be used
   in an automorphic-form constructor.
3. `F\𝔸_F` is compact with its invariant probability measure, and the nonabelian `GL₃` maximal
   unipotent example constructs `U(F)\U(𝔸_F)` as a compact homogeneous space, verifies Weil
   integration and Fubini, and never gives it a quotient-group structure.
4. The scalar extension of `D=M₂(F)` produces the *same* `GL₂` local and global interfaces up to
   named equivalences. Two splittings give conjugate data through the splitting torsor; the test
   distinguishes invariant Hecke output from a noncanonical intertwiner.
5. The prescribed-ramification theorem constructs, over an even-degree totally real field, a
   totally definite quaternion algebra unramified at every finite place. Its quotient modulo
   `A_G` is compact, its level class set and stabilizers are finite, and at parallel weight two
   with trivial central character its fixed-level functions recover the migrated FLT model.
6. Compact-open invariants are exact and agree with the `e_J` corner. Nonarchimedean Iwasawa and
   finiteness of `P\G/J` prove admissibility of an explicit normalized principal series before
   that principal series is used elsewhere.
7. With the full Lie algebra and genuine maximal compact, the explicit holomorphic and
   antiholomorphic `GL₂(ℝ)` discrete-series modules extend to full `O(2)` and have the expected
   relative cohomology; the `ℍˣ` calculation gives the expected degrees when central characters
   cancel and vanishes for a mismatched central action.
8. For `J'⊆J`, one fixed measure `μ` gives idempotents `e_J,e_{J'}`, the correct corner/inclusion
   laws, and compatible fixed-vector actions. The separately normalized `vol(J)=1` and
   `vol(J')=1` presentations compare by the proved rescaling rather than literal identification.
9. For every positive `n`, an explicit unramified principal series verifies
   `Sat(c_i)=q_v^{i(n-i)/2}e_i(z)` and
   `α_i=q_v^{(n-1)/2}z_i`. At `n=2` it verifies separately the raw, normalized, and classical
   arithmetic eigenvalues and the polynomial `X²-a_vX+N(v)s_v`.
10. The modular discriminant track exhibits additive and `SL₂` strong approximation, the
    determinant/idele-class step, every constant term, the full `O(2)` archimedean factor, all
    finite spherical factors and reference vectors, their restricted tensor product, and the
    equivariant occurrence/subquotient witness. Its `W_alg=Sym¹⁰` normalization gives exactly
    `P_p(X)=X²-τ(p)X+p¹¹`.
11. A `GoodPlaceHeckeDatum` proves that its embedded polynomials equal the normalized Hecke
    polynomials of its actual `π`, and two data compare in a common overfield. At `p=2`, the
    polynomial `(X-1)(X-2)=X²-3X+2` of `1⊕χ_cyc` is visibly not
    `X²-τ(2)X+2¹¹=X²+24X+2048`, so it cannot witness the discriminant conclusion.
12. Direct sums, duals, tensors, Tate twists, and restriction of the source field produce the exact
    root-free polynomial formulas of Layer 8, including the residue-degree power at `w|v`.
13. Cyclotomic characters satisfy good-place compatibility with `P_v(X)=X-N(v)` for arithmetic
    Frobenius; coefficient-field extension and bad-set enlargement give explicit equivalences.
14. A documented repository-wide import check confirms that no Tau Ceti file imports `FLT`.
15. The attached-system declaration elaborates with the genuine Type-valued automorphic and
    cohomological witnesses, one shared `GoodPlaceHeckeDatum`, no proxy `Prop`, no suppressed
    compilation, and no hypothesis which merely names missing mathematics.

## Migration and provenance from FLT

This table identifies candidate source material at FLT commit
[`bf70705a77242545d931db4923f2975cf7c9177d`](https://github.com/ImperialCollegeLondon/FLT/commit/bf70705a77242545d931db4923f2975cf7c9177d)
(2026-07-31). It does not authorize copying and does not prescribe Tau Ceti's final file structure.

| FLT source | Material to generalize or migrate | Destination layer |
|---|---|---|
| `FLT/Mathlib/Algebra/IsQuaternionAlgebra.lean` | central-simple rank-four notion and elementary API | 0 |
| `FLT/QuaternionAlgebra/NumberField.lean` | completions, rigidifications, compact opens, level data | 0, 1, 6 |
| `FLT/DedekindDomain/FiniteAdeleRing/` and `FLT/NumberField/AdeleRing.lean` | tensor/restricted-product comparisons, local units, scalar extension, and adèlic topology lemmas | 1 |
| `FLT/Mathlib/MeasureTheory/Constructions/BorelSpace/AdeleRing.lean` and `FLT/HaarMeasure/` | Borel and measure infrastructure to audit against the homogeneous-space construction | 1, 4 |
| `FLT/DivisionAlgebra/Finiteness.lean` and `FLT/Mathlib/GroupTheory/DoubleCoset.lean` | compactness/finiteness ingredients for quaternionic class sets and stabilizers | 1, 4 |
| `FLT/AutomorphicForm/QuaternionAlgebra/Basic.lean` and `FiniteDimensional.lean` | totally definite weight-two fixed-level model, finite double class set, and finiteness | 4 acceptance model |
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

The references do not settle the two remaining scope sign-offs automatically, and they use
differing Frobenius, Satake, and algebraicity conventions. The normalization table and formal
comparison lemmas in Layers 0, 5, and 6 settle those convention differences; the discriminant and
cyclotomic tests detect a reversal.
