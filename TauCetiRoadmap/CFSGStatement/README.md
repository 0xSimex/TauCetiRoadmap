# Roadmap: stating the classification of finite simple groups

The goal of **CFSGStatement** is deliberately narrower than a formalization of the
classification of finite simple groups. We want every group on the classification list to be an
honest Lean type with a `Group` instance, so that the classification becomes a named proposition:

```lean
universe u

def ClassificationStatement : Prop :=
  ∀ (G : Type u) [Group G] [Finite G] [IsSimpleGroup G],
    ∃ i : CFSGIndex, Nonempty (G ≃* i.Group)
```

The elaboration of this definition, with no placeholder carrier in any branch of `i.Group`, is the
endpoint. There is no `sorry` and no proof of `ClassificationStatement` in scope. In particular,
this roadmap does **not** ask contributors to prove that a candidate is finite or simple. It also
does not ask for order formulas, automorphism groups, recognition theorems, uniqueness of the list,
or the classification theorem itself. Those are separate developments that can consume the
concrete definitions built here by assuming `ClassificationStatement.{u}`.

Suggested home in Tau Ceti: `TauCeti/GroupTheory/SpecificGroups/CFSG/`, with reusable algebraic-group
machinery placed under the homes chosen by the reductive-groups and root-systems roadmaps.

## What counts as defining a group

Each branch of `CFSGIndex.Group` must reduce to explicit mathematical data:

- the cyclic group of prime order `p` is `Multiplicative (ZMod p)`;
- the alternating group is Mathlib's `alternatingGroup (Fin n)`;
- a group of Lie type is built from the fixed points of an explicit Steinberg endomorphism of an
  explicit pinned algebraic group, then by taking the derived subgroup modulo its center;
- a sporadic group is Mathlib's `PresentedGroup` for an explicit finite list of relator words.

A definition that selects the desired group by `Classical.choose` from an existence or uniqueness
theorem does not meet this requirement. Nor does a predicate that characterizes a group by its
order, involution centralizers, or place in the classification. Foundational choice internal to a
standard construction is allowed: Mathlib's algebraic closures, quotient types, and similar
infrastructure are not disqualified merely because their implementation uses choice. The forbidden
step is choosing a carrier from a theorem whose conclusion already says that it is the named group.
The resulting types should remain useful to downstream work even though CFSGStatement proves no
structure theory about them.

These requirements are enforced by review, not mechanically: Mathlib uses choice pervasively, so
`#print axioms` cannot distinguish an honest construction from one that selects a carrier from the
target existence theorem. Reviewers of each work item must read the definitions and trace the
carrier back to the explicit data named below.

## The list and its conventions

`CFSGIndex` has four constructors.

1. `cyclic p hp`, where `hp : p.Prime`.
2. `alternating n hn`, where `hn : 5 ≤ n`.
3. `lie d`, where `d : ValidLieTypeIndex := {d : LieTypeIndex // d.Valid}`.
4. `sporadic s`, where `s : SporadicName` is one of the twenty-six named sporadic groups.

The proof fields restrict the list; they do not bundle or demand `Finite` or `IsSimpleGroup`
instances for the constructed groups. All group-valued Lie-type definitions take
`ValidLieTypeIndex`, never a raw `LieTypeIndex`: an implementation must not invent dummy ambient
groups or Steinberg maps for invalid ranks. Proof irrelevance means that the evidence carried by a
valid index does not create a second mathematical parameter.

### Lie-type families

`LieTypeIndex` records the six classical families

```text
A_n(q),  ²A_n(q),  B_n(q),  C_n(q),  D_n(q),  ²D_n(q),
```

the five untwisted exceptional families

```text
E₆(q), E₇(q), E₈(q), F₄(q), G₂(q),
```

the graph-twisted exceptional families `²E₆(q)` and `³D₄(q)`, and the three Suzuki--Ree
families

```text
²B₂(2^(2m+1)),  ²G₂(3^(2m+1)),  ²F₄(2^(2m+1)).
```

The Tits group `²F₄(2)'` has its own constructor; that split is conventional rather than
mathematical, since the uniform derived-subgroup-modulo-center construction below, applied to
`²F₄` at field order two, produces the same group. A `PrimePower` stores `p`, a positive exponent,
and proofs that `p` is prime and the exponent is positive, so the corresponding Mathlib
`GaloisField` can be constructed without refactoring the index later.

The parameter `q` in the twisted families follows the Gorenstein--Lyons--Solomon/ATLAS
convention: `²A_n(q)` denotes the fixed points of the `q`-power Frobenius composed with the graph
automorphism, so it is the unitary family `PSU_{n+1}(q)` whose matrix realization has entries in
`𝔽_{q²}`, and likewise for `²D_n(q)`, `²E₆(q)`, and `³D₄(q)` (entries in `𝔽_{q³}`). Carter's
books index the same groups by the larger field, writing `²A_n(q²)`; do not follow that
convention here, since the small-field indexing is what makes the exclusions in
`InStandardRange` correct.

`LieTypeIndex.InStandardRange` pins the usual rank and small-field restrictions. In particular it
uses `B_n(q)` only for odd `q` and `n ≥ 3`, leaving the characteristic-two `B_n = C_n` overlap to
the `C` family; starts `C` at rank two and excludes `C₂(2)`; starts `D` and `²D` at rank four;
excludes `A₁(2)`, `A₁(3)`, `²A₂(2)`, and `G₂(2)`; and starts each Suzuki--Ree parameter at `m = 1`.
The separate Tits constructor supplies `²F₄(2)'`.

The root-systems roadmap deliberately treats `B₂` as valid and `C₂` as its duplicate, while this
roadmap uses the conventional finite-group name `C₂(q)` and omits `B₂(q)`. Pin the bridge as follows:
the `C₂` branch uses the root-systems roadmap's pinned `B₂` datum after the explicit permutation that
interchanges its two numbered nodes. Record the resulting pinned `B₂ ≅ C₂` identification in the
API. Use that same rank-two pinned datum for the Suzuki construction; `²B₂` remains the printed
finite-group name. No agent should create an unrelated second rank-two root datum to work around the
different validity conventions.

### Small isomorphism coincidences

We do not need an `∃!` statement, but avoiding the few remaining duplicate names makes the index
pleasant to use. After the standard range restrictions, `LieTypeIndex.Valid` drops the following
representatives:

| Dropped representative | Retained representative |
| --- | --- |
| `A₁(4)` and `A₁(5)` | `A₅` |
| `A₁(9)` | `A₆` |
| `A₂(2)` | `A₁(7)` |
| `A₃(2)` | `A₈` |
| `C₂(3)` | `²A₃(2)` |

Thus `Valid` means “our preferred representative in the CFSG list,” not “proved finite and
simple.” Its definition is just `InStandardRange ∧ ¬ IsDuplicateRepresentative`, with the finite
case split visible in `Suggested.lean`. We still state the classification with `∃`, not `∃!`:
there is no need to make the acceptance criterion depend on a formal proof that this table is
complete or that different valid indices give nonisomorphic groups.

### Sporadic names

Use a twenty-six-constructor enumeration, in the conventional names

```text
M11 M12 M22 M23 M24   J1 J2 J3 J4
HS McL He Ru Suz O'Nan   Co1 Co2 Co3
Fi22 Fi23 Fi24'   HN Ly Th B M.
```

Use unambiguous Lean identifiers such as `Fi24Prime` and `ONan`, with docstrings recording the
printed mathematical names. A decidable check that the enumeration has cardinality 26 belongs in
the interface; this checks the name list, not finiteness of any group.

---

## Workstreams, dependencies, and review units

The index and assembly work, the Lie-type construction, and the sporadic presentations are separate
lanes. They may proceed in parallel. The labels below are dependency identifiers, not a demand that
each lane land as one enormous pull request; each item should be split further whenever a reviewer
cannot inspect its defining data in one sitting.

| Item | Depends on | Concrete result | Completion evidence |
| --- | --- | --- | --- |
| I0: indices | Mathlib only | `PrimePower`, raw and valid Lie indices, sporadic names | range and duplicate examples reduce; 26-name check passes |
| L0: pinned ambient groups | root systems, reductive groups | root datum, pinning, points, root subgroups | every valid family traces to explicit data |
| L1: ordinary and graph Steinberg maps | L0 | Frobenius and numbered diagram maps | action on root subgroups and order relations are stated |
| L2: exceptional Steinberg maps | L0 | Suzuki--Ree half-Frobenius maps | exceptional-isogeny square relations are proved |
| L3: fixed groups | L1 and L2 | fixed points, derived subgroup, central quotient | every valid branch has a `Group` instance |
| S0: presentation format and sources | Mathlib only | signed-word format and 26-row source manifest | every source is a full presentation and is locatable |
| S1: presentation data | S0 | complete relator words for all sporadics | counts/checksums and independent transcription review |
| A0: assembly | I0, L3, S1 | `CFSGIndex.Group`, `ClassificationStatement` | named proposition elaborates with no placeholder carriers |

### I0: indices and Mathlib glue

Build `PrimePower`, `LieTypeIndex`, `LieTypeIndex.InStandardRange`,
`LieTypeIndex.IsDuplicateRepresentative`, `LieTypeIndex.Valid`, `ValidLieTypeIndex`,
`SporadicName`, and `CFSGIndex`. Keep parameters as data rather than encoding the list as a large
disjunction. Only `ValidLieTypeIndex` may be passed to a Lie-type carrier or endomorphism.

Consume Mathlib's existing `ZMod`, `Multiplicative`, `alternatingGroup`, `FreeGroup`,
`PresentedGroup`, `Subgroup.center`, `commutator`, quotient groups, `GaloisField`, finite-field
Frobenius, and algebraic closures. Provide the elementary coercions and group instances needed for
the final type to elaborate, but do not add `Finite` or `IsSimpleGroup` instances for a candidate.

Completion means that the small-field exclusions and duplicate table have executable examples, the
sporadic enumeration has cardinality 26, and the shape of `ClassificationStatement` elaborates in
`Suggested.lean` against the target signatures. The actual definition is accepted only at A0, after
the target carriers cease to be placeholders.

### L0: explicit pinned Chevalley--Demazure groups

For every underlying untwisted Dynkin type, construct the simply connected split reductive group
scheme over `ℤ` with a pinning, base-change it to the relevant characteristic, and take its points
over an algebraic closure of `𝔽_p`. This must be an explicit Chevalley--Demazure construction, not
the existence half of the classification of reductive groups.

Consume, rather than duplicate:

- [root systems, Weyl groups, and the Cartan--Killing classification](../RepresentationTheory/RootSystems/README.md)
  for the numbered `DynkinType`, Cartan matrices, and coordinate realizations, subject to the pinned
  `B₂`/`C₂` bridge above;
- [reductive algebraic groups](../ReductiveGroups/README.md) for root data, simply connected forms,
  base change, group schemes, and points.

These dependencies do not currently supply the whole contract. Extend the appropriate upstream
development rather than hiding the gap in `CFSGStatement`. The declarations this lane must consume
or add are:

- the explicit simply connected root datum and its numbered simple roots;
- the pinned Chevalley--Demazure group scheme over `ℤ`;
- base change to the prime field and its algebraic closure;
- the group of algebraic-closure-valued points;
- root-subgroup maps `x_α` and the equations expressing their compatibility with the pinning.

The output is the actual body of `ValidLieTypeIndex.AmbientGroup` and its `Group` instance. The
ambient group is generally infinite. A reviewer must be able to follow each carrier through these
named constructions; a theorem that merely asserts that a suitable pinned group exists is not a
substitute.

The uniform pinned route is the target even though matrices could define the classical families
earlier. If this route stalls, moving only the six classical branches to explicit `SL`, `SU`, `Sp`,
and orthogonal matrix groups is an allowed contained refactor, but it must be recorded as a change
of construction rather than silently mixed into L0.

### L1: ordinary and graph-twisted Steinberg maps

Let `Frob_q` be the endomorphism induced on points by `x ↦ x ^ q.card` on the algebraic closure.
Use the following exact maps:

| Families | Steinberg map | Required relation |
| --- | --- | --- |
| `A`, `B`, `C`, `D`, `E₆`, `E₇`, `E₈`, `F₄`, `G₂` | `Frob_q` | definition of field Frobenius |
| `²A`, `²D`, `²E₆` | `γ₂ ∘ Frob_q` | `γ₂ ^ 2 = 1` and `γ₂` commutes with `Frob_q` |
| `³D₄` | `γ₃ ∘ Frob_q` | `γ₃ ^ 3 = 1` and `γ₃` commutes with `Frob_q` |

The `q` here is the small-field GLS/ATLAS parameter fixed above. Pin the diagram permutations
against the numbered simple roots: reverse the `A_n` chain; exchange the two fork nodes of `D_n`;
use the Bourbaki `E₆` reflection (`1 ↔ 6`, `3 ↔ 5`, with `2` and `4` fixed); and for `D₄` triality
cycle the three outer nodes while fixing the central node. Translate these descriptions into the
actual `Fin` permutations used by the root-system API and expose those permutations as declarations.
The defining review equations are

```text
γ (x_α(t)) = x_{γ α}(t),
Frob_q (x_α(t)) = x_α(t^q).
```

Pinning must fix any signs or root-subgroup normalizations needed to make these literal equations.

### L2: exceptional Suzuki--Ree maps

For `X = C₂` in characteristic two, `G₂` in characteristic three, and `F₄` in characteristic two,
construct the pinned exceptional isogeny `τ_X` and prove

```text
τ_X ^ 2 = Frob_p.
```

For the constructor parameter `m`, define

```text
steinberg(m) = τ_X ^ (2m + 1),
steinberg(m) ^ 2 = Frob_(p ^ (2m + 1)).
```

Thus the fixed groups are `²B₂(2^(2m+1))`, `²G₂(3^(2m+1))`, and
`²F₄(2^(2m+1))`. The Tits constructor is the `F₄`, `m = 0` map `τ_F₄`; the other constructors have
`m ≥ 1`. Do not define these branches as `τ_X ∘ Frob_q`: the odd power of the half-Frobenius is the
pinned construction. Besides the square relation, record the action of `τ_X` on the numbered long
and short simple-root subgroups; the square relation alone is not the definition.

Suzuki groups are actively being developed in Mathlib in
[#42043](https://github.com/leanprover-community/mathlib4/pull/42043). A local construction may be
used while that work is in motion. Whatever Suzuki implementation ultimately lands in Mathlib
supersedes the local one: refactor this branch onto the landed Mathlib API and delete or abandon our
version, following the standard practice for downstream developments. The current draft API is not
a compatibility target.

### L3: fixed points and the simple-group candidate

For an endomorphism `F : G →* G`, define the fixed subgroup as `F.eqLocus (MonoidHom.id G)`. For
every valid index `d`, set

```text
H_d = fixedSubgroup d.steinberg
d.Group = [H_d, H_d] / Z([H_d, H_d]).
```

The center is the center of the derived subgroup, not the center of `H_d`. This uniform convention
handles the exceptional small cases, including the Tits group. Completion requires every branch of
`ValidLieTypeIndex.steinberg` to unfold to the L1 or L2 maps and `ValidLieTypeIndex.Group` to carry a
`Group` instance. No finiteness or simplicity proof is involved.

The open Mathlib PR [#40363, `(B, N)`-pairs](https://github.com/leanprover-community/mathlib4/pull/40363)
is relevant future structure theory but is not a dependency: this roadmap does not prove Bruhat
decomposition, simplicity, or recognition.

### S0: auditable presentation data and source selection

Represent a presentation word as a left-to-right list of signed generator indices and compile it to
`FreeGroup (Fin n)`. Do not store large relators directly as opaque nested `FreeGroup` expressions:
the signed-word form must be readable in diffs, importable from source data, and countable. Store
generator names, an exact bibliographic or stable database locator, the generator convention, and
transcription notes with the relators. The associated group is still

```lean
PresentedGroup {r | r ∈ relators.map Word.toFreeGroup}.
```

Before transcribing, create a 26-row source manifest. Each row records the name, exact source,
page/theorem or stable identifier, generator names, expected generator and relator counts,
transcription artifact/checksum, and review status. A database entry labelled a *semi-presentation*
or a set of relations for checking standard generators is not a presentation of the abstract group
and must be rejected. For comparison, the ATLAS [Monster page](https://atlas.math.rwth-aachen.de/Atlas/v3/spor/M/)
labels its generator-checking relations a semi-presentation, while the
[M₂₂ presentation page](https://brauer.maths.qmul.ac.uk/Atlas/v3/pres/M22G1-P1) explicitly gives a
group presentation. Record which kind of source each manifest row uses.

### S1: the twenty-six sporadic presentations

Fill every `SporadicName.presentation` branch with the complete signed relator words from the S0
manifest. Short presentations are preferred only when the generator convention is fully specified;
auditable data is more important than a uniform style.

The Monster must receive a genuine finite presentation. Coxeter-style `Y₅₅₅` relations present the
Bimonster `M ≀ 2`, not `M`, and ATLAS-style semi-presentations merely recognize generators in an
already available group. Neither is sufficient. Use a published full presentation of the Monster
itself and apply the same check to the Baby Monster and every other branch.

For each transcription, check the recorded generator and relator counts and a stable checksum of
the normalized signed-word data. Require an independent source-to-Lean read-through before marking
the row reviewed. This lane does not prove that the presented group has the expected order, is
nontrivial, finite, simple, or isomorphic to another construction.

### A0: assemble and state CFSG

Define `CFSGIndex.Group` by cases, supply its dependent `Group` instance, and define the named
`ClassificationStatement` displayed at the top. Do not replace the existential by a disjunction of
predicates or by `∃!`.

Completion requires the statement to elaborate at every universe with no placeholder carrier, no
raw invalid Lie index reaching a carrier-valued definition, and no `Finite` or `IsSimpleGroup`
instance assumed for `i.Group`. Review the four branches by following their definitions to `ZMod`,
`alternatingGroup`, the pinned fixed-point construction, or the audited presentation data.

## Existing work and provenance

The design was discussed in the Lean Zulip topic
[“Formalized statement of CFSG?”](https://leanprover.zulipchat.com/#narrow/channel/583339-AI-authored-projects/topic/Formalized.20statement.20of.20CFSG.3F/with/614411324).
Thomas Browning identified fixed points of algebraic groups over finite fields as the proper
definition of the Lie-type families; Kevin Buzzard suggested finite presentations as a manageable
definition of the sporadics even before their finiteness is proved. Those are the two construction
choices pinned here.

The old Lean 3 Formal Abstracts file
[`group_theory/classification.lean`](https://github.com/formalabstracts/formalabstracts/blob/b0173da1af45421239d44492eeecd54bf65ee0f6/src/group_theory/classification.lean)
is useful provenance for the four-way shape of the final statement. It is incomplete and mostly
organizes isomorphism predicates; it is not the API to port. In particular, this roadmap replaces
its predicates by actual group-valued definitions.

Mathematical references for the construction and naming conventions include:

- R. W. Carter, *Simple Groups of Lie Type*, for the fixed-point constructions;
- R. W. Carter, *Finite Groups of Lie Type: Conjugacy Classes and Complex Characters*, for
  Steinberg endomorphisms and twisted families;
- [*On the cohomology of the Ree groups and kernels of exceptional isogenies*](https://arxiv.org/abs/2108.06291),
  for the formulation `τ² = Frob_p` and the odd half-Frobenius powers;
- D. Gorenstein, R. Lyons, and R. Solomon, *The Classification of the Finite Simple Groups*,
  for the conventional list and low-rank identifications;
- J. H. Conway et al., *Atlas of Finite Groups*, and R. A. Wilson et al., the
  [ATLAS of Finite Group Representations](https://brauer.maths.qmul.ac.uk/Atlas/v3/), for sporadic
  naming and source data. Every transcribed presentation must also cite its own exact source.
