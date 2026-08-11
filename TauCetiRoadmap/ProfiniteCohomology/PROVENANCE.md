# Provenance and upstream status: continuous cohomology of profinite groups

**This file is not normative and it goes out of date.** The roadmap is
[`README.md`](README.md); it is the definitive specification, and no milestone in it depends on
anything recorded here. What follows is a dated snapshot of the surrounding ecosystem, kept so
that a contributor can see what already exists, what licence it carries, and whom to talk to
before starting work that touches the same objects.

## Appendix A: upstream status

Both appendices were audited on 2026-08-06; every status and revision below is as of that date,
which is not repeated. No statement in the roadmap's Layers 0 to 13 is written against a
declaration name that exists only in an open pull request.

- **Mathlib master**, `Mathlib/RepresentationTheory/Homological/ContCohomology/`. Continuous
  cohomology was redefined and moved by PR
  [#41144](https://github.com/leanprover-community/mathlib4/pull/41144) (merged 2026-07-02; Richard
  Hill, Andrew Yang, Edison Xie), from the pin's
  `Mathlib/Algebra/Category/ContinuousCohomology/Basic.lean`
  (`continuousCohomology (n) : Action (TopModuleCat R) G ⥤ TopModuleCat R`, upstreamed from
  `rmhi/ctsToDiscrete`), whose names master deleted. The current form is built on `TopRep k G`
  through an iterated coinduction resolution: `Basic.lean` (`TopRep.homogeneousCochains`,
  `continuousCohomology n`), `Functoriality.lean` (`ContinuousCohomology.cochainsMap φ f`,
  `cocyclesMap`, `map`, for `φ : H →ₜ* G` and `f : res φ X ⟶ Y`; PR
  [#41309](https://github.com/leanprover-community/mathlib4/pull/41309), merged 2026-07-03), and
  `LowDegree.lean` (`zeroIso : H⁰ ≅ invariants`, still the only computed degree). Its module
  documentation states the design reason for the homogeneous model, that `C(Gⁿ, M)` would restrict
  the theory to locally compact groups, and its TODO list names three of this roadmap's layers:
  coincidence with `groupCohomology` for discrete groups, the `n`-ary cochain description for
  locally compact groups, and long exact sequences. Anything written against the pin's deleted
  names must be treated as frozen and renamed at the bump; prefer explicit-model statements, which
  are stable, and keep canonical-facing statements in comparison files.
- **Open Mathlib PRs**, both by Richard Hill (`rmhi`), both still open:
  [#41539](https://github.com/leanprover-community/mathlib4/pull/41539), "refactor functoriality",
  which splits `map` through a `continuousCohomologyFunctor` and a restriction natural
  transformation `resNatTrans` (last updated 2026-07-27), and
  [#41545](https://github.com/leanprover-community/mathlib4/pull/41545), "add inflation maps in
  continuous cohomology", `Hⁿ(G⧸N, π^N) → Hⁿ(G, π)` as a natural transformation, stacked on #41539
  (last updated 2026-07-11). Layer 1 builds its restriction and inflation in the shape these
  describe, so that Mathlib's versions can replace them by deletion; no milestone depends on
  either pull request.
- **FLT staging**, `ImperialCollegeLondon/FLT`, `FLT/Mathlib/RepresentationTheory/`:
  `Homological/ContCohomology/CupProduct.lean` (Edison Xie, PR
  [FLT#1098](https://github.com/ImperialCollegeLondon/FLT/pull/1098), merged 2026-07-10) gives cup
  products on the canonical model in full bidegree, built through the coinduction resolution from
  an intertwining pairing with a joint-continuity hypothesis, with the Leibniz rule `cup_d_comm`,
  descent to cocycles and cohomology (`ContinuousCohomology.cup`), and a kernel-mod-coboundary
  presentation `cohomologyIsoQuot` in its companion `Basic.lean`. It has no graded commutativity,
  no associativity, no restriction, corestriction or Shapiro, and no inhomogeneous description.
  Layer 12 completes it rather than competing with it, and Layer 8 proves the low-degree explicit
  cups match it.
- **rmhi/ctsToDiscrete** (Richard Hill). The continuous-to-discrete comparison: for a **discrete**
  group `G`, natural isomorphisms `continuousCohomology ⋙ forget ≅ recursiveGroupCohomology` and
  `recursiveGroupCohomology ≅ groupCohomology.functor` (`ForgetfulFunctors.lean`,
  `RecursiveToMathlib.lean`), with its own `resNatTrans` and `inflNatTrans`. Two caveats, both
  verified: it is stated against a private copy of `continuousCohomology`, not the Mathlib module
  its own upstreaming created, and five `sorry`s remain, three in the leaf `ResolutionMachine.lean`
  and two inside `kerHomogeneousCochainsZeroEquiv`, on which its `H⁰` isomorphism depends. Layer
  3 proves its own finite and discrete comparison and does not depend on this work; coordinate
  with the author before starting, since the two developments prove the same theorem.
- **kbuzzard/ClassFieldTheory**: entirely finite-group, discrete-module cohomology over Mathlib's
  `groupCohomology`. Restriction (`rest`, with `δ`-naturality), **corestriction** (`coresNatTrans`,
  `cores_res : rest ≫ cores = index • id`, and the Sylow-injectivity corollaries; Buzzard, Aaron
  Liu, Yunzhou Xie), inflation, inflation-restriction (whose exactness still carries four
  `sorry`s), Tate cohomology (since upstreamed: master has
  `Mathlib/RepresentationTheory/Homological/TateCohomology/`), and Herbrand quotients. No cup
  products and no profinite or continuous material. Layer 6's finite-level corestriction facts
  should be convention-compatible with `cores_res`, so that a reader who knows one normalization
  can read the other without translating.
- **Tau Ceti code repository**: no cohomology and no profinite groups, so all of this is new work
  there; the directory convention there mirrors Mathlib's tree, which the suggested home
  follows.
- **Zulip.** The design thread is
  [#mathlib4 > recursive definition of Continuous Cohomology](https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/recursive.20definition.20of.20Continuous.20Cohomology.html)
  (February 2025; Hill, Buzzard, Riou, Commelin): Hill proposes the iterated-coinduction
  homogeneous model that Mathlib later adopted, over the continuous inhomogeneous alternative
  (which breaks without joint continuity and, under coinduction, without local compactness) and
  over Buzzard's colimit-over-finite-quotients suggestion (Hill: the right answer only for
  profinite `G` with discrete `M`, which is this roadmap's Layer 4). **The acceptance condition
  Joël Riou set there is Layer 3**: he is "very much ok" with the design provided the
  formalization includes a comparison map to the explicit inhomogeneous complex that is a
  quasi-isomorphism in the discrete case. A follow-up
  thread,
  [#mathlib4 > Understanding ContCohomology and TopRep](https://leanprover.zulipchat.com/#narrow/channel/287929-mathlib4/topic/Understanding.20ContCohomology.20and.20TopRep/with/611890095),
  cited from PR #41539, carries the live functoriality-typing discussion; the public archive mirror
  ends 2026-02-28, so it must be read logged in. Also relevant:
  [#maths > C1 fields?](https://leanprover-community.github.io/archive/stream/116395-maths/topic/C1.20fields.3F.html)
  (August 2025) asks for cohomological dimension (`cd ≤ 1` for C₁ fields) and confirms that nothing
  upstream defines it;
  [#mathlib4 > Universes restriction in Rep](https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Universes.20restriction.20in.20Rep.html)
  (January 2026) records that `Rep` forces `k` and `G` into one universe (Mathlib #33608), a live
  constraint on every statement here that meets `Rep`; and Mathlib #31613 (non-abelian `H⁰` and
  `H¹`, open) is neighboring discrete work. Zulip has no thread on cup products in group or
  continuous cohomology, none on the cohomological transfer, and no condensed-against-discrete
  decision thread for profinite Galois groups: the canonical-object decision was made in the
  February 2025 thread, and the remaining gaps are open.

## Appendix B: provenance and coordination

These records state evidenced status as of the audit date at the head of this file. "Not
recorded" means that adaptation of source code is blocked until the revision, license and
coordination fields are filled in; it does not mean permission is assumed. Consuming a public API,
and independently implementing a mathematically specified theorem, are not adaptation and are not
blocked by any of this; copying or translating source code is.

| Project | Authors | Revision or PR | License | Overlap | Plan |
|---|---|---|---|---|---|
| Mathlib `ContCohomology` | Richard Hill, Andrew Yang, Edison Xie | #41144, #41309 merged; #41539, #41545 open | Apache-2.0 | canonical carrier, functoriality, restriction, inflation | consume the merged API, build the gaps here, do not fork |
| FLT continuous cup product | Edison Xie | FLT #1098, merge commit `4a42f80d452a387960b458275478723dac893aae` | Apache-2.0 | the all-bidegree canonical cup | consume it, and build Layer 12's completion here, coordinating with the author |
| `rmhi/ctsToDiscrete` | Richard Hill | `fb09713296926c981226d87d6635c9215c40454e` (2026-07-10) | **no LICENSE file at that revision** | continuous-to-discrete comparison | statement-shape audit only; no code transfer unless the author supplies licensing terms |
| `kbuzzard/ClassFieldTheory` | Kevin Buzzard, Aaron Liu, Edison Xie | `ccc3323c6750abca25b49b35106f54eb3a398509` (2026-07-31) | Apache-2.0 | finite-group restriction, corestriction, exact sequences | align normalization, coordinate before touching the same objects |
| `roed-math/gq2-lean` | roed-math contributors | `d0714a7c431b64e18c422fb16cb5e93d79e5be25` | Apache-2.0 | explicit low-degree cohomology, cups, corestriction, Kummer, index-2 Evens | adapt with file-level credit, generalize, and prove the comparison to the canonical model |
| `davidturturean/gq2-lean-turturean` | David Turturean | `e868b9e3b97b2e4891860155b00ac2aa78b25868` | GPL-3.0-or-later | independent low-degree continuous Galois cohomology | mathematical cross-check of statements only; **license incompatible with Apache-2.0, no code transfer** |

No contact outcome with any upstream author is recorded in this repository, and no ownership
agreement is recorded. The roadmap assigns the canonical carrier to Mathlib and claims only the
explicit calculational model, the comparison theorems, and the material of Layers 4 to 13.

**Authors to coordinate with** before integrating existing material, per the root README's
coordination rule: Richard Hill (`rmhi`; Mathlib `ContCohomology`, PRs #41539 and #41545,
`ctsToDiscrete`), Edison (Yunzhou) Xie (`Whysoserioushah`; Mathlib `ContCohomology`, FLT cup
products, ClassFieldTheory), Andrew Yang (Mathlib `ContCohomology`), Kevin Buzzard and Aaron Liu
(ClassFieldTheory corestriction), and Joël Riou (whose quasi-isomorphism acceptance condition Layer
3 discharges). One person, Xie, currently spans three of the four upstream sites: he is easy to
coordinate with, but the coordination stops if he becomes unavailable. Register a Tau Ceti
intention and post the
layer plan on Zulip before Layer 3 or Layer 8 work starts, since those are the two places where
these theorems and in-flight upstream code touch the same objects. On the demand side, FLT's
planning documents name continuous cohomology and the Galois cohomology of local fields (blueprint
`ch_bestiary` §§13.4-13.9) among its blocking definitions, so this roadmap together with
the Class Field Theory roadmap supplies what they
need.

**Migration provenance.** The specifications above are the definition of done; the sources here
are evidence of feasibility and a source of material to adapt. [roed-math/gq2-lean](https://github.com/roed-math/gq2-lean)
contains sorry-free, axiom-free implementations of much of the explicit model, specialized in
places to its own paper's needs: `GQ2/Cohomology.lean` (Layer 2: the complex, compatible pairs,
restriction, inflation and coefficient maps, with conventions already identical to the pin's
`IsCocycle₁/₂`); `GQ2/DiscreteModule.lean` (Layer 0's openness API); `GQ2/CupProduct.lean` and
`GQ2/CupSymmetry.lean` (Layer 8: the `(1,1)`, `(0,2)` and `(2,0)` cups and characteristic-2
symmetry); `GQ2/Corestriction.lean` and `GQ2/CorestrictionCohomology.lean` (Layer 6: the
`Quotient.out` transversal calculus, `cor¹`, `cor²`, and `δ`-compatibility); `GQ2/EvensKahn.lean`
(Layer 13: the index-2 graph cocycle and its expansion rules); `GQ2/Kummer.lean` and
`GQ2/LocalKummer.lean` (Layer 9: the mod-2 Kummer cocycle and class map); `GQ2/Transgression.lean`
(Layer 5: a cochain-level transgression); `GQ2/Shapiro/` (Layer 7, specialized to index 2).

Migration is not transcription. Every one of those files is written for `ZMod 2` coefficients with
trivial action, index-2 subgroups, `n = 2`, or open subgroups where this roadmap needs closed ones.
The corestriction formulas in particular are correct there **because** the action is trivial, and
the general formulas of §3 differ from them by the factor `t u •`; the Kummer material is written
inside `AlgebraicClosure`, and this roadmap uses the separable closure. Migration means proving the
general statement, with the existing file as evidence that the low-degree bookkeeping is
manageable, then re-grounding on the canonical comparison. Credit the source in ported files. Its
`docs/cts-cohomology-gap.md` is the earlier gap analysis that Appendix A updates.

## Appendix C: current sibling-roadmap coordination

Dated, not normative, and deliberately outside the roadmap: the roadmap's exported-interface table
states only what is agreed, and this records what still has to be agreed with roadmaps that are
under review. Recorded 2026-08-07.

- **Continuous cohomology has one owner: settled at the all-degree carrier, open in low degrees.**
  The Profinite Pro-`p` Groups roadmap now states that Mathlib's `continuousCohomology` is the carrier of every
  cohomological statement it makes, and that it defines no second cohomology theory: its `cd_p`,
  the rank interpretations, the Demushkin predicate and its Layer 11 inputs all read through that
  object. The earlier claim recorded here, that it carries a separate all-degree `contH`, no longer
  describes it. What remains is the low-degree overlap. It still defines `contH0`, `contH1` and
  `contH2` as explicit subquotients over a finite discrete module, with a bidegree `(1,1)` cup
  product on cocycles and its own comparison isomorphisms with `continuousCohomology`. Those are a
  second copy of this roadmap's Layers 2, 3 and 8 under different coefficient hypotheses. Before
  either roadmap is accepted, one of the two must consume the other's explicit model through the
  exported-interface table rather than restate it, or a transport of every operation used across
  the two must be stated. Until then no claim of composability in low degrees is made anywhere in
  the roadmap. The original audit was recorded against the pre-restructuring Pro-`p` Groups head
  `62017de`; current consumers use `ProfiniteProPGroups`.
- **The Evens polarization: resolved.** The Quadratic Form Invariants roadmap now states its
  `evens_add` with a `conjClass` factor, which matches the mathematical shape exported here,
  `N(α + β) - N(α) - N(β) = cor (α ⌣ (s · β))`, following Kozlowski's Lemma 2.4. What remains is
  carrier transport rather than a mathematical disagreement: the two statements are about classes
  in two different carriers until the ownership question above is settled. Recorded 2026-08-07;
  the earlier unconjugated form is no longer present there.
- **Structure interfaces.** That roadmap also consumes `Mod2GaloisOps` and
  `Mod2GaloisTransferOps`. This roadmap constructs no terms of those structures. Either they are
  built from the exported table's declarations in that roadmap, or a transport is stated there;
  either way the obligation is on the consumer, and the roadmap does not assert that it is already
  discharged.

- **Where the roadmap's design conditions came from.** The comparison-to-the-inhomogeneous-complex
  condition that Layer 3 discharges is Joël Riou's, stated in the February 2025 Zulip design thread
  linked in Appendix A. Cohomological dimension was asked for in the August 2025 `#maths > C1
  fields?` thread and nothing upstream defined it at the audit date. Mathlib's `ContCohomology`
  module documentation lists, as TODOs, coincidence with `groupCohomology` for discrete groups, the
  `n`-ary cochain description for locally compact groups, and long exact sequences; those are
  Layers 3, 3 and 5 here, so coordinate rather than duplicate.
