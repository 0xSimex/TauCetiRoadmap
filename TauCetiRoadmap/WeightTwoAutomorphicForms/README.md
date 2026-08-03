# Weight-two automorphic forms on quaternionic inner forms of `PGL₂`

## Target and boundary

This roadmap builds exactly the language needed to state the following attachment problem.

> Let `F` be a totally real number field, let `D` be a quaternion algebra over `F`, and let `π`
> be a parallel-weight-two automorphic Hecke eigenpacket for `PGL₁(D)`. There are a number field
> `E`, a finite set `S` of finite places, coefficients `a_v ∈ E` for `v ∉ S`, and a semisimple
> family of continuous representations
> `ρ_{p,φ} : Gal(F̄/F) → GL₂(Q̄_p)`, indexed by primes `p` and embeddings
> `φ : E → Q̄_p`, such that for every `v ∉ S` with `v ∤ p`, the representation is
> unramified at `v` and arithmetic Frobenius has characteristic polynomial
> `X² - φ(a_v)X + N(v)`.

Here `D` is allowed to be `M₂(F)`, a division algebra split at some real places, or a totally
definite quaternion algebra. The Lean implementation uses automorphic forms on `Dˣ` invariant
under the adelic center, together with a proved equivalence to the corresponding `PGL₁(D)`
formulation. This avoids making a quotient-group presentation the primitive analytic object while
keeping the theorem genuinely projective.

"Parallel weight two" has one pinned meaning. At a real place where `D` splits, the local factor is
the full weight-two discrete-series representation of `PGL₂(ℝ)`: its restriction to the identity
component is the holomorphic/antiholomorphic pair, exchanged by a determinant-negative element. At a
ramified real place it is the trivial representation of `ℍˣ/ℝˣ = PGL₁(ℍ)`. The input may be
cuspidal or one-dimensional. Thus the constant form on a totally definite quaternion algebra is a
legitimate test case rather than an exception hidden outside the definitions.

The endpoint is a **statement**, not a proof. This roadmap does not prove the attachment theorem,
Jacquet--Langlands, local--global compatibility at bad places, or any modularity-lifting theorem. It
also does not develop general `GL_n`, arbitrary algebraic weights, general automorphic
representations, Harish--Chandra modules, relative Lie-algebra cohomology, general Satake theory,
Whittaker models, trace formulae, or Eisenstein series. Those subjects belong in a later roadmap.

## Pinned conventions

1. A quaternion algebra over `F` is intrinsically a central simple `F`-algebra of dimension four,
   never a chosen Hilbert-symbol presentation.
2. `PGL₁(D)` means `Dˣ/Fˣ` on rational points and the corresponding central quotient locally and
   adelically. Automorphic functions are implemented on `Dˣ` with trivial adelic central character;
   descent to and pullback from the projective quotient are proved inverse.
3. The finite adèlic group has its restricted-product topology based on units of local maximal
   orders. It is not silently given the subtype topology from units of an unrestricted product.
4. A finite level is one compact open subgroup fixing the form. Local constancy is a consequence,
   not the definition and not a converse.
5. At a good finite place, `D` is split, the level is the standard maximal compact, and the
   eigenpacket is spherical. The bad set contains every place where any of these conditions fails.
   The additional condition `v ∤ p` belongs to Galois compatibility, not to the definition of a
   good automorphic place.
6. `T_v` is the finite double-coset sum for
   `K_v diag(ϖ_v,1) K_v` after an order-adapted splitting. This is the classical arithmetic
   weight-two normalization. If convolution is used for comparison, Haar measure is normalized by
   `vol(K_v)=1`.
7. There is no separate central operator `S_v`: trivial central character fixes the constant term
   of the polynomial to `N(v)`. Thus
   `P_v(X)=X²-a_vX+N(v)`.
8. Frobenius is arithmetic Frobenius. In particular the `p`-adic cyclotomic character sends it to
   `N(v)` when `v ∤ p`.
9. The coefficient field and the assertion that its elements give the actual complex Hecke
   eigenvalues are conclusion data. They are not built into the definition of an eigenpacket.
10. No multiplicity-one assertion is hidden in "eigenpacket": it is a simultaneous eigencharacter
    together with a nonzero vector realizing it.

## Existing material and exact handoffs

Before each migration, search current Mathlib, open Mathlib pull requests, and Lean Zulip. Reconcile
with an in-flight API rather than introducing a parallel vocabulary.

### Mathlib already supplies

- number fields, rings of integers, finite places, completions, adèles, matrices, units, quotient
  groups, tensor products, finite-dimensional module topologies, Haar measure, polynomials, and
  continuous monoid homomorphisms;
- `Field.absoluteGaloisGroup`, `AlgebraicClosure ℚ_[p]`, `GL (Fin 2)`, characteristic
  polynomials, invariant submodules, and the elementary representation API;
- the algebraic quaternion type over a commutative ring, but not the global arithmetic and
  automorphic theory required here.

Every use must be checked against the current declaration and hypotheses. In particular, Mathlib's
adèle ring does not by itself supply the restricted-product topology on quaternionic units, and its
absolute Galois group does not by itself supply decomposition groups, inertia, or Frobenius at a
number-field place.

### Other Tau Ceti roadmaps

| Roadmap | Material consumed here | Material still built here |
|---|---|---|
| [Semisimple algebras](../RepresentationTheory/SemisimpleAlgebras/README.md) | central simple algebras, scalar extension, splitting, Skolem--Noether, Brauer-group foundations | the rank-four quaternion wrapper, reduced invariants, number-field orders, and local/global ramification interfaces |
| [Reductive groups](../ReductiveGroups/README.md) | the concrete functor-of-points and quotient descriptions for `GL₂` and `PGL₂` once available | topological local/adelic `PGL₁(D)`, central-invariant function comparison, levels, and quaternionic inner-form instances |
| [Lie groups](../RepresentationTheory/LieGroups/README.md) | matrix Lie groups, smooth actions, differentiation, connected components, and the concrete `PGL₂(ℝ)`/compact real-group infrastructure | the single weight-two split representation and its reflection action |
| [Compact groups](../RepresentationTheory/CompactGroups/README.md) | normalized Haar measure and the elementary continuous representation API for compact groups | only the trivial `PGL₁(ℍ)` representation is required; Peter--Weyl is not on the critical path |
| [Modular forms](../ModularForms/README.md) | Mathlib's abstract Hecke ring and the `n=2` local--global comparison of double-coset bases and structure constants | the adelic `PGL₁(D)` action, order-adapted splitting independence, and the weight-two normalization |

The handoffs are interfaces, not blanket dependencies on completion of those roadmaps. If a listed
interface has not landed when work reaches it, the contributing PR either lands that interface in
its owning roadmap first or builds the concrete specialization here and records the comparison to
the owning roadmap. It must not assume the missing theorem.

### FLT migration

The FLT repository contains working special cases, especially for totally definite quaternion
algebras. Tau Ceti cannot import FLT. Migration means coordinated PRs which move and improve the
material, preserve authorship and licence notices, and are followed by FLT PRs importing Tau Ceti.
The file map near the end of this document is provenance, not the specification.

## Dependency graph

```text
Layer 0: quaternion arithmetic and projective groups
                      │
                      ▼
Layer 1: local/adelic groups, orders, levels, compactness
             │                          │
             ▼                          ▼
Layer 2: weight two at infinity     Layer 5: local Galois theory
             │                          │
             ▼                          │
Layer 3: automorphic occurrences             │
             │                          │
             ▼                          │
Layer 4: Hecke eigenpackets and rational data │
             └─────────────┬─────────────┘
                           ▼
                 Layer 6: attachment statement
```

Within a layer, the bullets below are in dependency order. A later bullet may use Mathlib, a named
handoff above, or an earlier bullet; it may not use a later layer.

## Layer 0: quaternion arithmetic and `PGL₁`

### 0.1 Intrinsic quaternion algebras

- Define `IsQuaternionAlgebra F D` as centrality, simplicity, and `Module.rank F D = 4`. Prove
  finite-dimensionality and `finrank = 4`, stability under algebra equivalence and scalar extension,
  and the split matrix and Hamilton-quaternion examples.
- Construct the canonical standard involution, reduced trace, and reduced norm from the central
  simple algebra. Prove the degree-two reduced characteristic polynomial, multiplicativity of norm,
  compatibility with scalar extension, and agreement with matrix trace/determinant under every
  splitting. Prove that an element is a unit exactly when its reduced norm is nonzero.
- Prove the global dichotomy: a quaternion algebra is either a division algebra or is split, and in
  the latter case construct an `F`-algebra equivalence with `M₂(F)`. Later case splits use this
  theorem; they must not assume that "nonsplit" definitionally means "division".
- Package local scalar extension `D_v = F_v ⊗_F D`. Prove that it is again quaternionic and, for
  every real or nonarchimedean local field used here, is either split or division. A splitting is
  data, not a global choice.
- Define ramification as the division case. Prove invariance under equivalence and that only finitely
  many finite places ramify. The finite-ramification proof must expose its route: choose an order,
  show it is Azumaya away from finitely many primes, use triviality of the Brauer group of a finite
  residue field, and lift splitting over the henselian completion. Do not cite "almost all places
  split" without building these links.
- Provide the prescribed-ramification theorem needed to construct a quaternion algebra ramified at
  every real place and no finite place when `[F:ℚ]` is even. Its proof must include the reciprocity
  and parity input it uses; this is not a consequence of the local classification alone.

### 0.2 Projective multiplicative groups

- Define the scalar embedding `Fˣ → Dˣ`, prove that its image is exactly the center of `Dˣ`, and
  define `PGL₁(D)=Dˣ/Fˣ` as a quotient group. Prove functoriality under scalar extension and algebra
  equivalence.
- For split `D`, construct `PGL₁(D) ≃ PGL₂(F)` from a splitting and prove that two splittings
  differ by inner conjugation. Maintain both the chosen intertwiner and the resulting
  conjugacy-invariant statements; never claim the chosen equivalence is canonical.
- At a real place, identify the split group with full `PGL₂(ℝ)` and the ramified group with
  `ℍˣ/ℝˣ ≃ SO(3)`. Supply the topological-group and Lie-group forms of these equivalences, not
  only algebraic bijections.

Layer 0 closes when the split and Hamilton examples compile, the ramification predicate is
choice-independent, finite ramification is proved through the stated arithmetic route, and the
projective quotient has usable algebraic and topological interfaces.

## Layer 1: local and adelic groups, levels, and compactness

### 1.1 Local and adelic quaternion algebras

- Build the finite local algebras `D_v`, their finite-dimensional topological-algebra structures,
  and the locally compact, totally disconnected groups `D_vˣ` and `PGL₁(D_v)`.
- Construct full and finite adelic scalar extensions of `D`, the diagonal embeddings of `D` and
  `Dˣ`, and comparison with the restricted product of the `D_v`. For units, prove explicitly that
  invertibility is local with integral-unit conditions at almost every finite place.
- Give `Dˣ(𝔸_F)` and `PGL₁(D)(𝔸_F)` their restricted-product topologies. Prove the
  comparison with the central quotient by the idèles, continuity of all diagonal and projection
  maps, local compactness, and independence of the auxiliary order used to describe the restricted
  product.

### 1.2 Orders and finite levels

- Develop `𝓞_F`-orders in `D`, localization and completion of orders, maximal orders, their
  unit groups, and their behavior at split places. Prove existence of a maximal order and that two
  local maximal orders are conjugate.
- For a maximal order `𝓞_D`, define the standard local maximal compact
  `K_v ⊆ PGL₁(D_v)` as the image of `𝓞_{D,v}ˣ`. At a split place, an order-adapted splitting
  identifies it with `PGL₂(𝓞_v)`.
- Define compact open subgroups of the finite adelic group and restricted-product levels
  `K_f=∏'_v K_v`. Prove compactness, openness, commensurability, and that any compact open level
  admits a product decomposition with the standard local factor at all but finitely many places.
- Bundle the finite set where `D` is nonsplit or the level is nonstandard. Prove its finiteness here,
  before any Hecke datum uses it.

### 1.3 Quotients needed by automorphic forms

- Construct the rational and adelic projective quotients and prove that central-invariant functions
  on `Dˣ(F)\Dˣ(𝔸_F)` are equivalent to functions on
  `PGL₁(D)(F)\PGL₁(D)(𝔸_F)`. Include compatibility with right translation and finite level.
- When `D` is a division algebra, prove compactness of the adelic quotient. Deduce finiteness of
  the double-class set at a fixed level when the archimedean quotient is compact, and finiteness of
  the arithmetic stabilizers. Keep compactness of a quotient separate from finiteness of its
  fixed-level class set.
- For the split algebra, build the upper-unipotent subgroup of `PGL₂`, identify
  `N(F)\N(𝔸_F)` with the additive quotient `F\𝔸_F`, prove that quotient compact, and fix its
  invariant probability measure. Prove the measurability and translation-invariance lemmas needed
  for the constant-term integral in Layer 3.

Layer 1 closes when the split scalar extension agrees with the standard `PGL₂` local and adelic
interfaces, levels have a proved finite exceptional set, the division quotient/class-set theorems
are available, and the additive quotient supports the later cusp integral.

## Layer 2: the parallel-weight-two infinity type

This layer builds one archimedean type directly. It must not introduce a general category of
Harish--Chandra modules as an intermediate API.

- For every real embedding `τ : F → ℝ`, construct the real scalar extension and its split/ramified
  dichotomy, compatibly with the corresponding factor of the adelic group.
- On `PGL₂(ℝ)`, construct the holomorphic weight-two discrete series and its antiholomorphic
  conjugate in an explicit smooth model. Prove the group action, the weight `±2` maximal-compact
  types, the appropriate raising/lowering equations, irreducibility on the identity component, and
  square-integrability of matrix coefficients on `PGL₂(ℝ)`.
- Extend the pair to the full disconnected group `PGL₂(ℝ)`. Prove that a
  determinant-negative element exchanges the two identity-component summands and that the result
  is independent, up to a named intertwiner, of the chosen reflection.
- On `PGL₁(ℍ)`, construct the trivial one-dimensional continuous representation and identify it
  as the weight-two quaternionic infinity type. No classification of all representations of the
  compact group is required.
- Take the finite tensor product over the real places, using the split or ramified factor at each
  place, and define `ParallelWeightTwoInfinityType F D`. Define occurrence by an actual nonzero
  equivariant map or subrepresentation, not by a Boolean label.
- Prove that a one-dimensional occurrence of this infinity type forces every real place to be
  ramified. This explains why characters occur in the totally definite case but cannot masquerade
  as split weight-two cusp forms.

Layer 2 closes with the full-group reflection test at a split place, the trivial Hamilton test at a
ramified place, and the mixed-place tensor product. No relative Lie-algebra cohomology is involved.

## Layer 3: weight-two automorphic occurrences

### 3.1 The ambient function space

- Define complex-valued functions on `Dˣ(F)\Dˣ(𝔸_F)` which are invariant under the adelic
  center, smooth in the archimedean variables, right invariant under some finite level, of moderate
  growth in the split case, and have the Layer 2 infinity type. Package pullback/descent along the
  `PGL₁(D)` quotient as an equivariant equivalence.
- Define `HasFiniteLevel f` using one global compact open subgroup. Prove that it implies local
  constancy in the finite-adelic variable. Also formalize a locally constant function on `ℚ_p`
  without a common open translation stabilizer, so the converse is unavailable to constructors.
- Prove stability under right translation, shrinking the level, complex conjugation, and finite
  linear combinations. State the exact behavior of the holomorphic and antiholomorphic infinity
  components under conjugation.

### 3.2 Cuspidal and one-dimensional occurrences

- For `D=M₂(F)`, define the constant term by integrating over
  `N(F)\N(𝔸_F)` with Layer 1's probability measure. Prove that the integral exists for the
  ambient weight-two functions and is independent of representatives. Define cuspidality by
  vanishing of this one rank-two constant term.
- Prove that a nonsplit quaternion algebra has no proper rational parabolic subgroup. Its
  automorphic spectrum is discrete and its adelic quotient is compact, so no fake copy of the
  split constant-term definition is imposed there.
- Define `WeightTwoAutomorphicOccurrence` as either an actual cuspidal occurrence or an actual
  one-dimensional automorphic occurrence, both carrying the same parallel-weight-two infinity
  witness. A tag without a function or equivariant map is insufficient.
- In the totally definite case, prove that fixed-level forms are functions on the finite double
  class set with the prescribed stabilizer invariance. Deduce finite-dimensionality and construct
  the constant form. Prove an equivariant equivalence with the migrated FLT
  `WeightTwoAutomorphicForm` model rather than maintaining two definitions.

The roadmap does not need a general category of smooth admissible local representations or a
restricted-tensor-product factorization theorem. Layer 3 closes when the split cusp condition and
the division/character case inhabit the same honest occurrence API and the totally definite model
is finite-dimensional.

## Layer 4: good-place Hecke eigenpackets and rational data

### 4.1 The operator `T_v`

- Consume the abstract double-coset ring from the Modular Forms roadmap. Use only its `n=2`
  local--global comparison of double-coset bases and structure constants.
- At a split finite place with standard maximal compact `K_v`, define the projective double coset
  of `diag(ϖ_v,1)`. Prove independence from the uniformizer, from an order-adapted splitting, and
  from replacing the maximal order by a conjugate.
- Define its action as a finite sum of right translations on fixed-level automorphic forms. Prove
  independence from the chosen right-coset decomposition, preservation of the infinity type and
  cuspidality/one-dimensional occurrence, and compatibility with shrinking levels.
- Assemble the commutative good Hecke algebra generated by these operators. Prove that operators at
  distinct finite places commute and that the double-coset action is a ring homomorphism; the
  simultaneous eigencharacter in the next sublayer depends on these facts.
- Prove the normalization comparison with the classical weight-two `T_v`. If convolution is also
  exposed, prove that Haar normalization `vol(K_v)=1` gives this finite-sum action; do not maintain
  unrelated Haar measures for different levels.

### 4.2 Eigenpackets and coefficient fields

- Define `WeightTwoAutomorphicEigenpacket F D` as a Layer 3 occurrence, a finite level, a
  simultaneous eigencharacter for the good `T_v`, and a nonzero vector realizing every eigenvalue.
  Do not assume its joint eigenspace is one-dimensional.
- Define the actual complex eigenvalue `a_v(π)` at each spherical place and prove it is unchanged
  by all choices used to construct `T_v`.
- Define `WeightTwoGoodPlaceHeckeDatum π E` to contain a number-field embedding `E → ℂ`, a
  finite bad set containing all nonsplit, nonstandard-level, and nonspherical places, coefficients
  `a_v ∈ E`, and proofs that their complex images are the actual eigenvalues of `π`.
- Define
  `weightTwoGoodHeckePolynomial N(v) a_v = X²-a_vX+N(v)` and prove monicity, degree two,
  functoriality under coefficient embeddings, and compatibility with enlarging `E` or the bad set.
  The existence of this datum for every eigenpacket belongs to Layer 6's conclusion.
- Compute the constant form: the `q_v+1` cosets give `a_v=q_v+1`, hence
  `X²-(q_v+1)X+q_v=(X-1)(X-q_v)`.

Layer 4 closes when `T_v` is an operator on the actual automorphic space, every auxiliary choice has
been eliminated from its eigenvalue, and the constant-form calculation compiles. General `GL_n`
Cartan decompositions, Satake transforms, principal series, and central `S_v` operators are outside
this roadmap.

## Layer 5: local Galois representations and compatible families

This track can proceed in parallel with Layers 2--4 after Layer 0 fixes the number-field and
Frobenius conventions.

### 5.1 Local restriction and Frobenius

- Define finite places, residue fields, absolute norms, residue characteristics, and `v ∤ p`, with
  comparison lemmas to Mathlib's ideal-theoretic formulations.
- Starting from Mathlib's absolute Galois group, construct the maps induced by an embedding of a
  global algebraic closure into an algebraic closure of `F_v`, the decomposition group, inertia,
  and the residue Galois quotient. Record dependence on the embedding and prove conjugacy
  independence for the invariants used below.
- Define arithmetic and geometric Frobenius classes and prove they are inverse. For an unramified
  representation, prove that the characteristic polynomial of a Frobenius lift is independent of
  the lift and of the chosen local embedding.

### 5.2 Two-dimensional families

- Define a continuous two-dimensional representation as a continuous homomorphism
  `Gal(F̄/F) → GL₂(Q̄_p)`. Supply the topology on `Q̄_p`, matrices, and `GL₂`, restriction to a
  decomposition group, unramifiedness, trace, determinant, characteristic polynomial, conjugation,
  and coefficient scalar extension.
- Define semisimplicity as a predicate on the underlying two-dimensional representation. A general
  continuous semisimplification construction is not needed to state the target.
- Define `TwoDimensionalPadicGaloisFamily F E`, indexed by primes `p` and embeddings
  `E → Q̄_p`. A compatibility witness with a Layer 4 datum requires semisimplicity of every member
  and, for each good `v ∤ p`, unramifiedness and the exact arithmetic-Frobenius polynomial
  `X²-φ(a_v)X+N(v)`.
- Prove transport under conjugating a representation, extending the coefficient field, and
  enlarging the bad set. These are the only family operations required by the endpoint.
- Construct the trivial and cyclotomic one-dimensional representations and their direct sum.
  Prove continuity, semisimplicity, and the arithmetic-Frobenius polynomial of
  `1⊕χ_cyc` is `(X-1)(X-N(v))` at `v ∤ p`.

Layer 5 closes when unramified Frobenius polynomials are basis-, lift-, and embedding-independent,
map correctly along `E → Q̄_p`, and the `1⊕χ_cyc` regression compiles. Tensor products,
duals, Tate twists, resultants, source-field restriction, and bad-place Weil--Deligne data are not
part of this roadmap.

## Layer 6: the attachment declaration

Once Layers 3--5 supply the genuine types, add a declaration equivalent to:

```lean
/-- A semisimple two-dimensional compatible system attached to a parallel-weight-two
automorphic Hecke eigenpacket on a quaternionic inner form of PGL₂. -/
theorem WeightTwoAutomorphicEigenpacket.exists_attachedSystem
    {F : Type*} [Field F] [NumberField F] [IsTotallyReal F]
    {D : Type*} [Ring D] [Algebra F D]
    (hD : IsQuaternionAlgebra F D)
    (pi : WeightTwoAutomorphicEigenpacket F D hD) :
    ∃ (E : Type*) (_ : Field E) (_ : NumberField E)
      (hecke : WeightTwoGoodPlaceHeckeDatum pi E)
      (rho : TwoDimensionalPadicGaloisFamily F E),
      rho.IsCompatibleWith hecke := by
  sorry
```

The exact parameter order follows the implemented structures. The theorem must expose, directly or
through those structures:

- every totally real `F`, every quaternion algebra `D/F`, and both cuspidal and one-dimensional
  parallel-weight-two occurrences;
- one coefficient field, one finite bad set, and coefficients proved equal to the actual `T_v`
  eigenvalues;
- continuous semisimple two-dimensional representations for every `(p,φ)`;
- unramifiedness and the polynomial `X²-φ(a_v)X+N(v)` for arithmetic Frobenius at every good
  `v ∤ p`.

Do not put this theorem in `Suggested.lean` while any named type in the signature would be a proxy
`Prop`. Add it as soon as the genuine Layer 3--5 structures make the statement meaningful.

## Acceptance suite

The roadmap is complete only when all of the following compile as examples or theorems.

1. `D=M₂(F)` gives the standard local and adelic `PGL₂` interfaces. Over `ℝ`, Hamilton's
   quaternions give the compact inner form `PGL₁(ℍ)`.
2. The prescribed-ramification theorem constructs a totally definite quaternion algebra unramified
   at every finite place over an even-degree totally real field.
3. Two order-adapted splittings are related by conjugation; the resulting local level, double
   coset, Hecke operator, and eigenvalue agree in the exact invariant sense claimed.
4. `HasFiniteLevel f` implies finite-adelic local constancy, while the explicit `ℚ_p` clopen-ball
   example refutes the converse.
5. The split real infinity type restricts to the holomorphic/antiholomorphic weight-two pair and a
   reflection exchanges them. The ramified real infinity type is trivial.
6. The split constant-term integral is well-defined on representatives and detects cuspidality.
   The division case uses compactness rather than an invented parabolic integral.
7. Totally definite fixed-level forms are equivariantly equivalent to the migrated FLT
   finite-function model and are finite-dimensional.
8. The good-place operator is the actual finite double-coset action and is independent of the
   uniformizer, splitting, order conjugacy, and right-coset representatives.
9. The constant eigenpacket has `a_v=N(v)+1`, and its polynomial is proved equal to
   `(X-1)(X-N(v))`.
10. The family `1⊕χ_cyc` is semisimple and compatible with the constant eigenpacket using
    arithmetic Frobenius.
11. The final declaration specializes both to parallel-weight-two forms on split `PGL₂` and to
    arbitrary quaternionic inner forms, with one-dimensional cases still admitted.
12. The final signature uses genuine structures, contains no proxy proposition or suppressed
    compilation, and a repository-wide import check finds no Tau Ceti import of `FLT`.

## Migration and provenance from FLT

The following table records candidate source material at FLT commit
[`bf70705a77242545d931db4923f2975cf7c9177d`](https://github.com/ImperialCollegeLondon/FLT/commit/bf70705a77242545d931db4923f2975cf7c9177d)
(2026-07-31). It does not prescribe Tau Ceti's final file structure.

| FLT source | Material to migrate or generalize | Destination |
|---|---|---|
| `FLT/Mathlib/Algebra/IsQuaternionAlgebra.lean` | central-simple rank-four predicate and elementary API | Layer 0 |
| `FLT/QuaternionAlgebra/NumberField.lean` | local scalar extension, ramification, orders, compact opens, and prescribed examples | Layers 0--1 |
| `FLT/DedekindDomain/FiniteAdeleRing/` and `FLT/NumberField/AdeleRing.lean` | finite adèles, restricted products, units, and scalar-extension comparisons | Layer 1 |
| `FLT/DivisionAlgebra/Finiteness.lean` and `FLT/Mathlib/GroupTheory/DoubleCoset.lean` | compactness, finite class sets, stabilizers, and double-coset finiteness | Layers 1, 3--4 |
| `FLT/AutomorphicForm/QuaternionAlgebra/Basic.lean` | central-invariant totally definite weight-two forms | Layer 3 |
| `FLT/AutomorphicForm/QuaternionAlgebra/FiniteDimensional.lean` | fixed-level finite-function model and finite-dimensionality | Layer 3 |
| `FLT/AutomorphicForm/QuaternionAlgebra/HeckeOperators/` | abstract, local, and concrete good-place Hecke actions | Layer 4 |
| `FLT/Deformations/RepresentationTheory/AbsoluteGaloisGroup.lean` and `Frobenius.lean` | local maps, inertia, and arithmetic Frobenius | Layer 5 |
| `FLT/Deformations/RepresentationTheory/GaloisRep.lean` | continuous representations, local restriction, and characteristic polynomials | Layer 5 |
| `FLT/Deformations/RepresentationTheory/GaloisRepFamily.lean` | embedding-indexed compatible families | Layer 5 |
| `FLT/GaloisRepresentation/Automorphic.lean` | weight-two trace/determinant comparison and the final specialized interface | Layers 4--6 |

Do not migrate `FLT/GlobalLanglandsConjectures/GLnDefs.lean`: it concerns the broad theory removed
from this roadmap and contains suppressed compilation rather than a reusable implementation.

Migration follows the layer order in narrow PRs. Each PR records its FLT source commit and authors,
preserves required `Authors:` and notice material, reconciles names with current Mathlib, and adds
the relevant acceptance test in Tau Ceti. Coordinate with the existing authors before moving code.
After a component lands, update FLT to import Tau Ceti and prove comparison lemmas before deleting
the duplicate FLT implementation.

## References

- B. Gross, [*Algebraic modular
  forms*](https://www.math.harvard.edu/~gross/preprints/algmodforms.pdf), Israel J. Math. 113
  (1999), 61--93: the totally definite finite-function model and its Hecke operators.
- H. Jacquet and R. Langlands, [*Automorphic Forms on
  GL(2)*](https://publications.ias.edu/node/60), LNM 114 (1970): `GL₂` and quaternionic inner
  forms, locally and globally.
- J. Getz and H. Hahn, [*An Introduction to Automorphic
  Representations*](https://services.math.duke.edu/~jgetz/aut_reps.pdf), GTM 300 (2024): adelic
  groups, automorphic forms, cuspidality, and Hecke actions.
- R. Taylor, [*On Galois representations associated to Hilbert modular
  forms*](https://typo.iwr.uni-heidelberg.de/fileadmin/groups/arithgeo/templates/data/Hauptseminare/Literature-WS13/taylor_on_gal_reps_associated_to_HMF_1989__01.pdf),
  Invent. Math. 98 (1989), 265--280: the parallel-weight-two good-place polynomial and attached
  Galois-representation statement.
- The [Lean Zulip discussion motivating this
  roadmap](https://leanprover.zulipchat.com/#narrow/channel/416277-FLT/topic/Main.20blockers.20for.20a.20full.20proof.20of.20FLT.2E/near/613821903).
