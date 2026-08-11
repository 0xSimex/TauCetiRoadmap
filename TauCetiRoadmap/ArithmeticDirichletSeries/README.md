# Roadmap: arithmetic Dirichlet series and Tauberian methods

This roadmap develops the analytic infrastructure shared by zeta functions, Hecke L-functions,
Chebotarev density, and explicit prime-counting arguments. It starts from arithmetic functions on
the nonzero ideals of a number field, regroups them by norm into Mathlib's `LSeries`, builds local
Euler factors and Euler products, and ends with Landau-type positivity, Perron summation,
Dirichlet-density calculus, Wiener–Ikehara, and generic prime-number-theorem transfer.

The roadmap owns no completed L-function, Hecke character, Frobenius class, Chebotarev theorem, or
zero-free region. Those objects have separate owners. The purpose here is that each downstream
roadmap uses the same ideal weight, prime carrier, density predicate, summation convention, and
Tauberian theorem.

Suggested home: `TauCeti/NumberTheory/ArithmeticDirichletSeries/`, with one file per layer and a
small `Basic.lean` exporting the declarations in the contract table below.

---

## Scope and boundaries

### Owned here

- multiplicative arithmetic functions on integral ideals, including their value at the zero ideal;
- regrouping ideal-indexed sums by absolute norm into Mathlib `LSeries`;
- ideal convolution, logarithmic derivatives, local factors, and ideal-indexed Euler products;
- nonzero prime-ideal carriers and locally finite weighted counting functions;
- Abel–Stieltjes and Perron summation with fixed endpoint conventions;
- Dirichlet density, upper and lower density, finite-error invariance, squeeze, and fibre counts;
- reusable Landau positivity and Wiener–Ikehara theorems;
- the generic passage from von Mangoldt asymptotics to `ψ`, `ϑ`, and `π` asymptotics.

### Consumed

The pinned Mathlib supplies `Ideal`, `Ideal.absNorm`, unique factorization of nonzero ideals,
`IsDedekindDomain.HeightOneSpectrum`, `LSeries`, Dirichlet convolution, filters and asymptotics,
interval integration, and `Mathlib/NumberTheory/AbelSummation.lean`. This roadmap uses those
objects directly and does not wrap a competing series type or prime predicate around them.

### Not owned here

- analytic-normalized completed L-function data, continuation, gamma factors, and functional
  equations (`LFunctions`);
- moduli, ray class groups, and Hecke-character carriers (`GlobalNumberFields`);
- arithmetic Frobenius and ideal Artin maps (`NumberFieldArithmetic`);
- Frobenius prime sets and Chebotarev (`Chebotarev`);
- zero counting, zero-free regions, explicit formulas, and effective estimates
  (`ZerosOfLFunctions`).

The boundary is theorem-level. A downstream roadmap may specialize a declaration below, but it
does not redefine the carrier under a domain-specific name.

`IdealWeight` is a completely multiplicative degree-one character-like carrier. It is not the
coefficient carrier of an arbitrary Euler product. In particular, higher-dimensional Artin
coefficients require separate prime-power local data and do not define an `IdealWeight`.

---

## Pinned conventions

| Subject | Convention |
|---|---|
| ideal weights | The carrier is completely multiplicative and degree-one. Its value at `⊥` is `0`; multiplicativity alone does not imply this, as the constant-one rejection test shows. It is not a carrier for arbitrary local reciprocal polynomials. |
| norm coefficients | The `n = 0` coefficient is fixed by the ideal-weight convention. Equality of two `LSeries` coefficients is normally stated away from the irrelevant zero slot. |
| prime carrier | A prime is `IsDedekindDomain.HeightOneSpectrum (𝓞 K)`, not an arbitrary ideal with a later proof that it is nonzero and prime. |
| density | `HasDirichletDensity S δ` is the limit of `P_S(s) / P_all(s)` as `s → 1⁺`; `HasNaturalDensity S δ` is the analogous ratio of prime-counting functions as `x → ∞`. Normalization by `log (1/(s-1))` is a theorem after the all-prime asymptotic, not the definition. |
| cutoffs | Weighted counts include norm exactly equal to `x`. Natural-number and real cutoffs are connected by named lemmas. |
| Abel summation | Finite identities use half-open intervals chosen so a boundary term is counted exactly once. |
| Perron | The finite-height kernel at `x = 1` is `π⁻¹ arctan(T/c)`; `1/2` is only its limit. Arithmetic applications either exclude a norm endpoint or state the half-weight limit. |
| logarithmic derivatives | Prime powers are part of the coefficient. Removing higher powers is a later estimate, never a definitional simplification. |

The zero-ideal and Perron endpoint tests are required worked examples. They prevent two errors
that otherwise survive every coprimality-guarded or off-endpoint theorem.

---

## Export contract

| Object or theorem | Layer | Required declaration | Contract |
|---|---:|---|---|
| multiplicative ideal weight | 0 | `IdealWeight` | includes `eq_zero_bot` and finite bad-prime support |
| coefficient by norm | 1 | `normCoeff` | finite sum over ideals of absolute norm `n` |
| trivial-weight abscissa | 1 | `abscissaOfAbsConv_normCoeff_one` | exact abscissa `1`, the renamed Dedekind-zeta coefficient contract |
| regrouping | 1 | `regroupByNorm` | ideal-indexed series equals Mathlib `LSeries normCoeff` on the common convergence region |
| Euler-product package | 3 | `EulerProductData` | canonical local factors, convergence, finite bad set, and product equality |
| nonzero prime Dirichlet sum | 5 | `primeDirichletSum` | indexed by `HeightOneSpectrum`, with a set or weight parameter |
| weighted prime counts | 5 | `primeTheta`, `primeCount` | inclusive real cutoff and conversion to natural cutoffs |
| density predicates | 7 | `HasDirichletDensity`, `HasNaturalDensity`, `LowerDirichletDensity`, `UpperDirichletDensity` | ratio normalization by the corresponding all-prime sum or count |
| Abel summation | 6 | `abelSummation` | exact finite identity plus an asymptotic corollary |
| Perron summation | 6 | `perronFormula` | truncated kernel, endpoint value, and an arithmetic summatory form |
| cancellation and continuation | 6 | `HasCancellation`, `continuedLFunctionOfWeight` | a named continuation into the strip supplied by the ideal partial-sum estimate |
| Landau positivity | 8 | `landau` | singularity at the abscissa for nonnegative coefficients |
| Wiener–Ikehara | 9 | `wienerIkehara` | continuous boundary remainder on `Re s ≥ 1`, not a subtraction evaluated at the pole |
| generic PNT transfer | 10 | `primeNumberTheoremTransfer` | logarithmic derivative to `ψ`, prime-power removal to `ϑ`, and Abel transfer to `π` |

Consumers are `LFunctions`, `Chebotarev`, and `ZerosOfLFunctions`. Their contract tables name
these declarations rather than prose such as “the density lemmas” or “a Tauberian theorem.”

---

## The build, in layers

### Layer 0: arithmetic functions on ideals

**0.1 The carrier.** Define `IdealWeight K` as a complex-valued multiplicative function on
integral ideals, with a finite set of bad height-one primes, unit norm away from that set, value
zero on it, and value zero at `⊥`. Supply coercions, extensionality, `map_one`, and simplification
lemmas for good and bad primes. State explicitly that this completely multiplicative degree-one
carrier excludes coefficient systems whose prime powers are independent local-polynomial data.

**0.2 Constructors and operations.** Build the trivial weight, conjugation, pointwise product,
restriction away from a finite prime set, and finite-order weights. Keep pointwise multiplication
separate from ideal convolution. Prove functoriality under a number-field equivalence.

**0.3 The zero-ideal rejection test.** Prove that the constant-one function cannot be an
`IdealWeight`. Exhibit the corresponding multiplicative function without the zero law, so the
hypothesis is demonstrably necessary rather than decorative.

*Prerequisites:* Mathlib `Ideal`, `HeightOneSpectrum`, finite sets, unique factorization.

### Layer 1: norm fibres and Mathlib `LSeries`

**1.1 Finite norm fibres.** Package finiteness of `{I : Ideal (𝓞 K) | absNorm I = n}` and define
`normCoeff χ n` as the sum of `χ I` on that fibre. Prove the values at `0` and `1`, compatibility
with conjugation and pointwise products, and invariance under field equivalence.

**1.2 Regrouping.** Prove `regroupByNorm`: whenever the ideal-indexed series is absolutely
summable, regrouping by `absNorm` gives Mathlib's `LSeries (normCoeff χ)`. Include equality of
abscissae and the converse under nonnegative coefficients.

**1.3 The trivial specialization.** For the trivial weight, identify `normCoeff` with the named
Dedekind-zeta coefficient away from the zero slot. At `K = ℚ`, prove the coefficient is `1` for
every positive integer.

*Prerequisites:* Layer 0; Mathlib `LSeries`, `Ideal.finite_setOf_absNorm_eq`.

### Layer 2: convolution and logarithmic derivatives

**2.1 Ideal convolution.** Define convolution over factorizations `BC = A`; prove associativity,
commutativity, the delta identity, distributivity, and compatibility with norm regrouping and
Mathlib Dirichlet convolution.

**2.2 Möbius inversion.** Define the ideal Möbius function through unique factorization, prove
the expected prime-power values, and make it the convolution inverse of the trivial nonzero-ideal
weight.

**2.3 Von Mangoldt transform.** Define the ideal von Mangoldt weight and the transform attached to
a weight. Prove support on prime powers and the exact coefficient identity for the logarithmic
derivative of an Euler product on its absolute-convergence half-plane.

### Layer 3: local factors and Euler products

**3.1 Local data.** `EulerProductData` records the local coefficient at every height-one prime,
its bad set, and its local power series. Supply extensionality, restriction, product, conjugation,
and trivial-weight instances.

**3.2 Finite products first.** Prove the factorization of a coefficient over the prime-power
factorization of a nonzero ideal and the equality for Euler products over a finite set of primes.

**3.3 Infinite Euler product.** Under absolute convergence, pass to the directed limit of finite
prime sets and identify the product with `LSeries (normCoeff χ)`. State nonvanishing only where
absolute convergence of the reciprocal product proves it.

**3.4 Logarithm and derivative.** On a simply connected zero-free region, choose a logarithm and
prove both the prime-power logarithmic expansion and its derivative. Do not apply the principal
complex logarithm to an arbitrary Euler product.

### Layer 4: counting carriers and local finiteness

**4.1 Prime and ideal cutoff subtypes.** Package ideals and height-one primes with
`absNorm ≤ x`. Prove finiteness, monotonicity, equivalence of real and natural cutoffs, and the
empty small-cutoff cases.

**4.2 Generic summatory functions.** For nonnegative real weights define inclusive summatory
functions on ideals, prime ideals, and prime powers. Prove additivity, monotonicity, and invariance
under modification on a finite set.

**4.3 `primeTheta` and `primeCount`.** Define the logarithmically weighted and unweighted counts
for a set of height-one primes. Prove finite-union and finite-symmetric-difference lemmas.

### Layer 5: ideal and prime estimates

**5.1 Crude norm-fibre bounds.** Establish reusable polynomial bounds for ideal counts and the
number of prime powers at most `x`. The point is convergence and error control, not a best constant.

**5.2 Higher prime powers.** Prove the generic `O(√x log² x)` estimate under the standard
logarithmic prime-power weight. Isolate the hypotheses needed for other arithmetic weights.

**5.3 Degree-above-one primes.** For primes of a number field over rational primes, prove the
standard convergence and density-zero statements for residue degree greater than one. Chebotarev
uses this when moving between a field and a fixed subfield.

### Layer 6: Abel and Perron summation

**6.1 Abel summation.** Prove an exact formula for a locally finite norm-indexed family and a
`C¹` test function. Give both finite and Stieltjes forms, with the inclusive cutoff and boundary
term fixed by the conventions table.

**6.2 Standard transfers.** Derive `ϑ(x) ∼ δx ⟹ π(x) ∼ δ Li(x)` and
`Li(x) ∼ x/log x`, including the zero-density and `δ = 0` cases.

**6.3 Truncated Perron.** For `x > 0`, `c > 0`, and `T ≥ 1`, prove the vertical-segment kernel and
its error away from `x = 1`. Prove separately that the exact value at `x = 1` is
`π⁻¹ arctan(T/c)` and tends to `1/2`.

**6.4 Arithmetic Perron.** Interchange the integral with an absolutely convergent `LSeries` and
obtain a truncated summatory formula. State both the off-norm form and the limiting half-weight
form. `ZerosOfLFunctions` consumes this theorem for explicit formulas.

**6.5 Cancellation and a named continuation.** Define `HasCancellation χ` by the uniform
`O(X^(1-1/[K:ℚ]))` bound for ideal partial sums. Use Abel summation to construct
`continuedLFunctionOfWeight χ`, prove agreement with the norm-regrouped series on `Re s > 1`,
and analyticity on `Re s > 1-1/[K:ℚ]`. Finiteness of a coefficient quotient is not a substitute:
the prime values of a finite quotient of the free ideal group can be arbitrary. Export good-ideal,
conjugation, pointwise-square, and norm-twist operations used by character-family consumers; a
good ideal explicitly excludes `⊥`, even when the bad set is empty.

### Layer 7: Dirichlet density

**7.1 The predicates.** For `S : Set (HeightOneSpectrum (𝓞 K))`, define `P_S(s)` for real `s > 1`
and define density by `P_S(s)/P_all(s) → δ` as `s → 1⁺`. Define upper and lower density by
epsilon inequalities on the same ratio.

**7.2 The all-prime normalization.** From the Dedekind Euler product and bounded higher-prime-
power contribution, prove
`P_all(s) = log(1/(s-1)) + O(1)`. The Dedekind-zeta residue alone is not enough; the Euler product
is a prerequisite. Deduce equivalence with logarithmic normalization.

**7.3 Calculus.** Prove finite-set density zero, invariance under finite symmetric difference,
monotonicity, complements, finite disjoint unions, squeeze, and the implication from natural to
Dirichlet density.

**7.4 Fibre counts.** If a locally finite map of prime carriers has constant finite fibre size
away from a density-zero exception, relate the two prime sums and densities. State the variant
where fibres are counted only after intersecting with residue-degree-one primes.

### Layer 8: Landau-type positivity

**8.1 Landau's theorem.** For a Dirichlet series with nonnegative real coefficients and finite
abscissa of convergence, prove that the real point at the abscissa is a singularity of every
analytic continuation. Include the meromorphic-order corollary used by nonvanishing arguments.

**8.2 Positive combinations.** Package the `3-4-1` trigonometric nonnegativity argument as a
finite nonnegative coefficient combination, keeping analytic input separate from the positivity
lemma. `LFunctions` supplies character-specific continuation and applies this package.

The package does not assert cancellation for the trivial weight or its nonzero norm twists. Their
partial sums have linear size and their series are shifted Dedekind zeta functions with a pole;
this is the required rejection test for downstream character-family hypotheses.

### Layer 9: Wiener–Ikehara

**9.1 Boundary formulation.** Let `a n ≥ 0` and `F` agree with `LSeries a` on `Re s > 1`.
Assume there is a separately named continuous function `G` on `Re s ≥ 1` agreeing there with
`F(s) - κ/(s-1)`. Conclude `x⁻¹ ∑_{n≤x} a n → κ`.

The hypothesis is deliberately not continuity of the displayed subtraction at `s = 1`: both
terms are total functions with junk values there. The separate `G` records the continuous
extension.

**9.2 Variants.** Prove versions for natural cutoffs, finite changes of coefficients, a pole at a
positive abscissa after rescaling, and coefficients in an ordered real normed algebra when the
proof permits it.

### Layer 10: generic prime-number-theorem transfer

**10.1 From logarithmic derivative to `ψ`.** Apply Layer 9 to a nonnegative von Mangoldt
coefficient whose series has a simple pole of residue `δ` and continuous boundary remainder.

**10.2 Remove higher prime powers.** Use Layer 5 to derive `ϑ(x) ∼ δx` from `ψ(x) ∼ δx`.

**10.3 Count primes.** Use Layer 6 to obtain `π(x) ∼ δ Li(x) ∼ δx/log x`. Keep the theorem
generic in the prime set and weight. The trivial set gives the prime ideal theorem; a Frobenius
class gives qualitative Chebotarev only after `Chebotarev` supplies the correct coefficient and
analytic boundary statement.

---

## Worked examples and rejection tests

1. The constant-one ideal function is multiplicative but does not define `IdealWeight` because it
   has value `1` at `⊥`.
2. The trivial weight over `ℚ` regroups to the Riemann-zeta coefficient for every `n > 0`.
3. A finite prime set has Dirichlet density zero, and changing a set on finitely many primes does
   not change its density.
4. For the Perron kernel at `x = 1`, the finite-height value is
   `π⁻¹ arctan(T/c)`, not `1/2`; its limit is `1/2`.
5. Higher prime powers are visible in the logarithmic derivative before their contribution is
   estimated away.
6. The trivial prime carrier and residue `1` recover the prime ideal theorem.

---

## Ordering

```text
0 → 1 → 2 → 3
          ├────→ 7 → 8
1 → 4 → 5 ├────→ 9 → 10
      └→ 6 ┘
```

Layer 6 can be developed after Layers 1 and 4. Layer 7 needs the Euler product of Layer 3.
Layer 9 is analytically independent of arithmetic ideals after its statement is expressed in
Mathlib `LSeries` vocabulary. Layer 10 consumes Layers 5, 6, and 9.

## References

- H. Davenport, *Multiplicative Number Theory*, chapters on Dirichlet series, partial summation,
  Perron's formula, and the prime number theorem.
- G. Tenenbaum, *Introduction to Analytic and Probabilistic Number Theory*, chapters II–III for
  arithmetic functions and Tauberian transfer.
- J. Korevaar, *Tauberian Theory: A Century of Developments*, Chapter III for Wiener–Ikehara.
- J. Neukirch, *Algebraic Number Theory*, Chapter VII for ideal Euler products and prime ideals.
- J.-P. Serre, *Corps locaux*, and J. Milne, *Algebraic Number Theory*, for Dirichlet density and
  finite-error calculus.
- Titchmarsh, revised by Heath-Brown, *The Theory of the Riemann Zeta-Function*, Lemma 3.12 for
  the truncated Perron kernel and its endpoint restrictions.

The source migration and licensing record is in [`PROVENANCE.md`](PROVENANCE.md). It is not part
of this specification.
