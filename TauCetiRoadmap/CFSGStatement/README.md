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

`CFSGIndex.Group` lands in `Type`, so `ClassificationStatement.{0}` is the substantive instance and
every larger universe follows from it, `Finite G` supplying the transport. A downstream development
should assume the universe it needs and derive the rest, rather than assume `.{0}` and find it does
not apply.

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

`LieTypeIndex.InStandardRange` pins the usual rank and small-field restrictions. It starts `B` at
rank two and excludes the nonsimple `B₂(2)`; starts `C` at rank three and restricts it to odd
characteristic, leaving `B₂(q) = C₂(q)` and the characteristic-two overlap `B_n(q) = C_n(q)` to the
`B` family; starts `D` and `²D` at rank four; excludes `A₁(2)`, `A₁(3)`, `²A₂(2)`, and `G₂(2)`; and
starts each Suzuki--Ree parameter at `m = 1`. The separate Tits constructor supplies `²F₄(2)'`.

These are the ranges of the usual presentation of the list, and they are also the ranges carried by
`DynkinType.Valid` in the [root-systems roadmap](../RepresentationTheory/RootSystems/README.md)
(`A n (n ≥ 1)`, `B n (n ≥ 2)`, `C n (n ≥ 3)`, `D n (n ≥ 4)`). Every valid index here therefore names
a valid Dynkin type there, and no agent should introduce a reindexed or otherwise second copy of a
root datum to reconcile the two conventions. The Suzuki construction uses that same rank-two `B₂`
datum, so `²B₂` is both the printed finite-group name and the underlying Dynkin type.

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
| `B₂(3)` | `²A₃(2)` |

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

Two items, `U1` and `U2`, are work for the root-systems and reductive-groups roadmaps rather than
for this one. They are listed here because `L0` cannot start without them and because neither
roadmap currently targets them; see `L0` below for exactly what is missing. Claim them in the
roadmap that owns them, not here.

| Item | Depends on | Concrete result | Completion evidence |
| --- | --- | --- | --- |
| I0: indices and numbered conventions | Mathlib only | `PrimePower`, raw and valid Lie indices, sporadic names, rank/characteristic/field order, the pinned `Fin` permutations and exponent tables | range and duplicate examples reduce; 26-name check passes |
| U1: numbered root data over `ℤ` | root systems roadmap | a named based root datum for each valid `DynkinType`, its simply connected form, and a fixed Bourbaki node numbering into `Fin` | each datum is a definition, not a carrier chosen from an existence theorem |
| U2: pinned group schemes over `ℤ` | reductive groups roadmap, U1 | split reductive group schemes over a base, pinnings, base change, points over an algebraically closed field, root subgroups `x_α` | every declaration L0 consumes is named upstream |
| L0: pinned ambient groups | U1, U2 | root datum, pinning, points, root subgroups | every valid family traces to explicit data |
| L1: ordinary and graph Steinberg maps | L0 | Frobenius and numbered diagram maps | the simple-root-subgroup equations and the order relations are proved |
| L2: exceptional Steinberg maps | L0 | Suzuki--Ree half-Frobenius maps | the long/short exponent equations and the square relation are proved |
| L3: fixed groups | L1 and L2 | fixed points, derived subgroup, central quotient | every valid branch has a `Group` instance |
| S0: presentation format and sources | Mathlib only | relator expression type compiling to signed words, and a 26-row source manifest | every source is a full presentation, is locatable, and is proved to define its group |
| S1: presentation data | S0 | complete relator words for all sporadics | relator counts match the manifest; independent transcription review |
| A0: assembly | I0, L3, S1 | `CFSGIndex.Group`, `ClassificationStatement` | named proposition elaborates with no placeholder carriers |

### I0: indices and Mathlib glue

Build `PrimePower`, `LieTypeIndex`, `LieTypeIndex.InStandardRange`,
`LieTypeIndex.IsDuplicateRepresentative`, `LieTypeIndex.Valid`, `ValidLieTypeIndex`,
`LieTypeIndex.IsExceptional`, `ExceptionalLieTypeIndex`, `SporadicName`, and `CFSGIndex`. Keep
parameters as data rather than encoding the list as a large disjunction. Only `ValidLieTypeIndex`
may be passed to a Lie-type carrier or endomorphism, and only `ExceptionalLieTypeIndex` to a
half-Frobenius.

Build the numbered data read off an index: `ValidLieTypeIndex.rank`, `.characteristic`, and
`.fieldOrder`; and the pinned permutations `graphPermA`, `graphPermD`, `graphPermE6`,
`trialityPermD4`, `lengthPermRankTwo`, `lengthPermF4`, with the exponent tables
`exceptionalExponentB2`, `exceptionalExponentG2`, and `exceptionalExponentF4`. These carry the
conventions of L1 and L2 and are Mathlib-only, so they land here rather than waiting on L0.

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
  for the numbered `DynkinType`, its Cartan matrices, and coordinate realizations;
- [reductive algebraic groups](../ReductiveGroups/README.md) for root data, simply connected forms,
  base change, group schemes, and points.

Neither dependency currently targets what this lane consumes, so U1 and U2 above are the work that
makes L0 groundable, and they are targets rather than an instruction to improvise. Concretely:

- the root-systems roadmap's realization target `exists_rootPairing_of_dynkinType` is an
  **existence** statement about a `RootPairing` over `ℚ`. There is no named based root datum, nothing
  over `ℤ`, and no coroot lattice, so a carrier could only be extracted by `Classical.choose`, which
  the rule above forbids. `DynkinType.cartanMatrix` is itself a `sorry` there, and no node-numbering
  convention is fixed, which is what the L1 permutation table needs.
- the reductive-groups roadmap fixes its standing hypotheses over a field and files relative theory
  over a base under far-future generalizations. Its Layer 8 offers "Chevalley existence", which is
  again an existence theorem. Group schemes over `ℤ`, pinnings, base change from `ℤ`, and
  root-subgroup maps `x_α` are targeted nowhere.

U1 and U2 are therefore to be written into those roadmaps, and this lane cites them rather than
restating them. They are proposed in
[Pin the Bourbaki numbering and an integral root datum](https://github.com/TauCetiProject/TauCetiRoadmap/pull/158)
and
[Add pinned Chevalley-Demazure group schemes over the integers](https://github.com/TauCetiProject/TauCetiRoadmap/pull/157)
respectively. Until they land, L0 is blocked and should not be claimed; the I0 conventions, the
numbered permutations, and the whole sporadic lane are independent of it and can proceed.

The declarations L0 then consumes are:

- the explicit simply connected root datum and its numbered simple roots (U1);
- the pinned Chevalley--Demazure group scheme over `ℤ` (U2);
- base change to the prime field and its algebraic closure (U2);
- the group of algebraic-closure-valued points (U2);
- root-subgroup maps `x_α` and the equations expressing their compatibility with the pinning (U2).

The output is the actual body of `ValidLieTypeIndex.AmbientGroup`, its `Group` instance,
`ValidLieTypeIndex.Closure`, and `ValidLieTypeIndex.simpleRootSubgroup`. The ambient group is
generally infinite. A reviewer must be able to follow each carrier through these named
constructions; a theorem that merely asserts that a suitable pinned group exists is not a
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

The `q` here is the small-field GLS/ATLAS parameter fixed above.

Number the simple roots by the Bourbaki labels of the underlying untwisted diagram, and place
Bourbaki node `i` at `Fin` index `i - 1`, so that a rank-`n` diagram is indexed by `Fin n` running
from `0` to `n - 1`. This zero-based offset is the one thing an implementor is most likely to get
wrong, so the permutations are pinned as `Fin` data rather than as prose:

| Family | Underlying diagram | Permutation of `Fin n` |
| --- | --- | --- |
| `²A_n` | `A_n` | `Fin.revPerm`, the reversal `j ↦ n - 1 - j` |
| `²D_n` | `D_n` | `Equiv.swap (n - 2) (n - 1)`, the two fork nodes |
| `²E₆` | `E₆` | `Equiv.swap 0 5 * Equiv.swap 2 4`, fixing `1` and `3` (Bourbaki `1 ↔ 6`, `3 ↔ 5`) |
| `³D₄` | `D₄` | the three-cycle `(0 2 3)` on the outer nodes, fixing the centre `1` |
| the untwisted families | itself | `1`, so `γ` is the identity and no branch needs a dummy map |

Each permutation must be proved to be an automorphism of the corresponding Cartan matrix. The
defining equations are

```text
γ (x_α(t)) = x_{γ α}(t)      for α simple,
Frob_q (x_α(t)) = x_α(t^q)   for every root α.
```

The restriction of the first equation to simple roots is not a weakening, and it must not be
strengthened. A pinning normalizes the root-subgroup parameters on the simple root subgroups, and
`γ` is then the unique automorphism with that action, by Chevalley's isomorphism theorem for the
corresponding root data. On a general root the equation reads `γ (x_α(t)) = x_{γ α}(ε_α t)` with
`ε_α = ±1` forced by the Chevalley structure constants, and the signs cannot all be normalized to
`1` at once: the type-`A` graph automorphism `X ↦ -J Xᵀ J` of `sl_n` already shows this. Record the
general-root form as a consequence of the construction, never as a requirement on the pinning.

### L2: exceptional Suzuki--Ree maps

For `X = B₂` in characteristic two, `G₂` in characteristic three, and `F₄` in characteristic two,
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
pinned construction.

The square relation is a consequence of the definition, not the definition. `τ_X` is pinned by its
action on the numbered simple root subgroups. Writing `ᾱ` for the image of the simple root `α` under
the length-exchanging diagram map,

```text
τ_X (x_α(t)) = x_{ᾱ}(t)      for α long,
τ_X (x_α(t)) = x_{ᾱ}(t^p)    for α short.
```

The two exponents multiply to `p` along either composite, which is what makes `τ_X ^ 2 = Frob_p`
come out. Attaching `1` to the long roots and `p` to the short ones is a genuine convention: the
opposite assignment also squares to `Frob_p`, so leaving it to the implementor leaves the branch
undetermined. Take the assignment above, and in the Bourbaki numbering of the previous section that
gives, on `Fin n`:

| `X` | `p` | Length-exchanging map | Exponent by index |
| --- | --- | --- | --- |
| `B₂` | 2 | `Equiv.swap 0 1` | `α₁` long, so `0 ↦ 1` and `1 ↦ 2` |
| `G₂` | 3 | `Equiv.swap 0 1` | `α₂` long, so `0 ↦ 3` and `1 ↦ 1` |
| `F₄` | 2 | `Fin.revPerm`, the reversal | `α₁, α₂` long, so `0, 1 ↦ 1` and `2, 3 ↦ 2` |

Suzuki groups are being developed in Mathlib in
[feat(GroupTheory/SpecificGroups/Suzuki): define Suzuki groups](https://github.com/leanprover-community/mathlib4/pull/42043),
still a draft at the time of writing. That construction is
`suzukiGroup (n : ℕ) : Subgroup (GL (Fin 4) (GaloisField 2 (2 * n + 1)))`, the closure of explicit
four-by-four unipotent and Weyl matrices. It is a different object from this lane's: not the fixed
points of `τ_{B₂} ^ (2m + 1)` in a pinned ambient group, and its `n` is unrestricted, so
`suzukiGroup 0` is the solvable `Sz(2)`.

The pinned construction is the definition here, and the `suzuki` branch stays inside the uniform
`AmbientGroup`, `steinberg`, `FixedPoints`, derived-subgroup-modulo-centre route that L0 to L3
exist to build. Moving that one branch onto a matrix group would take it out of that route with no
stated obligation that the two agree, which is worse than a little duplication. So: once the Mathlib
work lands, add a target proving `²B₂(2^(2m+1)) ≃* suzukiGroup m` for `m ≥ 1`, and consume the
Mathlib API through that isomorphism. Nothing in this roadmap is deleted, and the `m ≥ 1`
restriction remains this roadmap's responsibility.

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

The stored form of a relator is a left-to-right list of signed generator indices, compiled to
`FreeGroup (Fin n)`. Do not store large relators as opaque nested `FreeGroup` expressions: the
signed-word form must be readable in diffs, importable from source data, and countable. The
associated group is still

```lean
PresentedGroup {r | r ∈ relators.map Word.toFreeGroup}.
```

Published relators are written with powers and commutators, not as flat letter strings: `(ab)^11`,
`[a,b]^5`, and the Monster's spider relator `(a b₁ c₁ a b₂ c₂ a b₃ c₃)^10`. Expanding those by hand
into signed letters makes the longest and most error-prone relators the least reviewable, which is
the opposite of what this lane is for. So transcribe into a small relator expression type with
generator, inverse, product, power, and commutator constructors, and compile that to the flat signed
word. The flat form remains the semantics; the expression form is what a reviewer compares against
the source, and the transcribed list is what the relator count is taken of.

Store generator names, an exact bibliographic or stable database locator, the generator convention,
transcription notes, and the expected generator and relator counts with the relators. Both counts
are then decidably checkable against the transcribed data.

Do not carry a checksum field. A checksum with no pinned normal form, no named algorithm, and no
function to recompute it against cannot be checked by a reviewer or by the kernel, so it reads like
a check without being one. The two counts are real checks, and everything beyond them rests on the
independent read-through below.

Before transcribing, create a 26-row source manifest. Each row records the name, exact source,
page/theorem or stable identifier, generator names, expected generator and relator counts,
transcription artifact, and review status. A database entry labelled a *semi-presentation* or a set
of relations for checking standard generators is not a presentation of the abstract group and must
be rejected. For comparison, the ATLAS
[Monster page](https://brauer.maths.qmul.ac.uk/Atlas/v3/spor/M/) labels its generator-checking
relations a semi-presentation, while the
[M₂₂ presentation page](https://brauer.maths.qmul.ac.uk/Atlas/v3/pres/M22G1-P1) explicitly gives a
group presentation. Record which kind of source each manifest row uses, and cite for each row a
source in which the presentation is *proved* to define the named group, not merely asserted to.

### S1: the twenty-six sporadic presentations

Fill every `SporadicName.presentation` branch with the complete signed relator words from the S0
manifest. Short presentations are preferred only when the generator convention is fully specified;
auditable data is more important than a uniform style.

The Monster must receive a genuine finite presentation, and one exists, so neither of the two
tempting substitutes is acceptable. Coxeter-style `Y₅₅₅` relations plus the spider relation present
the Bimonster `M ≀ 2`, not `M`; `M` sits inside it at index `2·|M|`, and no presentation of `M`
follows from that in any usable form. ATLAS-style semi-presentations merely recognize generators in
an already available group, and the ATLAS Monster page carries only one of those. Use instead the
`Y₄₄₃` presentation: the 12 nodes of that diagram, the Coxeter relations, the spider relation, and
`Z = 1` for the central involution `Z`, giving 12 generators and 80 relators. The theorem is
Norton's (1990), simplified by Ivanov (1999); the explicit word list is on J. N. Bray's
[Monster presentation page](https://webspace.maths.qmul.ac.uk/j.n.bray/web/Pres/Mnst.html), which
displays `M × 2` and becomes `M` on adding `Z = 1`. Farooq, Norton, and Wilson,
[*A presentation of the Monster and a set of matrices which satisfy it*](https://doi.org/10.1016/j.jalgebra.2013.01.015),
J. Algebra **379** (2013) 432-440, is an alternative.

Apply the same standard to the Baby Monster, whose `Y₄₃₃` presentation was conjectured in the ATLAS
and proved by Ivanov, and to every other branch. The Fischer groups come from smaller Y-diagrams
with the spider relation.

Do not assume a presentation is a link away for the rest. Bray's
[presentation pages](https://webspace.maths.qmul.ac.uk/j.n.bray/web/Pres/) carry the Monster
directly, but several entries are 1996 stubs that record only the order and a pointer to the ATLAS:
the Baby Monster page states `Length ??, 2-generator, ?-relator`, and `Co1`, `Co2`, `Co3` are the
same shape. The [ATLAS v3](https://brauer.maths.qmul.ac.uk/Atlas/v3/) they point to has a
presentations section for some sporadics (`M11`, `J1`) and none for others (`B`, `Co1`, `M24`,
`HS`), where it offers standard generators and a **semi-presentation** instead. A semi-presentation
is not a presentation: it pins the generators up to automorphism so that standard generators can be
checked, and it does not define the group. Transcribing one as a presentation is exactly the error
this lane's review discipline exists to catch.

So the first S0 task is to find, for each of the 26 names, a source that gives an actual
presentation, and to record in the manifest both that source and the names for which no such source
is readily available. Expect that second list to be nonempty.

For each transcription, check the recorded relator count against the transcribed list, and require
an independent source-to-Lean read-through before marking the row reviewed. This lane does not prove
that the presented group has the expected order, is nontrivial, finite, simple, or isomorphic to
another construction.

That gap is survivable, and it is worth saying why, because the reason is the whole argument for
resting on review here. Each group on the list is simple, so a transcription error can only make
`ClassificationStatement` false, never easier to prove: dropping a relator yields a proper cover of
the intended group, and adding or corrupting one yields a proper quotient, hence the trivial group.
In both cases nothing finite and simple is isomorphic to that branch. Review protects the truth of
the final statement, not its provability.

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

[FiniteSimpleGroups](https://github.com/KitaKen1/finite-simple-groups-lean) is a Lean 4 development
that builds a good part of this list by a different route: each group is the subgroup of
`Equiv.Perm (Fin n)` generated by named permutations, and its order and simplicity are *proved*, by
kernel-checked stabilizer chains with an axiom audit admitting only `propext`, `Classical.choice`,
and `Quot.sound`. At the time of writing it covers `M11 M12 M22 M23 M24 J1 J2 HS McL Co2 Co3 Suz
Fi22 He`, together with `L2(11) L3(4) U3(3) U4(2) U5(2) U6(2) G2(4)`.

That is stronger evidence per group than a transcribed presentation, which nothing here verifies,
and it should be used as a cross-check: a sporadic name it covers gives an independent handle on
whether our relator words present the group we think they do. It is not the construction this
roadmap adopts, because it does not reach the top of the list. The smallest faithful permutation
representations of `B` and `M` have degrees far beyond anything expressible as Lean source, which is
why the sporadics are defined here by presentations throughout. Anyone reusing that code must first
coordinate with its author: the repository carries no licence file, so the repository-level rule on
integrating existing work applies before anything is copied or adapted.

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
