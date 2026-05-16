"""Run executable certificates from certificates/manifest.json.

The manifest is the source of truth for the repository's multi-language
certificate surface.  This runner deliberately stays small: it loads the
manifest, selects default or all entries, runs each command from the repo root,
and reports a compact pass/fail summary.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MANIFEST = ROOT / "certificates" / "manifest.json"


@dataclass(frozen=True)
class Certificate:
    id: str
    language: str
    trust: str
    default: bool
    command: tuple[str, ...]
    purpose: str

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> "Certificate":
        return cls(
            id=str(data["id"]),
            language=str(data["language"]),
            trust=str(data["trust"]),
            default=bool(data.get("default", False)),
            command=tuple(str(part) for part in data["command"]),
            purpose=str(data["purpose"]),
        )


def load_manifest(path: Path) -> list[Certificate]:
    raw = json.loads(path.read_text(encoding="utf-8"))
    if raw.get("schema") != 1:
        raise ValueError(f"unsupported manifest schema in {path}")
    return [Certificate.from_json(item) for item in raw["entries"]]


def selected_certificates(
    certificates: list[Certificate],
    *,
    run_all: bool,
    only: set[str],
) -> list[Certificate]:
    if only:
        known = {item.id for item in certificates}
        unknown = sorted(only - known)
        if unknown:
            raise ValueError(f"unknown certificate id(s): {', '.join(unknown)}")
        return [item for item in certificates if item.id in only]
    if run_all:
        return certificates
    return [item for item in certificates if item.default]


def run_certificate(certificate: Certificate) -> bool:
    command_text = " ".join(certificate.command)
    print(f"[RUN] {certificate.id}", flush=True)
    print(f"      {certificate.language}; {certificate.trust}", flush=True)
    print(f"      {command_text}", flush=True)

    start = time.perf_counter()
    result = subprocess.run(certificate.command, cwd=ROOT)
    elapsed = time.perf_counter() - start
    if result.returncode == 0:
        print(f"[PASS] {certificate.id} ({elapsed:.2f}s)", flush=True)
        return True

    print(f"[FAIL] {certificate.id} exited with {result.returncode} ({elapsed:.2f}s)", flush=True)
    return False


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=DEFAULT_MANIFEST,
        help="certificate manifest path",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="include non-default certificate entries",
    )
    parser.add_argument(
        "--only",
        action="append",
        default=[],
        metavar="ID",
        help="run one certificate id; may be provided multiple times",
    )
    args = parser.parse_args(argv)

    try:
        certificates = load_manifest(args.manifest)
        selected = selected_certificates(
            certificates,
            run_all=args.all,
            only=set(args.only),
        )
    except Exception as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 2

    if not selected:
        print("[ERROR] no certificates selected", file=sys.stderr)
        return 2

    failed: list[str] = []
    for certificate in selected:
        if not run_certificate(certificate):
            failed.append(certificate.id)

    print("")
    print(f"checked: {len(selected)}")
    print(f"passed:  {len(selected) - len(failed)}")
    print(f"failed:  {len(failed)}")
    if failed:
        print("failed ids: " + ", ".join(failed))
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
