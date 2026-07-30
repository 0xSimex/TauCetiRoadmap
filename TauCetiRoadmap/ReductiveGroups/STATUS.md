<!--tauceti-status:v1 {"roadmap":"ReductiveGroups","to_sha":"4fffb8532f528626d101bd1bfc6c15e1ccce5809","ts":"2026-07-30T13:01:12Z"}-->
# Status: ReductiveGroups

This file documents the status of the ReductiveGroups roadmap up until `4fffb85` (2026-07-30T13:01:12Z). There may have been subsequent updates.

It is generated, and its prose is not security-validated; see
https://github.com/TauCetiProject/TauCetiProgress for what that means.

## Where this roadmap stands

**Standing hypotheses.** The unbundling discipline has held. There is no `LinearAlgebraicGroup` or
`Variety` class anywhere; groups appear as commutative Hopf algebras with `IsAffine`-style
predicates kept separate, and finite type is an object property (`finiteTypeCommHopfAlgProperty`)
selecting a full subcategory rather than a field of a structure. Smoothness has not come up yet,
because nothing so far needs it; correspondingly nothing has been proved about geometric
reducedness. Non-smooth groups are admitted in practice, not just in principle: `μ_p` and `αₚ` are
both constructed and both proved non-reduced.

**The three synchronized models.** One of the three is built, one is partly built, one is untouched.
The Hopf-algebra model is the working model: `CommHopfAlgCat R` and `FiniteTypeCommHopfAlgCat R`
exist with their forgetful functors, tensor products, and base change along a ring map. The functor
of points is built directly on top of it rather than derived: `AlgHom.points`, the convolution group
structure `instGroup` (and `instCommGroup` in the cocommutative case), `mapValue` for covariance in
the value algebra, `mapDomain` and `mapPointsFunctor` for contravariance in the coordinate algebra,
and `pointsFunctor` packaging these. It is a group-valued functor on commutative algebras, but it
has not been characterised as *representable* in any abstract sense, and there is no Yoneda or
representability statement. The group-object-in-schemes model does not exist: no declaration in the
library mentions `Scheme` or `GrpObj`, and the two Layer 0 targets in `Suggested.lean` are still
`sorry`. Consequently none of the three explicit equivalences the roadmap asks for has been started.

**Cross-cutting sheaves and descent.** Untouched. There is no fppf topology, no sheafification, no
torsors, no faithfully flat descent, and no presheaf category on `CommAlgCat k`. What does exist is
the base-change lane: `CommHopfAlgCat.baseChangeFunctor`, `baseChangePointsMulEquiv`, preservation
of finite type under base change, and a restriction-of-scalars functor on `CommAlgCat`, with
base-change points equivalences worked out individually for `𝔾ₐ`, `𝔾ₘ`, `D(M)`, `μ_n`, the split
torus and the trivial group.

**Layer 0 (functor of points and the dictionary).** Half done. The convolution group structure, its
functoriality in both variables, and base change of Hopf algebras are all in place, and the pitfall
the roadmap flags is avoided: the points functor is `H →ₐ[R] A`, not `GroupLike`. The dictionary
itself, meaning the anti-equivalence with affine group schemes and the third equivalence with
representable group functors, is not started.

**Layer 1 (representations = comodules).** Partly done, and the largest single body of work. The
`Comodule` class, `ComoduleCat`, and `FGComoduleCat` exist; the category is preadditive with a zero
object and finite biproducts; there are cofree comodules with a universal property, transport along
linear equivalences, corestriction along coalgebra morphisms, the regular comodule, trivial and
group-like comodules, and a full subcomodule theory (lattice with joins, `ker`, `range`, induced
coactions, quotients). `FGComoduleCat` over a bialgebra is a monoidal category
(`instMonoidalCategory`) under the diagonal coaction. Matrix coefficients are developed with the
submodule and subalgebra they generate, computed for the regular, trivial, group-like, product and
tensor-product comodules. Missing, and these are the load-bearing pieces: the finite-dimensional
subcoalgebra theorem in any form, duals and rigidity, the definition of faithfulness as a closed
immersion together with its matrix-coefficient characterisation, the embedding theorem
`G ↪ GLₙ`, and Tannakian reconstruction. `Subcoalgebra` exists but carries almost nothing beyond
`groupLikeSpan` and the order embedding `toRegularSubcomodule` into subcomodules of the regular
comodule.

**Layer 2 (Lie algebra and adjoint representation).** Untouched. No tangent space, no `Lie(G)`, no
differential, no `Ad`.

**Layer 3 (subgroups, quotients, components).** The Hopf-ideal side is done; everything geometric is
not. `HopfIdeal` has the three closure conditions, arbitrary suprema, and inverse images along
surjective morphisms; `H ⧸ I` carries descended coalgebra, bialgebra and Hopf structures with the
expected lift and uniqueness; `HopfAlgebra.ker` is a Hopf ideal, `ker_eq_bot_iff` characterises
injectivity, and `kerLiftBialgEquiv` is the first isomorphism theorem for surjections. On points,
`quotientPointsSubgroupNatIso` shows `H ⧸ I` represents the subgroup functor of points vanishing on
`I`, `quotientPointsHom_injective` makes the inclusion a monomorphism, and the correspondence is
antitone in `I`. Not done: normality and the adjoint coaction, quotients `G/H` in any form (sheaf
quotient or otherwise), short exact sequences, geometric connectedness, the identity component `G°`
and the component group `π₀(G)`.

**Layer 4 (Jordan decomposition, diagonalizable groups, tori).** Diagonalizable groups and split
tori are substantially done; the rest is not. `D(G) = Spec R[G]` has its points identified with
characters `G →* Aˣ` (`DiagonalizableGroup.pointEquiv`), contravariant functoriality in `G`
(`pointsMap`, with `pointsMap_injective` for surjective `φ`), base change, and the product
decomposition `R[G × H] ≅ R[G] ⊗ R[H]` as a bialgebra isomorphism with its consequence
`prodPointsMulEquiv` on points. `μ_n` is realised as `D(ℤ/n)` with points the `n`th roots of unity,
`μ_1` is proved trivial, `μ_n ↪ 𝔾ₘ` is the kernel of the `n`th power endomorphism, and
`not_isReduced_monoidAlgebra` gives the characteristic-`p` non-reducedness that makes `μ_p` the
intended counterexample. For the split torus, the character lattice, the cocharacter lattice, the
dot-product pairing and its perfectness (for finite rank) are all in place, as is the identification
of the pairing with a power endomorphism of `𝔾ₘ`. Not done: `D` as an anti-equivalence (only the
functor `coordinateRingFunctor : FGCommGrpCat ⥤ FiniteTypeCommHopfAlgCat R` exists, with no
fullness, faithfulness or essential-image result), groups of multiplicative type as a class,
non-split tori, Cartier duality, and Jordan decomposition, which has no prerequisites in place
either.

**Layers 5 through 8 (unipotent groups and the unipotent radical; reductive and semisimple groups;
Borel subgroups, root data, Bruhat; classification).** Entirely untouched. No declaration mentions
unipotence, solvability, reductivity, semisimplicity, Borel or parabolic subgroups, root data, Weyl
groups or isogenies.

**Worked examples.** `𝔾ₐ` (as `Spec` of a symmetric algebra, with the Hopf structure and the
antipode `ι x ↦ -ι x`), `𝔾ₘ` (Laurent polynomials, points the units), `D(M)`, `μ_n`, `μ_p`, `αₚ`,
the split torus of arbitrary rank, the trivial group, and products. `GLₙ`, `SLₙ`, `PGLₙ`, `SOₙ` and
`Sp₂ₙ` do not exist yet, and neither does any non-split torus.

## The frontier

The nearest target, and the one that unblocks the most, is the **fundamental theorem of comodules**:
every element of a coalgebra lies in a finite subcoalgebra, and every comodule is the union of its
finitely generated subcomodules. The scaffolding is deliberately in place, `Subcomodule` joins of
finitely generated subcomodules are finitely generated (`Subcomodule.sup_finite`, `iSup_finite`),
`Subcoalgebra.toRegularSubcomoduleOrderEmbedding` preserves joins, and
`Subcoalgebra.groupLikeSetSpan_finite` handles the group-like case, so the statement is expressible
today and only the argument is missing.

Downstream of it, in order: **faithfulness**, where the matrix-coefficient half can already be
stated (`matrixCoefficientSubalgebra ... = ⊤` is available and computed for the regular comodule),
but the closed-immersion half has nowhere to live until there is a scheme model or a representability
notion; **duals and rigidity** on `FGComoduleCat`, which will need a projectivity or field
hypothesis that the current finitely-generated-over-a-commutative-ring setup does not supply; and
the **embedding theorem**, which additionally needs `GLₙ` as a Hopf algebra. `GLₙ` is a small,
self-contained, unclaimed piece of work and is a good entry point.

The **scheme side** is the other open flank. The two `Suggested.lean` targets are stated and
elaborate, and nothing in the library blocks them; they are simply not started. The roadmap notes
that the Toric work giving one direction is not in Mathlib master, so the `Spec`-to-Hopf direction
would have to be built here, via affine fibre products and `Γ(Spec A ×_{Spec R} Spec B) ≅ A ⊗_R B`.
Until this exists, several statements can only be made pointwise: `μ_n = ker` and `αₚ = ker` are
currently equalities of subgroups of `A`-points plus naturality, not scheme-theoretic kernels.

Three smaller targets are within reach and would tidy existing work. First, upgrade
`coordinateRingFunctor` to the anti-equivalence between finitely generated abelian groups and
finite-type diagonalizable groups; the functor and both categories exist, so what remains is
fullness, faithfulness and the essential image. Second, bundle the exponent arithmetic of
`powEnd` into the ring homomorphism `ℤ → End(𝔾ₘ)` that `powEnd_add`, `powEnd_zero`, `powEnd_neg` and
`powEnd_comp` already amount to. Third, **normal Hopf ideals**: the adjoint coaction at Hopf level
is the missing definition, and it is the last piece of Layer 3 that does not require sheaves.

Blocked, and honestly so: **quotients `G/H`** and everything in Layer 3 past normality wait on the
fppf sheaf and descent lane, which has not begun and is a substantial project in its own right.
**`Lie(G)`** (Layer 2) is not blocked by anything except effort; the dual-numbers algebra `R[ε]`
already appears as a test object in the `αₚ` work, so the tangent-space definition is expressible
now, and Layers 5 and 6 will not start without it. **Layers 5 through 8** are unreachable as stated
until Layers 1 through 4 close: in particular the roadmap's own warning stands, that a correct
`IsUnipotent` needs the comodule theory rather than a nilpotence test in the coordinate ring, and
the comodule theory is not yet strong enough to support it.
