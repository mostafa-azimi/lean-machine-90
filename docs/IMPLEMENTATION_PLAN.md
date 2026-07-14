# Implementation plan

## Product loop

The application is organized around:

**Plan → Today → Log → Review → Adjust**

## Confirmed product decisions

- iOS first.
- Full web logging and planning in v2.
- Local-first operation.
- Opt-in cloud sync.
- Sync after changes, at foreground, manually, and opportunistically in the background.
- Personal launch with multi-user-ready ownership.
- Native SwiftUI client; future Next.js web client on Vercel.
- One canonical record for nutrition, X3 training, recovery, symptoms, body composition, and plan revisions.
- Official WHOOP OAuth integration, with manual entry available when disconnected.
- First-party food logging replaces the daily need for Cal.ai; imports remain a migration aid, not a runtime dependency.
- AI-assisted pattern review and next-step coaching, with explicit medical and plan-change boundaries.
- iOS 17 minimum.

## Product promise

Lean Machine 90 should replace the daily switching cost among X3, Cal.ai, WHOOP, and a general chat assistant. It is the user's health operating system:

**Capture → Unify → Understand → Decide → Act**

The application owns the canonical timeline. Connected services are data providers, not separate sources of truth the user must reconcile.

## Source-of-truth rules

- Every imported or entered value records its source, source record ID, confidence, and last synchronization time.
- A manual correction may override an imported value without destroying the original observation.
- The same workout must not be counted twice when it arrives through WHOOP and HealthKit.
- Sensor force, user-entered force, and estimated band range are different measurement types and are never presented as equivalent.
- AI-extracted foods and portions are drafts until the user confirms them.

## Milestones

### 0–1: Foundation

- Xcode project and test targets.
- Versioned SwiftData schema.
- CalendarDay and canonical unit conversion.
- UserProfile, GoalPlan, TargetRevision, DayPlan, DailyLog, AppSettings, and SyncOperation.
- Root navigation, dependency environment, previews, and foundation tests.

### 2: Onboarding and plan

- Safety acknowledgement.
- Profile, goals, motivation, risks, equipment, schedule, and optional health context.
- Editable initial targets.
- Optional baseline.
- Initial TargetRevision and DayPlan.

### 3: Unified logging vertical slice

- Today dashboard with morning, nutrition, training, recovery, symptoms, and evening sections.
- Food search, manual foods, recent/favorite foods, meal templates, portions, and daily macro totals.
- X3 session templates and fast set logging: exercise, band, single/doubled configuration, full reps, partial reps, time under tension, RPE, pain, and notes.
- Manual Total Force entry for users who can read it from the X3 Force app.
- Partial saves.
- Quick add and undo.
- Deterministic next action.
- Safety suppression.

### 4: Private backend and opt-in synchronization

- Authenticated API hosted on Vercel without requiring a web interface yet.
- Multi-user Postgres schema, per-user authorization, encrypted integration secrets, and audit events.
- Idempotent push/pull synchronization for the iOS outbox.
- Separate consent controls for structured health data, photos, free-text health notes, connected services, and AI processing.
- Account export and complete cloud deletion.

### 5: Nutrition intelligence

- USDA FoodData Central search and food details through the backend, with local caching for offline reuse.
- Barcode provider abstraction and branded-food matching.
- Recipes, saved meals, serving conversion, and copy-from-day.
- Optional voice or meal-photo parsing into a reviewable draft.
- Calories and macros always show provenance; uncertain portions show an uncertainty cue instead of false precision.

### 6: WHOOP integration

- Backend-managed WHOOP OAuth with refresh-token rotation; no client secret in the iOS application.
- Import recovery, cycle/strain, sleep, workout, profile, and body-measurement data granted by the user.
- Cursor-based incremental sync, retry/backoff, revocation handling, and manual refresh.
- Local cached summaries remain available offline.
- Clear last-updated and provider-health status.
- Dedupe rules prevent WHOOP, HealthKit, and manual workout records from inflating totals.

### 7: AI health coach

- Separate opt-in consent and a plain-language data-use preview before the first request.
- Server-side OpenAI Responses API; API keys never ship in the app.
- Narrow read tools for daily summaries, nutrition adherence, workout history, force trends, WHOOP recovery/sleep trends, symptoms, and data completeness.
- Structured answers containing observations, possible explanations, confidence, missing data, one next-best action, questions, and safety state.
- Rule-based checks before and after model use for urgent symptoms, eating-risk patterns, medication questions, and other high-risk cases.
- The coach may surface correlations, explain possibilities, and recommend appropriate next steps. It does not diagnose disease, prescribe, change medication, or replace a clinician.
- Plan adjustments are drafts. The user must confirm before a TargetRevision is created.
- Evaluation fixtures cover unsupported causal claims, unsafe calorie changes, false certainty, data conflicts, and escalation behavior.

### 8: Photos and app privacy

- Protected PhotoStore.
- Import and guided capture.
- Thumbnails, calendar, deletion, and comparison.
- Device-owner app lock and inactive-scene privacy cover.

### 9: Measurements and progress

- Body measurements.
- Weight and waist trends.
- Nutrition, movement, recovery, symptoms, training, and X3 force/progression charts.
- Accessible chart summaries.

### 10: Weekly review, reminders, and export

- Adherence and conservative adjustments.
- Confirmation, revision history, and Undo.
- Local notifications.
- Redacted-by-default export.
- Complete data deletion.

### 11: Meal intelligence and travel

- Kitchen inventory and food tolerance.
- Deterministic meal planner.
- Shopping list.
- Travel mode.

### 12: HealthKit and 1.0 polish

- Optional read-only HealthKit.
- Provenance and manual override.
- Advanced photo comparison.
- Milestones, accessibility, and device verification.

### Later: Direct X3 Force sensor integration

- Keep `ForceDataProvider` independent from workout storage.
- Ship with `manualTotalForce` and clearly labeled `estimatedBandRange` providers.
- Add `x3ForceAuthorized` only after a documented vendor API, approved SDK, or supported export path is available.
- Do not reverse engineer the private Bluetooth protocol for a production health application.
- Store peak, average, time-under-tension, repetitions, calibration metadata, and provider payload ID when an authorized measured-force source becomes available.

### v2: Full web application

- Reuse the authenticated backend and sync contracts built for iOS integrations.
- Full Next.js logging and planning interface.
- Offline-capable web shell where browser constraints allow.
- Private photo upload and download when the user enables photo sync.

## Build order for the first useful release

1. Onboarding and consent.
2. Food logging, X3 manual logging, symptoms, and the Today dashboard.
3. Local trends and weekly review.
4. Minimal backend, account, and opt-in sync.
5. WHOOP connection.
6. AI coach over narrow, user-authorized summaries.

This order makes the iOS app useful without accounts or connectivity, then adds the backend only where WHOOP, AI, and cross-device synchronization require it.

## Integration references verified July 14, 2026

- [WHOOP API and available scopes](https://developer.whoop.com/api/)
- [WHOOP OAuth and offline refresh tokens](https://developer.whoop.com/docs/developing/oauth/)
- [X3 Force product and Total Force](https://www.jaquishbiomedical.com/products/x3-force-bar)
- [X3 Force app](https://www.jaquishbiomedical.com/products/x3-force-mobile-app)
- [USDA FoodData Central API guide](https://fdc.nal.usda.gov/api-guide/)
- [OpenAI model guidance](https://developers.openai.com/api/docs/models)
- [OpenAI function calling](https://developers.openai.com/api/docs/guides/function-calling)
- [OpenAI structured outputs](https://developers.openai.com/api/docs/guides/structured-outputs)
- [OpenAI API data controls](https://developers.openai.com/api/docs/guides/your-data)

## Foundation exit criteria

- Project builds with the installed stable Xcode.
- Tests run.
- Production starts without demo data.
- Daily identifiers survive timezone and daylight-saving cases.
- Historical target snapshots remain stable after target edits.
- Core models are owner-scoped and sync-ready without requiring a backend.
