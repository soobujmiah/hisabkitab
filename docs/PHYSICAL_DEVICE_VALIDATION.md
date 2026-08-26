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
| Checkpoint commit | `3560726` |
| CI workflow | `Flutter CI` — run [32957912379](https://github.com/soobujmiah/songjog/actions/runs/32957912379) |
| Pinned toolchain | Flutter 3.47.1 (Dart 3.13.1), Java 21, AGP 9.1.0, Gradle 9.3.1 |
| Analyze | clean (no issues) — CI job `Analyze + unit/widget tests`: success |
| Tests | 48/48 passed (unit + widget; SQLite exercised via sqflite_common_ffi) — CI job: success |
| APK | `flutter build apk --debug` → `app-debug.apk` (156 MB debug) uploaded as artifact `songjog-debug-apk` |
| APK badging (aapt) | `package: com.songjog.songjog` `versionName=0.1.0` `versionCode=1` `minSdk=24` `targetSdk=36` `application-label: Songjog` |
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
- [ ] APK installs successfully (debug artifact from the CI run).
- [ ] App launches.
- [ ] Launcher app name is **Songjog**; no HisabKitab identity visible.

### Export — user data
- [ ] Record at least one business profile and one transaction first.
- [ ] Settings → Export my data completes (progress → success snackbar).
- [ ] File `songjog_data_<UTC>.json` exists in
  `/storage/emulated/0/Android/data/com.songjog.songjog/files/exports/`.
- [ ] File opens/reads as valid JSON; content includes the business profile
  and the recorded transaction.
- [ ] Share action opens the Android share sheet with the file.

### Export — diagnostics
- [ ] Settings → Export diagnostics completes.
- [ ] File `songjog_diagnostics_<UTC>.json` exists and is valid JSON.
- [ ] Contains app version `0.1.0`, build `1`, platform `android`,
  device model (Redmi / 25053RT47C), OS version (SDK 36), runtime mode
  `debug`, and recorded events (app_start, database_open, package_info).
- [ ] No passwords, tokens, API keys, or private credentials in the file.

### Diagnostic usefulness (controlled event)
- [ ] Debug-only *Record a test diagnostic event* writes an event that
  appears in the next diagnostic export.
- [ ] Force a controlled failure (e.g. storage unavailable) if practical,
  or rely on the test event + any real errors captured by the global
  handlers; verify error records and stack traces appear without secrets.

### Android behavior
- [ ] No runtime permission prompts required for export/share
  (app-specific storage + FileProvider).
- [ ] Share sheet accepts the file and a target app can open it.
- [ ] App survives background/foreground and configuration change;
  exports remain available after relaunch (persistent log + file system).
- [ ] Restart the app: diagnostic export still contains `app_start` events
  from the previous session (persistent log).

## Result

**Status: PENDING PHYSICAL DEVICE TEST** — automated gates are green on
commit `3560726`; the device checklist above must be executed by the owner
on the Redmi Turbo 4 Pro before the milestone is closed.

## Branch state (as of this checkpoint)

| Branch | State |
|---|---|
| `main` | Product foundation (business profile, adaptive domain models, Songjog docs). Not merged with the MVP work yet; merging the milestone into `main` is the next release decision after physical-device validation. |
| `feature/android-owner-mvp` | Active working branch — contains everything: foundation, export/diagnostic implementation, tests, Android scaffold, CI. |
| `foundation/product-spec` | Obsolete duplicate — all of its commits are contained in `feature/android-owner-mvp` (verified by merge-base); PR #1 was closed without merging. Scheduled for deletion after this milestone is confirmed. |
