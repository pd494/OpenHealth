#!/usr/bin/env python3
"""Rebuild and relaunch OpenCare when project sources change."""

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIRS = (ROOT / "OpenCare", ROOT / "StepsWidget", ROOT / "Shared")
WATCH_SUFFIXES = {".swift", ".plist", ".entitlements"}
BUNDLE_ID = "com.prasanthdendukuri.opencare"


def changed_files() -> dict[Path, int]:
    files = [ROOT / "project.yml"]
    for directory in SOURCE_DIRS:
        files.extend(path for path in directory.rglob("*") if path.suffix in WATCH_SUFFIXES)
    return {path: path.stat().st_mtime_ns for path in files if path.is_file()}


def booted_simulator() -> str:
    result = subprocess.run(
        ["xcrun", "simctl", "list", "devices", "booted", "-j"],
        capture_output=True,
        text=True,
        check=True,
    )
    for devices in json.loads(result.stdout)["devices"].values():
        for device in devices:
            if device["state"] == "Booted":
                return device["udid"]
    raise RuntimeError("Boot an iPhone Simulator before starting the watcher.")


def run(command: list[str], *, required: bool = True) -> bool:
    result = subprocess.run(command, cwd=ROOT, check=False)
    if result.returncode and required:
        print(f"Command failed ({result.returncode}): {' '.join(command)}", flush=True)
        return False
    return True


def rebuild(simulator: str) -> bool:
    print("\nRebuilding OpenCare…", flush=True)
    if not run(["xcodegen", "generate", "-q"]):
        return False
    if not run([
        "xcodebuild", "-quiet", "-project", "OpenCare.xcodeproj",
        "-scheme", "OpenCare", "-configuration", "Debug",
        "-sdk", "iphonesimulator",
        "-destination", f"platform=iOS Simulator,id={simulator}",
        "-derivedDataPath", ".build", "CODE_SIGNING_ALLOWED=NO", "build",
    ]):
        return False
    run(["xcrun", "simctl", "terminate", simulator, BUNDLE_ID], required=False)
    app = ROOT / ".build/Build/Products/Debug-iphonesimulator/OpenCare.app"
    if not run(["xcrun", "simctl", "install", simulator, str(app)]):
        return False
    if not run(["xcrun", "simctl", "launch", simulator, BUNDLE_ID]):
        return False
    print("OpenCare reloaded in Simulator. The browser stream stays connected.", flush=True)
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--simulator", help="Simulator UDID; defaults to the first booted simulator")
    args = parser.parse_args()
    try:
        simulator = args.simulator or booted_simulator()
    except (RuntimeError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1

    print(f"Watching OpenCare sources for Simulator {simulator}", flush=True)
    rebuild(simulator)
    previous = changed_files()
    try:
        while True:
            time.sleep(0.4)
            current = changed_files()
            if current == previous:
                continue
            time.sleep(0.4)  # Let editors finish atomic saves.
            previous = changed_files()
            rebuild(simulator)
    except KeyboardInterrupt:
        print("\nStopped watching.", flush=True)
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
