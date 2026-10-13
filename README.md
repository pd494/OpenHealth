# OpenHealth

A SwiftUI home screen for iPhone: a card of goal rings you can add, remove and reorder.

- Ring values are hard-coded placeholders in `MetricRegistry`; no real data source is wired in yet
- Edit shows a hide badge on each ring; touch and hold a ring to move or hide it
- Add opens a sheet listing the hidden metrics

## Run it

- Open `OpenHealth.xcodeproj` and run the `OpenHealth` scheme
- `project.yml` is the source of truth: run `xcodegen generate` after adding files
- Hot reload: `./scripts/run-sim.sh` builds, installs and launches with hot reload on; save any Swift file to update the simulator (InjectionIII standalone via the `Inject` package)
- Add a metric: a `MetricID` case plus one line in `MetricRegistry`
