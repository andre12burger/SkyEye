#!/usr/bin/env python3
import os
import sys
import argparse
from pathlib import Path

REQUIRED_FILES = [
    "metadata_ortho.bin",
    "metadata_front.bin",
    "img/front.json",
    "split/train.txt",
    "split/val.txt",
]

REQUIRED_DIRS = [
    "bev_msk/bev_ortho",
    "bev_plabel_dynamic/bev_ortho",
    "front_msk_seam/front",
    "split/percentages",
]


def check_path(root: Path):
    missing = []
    present = []
    for rel in REQUIRED_FILES:
        p = root / rel
        (present if p.is_file() else missing).append(("file", rel))
    for rel in REQUIRED_DIRS:
        p = root / rel
        (present if p.is_dir() else missing).append(("dir", rel))
    return present, missing


def main():
    parser = argparse.ArgumentParser(description="Validate SkyEye SEAM (PanopticBEV) dataset root structure.")
    parser.add_argument("--root", required=True, help="Path to SEAM root (kitti360_bev)")
    args = parser.parse_args()

    root = Path(args.root)
    if not root.exists():
        print(f"ERROR: Root does not exist: {root}", file=sys.stderr)
        sys.exit(2)

    present, missing = check_path(root)

    print(f"Checking: {root}")
    for kind, rel in present:
        print(f"OK    {kind:4}  {rel}")
    if missing:
        print("\nMissing:")
        for kind, rel in missing:
            print(f"MISS  {kind:4}  {rel}")
        print("\nHint: Set SEAM_ROOT_DIR to the directory containing these files/dirs, or download/extract the PanopticBEV dataset.")
        sys.exit(1)
    else:
        print("\nAll required files and directories are present.")
        sys.exit(0)


if __name__ == "__main__":
    main()
