# Chebotarev: provenance and coordination

This file is supporting material for [`README.md`](README.md), which is the definitive roadmap.
**Nothing here is normative.** No milestone depends on an external repository, a pull request, a
source file, or a permission statement recorded here. The information is dated and may go stale.

Audit date: **2026-08-10**.

## Roadmap sources

The main mathematical source was the corrected Chebotarev and prime-counting development on the
`roadmap/lfunctions` branch of `roed-math/TauCetiRoadmap`, read at
`a070739ff7c026723e1ef67477fe206dfdf28455`. That revision includes the reviewed corrections to:

- the consumed Number Field Arithmetic Artin symbol and its prime-relative tower theorem;
- the dependent unramified-prime set, rather than a total Frobenius function with a ramified junk
  value;
- density as a ratio to the all-prime sum;
- the tagged crossing constant and fixed-field fibre size;
- the nonnegative Frobenius von Mangoldt coefficient and the prime-counting reduction.

That repository is Apache-2.0 licensed. The present roadmap restates the mathematics and does not
copy implementation code.

The dedicated-roadmap architecture and three convention tests were checked against
`TauCetiProject/TauCetiRoadmap` pull request
[#181](https://github.com/TauCetiProject/TauCetiRoadmap/pull/181), head
`ba040a3195ccda6a42f5b3e48b54d85f32465ec3`. Its closing comment records three corrections that
are incorporated here:

1. the all-prime logarithmic asymptotic needs the Euler product and bounded higher-prime-power
   contribution, not only the Dedekind-zeta residue;
2. continuation of a nontrivial character series needs counting and cancellation in ray classes;
3. prime-counting carriers must be a subtype of nonzero prime ideals, not a set of arbitrary
   ideals.

The master portfolio plan was used only for ownership, dependency order, and the fourteen-layer
split. No changed-file content from its coordination branch was used as mathematical source.

## Existing Lean developments

Two external repositories contain closely related formalizations.

| Repository | Revision audited | Licence | Role |
| --- | --- | --- | --- |
| [`CBirkbeck/AINTLIB`](https://github.com/CBirkbeck/AINTLIB) | `1c1c74664e40071c2c2165bc55ca2616a67ccd6b` | Apache-2.0 | Sorry-free proof architecture in `projects/Chebotarev/CebotarevDensity/`, especially the cyclotomic, abelian crossing, fixed-field, and main theorem files. It is prior art, not an API dependency. |
| [`CBirkbeck/chebotarev-density`](https://github.com/CBirkbeck/chebotarev-density) | `c64095e6cc6483b401849c7fd9182d983d3bf261` | Apache-2.0 | Human-reviewed rebuilding of the same route and infrastructure intended for closer Mathlib alignment. It is prior art, not an API dependency. |

The AINTLIB development predates Mathlib's present `IsArithFrobAt` API. Any implementation port
must replace its parallel Frobenius layer with the Number Field Arithmetic declarations consumed
by the roadmap; retaining both would defeat the portfolio ownership split.

## Permission and attribution status

PR #181 states that Riccardo Brasca and Xavier Roblot consented to adaptation of the existing
formalization. Chris Birkbeck authored that PR and the cited repositories. Both repositories
publish an Apache-2.0 licence, which permits adaptation and redistribution subject to its notice,
attribution, and licence conditions.

This audit did not independently obtain or archive the private consent messages. The public PR
statement and the repository licences are sufficient to treat the mathematics as usable prior art.
If implementation code is copied or adapted rather than independently reimplemented, the porter
must preserve the Apache-2.0 notices and check for any repository `NOTICE` file at the exact source
revision.

No source-permission blocker is known for the roadmap prose. The implementation team should still
coordinate with the authors before integrating code, as the repository contribution guide asks.

## Source-to-layer map

This map is deliberately secondary and non-prescriptive.

- Corrected L-functions density material supplies Layers 1--3 and 7--10.
- Corrected L-functions prime-counting material supplies Layers 11--14.
- PR #181 supplies the dedicated roadmap shape and the public convention tests.
- AINTLIB's `Cyclotomic`, `Abelian`, `FixedFieldDensity`, and `Main` developments supply a checked
  proof route for Layers 4--10.
- Arithmetic Dirichlet Series, Number Field Arithmetic, and Global Number Fields own the extracted
  carriers. Their final declarations, not any source file listed here, are the implementation
  prerequisites.

## Ecosystem notes at the audit date

Mathlib has `IsArithFrobAt`, `arithFrobAt`, conjugacy of arithmetic Frobenius choices, cyclotomic
Galois infrastructure, `LSeries`, Dirichlet characters, and the rational theorem on primes in
arithmetic progressions. The Tau Ceti portfolio adds the number-field Artin symbol, generic density
and Tauberian infrastructure, and ray-class arithmetic before this roadmap begins. Effective
Chebotarev and a general Artin-L-function route remain outside this roadmap.
