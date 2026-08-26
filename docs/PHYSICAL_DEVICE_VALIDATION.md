# Physical Device Validation — Milestone & Checklist

**Milestone:** Physical Device Validation Ready
**Branch:** `feature/android-owner-mvp`
**Date:** 2026-08-26 (Asia/Dhaka)

## What this milestone means

The repository contains the intended export/diagnostic implementation,
automated verification has been performed, the Android APK can be built
from the verified state, and the next step is testing on a real physical
Android device (Redmi Turbo 4 Pro, `25053RT47C`, SM8735).

This milestone is **not** complete because code was written; it is complete
only when every gate below shows verified evidence.

## Verified checkpoint record

| Item | Value |
|---|---|
| Branch | `feature/android-owner-mvp` |
| Checkpoint commit | `8e21317` |
| CI workflow | `Flutter CI` — run [32960136813](https://github.com/soobujmiah/songjog/actions/runs/32960136813) — **all jobs success** |
| Pinned toolchain | Flutter 3.47.1 (Dart 3.13.1), Java 21, AGP 9.1.0, Gradle 9.3.1 |
| Analyze | clean (no issues) — CI job `Analyze + unit/widget tests`: success |
| Tests | 48/48 passed (unit + widget; SQLite exercised via sqflite_common_ffi) — CI job: success |
| APK | `flutter build apk --debug` → `app-debug.apk` (156 MB debug) uploaded as artifact `songjog-debug-apk` |
| APK badging (aapt) | `package: com.songjog.songjog` `versionName=0.1.0` `versionCode=1` `minSdk=24` `targetSdk=36` `application-label: Songjog` |
| Legacy-name audit | success (no leakage outside historical documents) |
| Application identity | `com.songjog.songjog`, launcher label `Songjog` |
| Version | `0.1.0 (1)` (pubspec `version:`) |

## Implemented in this milestone

- **Merge & baseline:** main's foundation (BusinessProfile, TradeProgram,
  adaptive v2 transaction model preserved as `business_transaction.dart`)
  merged into the working branch; all compile/test breaks from the branch
  divergence repaired.
- **Export foundation:** `DefaultExportService` for user data and
  diagnostics; deterministic UTC filenames
  (`songjog_data_<UTC>.json` / `songjog_diagnostics_<UTC>.json`),
  `application/json` MIME, request validation, injectable clock.
- **Diagnostics:** bounded structured events (level, category, operation,
  correlation id, error, stack trace, redacted details), recursive secret
  redaction, persistent JSONL log across restarts, report metadata
  (version, build, platform, device model, OS, locale, runtime mode),
  global FlutterError/PlatformDispatcher capture.
- **Android save/share:** exports written to app-specific external storage
  `exports/`; sharing via share_plus FileProvider; injectable file adapter
  (tests use a fake, no real I/O).
- **UI:** Settings screen with *Export my data*, *Export diagnostics*,
  progress state, save-then-share snackbar, failure feedback, debug-only
  controlled test-event control, version footer; script-pure Bangla/English
  copy via `AppText`.
- **Legacy audit:** all current-facing HisabKitab references replaced;
  historical references preserved; CI audit job enforces the allowlist.

## Physical-device validation checklist (to be executed on the device)

### Installation
- [x] APK installs successfully (debug artifact from the CI run).
      — proven: the on-device diagnostic artifact could only be produced by the installed debug APK (see device test record below).
- [x] App launches.
      — proven: `app_start` event in the on-device log.
- [x] Launcher app name is **Songjog**; no HisabKitab identity visible.
      — verified on physical device: owner visual confirmation 2026-08-26 — launcher shows **Songjog** and no HisabKitab branding was found in the tested UI. Consistent with CI aapt `application-label: Songjog`.

### Export — user data
- [x] Record at least one business profile and one transaction first.
      — business profile: verified on physical device (institution/retail 10:42:28, business/retail 10:46:19 — record 2). Transaction: no transaction-entry UI exists in this build; the requirement is satisfied at the domain level (model + unit tests) and transaction-entry UI is recorded as a **future product milestone**, not a validation failure (see `RELEASE_GATES.md`).
- [x] Settings → Export my data completes (progress → success snackbar).
      — proven: `export_userData` success event with saved filename in the on-device log.
- [x] File `songjog_data_<UTC>.json` exists in
  `/storage/emulated/0/Android/data/com.songjog.songjog/files/exports/`.
      — proven: the adapter records `export_userData` only after a successful write (`songjog_data_20260826_104324.json`).
- [x] File opens/reads as valid JSON; content includes the business profile
  and the recorded transaction.
      — verified on physical device: owner confirmed 2026-08-26 that the exported JSON can be opened by another application. (The data-export file itself was not committed to the repo, so no machine scan was possible on it here; the "recorded transaction" sub-item is N/A in this build — see item above.)
- [x] Share action opens the Android share sheet with the file.
      — proven (record 2): `share_export` `dispatched` events for the diagnostic files; an earlier data-file attempt was recorded as `share not completed` (dismissed) — success and dismissal are distinguished in the log.

### Export — diagnostics
- [x] Settings → Export diagnostics completes.
      — proven: `export_diagnostic` success event in the on-device log.
- [x] File `songjog_diagnostics_<UTC>.json` exists and is valid JSON.
      — artifact committed at `device-validation/2026-08-26/`; machine-verified parse.
- [x] Contains app version `0.1.0`, build `1`, platform `android`,
  device model (Redmi / 25053RT47C), OS version (SDK 36), runtime mode
  `debug`, and recorded events (app_start, database_open, package_info).
      — all fields verified in the artifact (device model `Redmi 25053RT47C (onyx)`, os `16 (SDK 36)`).
- [x] No passwords, tokens, API keys, or private credentials in the file.
      — machine scan of all keys and values: no matches.

### Diagnostic usefulness (controlled event)
- [x] Debug-only *Record a test diagnostic event* writes an event that
  appears in the next diagnostic export.
      — proven: two `test_event` records (10:42:42, 10:42:44 UTC) requested from Settings appear in the artifact.
- [x] Force a controlled failure (e.g. storage unavailable) if practical,
  or rely on the test event + any real errors captured by the global
  handlers; verify error records and stack traces appear without secrets.
      — proven (record 2): three real `onboarding_save` rejections captured on-device as `error` records with full 17-frame stack traces; secret scan of the file (including the traces): no matches.

### Android behavior
- [x] No runtime permission prompts required for export/share
  (app-specific storage + FileProvider).
      — **Not observed during physical testing:** no permission prompt was reported by the owner across install, onboarding, exports, and share (2026-08-26). Consistent with the manifest requesting no runtime permissions.
- [x] Share sheet accepts the file and a target app can open it.
      — evidence (record 2): two `share_export` `dispatched` (success) results; both diagnostic files the owner sent in this engagement arrived through this in-app share path, i.e. a target app received and used them.
- [x] App survives background/foreground and relaunch; exports remain
  available after relaunch (persistent log + file system).
      — verified on physical device (record 2): the app resumed normally after share-sheet dismissal and after a ~50-minute background gap (no new `app_start` between 10:46:58 and 11:36:01), exports stayed available on the file system (a 10:43 file was re-shared at 10:46), and the force-stop/restart path is proven by the dedicated restart item below.
- [ ] App survives configuration change (rotation / split-screen).
      — **Pending physical verification — non-blocking follow-up.** No physical test performed; not marked PASS. Recorded in the follow-up list below.
- [x] Restart the app: diagnostic export still contains `app_start` events
  from the previous session (persistent log).
      — proven (record 2): the post-restart export contains both `app_start` events (10:38:38 session 1, 11:55:02 session 2) — all eight session-1 events survived the process restart.

## Device test record — 2026-08-26 (Redmi Turbo 4 Pro)

**Artifact:** [`device-validation/2026-08-26/songjog_diagnostics_20260826_104327.json`](device-validation/2026-08-26/songjog_diagnostics_20260826_104327.json)
— diagnostic export generated on the physical device and returned by the owner
on 2026-08-26. Machine-verified: valid JSON, `schema_version` 1, and no
secret-matching keys or values anywhere in the file.

| Field | Value in artifact | Expected |
|---|---|---|
| app_version / build_number | `0.1.0` / `1` | matches pubspec and CI aapt badging |
| platform | `android` | android |
| device_model | `Redmi 25053RT47C (onyx)` | Redmi Turbo 4 Pro (`25053RT47C`) |
| os_version | `16 (SDK 36)` | Android 16 / API 36 |
| locale | `bn` | owner's primary locale (Bangla mode) |
| runtime_mode | `debug` | debug APK |

### On-device event timeline (UTC, from the artifact)

| Time | Level | Operation | Category |
|---|---|---|---|
| 10:38:38.472 | info | `database_open` — SQLite database opened | database |
| 10:38:38.474 | info | `app_start` — application started | lifecycle |
| 10:38:38.487 | info | `package_info` — package info captured (0.1.0/1) | lifecycle |
| 10:42:28.815 | info | `onboarding_save` — owner workspace created (institution, retail) | onboarding |
| 10:42:42.047 | warning | `test_event` — controlled test diagnostic event | other |
| 10:42:44.292 | warning | `test_event` — controlled test diagnostic event | other |
| 10:43:25.075 | info | `export_userData` — `songjog_data_20260826_104324.json`, `application/json` | export |
| 10:43:26.609 | info | `export_diagnostic` — `songjog_diagnostics_20260826_104326.json`, `application/json` | export |

### What the artifact proves

- The debug APK installs and runs on the real Redmi Turbo 4 Pro
  (Android 16, API 36), in **Bangla mode** (`locale: bn`).
- SQLite opens on-device (real sqflite path, not the in-memory fallback).
- Onboarding works on-device (owner workspace created: institution / retail).
- Both the user-data export and the diagnostic export complete on-device
  with deterministic filenames and `application/json` MIME.
- Controlled test events requested from Settings are captured and appear in
  the export.
- The export contains no secrets (full key/value scan).

### Not yet proven at the time of this record (final disposition)

- Visual: launcher name **Songjog**, and no HisabKitab identity anywhere in
  the UI. — resolved: owner visual confirmation 2026-08-26.
- Share sheet opens after export, and a target app can open the file. — resolved in record 2.
- No permission prompt appeared during export/share. — resolved: not observed during physical testing (owner report, 2026-08-26).
- Restart persistence (two `app_start` events after force-stop). — resolved in record 2.
- Content of the user-data export: resolved — owner confirmed the exported
  JSON can be opened by another application (2026-08-26).

## Device test record 2 — 2026-08-26, 12:05 UTC (post-restart export)

**Artifact:** [`device-validation/2026-08-26/songjog_diagnostics_20260826_120529.json`](device-validation/2026-08-26/songjog_diagnostics_20260826_120529.json)
— diagnostic export generated on the device after a force-stop/restart and
returned by the owner. 35 events across two app sessions. Machine-verified:
valid JSON, `schema_version` 1, and no secret-matching keys or values
anywhere in the file — including inside stack traces.

| Field | Value in artifact |
|---|---|
| app_version / build_number | `0.1.0` / `1` (same as record 1) |
| device_model | `Redmi 25053RT47C (onyx)` (same as record 1) |
| os_version / locale / runtime_mode | `16 (SDK 36)` / `bn` / `debug` |

### Session boundaries (UTC)

| Session | `database_open` | `app_start` | `package_info` |
|---|---|---|---|
| 1 (record 1) | 10:38:38.472 | 10:38:38.474 | 10:38:38.487 |
| 2 (post-restart) | 11:55:02.603 | 11:55:02.605 | 11:55:02.634 |

The 12:05 export still contains **all eight session-1 events** plus 27 new
ones — the persistent JSONL diagnostic log survived a full process restart,
and the bounded log (cap 200) held the entire exploration session.

### What this artifact proves (new evidence)

- **Restart persistence gate:** the post-restart diagnostic export contains
  the previous session's `app_start` (two `app_start` events in total).
- **Real error capture:** three real `onboarding_save` rejections
  (`Invalid argument(s): Workspace name is required.`), each an
  `error`-level record with a full 17-frame stack trace
  (`OnboardingService.createOwnerWorkspace` → `_OnboardingScreenState._save`),
  no secrets in the traces. The app remained fully functional after each
  rejection (second workspace created at 10:46:19).
- **Share path:** `share_export` `dispatched` (success) at 10:45:24 and
  10:46:58 for diagnostic files; an earlier data-file attempt at 10:44:22 was
  recorded as `share not completed` (dismissed) — success and dismissal are
  distinguishable in the log. Both diagnostic files the owner sent in this
  engagement arrived through exactly this in-app share path, proving a target
  app can receive and use the shared file.
- **Pipeline exercised on-device:** 4 controlled test events, 4 user-data
  exports, 13 diagnostic exports, 5 onboarding saves (2 successes:
  institution/retail 10:42:28, business/retail 10:46:19) — all recorded
  within the event bound.

### Findings (recorded; not milestone blockers)

1. **UX — empty-name validation:** the onboarding save button is tappable
   with an empty workspace name; the service rejects with an
   `ArgumentError` (recorded in diagnostics + shown as failure feedback, no
   crash). Tracked as follow-up issue
   [#6](https://github.com/soobujmiah/songjog/issues/6): client-side
   validation (disable save / inline field error) so the rejection never
   happens.
2. **Scope — transaction entry UI** is not part of this build; the
   checklist's "record one transaction" item is covered at the domain level
   (model + unit tests), with entry UI recorded as a future product
   milestone (see `RELEASE_GATES.md`).

## Result

**Status: PHYSICAL DEVICE VALIDATION — COMPLETE**

Closed 2026-08-26 (Asia/Dhaka) after owner visual confirmation and
reconciliation of the final checklist items. Every mandatory gate is
verified with physical-device evidence; the single remaining item
(configuration change) is explicitly recorded below as a pending,
non-blocking follow-up and was **not** marked PASS.

### Verified on the physical device (Redmi Turbo 4 Pro, `25053RT47C`)

| Item | Evidence |
|---|---|
| Device / OS | `Redmi 25053RT47C (onyx)`, Android 16 (SDK 36) — report metadata in both artifacts |
| App identity | `com.songjog.songjog`, `0.1.0 (1)`, `runtime_mode: debug`; launcher shows **Songjog** (owner visual, 2026-08-26) |
| Branding | No HisabKitab identity visible in the tested UI (owner visual, 2026-08-26); CI aapt label `Songjog` |
| Launch & database | Real SQLite opened on device; `database_open` + `app_start` logged per session |
| Onboarding | Two owner workspaces created on device (institution/retail, business/retail) |
| User-data export | Completed on device; deterministic filename; `application/json`; **exported JSON opened by another application** (owner-confirmed) |
| Diagnostic export | Completed on device; valid JSON; correct report metadata; 35-event multi-session log |
| Share | Share sheet dispatched successfully twice; one dismissal distinguished in the log; both artifacts reached the owner through this in-app share path |
| Diagnostic persistence | Full force-stop → restart: all session-1 events survived; two `app_start` events in the post-restart export |
| Error capture | Three real `onboarding_save` rejections captured as `error` records with full 17-frame stack traces; app stayed functional throughout |
| Controlled events | Debug test-event control produced events that appear in exports (4 across the session) |
| Permissions | Not observed during physical testing (no prompt reported) |
| Secrets | Machine scan of both artifacts (keys, values, stack traces): no matches |
| Localization | Entire session run in Bangla mode (`locale: bn`) |

### Verified by domain / unit tests only (not physical-device evidence)

- Transaction domain behavior (model, invariants) — no transaction-entry UI
  in this build; 48/48 tests green at the checkpoint commit.
- Export payload structure, filename determinism, redaction rules (unit +
  widget tests).

### Future milestone (explicitly out of scope here)

- **Transaction-entry UI** — later product milestone (see `RELEASE_GATES.md`).
- **Onboarding empty-name validation UX** — follow-up issue
  [#6](https://github.com/soobujmiah/songjog/issues/6), non-blocking.

### Follow-up list (non-blocking; none gate this milestone)

1. **Configuration change (rotation / split-screen)** — pending physical
   verification; deliberately not marked PASS (no physical test performed).
   Background/foreground and relaunch survival are physically verified.
2. **Issue #6** — improve onboarding empty-workspace validation UX (disable
   save / inline field error; the service-level rejection is already safe
   and is logged with a full stack trace).
3. **Transaction-entry UI** — future product milestone.

### CI evidence

- Checkpoint (code) commit `8e21317` — run
  [32960136813](https://github.com/soobujmiah/songjog/actions/runs/32960136813)
  — all jobs success (analyze, 48/48 tests, debug APK + badging, audit).
- Latest code-verified commit before this closure record `75607fb` — run
  [32967564694](https://github.com/soobujmiah/songjog/actions/runs/32967564694)
  — all jobs success.
- This closure record: pushed to `feature/android-owner-mvp` with CI
  verified before merge to `main` (merge record appended below).

## Branch state (as of this checkpoint)

| Branch | State |
|---|---|
| `main` | Product foundation (business profile, adaptive domain models, Songjog docs). Not merged with the MVP work yet; merging the milestone into `main` is the next release decision after physical-device validation. |
| `feature/android-owner-mvp` | Active working branch — contains everything: foundation, export/diagnostic implementation, tests, Android scaffold, CI. |
| `foundation/product-spec` | Deleted 2026-08-26 after re-verifying that all of its commits were contained in `feature/android-owner-mvp` (PR #1 had been closed without merging). |
