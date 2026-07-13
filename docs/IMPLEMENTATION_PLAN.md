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
- Manual Whoop and Cal.ai entry initially.
- iOS 17 minimum.

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

### 3: Today and daily check-ins

- Morning, nutrition totals, activity/recovery, and evening forms.
- Partial saves.
- Quick logging.
- Deterministic next action.
- Safety suppression.

### 4: Nutrition and workouts

- Meals and templates.
- X3 templates, sessions, exercise logs, history, and personal records.
- Cardio, walking, mobility, sauna, and cold plunge.

### 5: Photos and app privacy

- Protected PhotoStore.
- Import and guided capture.
- Thumbnails, calendar, deletion, and comparison.
- Device-owner app lock and inactive-scene privacy cover.

### 6: Measurements and progress

- Body measurements.
- Weight and waist trends.
- Nutrition, movement, recovery, symptoms, and training charts.
- Accessible chart summaries.

### 7: Weekly review, reminders, and export

- Adherence and conservative adjustments.
- Confirmation, revision history, and Undo.
- Local notifications.
- Redacted-by-default export.
- Complete data deletion.

### 8: Meal intelligence and travel

- Kitchen inventory and food tolerance.
- Deterministic meal planner.
- Shopping list.
- Travel mode.

### 9: HealthKit and 1.0 polish

- Optional read-only HealthKit.
- Provenance and manual override.
- Advanced photo comparison.
- Milestones, accessibility, and device verification.

### v2: Web and cloud

- Authenticated backend.
- Opt-in iOS sync.
- Postgres schema and idempotent sync endpoints.
- Private photo upload and download.
- Full Next.js logging and planning interface.
- Offline-capable web shell where browser constraints allow.

## Foundation exit criteria

- Project builds with the installed stable Xcode.
- Tests run.
- Production starts without demo data.
- Daily identifiers survive timezone and daylight-saving cases.
- Historical target snapshots remain stable after target edits.
- Core models are owner-scoped and sync-ready without requiring a backend.
