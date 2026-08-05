import Mathlib

/-!
# A statement of the classification of finite simple groups: target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The declarations here suggest Lean forms for the indexing types and concrete group
constructions needed to state CFSG. Discharging all of them finishes neither a work item nor the
roadmap. `sorry` is allowed in this human-owned roadmap library: these are targets, not completed
definitions or proofs.

The scope ends at the final named proposition: this roadmap defines the groups on the CFSG list well
enough to state that every finite simple group is isomorphic to one of them. It does not ask for
proofs that the listed groups are finite or simple, or for a proof of the classification.
-/

namespace TauCetiRoadmap.CFSGStatement

/-! ## Parameters and the groups of Lie type -/

/-- A prime power `p ^ exponent`, carrying the data needed to construct its finite field. -/
structure PrimePower where
  p : ℕ
  exponent : ℕ
  prime_p : p.Prime
  exponent_pos : 0 < exponent

/-- The cardinality represented by a `PrimePower`. -/
def PrimePower.card (q : PrimePower) : ℕ := q.p ^ q.exponent

/-- The families of finite groups of Lie type. The rank parameters follow the Dynkin subscripts.

`q` follows the Gorenstein--Lyons--Solomon/ATLAS convention in the ordinary and graph-twisted
constructors: the latter compose the pinned graph automorphism with the `q.card`-power field
Frobenius. So `twistedA 2 q` with `q.card = 3` is `²A₂(3) = PSU₃(3)`, whose matrix realization has
entries in the field of `q.card ^ 2` elements. Carter indexes the twisted groups by the larger field,
as `²A_n(q²)`; do not follow that convention here, since the small-field indexing is what makes the
exclusions in `InStandardRange` correct.

The Suzuki and Ree constructors record `m`, with field sizes `2 ^ (2 * m + 1)`,
`3 ^ (2 * m + 1)`, and `2 ^ (2 * m + 1)` respectively. The Tits group is represented separately
from the simple Ree groups `²F₄(2 ^ (2 * m + 1))`, which have `m ≥ 1`. That split is conventional
rather than mathematical: the uniform derived-subgroup-modulo-center construction applied to `²F₄`
at field order two would produce the same group, but the Tits group is traditionally listed apart
from the groups of Lie type. -/
inductive LieTypeIndex where
  | A (rank : ℕ) (q : PrimePower)
  | twistedA (rank : ℕ) (q : PrimePower)
  | B (rank : ℕ) (q : PrimePower)
  | C (rank : ℕ) (q : PrimePower)
  | D (rank : ℕ) (q : PrimePower)
  | twistedD (rank : ℕ) (q : PrimePower)
  | E6 (q : PrimePower)
  | E7 (q : PrimePower)
  | E8 (q : PrimePower)
  | F4 (q : PrimePower)
  | G2 (q : PrimePower)
  | twistedE6 (q : PrimePower)
  | trialityD4 (q : PrimePower)
  | suzuki (m : ℕ)
  | reeG2 (m : ℕ)
  | reeF4 (m : ℕ)
  | tits

/-- Conventional rank and small-field restrictions. These remove the nonsimple members and the
systematic low-rank and characteristic-two overlaps before a preferred representative is chosen
for the remaining sporadic coincidences. This predicate is indexing data only: it does not assert
that the resulting group has been proved finite or simple in Lean. -/
def LieTypeIndex.InStandardRange : LieTypeIndex → Prop
  | .A rank q => 1 ≤ rank ∧ (rank = 1 → 4 ≤ q.card)
  | .twistedA rank q => 2 ≤ rank ∧ (rank = 2 → 3 ≤ q.card)
  | .B rank q => 3 ≤ rank ∧ Odd q.card
  | .C rank q => 2 ≤ rank ∧ ¬(rank = 2 ∧ q.card = 2)
  | .D rank _ => 4 ≤ rank
  | .twistedD rank _ => 4 ≤ rank
  | .G2 q => 3 ≤ q.card
  | .suzuki m | .reeG2 m | .reeF4 m => 1 ≤ m
  | .E6 _ | .E7 _ | .E8 _ | .F4 _ | .twistedE6 _ | .trialityD4 _ | .tits => True

/-- The representatives deliberately omitted in favor of the alternating or Lie-type names fixed
by the roadmap. After `InStandardRange`, these are the remaining small coincidences relevant to
the list. -/
def LieTypeIndex.IsDuplicateRepresentative : LieTypeIndex → Prop
  | .A 1 q => q.card = 4 ∨ q.card = 5 ∨ q.card = 9
  | .A 2 q => q.card = 2
  | .A 3 q => q.card = 2
  | .C 2 q => q.card = 3
  | _ => False

/-- A preferred representative in the CFSG list. This is not a finiteness or simplicity
predicate. -/
def LieTypeIndex.Valid (d : LieTypeIndex) : Prop :=
  d.InStandardRange ∧ ¬d.IsDuplicateRepresentative

private def q2 : PrimePower := ⟨2, 1, by decide, by decide⟩
private def q3 : PrimePower := ⟨3, 1, by decide, by decide⟩
private def q4 : PrimePower := ⟨2, 2, by decide, by decide⟩

/-! Executable checks for representative range and duplicate conventions. -/
example : ¬(LieTypeIndex.A 1 q2).InStandardRange := by
  norm_num [LieTypeIndex.InStandardRange, PrimePower.card, q2]
example : (LieTypeIndex.A 1 q4).InStandardRange := by
  norm_num [LieTypeIndex.InStandardRange, PrimePower.card, q4]
example : ¬(LieTypeIndex.A 1 q4).Valid := by
  norm_num [LieTypeIndex.Valid, LieTypeIndex.InStandardRange,
    LieTypeIndex.IsDuplicateRepresentative, PrimePower.card, q4]
example : (LieTypeIndex.twistedA 2 q3).Valid := by
  norm_num [LieTypeIndex.Valid, LieTypeIndex.InStandardRange,
    LieTypeIndex.IsDuplicateRepresentative, PrimePower.card, q3]
example : ¬(LieTypeIndex.C 2 q3).Valid := by
  norm_num [LieTypeIndex.Valid, LieTypeIndex.InStandardRange,
    LieTypeIndex.IsDuplicateRepresentative, PrimePower.card, q3]

/-- A Lie-type index whose rank, field, and preferred-representative conditions hold. All
carrier-valued constructions below take this subtype, so no implementation branch is required for
an invalid Dynkin rank or excluded small group. -/
abbrev ValidLieTypeIndex := {d : LieTypeIndex // d.Valid}

/-- The kind of Steinberg endomorphism required by a valid family. For an exceptional entry
`exceptional p m`, the required map is `τ ^ (2 * m + 1)`, where `τ ^ 2 = Frob_p`; `tits` is the
`p = 2`, `m = 0` case. -/
inductive SteinbergKind where
  | ordinary
  | graphTwist (order : ℕ)
  | exceptional (p m : ℕ)
  deriving DecidableEq

/-- The construction lane for each valid Lie-type family. -/
def ValidLieTypeIndex.steinbergKind (d : ValidLieTypeIndex) : SteinbergKind :=
  match d.1 with
  | .A .. | .B .. | .C .. | .D .. | .E6 .. | .E7 .. | .E8 .. | .F4 .. | .G2 .. =>
      .ordinary
  | .twistedA .. | .twistedD .. | .twistedE6 .. => .graphTwist 2
  | .trialityD4 .. => .graphTwist 3
  | .suzuki m => .exceptional 2 m
  | .reeG2 m => .exceptional 3 m
  | .reeF4 m => .exceptional 2 m
  | .tits => .exceptional 2 0

/-- The fixed points `{g | F g = g}` of a group endomorphism: Mathlib's `MonoidHom.eqLocus`
against the identity. -/
def fixedSubgroup {G : Type*} [Group G] (F : G →* G) : Subgroup G :=
  F.eqLocus (MonoidHom.id G)

/-- The points over an algebraic closure of the explicitly pinned simply connected
Chevalley--Demazure group attached to the valid index `d`. The implementation must expose and use
the root datum, pinning, base change, points, and root-subgroup maps specified in `README.md`, not a
group chosen from an existence or classification theorem. -/
def ValidLieTypeIndex.AmbientGroup (_d : ValidLieTypeIndex) : Type := sorry

/-- The group structure on the algebraic group's points. -/
instance (d : ValidLieTypeIndex) : Group d.AmbientGroup := sorry

/-- The Steinberg endomorphism defining the finite group attached to `d`. The ordinary and graph
branches are `Frob_q` and `γ ∘ Frob_q`. An exceptional branch is `τ ^ (2 * m + 1)` with
`τ ^ 2 = Frob_p`; it is not `τ ∘ Frob_q`. The numbered diagram permutations, root-subgroup action,
commutation relations, and exceptional square relations are part of this target. -/
def ValidLieTypeIndex.steinberg (d : ValidLieTypeIndex) :
    d.AmbientGroup →* d.AmbientGroup := sorry

/-- Fixed points of the Steinberg endomorphism. -/
abbrev ValidLieTypeIndex.FixedPoints (d : ValidLieTypeIndex) : Type := fixedSubgroup d.steinberg

/-- The concrete simple-group candidate attached to a Lie-type index: the derived subgroup of the
fixed points, modulo its center. This also gives the Tits group from the `tits` index. -/
abbrev ValidLieTypeIndex.Group (d : ValidLieTypeIndex) : Type :=
  let derived := commutator d.FixedPoints
  derived ⧸ Subgroup.center derived

/-! ## The sporadic groups -/

/-- The twenty-six sporadic group names. `Fi24Prime` denotes `Fi₂₄'`. -/
inductive SporadicName where
  | M11 | M12 | M22 | M23 | M24
  | J1 | J2 | J3 | J4
  | HS | McL | He | Ru | Suz | ONan
  | Co1 | Co2 | Co3
  | Fi22 | Fi23 | Fi24Prime
  | HN | Ly | Th | B | M
  deriving DecidableEq, Fintype

/-- A generator or inverse generator in an auditable presentation word. -/
inductive GeneratorLetter (n : ℕ) where
  | of (i : Fin n)
  | inv (i : Fin n)
  deriving DecidableEq

/-- Convert a signed generator to the corresponding element of the free group. -/
def GeneratorLetter.toFreeGroup {n : ℕ} : GeneratorLetter n → FreeGroup (Fin n)
  | .of i => FreeGroup.of i
  | .inv i => (FreeGroup.of i)⁻¹

/-- A relator word stored as a diff-friendly, left-to-right list of signed generator indices. -/
abbrev PresentationWord (n : ℕ) := List (GeneratorLetter n)

/-- Evaluate an auditable presentation word in the free group. -/
def PresentationWord.toFreeGroup {n : ℕ} (w : PresentationWord n) : FreeGroup (Fin n) :=
  w.foldl (fun g x => g * x.toFreeGroup) 1

/-- Finite presentation data with its auditable source and transcription metadata. The source must
be a full presentation of the abstract group, not a semi-presentation for recognizing generators in
an already constructed group. -/
structure GroupPresentation where
  generatorCount : ℕ
  generatorNames : Fin generatorCount → String
  source : String
  sourceLocator : String
  generatorConvention : String
  transcriptionNotes : String
  expectedRelatorCount : ℕ
  normalizedChecksum : String
  relators : List (PresentationWord generatorCount)

/-- The finite list of relator words, regarded as a set for `PresentedGroup`. -/
def GroupPresentation.relatorSet (P : GroupPresentation) :
    Set (FreeGroup (Fin P.generatorCount)) :=
  {r | r ∈ P.relators.map PresentationWord.toFreeGroup}

/-- The group concretely defined by a finite presentation. -/
abbrev GroupPresentation.Group (P : GroupPresentation) : Type :=
  PresentedGroup P.relatorSet

/-- An explicit, cited full finite presentation for each sporadic group. Every branch is to contain
the actual signed relator words and source metadata; no branch may use a semi-presentation or choose
a group from an existence or uniqueness theorem. -/
def SporadicName.presentation (_s : SporadicName) : GroupPresentation := sorry

/-- The recorded relator count agrees with the transcribed list. This is transcription metadata,
not a claim about the presented group. -/
def GroupPresentation.relatorsMatchMetadata (P : GroupPresentation) : Prop :=
  P.relators.length = P.expectedRelatorCount

/-- Executable count check for every transcribed presentation. -/
example (s : SporadicName) : s.presentation.relatorsMatchMetadata := sorry

/-- The sporadic group defined by its pinned presentation. -/
abbrev SporadicName.Group (s : SporadicName) : Type := s.presentation.Group

/-- A small acceptance check that the enumeration has exactly twenty-six constructors. -/
example : Fintype.card SporadicName = 26 := by decide

/-! ## The classification list and final statement -/

/-- Indices for the preferred representatives on the CFSG list. The proof fields restrict
parameters without asserting that any candidate group is finite or simple. -/
inductive CFSGIndex where
  | cyclic (p : ℕ) (prime_p : p.Prime)
  | alternating (degree : ℕ) (degree_ge_five : 5 ≤ degree)
  | lie (index : ValidLieTypeIndex)
  | sporadic (name : SporadicName)

/-- The concrete group represented by a CFSG index. -/
abbrev CFSGIndex.Group : CFSGIndex → Type
  | .cyclic p _ => Multiplicative (ZMod p)
  | .alternating degree _ => alternatingGroup (Fin degree)
  | .lie index => index.Group
  | .sporadic name => name.Group

instance : (i : CFSGIndex) → Group i.Group
  | .cyclic .. => inferInstance
  | .alternating .. => inferInstance
  | .lie .. => inferInstance
  | .sporadic .. => inferInstance

universe u

/-- **Classification of finite simple groups, statement only.** Proving this proposition, or
proving finiteness or simplicity of any listed group, is outside this roadmap. The existential is
intentional: `Valid` picks conventional representatives, but the interface does not claim a
machine-checked uniqueness theorem for the index. -/
def ClassificationStatement : Prop :=
  ∀ (G : Type u) [Group G] [Finite G] [IsSimpleGroup G],
    ∃ i : CFSGIndex, Nonempty (G ≃* i.Group)

end TauCetiRoadmap.CFSGStatement
