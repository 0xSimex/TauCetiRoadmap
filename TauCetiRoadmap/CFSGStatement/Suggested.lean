import Mathlib

/-!
# A statement of the classification of finite simple groups: target signatures

**This file is not the roadmap and is not exhaustive.** The definitive document is
`README.md`. The declarations here suggest Lean forms for the indexing types and concrete group
constructions needed to state CFSG. Discharging all of them finishes neither a milestone nor the
roadmap. `sorry` is allowed in this human-owned roadmap library: these are targets, not completed
definitions or proofs.

The scope ends at the final `example`: this roadmap defines the groups on the CFSG list well enough
to state that every finite simple group is isomorphic to one of them. It does not ask for proofs that
the listed groups are finite or simple, or for a proof of the classification.
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
The Suzuki and Ree constructors record `m`, with field sizes `2 ^ (2 * m + 1)`,
`3 ^ (2 * m + 1)`, and `2 ^ (2 * m + 1)` respectively. The Tits group is represented separately
from the simple Ree groups `²F₄(2 ^ (2 * m + 1))`, which have `m ≥ 1`. -/
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

/-- The fixed points of a group endomorphism. -/
def fixedSubgroup {G : Type*} [Group G] (F : G →* G) : Subgroup G where
  carrier := {g | F g = g}
  one_mem' := by simp
  mul_mem' := by
    intro a b ha hb
    change F a = a at ha
    change F b = b at hb
    change F (a * b) = a * b
    rw [map_mul, ha, hb]
  inv_mem' := by
    intro a ha
    change F a = a at ha
    change F a⁻¹ = a⁻¹
    rw [map_inv, ha]

/-- The points over an algebraic closure of the explicitly pinned simply connected
Chevalley--Demazure group attached to `d`. The implementation must be the construction specified in
`README.md`, not a group chosen from an existence or classification theorem. -/
def LieTypeIndex.AmbientGroup (_d : LieTypeIndex) : Type := sorry

/-- The group structure on the algebraic group's points. -/
instance (d : LieTypeIndex) : Group d.AmbientGroup := sorry

/-- The Steinberg endomorphism defining the finite group attached to `d`: field Frobenius, composed
with the pinned graph or exceptional isogeny in the twisted families. -/
def LieTypeIndex.steinberg (d : LieTypeIndex) : d.AmbientGroup →* d.AmbientGroup := sorry

/-- Fixed points of the Steinberg endomorphism. -/
abbrev LieTypeIndex.FixedPoints (d : LieTypeIndex) : Type := fixedSubgroup d.steinberg

/-- The concrete simple-group candidate attached to a Lie-type index: the derived subgroup of the
fixed points, modulo its center. This also gives the Tits group from the `tits` index. -/
abbrev LieTypeIndex.Group (d : LieTypeIndex) : Type :=
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

/-- Finite presentation data with generators `Fin generatorCount`. -/
structure GroupPresentation where
  generatorCount : ℕ
  relators : List (FreeGroup (Fin generatorCount))

/-- The finite list of relator words, regarded as a set for `PresentedGroup`. -/
def GroupPresentation.relatorSet (P : GroupPresentation) :
    Set (FreeGroup (Fin P.generatorCount)) :=
  Set.range fun i : Fin P.relators.length => P.relators[i]

/-- The group concretely defined by a finite presentation. -/
abbrev GroupPresentation.Group (P : GroupPresentation) : Type :=
  PresentedGroup P.relatorSet

/-- An explicit, cited finite presentation for each sporadic group. Every branch is to contain the
actual relator words; no branch may choose a group from an existence or uniqueness theorem. -/
def SporadicName.presentation (_s : SporadicName) : GroupPresentation := sorry

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
  | lie (index : LieTypeIndex) (valid : index.Valid)
  | sporadic (name : SporadicName)

/-- The concrete group represented by a CFSG index. -/
abbrev CFSGIndex.Group : CFSGIndex → Type
  | .cyclic p _ => Multiplicative (ZMod p)
  | .alternating degree _ => alternatingGroup (Fin degree)
  | .lie index _ => index.Group
  | .sporadic name => name.Group

instance (i : CFSGIndex) : Group i.Group := by
  cases i <;> infer_instance

/-- **Classification of finite simple groups, statement only.** Proving this example, or proving
finiteness or simplicity of any listed group, is outside this roadmap. The existential is
intentional: `Valid` picks conventional representatives, but the interface does not claim a
machine-checked uniqueness theorem for the index. -/
example (G : Type*) [Group G] [Finite G] [IsSimpleGroup G] :
    ∃ i : CFSGIndex, Nonempty (G ≃* i.Group) := sorry

end TauCetiRoadmap.CFSGStatement
