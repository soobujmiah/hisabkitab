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
- [ ] Launcher app name is **Songjog**; no HisabKitab identity visible.
      — aapt badging in CI verified `application-label: Songjog`; owner's on-screen visual check still pending.

### Export — user data
- [ ] Record at least one business profile and one transaction first.
      — profile created on-device via onboarding (`onboarding_save`: institution / retail); a recorded transaction not yet confirmed.
- [x] Settings → Export my data completes (progress → success snackbar).
      — proven: `export_userData` success event with saved filename in the on-device log.
- [x] File `songjog_data_<UTC>.json` exists in
  `/storage/emulated/0/Android/data/com.songjog.songjog/files/exports/`.
      — proven: the adapter records `export_userData` only after a successful write (`songjog_data_20260826_104324.json`).
- [ ] File opens/reads as valid JSON; content includes the business profile
  and the recorded transaction.
      — `songjog_data_20260826_104324.json` not yet returned by the owner.
- [ ] Share action opens the Android share sheet with the file.
      — owner confirmation pending.

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
- [ ] Force a controlled failure (e.g. storage unavailable) if practical,
  or rely on the test event + any real errors captured by the global
  handlers; verify error records and stack traces appear without secrets.
      — test-event branch satisfied; no real error occurred in this session (clean run), so the error/stack-trace path is not yet exercised on-device (covered by unit tests: collector error events + redaction).

### Android behavior
- [ ] No runtime permission prompts required for export/share
  (app-specific storage + FileProvider).
      — export completed without permission errors; owner to confirm no prompt appeared.
- [ ] Share sheet accepts the file and a target app can open it.
- [ ] App survives background/foreground and configuration change;
  exports remain available after relaunch (persistent log + file system).
- [ ] Restart the app: diagnostic export still contains `app_start` events
  from the previous session (persistent log).
      — the artifact contains exactly one `app_start`; no restart has been performed yet.

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

### Not yet proven (owner confirmation required)

- Visual: launcher name **Songjog**, and no HisabKitab identity anywhere in
  the UI (Bangla and English).
- Share sheet opens after export, and a target app can open the file.
- No permission prompt appeared during export/share.
- Restart persistence: force-stop → relaunch → a new diagnostic export must
  show two `app_start` events (this artifact has exactly one).
- Content of the user-data export (profile + any transaction):
  `songjog_data_20260826_104324.json` not yet returned.

## Result

**Status: PHYSICAL DEVICE TEST IN PROGRESS** — all automated gates are green
on commit `8e21317` (analyze, 48/48 tests, debug APK built and uploaded,
legacy-name audit). On-device validation started 2026-08-26 on the Redmi
Turbo 4 Pro: the first artifact (diagnostic export) is recorded above and
confirms installation, launch, database open, onboarding, both export paths,
and controlled test events in Bangla mode. Remaining checklist items: visual
identity check, share sheet, permission-prompt confirmation, restart
persistence, and user-data export content. The milestone closes when every
checklist box is checked with evidence.

## Branch state (as of this checkpoint)

| Branch | State |
|---|---|
| `main` | Product foundation (business profile, adaptive domain models, Songjog docs). Not merged with the MVP work yet; merging the milestone into `main` is the next release decision after physical-device validation. |
| `feature/android-owner-mvp` | Active working branch — contains everything: foundation, export/diagnostic implementation, tests, Android scaffold, CI. |
| `foundation/product-spec` | Deleted 2026-08-26 after re-verifying that all of its commits were contained in `feature/android-owner-mvp` (PR #1 had been closed without merging). |
