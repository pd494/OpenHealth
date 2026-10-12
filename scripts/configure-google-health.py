#!/usr/bin/env python3
"""Set the public iOS OAuth client ID and its callback scheme for OpenCare."""

import plistlib
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SUFFIX = ".apps.googleusercontent.com"


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: python3 scripts/configure-google-health.py IOS_CLIENT_ID")
        return 2
    client_id = sys.argv[1].strip()
    if not client_id.endswith(SUFFIX) or len(client_id) <= len(SUFFIX):
        print("Expected an iOS OAuth client ID ending in .apps.googleusercontent.com")
        return 2
    scheme = "com.googleusercontent.apps." + client_id[: -len(SUFFIX)]
    path = ROOT / "OpenCare/Info.plist"
    with path.open("rb") as file:
        info = plistlib.load(file)
    info["GoogleHealthClientID"] = client_id
    info["GoogleHealthRedirectScheme"] = scheme
    info["CFBundleURLTypes"] = [
        {"CFBundleURLName": "Google Health OAuth", "CFBundleURLSchemes": [scheme]},
        {"CFBundleURLName": "OpenCare links", "CFBundleURLSchemes": ["opencare"]},
    ]
    with path.open("wb") as file:
        plistlib.dump(info, file, sort_keys=False)
    print("Configured Google Health iOS OAuth callback. The development watcher will rebuild OpenCare.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
