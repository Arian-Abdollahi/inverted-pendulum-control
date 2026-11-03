"""Add missing assets from the prepared project ZIP to the existing GitHub PR branch.

Example:
    python finish_import.py inverted-pendulum-control-git-ready.zip --push

Requires a local Git installation and permission to push to the repository.
The script does not modify main, and it does not overwrite files already on the PR branch.
"""

from __future__ import annotations

import argparse
from pathlib import Path, PurePosixPath
import subprocess
import sys
import tempfile
from zipfile import ZipFile

REPOSITORY = "https://github.com/Arian-Abdollahi/inverted-pendulum-control.git"
BRANCH = "import/inverted-pendulum-source"


def run(*args: str, cwd: Path | None = None) -> None:
    subprocess.run(args, cwd=cwd, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, help="Path to the Git-ready ZIP")
    parser.add_argument("--push", action="store_true", help="Commit and push added files to the PR branch")
    args = parser.parse_args()

    archive = args.archive.expanduser().resolve()
    if not archive.is_file():
        parser.error(f"ZIP archive not found: {archive}")

    with tempfile.TemporaryDirectory(prefix="inverted-pendulum-import-") as temp:
        root = Path(temp) / "repo"
        run("git", "clone", "--branch", BRANCH, "--single-branch", REPOSITORY, str(root))
        additions: list[str] = []
        unchanged = []
        with ZipFile(archive) as source:
            bad_member = source.testzip()
            if bad_member:
                raise ValueError(f"ZIP contains a corrupted entry: {bad_member}")
            for member in source.infolist():
                if member.is_dir():
                    continue
                posix_path = PurePosixPath(member.filename)
                if (
                    posix_path.is_absolute()
                    or ".." in posix_path.parts
                    or "\\" in member.filename
                    or not member.filename.strip()
                ):
                    raise ValueError(f"Unsafe archive path: {member.filename!r}")
                relative = posix_path.as_posix()
                target = root.joinpath(*posix_path.parts)
                if target.exists():
                    unchanged.append(relative)
                    continue  # Never overwrite the PR's already committed text files.
                additions.append(relative)
                if args.push:
                    target.parent.mkdir(parents=True, exist_ok=True)
                    target.write_bytes(source.read(member))

        print(f"Existing files preserved: {len(unchanged)}")
        print(f"Missing files to import: {len(additions)}")
        for path in additions:
            print(f"  + {path}")
        if not args.push:
            print("\nDry run only. Pass --push to commit these files to the PR branch.")
            return
        if not additions:
            print("No new files to commit.")
            return

        run("git", "add", "--", *additions, cwd=root)
        validator = root / "scripts" / "validate_structure.py"
        if validator.is_file():
            run(sys.executable, str(validator), cwd=root)
        run("git", "commit", "-m", "import: add remaining Simulink models, reports and media", cwd=root)
        run("git", "push", "origin", f"HEAD:{BRANCH}", cwd=root)
        print(f"\nPushed to PR branch: {BRANCH}")
        print("Review: https://github.com/Arian-Abdollahi/inverted-pendulum-control/pull/1")


if __name__ == "__main__":
    main()
