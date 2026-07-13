# Architecture decisions

## ADR-001: iOS-first, web-capable product

Status: accepted
Date: July 13, 2026

The first shipping client is a native SwiftUI iPhone application. Full web logging and planning parity is a v2 goal. The web client will use Next.js and Vercel but will not share interface code with SwiftUI.

The clients will eventually share:

- Canonical identifiers.
- JSON API contracts.
- Validation rules.
- Plan and target revision semantics.
- Sync and conflict behavior.

HealthKit access and guided native camera behavior remain iOS-specific.

## ADR-002: Local-first with opt-in cloud sync

Status: accepted

All iOS writes commit locally first. Cloud availability must never block logging.

Sync triggers will be:

- Debounced after local changes.
- App launch and foreground.
- User-initiated refresh.
- Opportunistic background processing scheduled with Apple APIs.

iOS does not guarantee exact periodic background execution. The protocol must therefore be idempotent and safe after long gaps.

Each syncable record includes:

- Globally unique record ID.
- Owner ID.
- Created and updated timestamps.
- Optional server revision.
- Last-synced timestamp.
- Local sync state.
- Tombstone timestamp for synchronized deletion.

A persistent SyncOperation outbox records pending creates, updates, and deletions. The server will accept idempotency keys and use revision checks to detect conflicts.

## ADR-003: Multi-user-ready, personal launch

Status: accepted

The first release is personal, but no record is globally anonymous. Local installation ownership exists from schema version 1 and can later be attached to an authenticated server account.

The backend and web client are not part of the first iOS vertical slice. When added, the likely shape is:

- Next.js web application and authenticated API routes on Vercel.
- Marketplace Postgres provider for structured records.
- Vercel Private Blob for explicitly synchronized progress photos.
- Authentication selected before backend implementation.

No cloud resource is provisioned until cloud sync is implemented and explicitly enabled.

## ADR-004: Stable local calendar days

Status: accepted

A timestamp alone cannot safely represent a user-facing day across daylight-saving changes and travel.

Daily entities store:

- A stable YYYY-MM-DD day key.
- The timezone identifier used to create that key.
- A normalized date for sorting.
- An owner-scoped unique record key.

An existing record keeps its original day identity. A new record uses the current local day unless the user explicitly selects a different date.

## ADR-005: Immutable target history

Status: accepted

Goal targets are never overwritten historically. Every change creates a TargetRevision with an effective day and reason. DayPlan snapshots preserve the targets that were active on that day.

Undo creates a new revision; it does not erase history.

## ADR-006: Core MVP versus complete 1.0

Status: accepted

Core MVP contains the complete daily loop, workouts, manual nutrition, photos, measurements, trends, weekly review, privacy lock, reminders, export, and deletion.

Complete 1.0 adds kitchen intelligence, travel mode, live read-only HealthKit, and advanced comparison/reporting polish.

Whoop OAuth, Cal.ai automation, cloud accounts, and the web interface remain later work.
