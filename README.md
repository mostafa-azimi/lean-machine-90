# Lean Machine 90

Lean Machine 90 is a private, local-first health and body-composition planning app. The initial client is a native SwiftUI iPhone app. A full Next.js web client is planned after the iOS daily loop is proven.

## Current status

Milestones 0–1 are in progress:

- Native iOS project foundation.
- Versioned SwiftData schema.
- Timezone-safe calendar-day identity.
- Multi-user-ready record ownership and sync metadata.
- Five-tab application shell.
- Foundation unit and UI tests.

Production launches with no seeded personal data. Sample data belongs only in previews and explicit debug fixtures.

## Architecture

- iOS 17 or later.
- SwiftUI, SwiftData, and Swift Charts.
- No third-party application dependencies.
- Local-first writes through SwiftData.
- Cloud synchronization is opt-in and will use an outbox-based, idempotent protocol.
- Web v2 will be a separate Next.js interface sharing API contracts, not SwiftUI code.

See [Architecture decisions](docs/ARCHITECTURE_DECISIONS.md) and [Implementation plan](docs/IMPLEMENTATION_PLAN.md).

## Open the project

1. Open LeanMachine90.xcodeproj in Xcode 26.6 or a compatible stable release.
2. Select the LeanMachine90 scheme.
3. Choose a current iPhone simulator.
4. Build and run.

Command-line build:

    xcodebuild \
      -project LeanMachine90.xcodeproj \
      -scheme LeanMachine90 \
      -destination 'generic/platform=iOS Simulator' \
      -derivedDataPath DerivedData \
      build

Command-line tests:

    xcodebuild \
      -project LeanMachine90.xcodeproj \
      -scheme LeanMachine90 \
      -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
      -derivedDataPath DerivedData \
      test

Simulator names vary by installed runtime. Use xcrun simctl list devices available to select one that exists locally.

## Privacy and health boundaries

- No advertising, analytics, remote tracking, or automatic cloud upload.
- Cloud sync will require explicit opt-in.
- Health notes and progress photos will have separate sync/export controls.
- The app does not diagnose, prescribe, manage medication, or guarantee outcomes.
- HealthKit will be read-only and optional when implemented.

## Repository structure

    LeanMachine90/          iOS application source
    LeanMachine90Tests/     Unit and persistence tests
    LeanMachine90UITests/   Critical-path UI tests
    docs/                   Product and architecture decisions

The future web client will be added under apps/web when the repository transitions to a monorepo layout. The iOS project will then move to apps/ios without changing its module or bundle identity.
