# OpenHealth

A native SwiftUI health dashboard for iPhone, backed by Apple Health and Google Health (Fitbit Air).

## What it does

- Steps, sleep, recovery, and hydration rings
- Home Screen widgets for steps and hydration
- Water logging
- **Ask OpenHealth**: on-device answers about your stats (Foundation Models when available)
- Recovery estimate: 50% sleep vs goal, 25% HRV and 25% resting HR vs your 7-day baseline. Not medical advice.

## Run it

- Open `OpenHealth.xcodeproj` and run the `OpenHealth` scheme
- The simulator loads demo data automatically
- `project.yml` is the source of truth: run `xcodegen generate` after adding files
- Hot reload: run the Debug build in the simulator and save any Swift file. No extra app needed (InjectionIII standalone via the `Inject` package)

## On a device

- Pick your team under **Signing & Capabilities** for `OpenHealth` and `StepsWidget`
- If your team can't register the bundle IDs or App Group `group.com.prasanthdendukuri.openhealth`, change them in `project.yml`, both `.entitlements` files, and `Shared/SharedSnapshot.swift`
- Add the **OpenHealth Steps** and **OpenHealth Hydration** widgets from the widget gallery

## Data sources

- **Apple Health:** reads steps, sleep, water, HRV, and resting heart rate
- **Google Health (direct):** OAuth with PKCE, tokens in the Keychain, and no client secret in the app
  - The public iOS client ID is in `OpenHealth/Info.plist`
  - To use your own Cloud project, run `python3 scripts/configure-google-health.py YOUR_IOS_CLIENT_ID`
- **Fitbit Air without Google Cloud:** in Google Health, open **Partner apps → Apple Health**, turn on sharing, then connect Apple Health in OpenHealth

## Refresh

- HealthKit observer queries, background app refresh, a refresh on open, and 30 s polling while the app is visible
- Widgets reload when new data arrives. iOS budgets widget reloads, so updates can lag by a few minutes.
- **Faster step updates** (optional): Google Health shares steps to Apple Health, and each new sample wakes OpenHealth to fetch Google's total
- The floor is the Air syncing to the Google Health app. No API can make the tracker sync.

## Privacy

See [PRIVACY.md](PRIVACY.md).
