# Roadmap: stating the classification of finite simple groups

The goal of **CFSGStatement** is deliberately narrower than a formalization of the
classification of finite simple groups. We want every group on the classification list to be an
honest Lean type with a `Group` instance, so that the following theorem can be *stated* cleanly:

```lean
example (G : Type*) [Group G] [Finite G] [IsSimpleGroup G] :
    ∃ i : CFSGIndex, Nonempty (G ≃* i.Group) := sorry
```

The `sorry` is the endpoint of this roadmap, not a theorem to prove here. In particular, this
roadmap does **not** ask contributors to prove that a candidate is finite or simple. It also does
not ask for the order formulas, automorphism groups, recognition theorems, uniqueness of the list,
or the classification theorem itself. Those are separate developments that can consume the
concrete definitions built here.

Suggested home in Tau Ceti: `TauCeti/GroupTheory/SpecificGroups/CFSG/`, with reusable algebraic-group
machinery placed under the homes chosen by the reductive-groups and root-systems roadmaps.

## What counts as defining a group

Each branch of `CFSGIndex.Group` must reduce to explicit mathematical data:

- the cyclic group of prime order `p` is `Multiplicative (ZMod p)`;
- the alternating group is Mathlib's `alternatingGroup (Fin n)`;
- a group of Lie type is built from the fixed points of an explicit Steinberg endomorphism of an
  explicit pinned algebraic group, then by taking the derived subgroup modulo its center;
- a sporadic group is Mathlib's `PresentedGroup` for an explicit finite list of relator words.

A definition by `Classical.choose` from an existence or uniqueness theorem does not meet this
requirement. Nor does a predicate that characterizes a group by its order, involution centralizers,
or place in the classification. The resulting types should remain useful to downstream work even
though CFSGStatement proves no structure theory about them.

## The list and its conventions

`CFSGIndex` has four constructors.

1. `cyclic p hp`, where `hp : p.Prime`.
2. `alternating n hn`, where `hn : 5 ≤ n`.
3. `lie d hd`, where `d : LieTypeIndex` and `hd : d.Valid`.
4. `sporadic s`, where `s : SporadicName` is one of the twenty-six named sporadic groups.

The proof fields restrict the list; they do not bundle or demand `Finite` or `IsSimpleGroup`
instances for the constructed groups. Proof irrelevance also means that the evidence carried by an
index does not create a second mathematical parameter.

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

The Tits group `²F₄(2)'` has its own constructor. A `PrimePower` stores `p`, a positive exponent,
and proofs that `p` is prime and the exponent is positive, so the corresponding Mathlib
`GaloisField` can be constructed without refactoring the index later.

`LieTypeIndex.InStandardRange` pins the usual rank and small-field restrictions. In particular it
uses `B_n(q)` only for odd `q` and `n ≥ 3`, leaving the characteristic-two `B_n = C_n` overlap to
the `C` family; starts `C` at rank two and excludes `C₂(2)`; starts `D` and `²D` at rank four;
excludes `A₁(2)`, `A₁(3)`, `²A₂(2)`, and `G₂(2)`; and starts each Suzuki--Ree parameter at `m = 1`.
The separate Tits constructor supplies `²F₄(2)'`.

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

## Milestone 0: the common index and Mathlib glue

Build `PrimePower`, `LieTypeIndex`, `LieTypeIndex.InStandardRange`,
`LieTypeIndex.IsDuplicateRepresentative`, `LieTypeIndex.Valid`, `SporadicName`, and `CFSGIndex`.
Keep parameters as data rather than encoding the list as a large disjunction.

Consume Mathlib's existing definitions directly:

- `ZMod` and `Multiplicative` for the cyclic branch;
- `alternatingGroup` for the alternating branch;
- `FreeGroup` and `PresentedGroup` for presentations;
- `Subgroup.center`, `commutator`, and quotient groups for the final Lie-type operation;
- `Finite`, `IsSimpleGroup`, `MulEquiv`, and `Nonempty` in the final statement;
- `GaloisField`, finite-field Frobenius, and algebraic closures in the Lie-type construction.

Provide the elementary coercions and group instances needed for `CFSGIndex.Group` to elaborate, but
do not add `Finite` or `IsSimpleGroup` instances for any candidate as part of this roadmap.

## Milestone 1: explicit pinned Chevalley--Demazure groups

For every untwisted Dynkin type, construct the simply connected split reductive group scheme over
`ℤ` with a pinning, then base-change it and take its points over an algebraic closure of `𝔽_p`.
This must be an explicit Chevalley--Demazure construction, not merely the existence half of the
classification of reductive groups.

The construction should consume, rather than duplicate, the following other Tau Ceti roadmaps:

- [root systems, Weyl groups, and the Cartan--Killing classification](../RepresentationTheory/RootSystems/README.md)
  for `DynkinType`, its validity convention, Cartan matrices, and concrete coordinate realizations;
- [reductive algebraic groups](../ReductiveGroups/README.md) for root data, simply connected forms,
  base change, group schemes, and points.

The reductive-groups roadmap's existence theorem is not by itself enough for this target: pinning
is what makes the root-subgroup maps and diagram automorphisms canonical enough to define the
twists. Extend that development with an explicit pinned construction and expose:

- the simply connected root datum attached to each valid Dynkin type;
- the pinned Chevalley--Demazure group scheme over `ℤ`;
- base change to a finite field and its algebraic closure;
- the abstract group of algebraic-closure-valued points;
- the root-subgroup maps and their compatibility with the pinning.

This milestone ends with the actual body of `LieTypeIndex.AmbientGroup` and its `Group` instance.
No finiteness statement is involved: the ambient group is generally infinite.

## Milestone 2: Steinberg maps and fixed points

Define the field Frobenius on the algebraic closure and its action on the pinned algebraic group's
points. Then define the endomorphism attached to every `LieTypeIndex`:

- field Frobenius alone for the untwisted types;
- field Frobenius composed with the pinned order-two graph automorphism for `²A`, `²D`, and `²E₆`;
- field Frobenius composed with the pinned triality automorphism for `³D₄`;
- the characteristic-two or characteristic-three exceptional isogeny, with its precise square
  relation to Frobenius, for `²B₂`, `²G₂`, and `²F₄`.

Pin the exponents carefully: the Suzuki and Ree constructors use fields of order
`2^(2m+1)`, `3^(2m+1)`, and `2^(2m+1)`. The `tits` constructor uses the same `²F₄` construction at
field order two.

For an endomorphism `F : G →* G`, define the fixed subgroup directly as
`{g | F g = g}`. For each index `d`, set

```text
H_d = fixedSubgroup d.steinberg
d.Group = [H_d, H_d] / Z([H_d, H_d]).
```

This uniform derived-mod-center convention handles the small exceptional behavior, including the
Tits group, while still producing an explicit type. The milestone ends when every branch of
`LieTypeIndex.steinberg` is definitionally tied to the pinned construction and
`LieTypeIndex.Group` elaborates with a `Group` instance.

The open Mathlib PR [#40363, `(B, N)`-pairs](https://github.com/leanprover-community/mathlib4/pull/40363)
is relevant future structure theory but is not a dependency: CFSGStatement does not prove Bruhat
decomposition, simplicity, or recognition. Coordinate with the draft Mathlib PR
[#42043, defining Suzuki groups](https://github.com/leanprover-community/mathlib4/pull/42043);
if its API lands, refactor the Suzuki branch onto it rather than maintaining a second construction.

## Milestone 3: explicit presentations of the sporadic groups

Define a small presentation-data structure with a number of generators and a finite list of words
in `FreeGroup (Fin n)`. Its associated group is

```lean
PresentedGroup (Set.range fun i : Fin relators.length => relators[i])
```

For each `SporadicName`, fill in a published finite presentation, including the complete relator
words. Record a source, theorem/table number or stable database identifier, generator convention,
and transcription notes next to each definition. Short presentations are preferred when their
generator convention is fully specified; uniformity of presentation style is less important than
an auditable definition.

The Monster is subject to the same rule: it gets a genuine finite presentation, not a name selected
by order or local subgroup data. This milestone asks only for the presentation to be transcribed
and for `PresentedGroup` to supply the group type. It does not ask for a proof that the presented
group has the expected order, is nontrivial, finite, simple, or isomorphic to another construction
of the named sporadic group.

## Milestone 4: assemble and state CFSG

Define `CFSGIndex.Group` by cases using the four constructions above and supply its `Group` instance.
The acceptance criterion is that the exact example at the top of this roadmap elaborates in
`Suggested.lean` with no placeholder type standing in for any family and with no finiteness or
simplicity assumptions attached to `i.Group`.

Do not replace the existential by a disjunction of predicates or by `∃!`. Downstream developments
can state consequences of CFSG by assuming the displayed proposition, and can inspect the concrete
group delivered by the witness.

## Existing work and provenance

The design was discussed in the Lean Zulip topic
[“Formalized statement of CFSG?”](https://leanprover.zulipchat.com/#narrow/channel/583339-AI-authored-projects/topic/Formalized.20statement.20of.20CFSG.3F/with/614645364).
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
- D. Gorenstein, R. Lyons, and R. Solomon, *The Classification of the Finite Simple Groups*,
  for the conventional list and low-rank identifications;
- J. H. Conway et al., *Atlas of Finite Groups*, and R. A. Wilson et al., the
  [ATLAS of Finite Group Representations](https://brauer.maths.qmul.ac.uk/Atlas/v3/), for sporadic
  naming and source data. Every transcribed presentation must also cite its own exact source.
