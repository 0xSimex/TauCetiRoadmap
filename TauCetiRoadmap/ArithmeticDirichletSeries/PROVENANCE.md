# Provenance: arithmetic Dirichlet series and Tauberian methods

**This file is non-normative and dated.** The specification is [`README.md`](README.md). This file
records the migration sources, revisions, licensing questions, and ownership decisions so that
reviewed corrections are not lost during extraction.
No roadmap milestone or dependency depends on this file.

Audit date: 2026-08-10.

## Migration table

| Source | Source revision | Material moved | Changes during extraction |
|---|---|---|---|
| `roed-math/TauCetiRoadmap` PR #8 | `a070739ff7c026723e1ef67477fe206dfdf28455` | `IdealWeight`, norm regrouping, generic local factors and Euler products, Landau, density calculus, prime carriers, Wiener–Ikehara, prime-ideal transfer | Removed completed-L-function, Hecke-character, and Frobenius ownership; retained the corrected zero-ideal law and density ratio normalization. |
| `roed-math/TauCetiRoadmap` PR #11 | `21e58a4bcba71584e143aa37f8abdb4ac46a4262` | generic truncated Perron machinery and endpoint conventions | Separated generic kernel and summatory bridge from zero-specific contour shifts; retained the exact finite-height value at the endpoint. |
| `TauCetiProject/TauCetiRoadmap` PR #181 | description and review record as of 2026-08-10 | independent identification of Dirichlet density, ideal Euler products, and Wiener–Ikehara as reusable inputs | Used as architectural corroboration only. No source file from PR #181 was copied. |

The normative migration ledger is maintained separately by the portfolio restructuring pass. This
file records only the rows that land in this roadmap.

## Corrections preserved

- `IdealWeight.eq_zero_bot` is mandatory. The constant-one function is the counterexample to the
  weaker carrier.
- `IdealWeight.map_mul` makes this a completely multiplicative degree-one carrier. It cannot carry
  a general Artin Euler product: for the two-dimensional trivial representation `(1-T)⁻²` has
  coefficients `a(𝔭)=2` and `a(𝔭²)=3`, not `a(𝔭)²=4`.
- The public prime type is `HeightOneSpectrum (𝓞 K)`, so primality and nonzeroness are carried by
  the type.
- Dirichlet density is the ratio to the all-prime prime sum. Equivalence with logarithmic
  normalization follows only after the Euler-product estimate.
- The all-prime asymptotic uses the Euler product and bounded higher-prime-power contribution; the
  Dedekind-zeta residue alone does not prove it.
- Perron's endpoint has the exact finite-height value `π⁻¹ arctan(T/c)`. The half weight occurs
  only in the limit.
- Logarithmic derivatives retain all prime-power terms until a proved error estimate removes the
  higher powers.

## Existing formalizations and licences

| Project | Status or revision | Licence | Use here |
|---|---|---|---|
| Mathlib `LSeries`, Abel summation, ideal arithmetic | repository pin | Apache-2.0 | consume directly |
| PNT+ / `PrimeNumberTheoremAnd` | status cited by PR #181 | verify before adapting code | mathematical route and API comparison only until revision and licence are pinned |
| AINTLIB Chebotarev development | status cited by PR #181 | verify project licence and author consent before adapting code | density architecture only; no code transfer in this extraction |
| `roed-math/TauCetiRoadmap` PRs #8 and #11 | SHAs above | repository licence | reviewed roadmap prose and target signatures migrated with attribution |

No claim of permission to adapt the AINTLIB or PNT+ source code is made here. A contributor who
ports code must first record the exact repository revision, licence, and coordination outcome.

## Rejected ownership routes

- Keeping generic Euler products and Tauberian theory in `LFunctions` would make Chebotarev and
  other arithmetic projects depend on a completed-L-function roadmap for unrelated tools.
- Keeping Wiener–Ikehara or generic Perron machinery in `ZerosOfLFunctions` would reverse the
  intended dependency.
- Calling the roadmap `AnalyticNumberTheory` would claim a much larger subject. Calling it
  `LSeries` would conflict with Mathlib's carrier and with the separate `LFunctions` roadmap.
