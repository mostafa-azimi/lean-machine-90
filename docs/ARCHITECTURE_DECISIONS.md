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

The backend and web interface are not part of the first offline iOS vertical slice. A minimal backend is required before WHOOP, AI, and cross-device sync. Its shape is:

- Next.js web application and authenticated API routes on Vercel.
- Marketplace Postgres provider for structured records.
- Vercel Private Blob for explicitly synchronized progress photos.
- Authentication selected before backend implementation.

No personal record is uploaded until cloud sync or a connected feature is explicitly enabled. WHOOP and AI have consents separate from general cloud sync.

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

Core MVP contains the complete daily loop, first-party food logging, X3 workout logging, photos, measurements, trends, weekly review, privacy lock, reminders, export, and deletion.

Complete 1.0 adds opt-in sync, WHOOP, a bounded AI coach, kitchen intelligence, travel mode, live read-only HealthKit, and advanced comparison/reporting polish.

The full web interface remains v2. Cal.ai is not a runtime dependency; first-party food logging replaces it, with optional migration/import tooling if a supported export is available.

## ADR-007: Provider-neutral health timeline

Status: accepted
Date: July 14, 2026

Lean Machine 90 owns a canonical health timeline. WHOOP, HealthKit, USDA FoodData Central, user input, and future integrations map into provider-neutral records with provenance.

Provider records keep:

- Provider and external record ID.
- Observed and imported timestamps.
- Original unit and normalized unit.
- Source confidence and sync status.
- Raw payload version or checksum where retention is permitted.
- Manual override relationship.

Deduplication happens before aggregation. Imported observations are not silently overwritten by a manual correction.

## ADR-008: Force provenance is mandatory

Status: accepted
Date: July 14, 2026

An ordinary X3 band does not measure force. Band resistance also changes with stretch, user geometry, exercise, and single-versus-doubled configuration. The application therefore never represents a band label or nominal range as measured force.

Each force value has one of these kinds:

- `sensorMeasured`: produced by an authorized sensor integration.
- `manualTotalForce`: copied by the user from a source such as the X3 Force app.
- `estimatedBandRange`: a clearly labeled nominal range, unsuitable for exact comparisons.

Workout progression can be tracked without measured force using band, configuration, full and partial repetitions, time under tension, RPE, and form quality.

The storage layer depends on a `ForceDataProvider` protocol. A direct X3 Force provider will only be added if a documented vendor API, approved SDK, or supported export becomes available. No public developer API was located in the vendor documentation during the July 14, 2026 review.

## ADR-009: WHOOP authentication is server-side

Status: accepted
Date: July 14, 2026

WHOOP connects through its official OAuth 2 flow. The backend stores encrypted per-user refresh tokens and rotates them according to WHOOP's documented flow. Client secrets never ship in the iOS bundle.

The integration requests only user-approved scopes and imports recovery, cycle, sleep, workout, profile, and body-measurement data as provider observations. Disconnecting WHOOP stops refresh and offers deletion of imported records.

## ADR-010: AI is an evidence-bounded coach, not a diagnostician

Status: accepted
Date: July 14, 2026

The AI coach can summarize observations, surface correlations, explain plausible possibilities, identify missing information, prepare questions for a clinician, and suggest conservative next steps. It cannot diagnose, prescribe, manage medication, or make autonomous plan changes.

The implementation uses a server-side model through narrow read tools rather than sending the full database. Inputs default to summarized structured data. Photos and free-text health notes require separate consent. Outputs conform to a schema containing:

- Observations with supporting data.
- Possible explanations labeled as possibilities.
- Confidence and data completeness.
- One next-best action.
- Clarifying questions.
- Safety state and escalation guidance.

Deterministic safety checks run before and after model inference. High-risk symptoms suppress ordinary coaching and direct the user toward appropriate professional or emergency care. Medication changes are never recommended.

Suggested plan changes are stored as proposals and require explicit user confirmation before a new immutable TargetRevision is created.

## ADR-011: AI privacy is separate and explicit

Status: accepted
Date: July 14, 2026

OpenAI API credentials stay on the backend. AI processing is independently opt-in and the user sees which categories will be sent before enabling it.

Requests use the Responses API with `store: false` where supported. This setting does not by itself mean zero retention: current OpenAI documentation states that API data is not used to train models unless the customer opts in, while default abuse-monitoring logs may retain customer content for up to 30 days. Zero Data Retention requires separate eligibility and approval, so the product will not claim it unless the production organization has it enabled.
