# Progress log: ReductiveGroups

An append-only record of what landed on the ReductiveGroups roadmap, one section per window of
merged pull requests, oldest first. Generated; the prose is not security-validated.
For a current snapshot instead, read `STATUS.md` beside this file.

<!--tauceti-progress:v1 {"from_sha":"1f1d7527e4085f3ac0ffad2ac3ad69cfbebe809c","prs":[45,54,56,62,64,75,78,80,90,97,101,106,109,111,112,113,116,117,118,119,122,123,124,125,126,127,129,135,136,137,138,139,148,155,156,157,158,159,165,166,167,169,181,182,183,185,186,196,240,241,242,243,244,245,282,285,297,314,325,357,361,373,383,386,399,427,428,458,469,478,490,512,515,552,611,665,690,700,748,761,762,769,785,862,890,909,968,976,1024,1027,1134,1139,1146,1163,1214,1280,1321],"roadmap":"ReductiveGroups","to_sha":"4fffb8532f528626d101bd1bfc6c15e1ccce5809"}-->
## ReductiveGroups: 2026-06-04 to 2026-07-30 (`1f1d752` to `4fffb85`)

This is the first window on the reductive-groups roadmap, and it runs from an empty directory to
roughly twelve hundred declarations. Two genuine theorems about group schemes are in it. The first
is that `αₚ` is the kernel of the Frobenius endomorphism of the additive group: `αₚ` is built as
`Spec` of the quotient Hopf algebra `R[x]/(xᵖ)` in TauCeti#611, its coordinate ring is shown to be
non-reduced over a nontrivial base of characteristic `p`, and `AlphaP.range_inclusion` in
TauCeti#1146 identifies the image of `αₚ ↪ 𝔾ₐ` with the kernel of `frobeniusEnd`, the endomorphism
`x ↦ xᵖ` of the coordinate bialgebra which acts on points as `a ↦ aᵖ`. Along the way the points of
`αₚ` are computed outright (`mem_range_pointsHom_iff`: they are the `a` with `aᵖ = 0`), and
TauCeti#1024 records that over a reduced algebra there is only the identity point, which is the
concrete form of the roadmap's warning that a nilpotence test in a reduced ring is vacuous. The
second is the multiplicative counterpart: `RootsOfUnityGroup.range_inclusion` in TauCeti#976 shows
`μ_n` is the kernel of the `n`th power endomorphism of `𝔾ₘ`, resting on the inclusion `μ_n ↪ 𝔾ₘ`
constructed in TauCeti#862 as the contravariant image of the surjection `ℤ ↠ ℤ/n`. Both statements
are equalities of subgroups of `A`-points for each commutative algebra `A`, together with naturality
in `A`; there is no scheme-theoretic kernel here, because there is as yet no scheme model at all.

The torus lane reached the input to root data. TauCeti#968 defines the character-cocharacter pairing
`⟨m, ψ⟩` of a diagonalizable group `D(M)` and, in `charPoints_comp_cocharPoints`, gives it its
geometric meaning: composing the character `m` after the cocharacter `ψ` is exactly the
`⟨m, ψ⟩`-power endomorphism of `𝔾ₘ`. TauCeti#1134 then specialises to the split torus
`T = D(Multiplicative (σ →₀ ℤ))`, identifies the cocharacter lattice `X_*(T)` with `σ → ℤ`, computes
the pairing against `X*(T) = σ →₀ ℤ` as the dot product, proves non-degeneracy in each variable
separately, and supplies `IsPerfPair` instances both for the coordinate model and, transported along
`cocharAddEquiv`, for the genuine cocharacter lattice. The perfectness instances carry a `Finite σ`
hypothesis, so this is the finite-rank split torus and nothing wider. TauCeti#1163 adds the
arithmetic of the exponent, `powEnd_add`, `powEnd_zero`, `powEnd_neg` and
`toAdditive_powEnd_eq_intCast`; what landed are those pointwise laws rather than a bundled ring
homomorphism `ℤ → End(𝔾ₘ)`.

Underneath all of that, the window built the functor-of-points model and the comodule theory the
roadmap asks for. TauCeti#45 puts the convolution group structure on `H →ₐ[R] A` with unit the
counit and inverse `f ∘ S`, abelian when `H` is cocommutative, and TauCeti#54, TauCeti#80 and
TauCeti#113 package it as a functor, contravariant in the coordinate algebra and covariant in the
value algebra, on categories `CommHopfAlgCat` and `FiniteTypeCommHopfAlgCat` of commutative and
finite-type commutative Hopf algebras. Products (TauCeti#552, TauCeti#167) and base change along
`k → K` (TauCeti#762) are available at the level of those categories. Comodules arrive in
TauCeti#62 as a class and grow into a preadditive category with a zero object, finite biproducts,
transport along linear equivalences, corestriction along coalgebra morphisms, cofree comodules with
their universal property, and the regular, trivial and group-like comodules; subcomodules get a
lattice, kernels, images and quotients (TauCeti#135, TauCeti#136, TauCeti#241, TauCeti#785,
TauCeti#909). The finitely generated comodules over a bialgebra became monoidal in TauCeti#1027,
TauCeti#1280 and TauCeti#1321 under the diagonal coaction. They are not yet rigid: duals are absent,
so the "rigid monoidal category of finite-dimensional comodules" of Layer 1 is monoidal only, and
stated for finitely generated modules over a commutative ring rather than finite-dimensional vector
spaces. Matrix coefficients (TauCeti#112, TauCeti#116) come with the submodule and subalgebra they
generate, the computation that the regular comodule's coefficients give the whole coalgebra and the
whole algebra (TauCeti#156), and multiplicativity on tensor products (TauCeti#1139). What is *not*
here is the fundamental theorem of comodules: nothing yet says every element lies in a finite
subcoalgebra, and so nothing says a representation is faithful when its matrix coefficients
generate `A`, and there is no embedding theorem.

Hopf ideals are the other substantial line. TauCeti#139 defines `HopfIdeal` with the three closure
conditions, arbitrary suprema computed on underlying ideals, and the `I ⊗ H` and `H ⊗ I` operations
they need; TauCeti#169 descends the coalgebra, bialgebra and Hopf structures to `H ⧸ I` with the
expected universal property; TauCeti#185 identifies the kernel of a bialgebra morphism as a Hopf
ideal and proves the first isomorphism theorem `kerLiftBialgEquiv` for surjective morphisms; and
TauCeti#383 gives inverse images along surjections. On points, TauCeti#515 and TauCeti#690 assemble
`quotientPointsSubgroupNatIso`, which says the quotient Hopf algebra represents the subgroup functor
of points killing `I`, and TauCeti#748 and TauCeti#761 make the correspondence antitone in `I`. This
is the Hopf-algebra half of "Hopf ideals correspond to closed subgroup schemes". The scheme half,
normality and the adjoint coaction, sheaf quotients, and the identity component are all absent.

Proportionally, this window is mostly scaffolding. Of the ninety-seven pull requests, three carry no
new declarations at all (TauCeti#373, TauCeti#357, TauCeti#361), and a large fraction of the rest are
naturality lemmas, base-change compatibilities, normal forms for evaluating points on generators, and
order-theoretic API. That is the right shape for a library being built from nothing, but it should
not be mistaken for depth: the concrete groups exercised so far are `𝔾ₐ`, `𝔾ₘ`, `D(M)`, `μ_n`,
`μ_p`, `αₚ`, the split torus, the trivial group and products of these, and `GLₙ` has not appeared.
The two Layer 0 targets written down in `Suggested.lean`, the Hopf-algebra structure on `Γ(G)` and
the group-object structure on `Spec A`, remain `sorry`; no declaration in this window mentions a
scheme. (The extracted record truncates the declaration lists of a few of the largest pull requests,
so the counts above are close rather than exact.)
