#!/bin/sh
# Build, install and launch OpenHealth in the simulator with hot reload on.
# Leave it running; saving any .swift file under ~ reloads the change in about a second.
set -e
cd "$(dirname "$0")/.."
SIM="${SIM:-booted}"
xcodebuild -scheme OpenHealth -destination "platform=iOS Simulator,name=${SIM_NAME:-iPhone 17}" -quiet build
APP=$(xcodebuild -scheme OpenHealth -destination "platform=iOS Simulator,name=${SIM_NAME:-iPhone 17}" -showBuildSettings 2>/dev/null \
  | awk '/ TARGET_BUILD_DIR/{d=$3} / WRAPPER_NAME/{w=$3} END{print d"/"w}')
xcrun simctl install "$SIM" "$APP"
SIMCTL_CHILD_INJECTION_STANDALONE=1 exec xcrun simctl launch --console-pty --terminate-running-process "$SIM" com.prasanthdendukuri.openhealth
