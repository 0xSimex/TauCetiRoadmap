#!/usr/bin/env python3
"""Re-verify an archived roadmap target file against the revisions it names.

A closed-out `Suggested.lean` states each target of a roadmap and closes it with the Tau Ceti
declaration that realizes it, so that a completion claim is checked by the Lean kernel rather than asserted
in prose. Once its roadmap is archived under `Completed/`, the file is finished: closing a
roadmap is a judgment about the roadmap, not about the area, and Tau Ceti carries on moving
afterwards. So an archived record must not be dragged along with the library -- it should stay
exactly as it was and stay checkable.

That is what the header buys. Each record carries one line

    -- tauceti-discharge:v1 {"roadmap": ..., "tauceti": ..., "mathlib": ..., "toolchain": ...}

naming the exact revisions it elaborates against. This script builds the record against *those*
revisions in a scratch workspace, never against whatever the repository pins today. A record
therefore never needs updating, and never reddens the ordinary `TauCetiRoadmap` build, while
remaining reproducible by anyone years later.

Deliberately not wired into required CI. Re-verification depends on things outside this
repository that decay: Mathlib and Tau Ceti artifact caches retaining the pinned revisions, elan
still serving the pinned toolchain, that toolchain still running on the host. As a mandatory gate
this becomes a liability the first time a cache expires, for a roadmap nobody is working on. As an
on-demand script it simply stops being useful, which is the better failure.

The header earns its keep either way. Even once re-verification is impractical, "these statements
were discharged against Tau Ceti X, Mathlib Y, toolchain Z" is a precise and falsifiable historical
claim, which is more than a prose judgment offers. Reproducibility here is a bonus with a decay
curve, not the load-bearing part.

Usage:
    .github/scripts/check_discharged.py                     # every archived record
    .github/scripts/check_discharged.py Completed/X/Discharged.lean
    .github/scripts/check_discharged.py --list              # show the headers, verify nothing
"""

from __future__ import annotations

import argparse
import json
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
HEADER = re.compile(r"^--\s*tauceti-discharge:v1\s*(\{.*\})\s*$", re.MULTILINE)
TAUCETI_GIT = "https://github.com/TauCetiProject/TauCeti"


def read_header(path: pathlib.Path, source: str | None = None) -> dict:
    m = HEADER.search(source if source is not None else path.read_text())
    if not m:
        raise SystemExit(f"{path}: no `tauceti-discharge:v1` header")
    try:
        meta = json.loads(m.group(1))
    except json.JSONDecodeError as exc:
        raise SystemExit(f"{path}: malformed header: {exc}") from exc
    for key in ("tauceti", "toolchain"):
        if key not in meta:
            raise SystemExit(f"{path}: header is missing {key!r}")
    return meta


def records() -> list[pathlib.Path]:
    out = []
    for p in sorted((ROOT / "Completed").rglob("Suggested.lean")):
        if HEADER.search(p.read_text()):
            out.append(p)
    return out


def verify(path: pathlib.Path) -> bool:
    """Elaborate `path` against the revisions its own header names."""
    # Read the source once: everything below runs off this snapshot, so a checkout or edit
    # while the (slow) build is in flight cannot change what is being verified.
    source = path.read_text()
    meta = read_header(path, source)
    rel = path.relative_to(ROOT)
    print(f"→ {rel}  (Tau Ceti {meta['tauceti'][:10]}, {meta['toolchain']})")

    work = pathlib.Path(tempfile.mkdtemp(prefix="discharge-"))
    try:
        (work / "lean-toolchain").write_text(meta["toolchain"] + "\n")
        (work / "lakefile.toml").write_text(
            'name = "DischargeCheck"\n'
            'defaultTargets = ["DischargeCheck"]\n\n'
            "[[require]]\n"
            'name = "TauCeti"\n'
            f'git = "{TAUCETI_GIT}"\n'
            f'rev = "{meta["tauceti"]}"\n\n'
            "[[lean_lib]]\n"
            'name = "DischargeCheck"\n'
        )
        (work / "DischargeCheck.lean").write_text("")
        (work / "Record.lean").write_text(source)

        r = subprocess.run(["lake", "update", "TauCeti"], cwd=work, capture_output=True, text=True)
        if r.returncode != 0:
            print(r.stderr.strip()[-2000:])
            print(f"  FAIL: could not materialize Tau Ceti at {meta['tauceti'][:10]}")
            return False
        subprocess.run(["lake", "exe", "cache", "get"], cwd=work, capture_output=True, text=True)

        # The record imports Tau Ceti modules, and those have to exist as `.olean`s before it can
        # elaborate. `lake exe cache get` above fetches Mathlib only, so build what the record
        # actually imports -- the expensive step, and the one that decides whether re-verifying an
        # old record is minutes or hours.
        mods = re.findall(r"^import\s+(TauCeti\.[\w.]+)", source, re.MULTILINE)
        if mods:
            print(f"  building {len(mods)} Tau Ceti modules it imports ...")
            r = subprocess.run(["lake", "build", *mods], cwd=work, capture_output=True, text=True)
            if r.returncode != 0:
                print((r.stdout + r.stderr).strip()[-3000:])
                print(f"  FAIL: could not build Tau Ceti {meta['tauceti'][:10]} for this record")
                return False

        r = subprocess.run(
            ["lake", "env", "lean", "Record.lean"], cwd=work, capture_output=True, text=True
        )
        out = (r.stdout + r.stderr).strip()
        if r.returncode != 0:
            print(out[-4000:])
            print(f"  FAIL: {rel} does not elaborate against the revisions it names")
            return False
        if out:
            print(out[-2000:])
        print(f"  ok: {rel}")
        return True
    finally:
        shutil.rmtree(work, ignore_errors=True)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("paths", nargs="*", type=pathlib.Path)
    ap.add_argument("--list", action="store_true", help="print headers without verifying")
    args = ap.parse_args()

    targets = [p.resolve() for p in args.paths] or records()
    if not targets:
        print("no archived discharge records found")
        return 0

    if args.list:
        for p in targets:
            meta = read_header(p)
            print(f"{p.relative_to(ROOT)}  {json.dumps(meta, sort_keys=True)}")
        return 0

    return 0 if all([verify(p) for p in targets]) else 1


if __name__ == "__main__":
    sys.exit(main())
