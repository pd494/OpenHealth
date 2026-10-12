# OpenCare

Native SwiftUI iPhone prototype with steps and hydration Home Screen widgets, sleep and recovery rings, hydration logging, and local questions about your stats.

## Try it now

Open `OpenCare.xcodeproj` and run the `OpenCare` scheme. The simulator shows demo data automatically; its `+` button lets you try logging water, and **Ask OpenCare** answers questions from the displayed stats. On a physical iPhone, connect Google Health for Fitbit Air after OAuth setup, or connect Apple Health to read steps, sleep, water, HRV, and resting heart rate.

To test on your iPhone, select your Apple development team under **Signing & Capabilities** for both `OpenCare` and `StepsWidget`. Both targets use the App Group `group.com.prasanthdendukuri.opencare` to share widget data. If your team cannot register that group or the bundle IDs, change them consistently in `project.yml`, both `.entitlements` files, and `Shared/SharedSnapshot.swift`, then run `xcodegen generate` again. Add **OpenCare Steps** and **OpenCare Hydration** from the iPhone Home Screen widget gallery. Tapping Hydration opens the water-entry sheet.

## Fitbit Air through direct Google Health connection

OpenCare's direct Google path uses Google's installed-app OAuth flow with PKCE. Tokens are stored in the iPhone Keychain. After sign-in, it requests Google's **dailyRollUp** of wearable steps, which reconciles overlapping samples, and the paired Fitbit Air's reported last sync time. It also fetches wearable sleep and recent HRV/resting heart rate where authorized and available. The steps total is for Google's **wearables source family**, so another Google/Fitbit wearable on the same account can contribute; the app does not claim it is an Air-only total in that case. [Google's steps guide](https://developers.google.com/health/data-types/steps), [source family guide](https://developers.google.com/health/filters).

The development Google Cloud project, OAuth consent screen, and **iOS OAuth client** for bundle ID `com.prasanthdendukuri.opencare` are configured. The public client ID is in `OpenCare/Info.plist`; no client secret is stored in the app. To use a different project, run `python3 scripts/configure-google-health.py YOUR_IOS_CLIENT_ID` from this folder. [Google Health setup](https://developers.google.com/health/setup), [Google installed-app OAuth](https://developers.google.com/identity/protocols/oauth2/native-app).

Google [requires standard OAuth clients to be created manually in Cloud Console](https://developers.google.com/identity/protocols/oauth2/resources/best-practices). `gcloud-mcp` wraps the gcloud CLI and cannot create that Google Health iOS client.

## Fitbit Air without Google Cloud setup

In Google Health, open **Partner apps → Apple Health** and allow it to share the metrics you want. Then connect Apple Health in OpenCare. Google Health introduced sharing back to Apple Health on iOS in version 5.05; OpenCare reads those samples through HealthKit. [Google announcement](https://support.google.com/googlehealth/thread/456993110), [Google connection guidance](https://support.google.com/googlehealth/answer/14236613?hl=en).

This route depends on Google Health's own sync schedule. Apple Health merges step samples from its sources by default; check its Steps data sources if your iPhone and tracker disagree. [Apple HealthKit statistics](https://developer.apple.com/documentation/healthkit/hkstatistics).

## Refresh behavior

OpenCare registers HealthKit observer queries at launch and requests immediate background delivery for relevant sample types. Direct Google Health accounts use a background app refresh task, a refresh whenever the app opens, and a manual check button. When the app receives new data, it saves steps and hydration in the shared App Group and asks WidgetKit to reload both widgets. Widget timelines also request a reload after five minutes and display the actual last check time.

For a faster Fitbit widget path, connect Google Health in OpenCare, then open **Google Health → Connections → Apps & services (or Partner apps) → Apple Health** and share **Steps**. In OpenCare's Google Health connection screen, tap **Enable faster step updates** and allow access to Apple Health Steps. A new Google Health step sample in Apple Health wakes OpenCare to fetch Google's wearable step rollup and request a widget reload. Apple Health is only the wakeup signal for this path, so the displayed total continues to come from Google Health. The connection screen says whether shared steps have been detected. While OpenCare is visible, it also checks steps every 30 seconds; opening the app always bypasses the one-minute cache guard.

iOS decides when HealthKit delivers background changes, schedules app refresh, and redraws a Home Screen widget. Apple documents a limited widget reload budget, so a refresh on **every** phone pickup cannot be guaranteed. Google Health only exposes new Fitbit Air data after the Air syncs with the Google Health app; Google documents approximately 15-minute automatic sync when that app is open and connected. [HealthKit background delivery](https://developer.apple.com/documentation/healthkit/executing-observer-queries), [WidgetKit update budget](https://developer.apple.com/documentation/WidgetKit/Keeping-a-Widget-Up-To-Date), [Google data availability](https://developers.google.com/health/data-types).

Google Health also offers a steps webhook, but it requires a public HTTPS server and only fires once the data reaches Google. Apple offers widget push notifications, but those remain subject to widget reload budgets. Neither mechanism can command the Fitbit Air to sync. [Google webhooks](https://developers.google.com/health/webhooks), [WidgetKit pushes](https://developer.apple.com/documentation/widgetkit/updating-widgets-with-widgetkit-push-notifications).

Recovery is a starter estimate: 50% sleep versus goal, 25% current HRV versus the previous seven days, and 25% resting heart rate versus the previous seven days. It remains unavailable until those measurements exist. It is not a medical assessment.

**Ask OpenCare** uses Apple's on-device Foundation Models when available and a deterministic stats summary otherwise. It only uses the values shown in the app and treats recovery factors as possible contributors rather than a diagnosis.

## Build

`project.yml` is the XcodeGen source of truth. Regenerate with `xcodegen generate`. The included Xcode project opens directly in Xcode.

For automatic simulator reload during development, boot a simulator and run `python3 scripts/dev-watch.py` from this folder. It watches Swift sources and project metadata, incrementally rebuilds, then relaunches the app. The `serve-sim` browser stream stays connected during each reload. This restarts the app, so transient in-memory UI state is reset.
