#!/usr/bin/env python3
"""Bump the version of a Python project (SemVer). Stdlib only.

Usage: bump.py {major|minor|patch|X.Y.Z} [--project DIR] [--dry-run]

Finds the single source of truth for the version, in this order:
  1. the file named by [tool.hatch.version] path in pyproject.toml
  2. a `_version.py` at the project root or under src/*/ (when version is dynamic)
  3. a static `version = "..."` in [project] in pyproject.toml
Then refreshes uv.lock if the project has one. It only edits files: committing,
merging, and tagging are done by the caller (see the git-workflow and release skills).
On success it prints the new version (bare, no "v") as the last line of stdout.
"""
import argparse
import re
import subprocess
import sys
import tomllib
from pathlib import Path

SEMVER = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
PY_VERSION = re.compile(r"""^(__version__\s*=\s*)(['"])([^'"]+)\2""", re.M)
TOML_VERSION = re.compile(r"""^(version\s*=\s*)(['"])([^'"]+)\2""", re.M)


def find_version_file(root: Path) -> tuple[Path, re.Pattern]:
    pyproject = root / "pyproject.toml"
    if not pyproject.exists():
        sys.exit(f"error: no pyproject.toml in {root}")
    data = tomllib.loads(pyproject.read_text())
    project = data.get("project", {})

    hatch_path = data.get("tool", {}).get("hatch", {}).get("version", {}).get("path")
    if hatch_path:
        return root / hatch_path, PY_VERSION
    if "version" in project.get("dynamic", []):
        for candidate in [root / "_version.py", *root.glob("src/*/_version.py")]:
            if candidate.exists():
                return candidate, PY_VERSION
        sys.exit("error: version is dynamic but no _version.py found")
    if "version" in project:
        return pyproject, TOML_VERSION
    sys.exit("error: could not locate the project version")


def bump(current: str, part: str) -> str:
    if SEMVER.match(part):
        return part
    m = SEMVER.match(current)
    if not m:
        sys.exit(f"error: current version {current!r} is not X.Y.Z")
    major, minor, patch = map(int, m.groups())
    if part == "major":
        return f"{major + 1}.0.0"
    if part == "minor":
        return f"{major}.{minor + 1}.0"
    if part == "patch":
        return f"{major}.{minor}.{patch + 1}"
    sys.exit(f"error: unknown bump {part!r} (use major, minor, patch, or X.Y.Z)")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("part", help="major, minor, patch, or an explicit X.Y.Z")
    ap.add_argument("--project", default=".", type=Path)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    root = args.project.resolve()
    path, pattern = find_version_file(root)
    text = path.read_text()
    m = pattern.search(text)
    if not m:
        sys.exit(f"error: no version string found in {path}")

    current, new = m.group(3), bump(m.group(3), args.part)
    if new == current:
        sys.exit(f"error: version is already {current}")

    print(f"{path.relative_to(root)}: {current} -> {new}", file=sys.stderr)
    if not args.dry_run:
        path.write_text(pattern.sub(lambda mm: f"{mm.group(1)}{mm.group(2)}{new}{mm.group(2)}", text, count=1))
        if (root / "uv.lock").exists():
            result = subprocess.run(["uv", "lock"], cwd=root)
            if result.returncode:
                print("warning: `uv lock` failed; uv.lock may be stale", file=sys.stderr)
    print(new)


if __name__ == "__main__":
    main()
