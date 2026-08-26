# Release Gates

A feature is not release-ready because its documentation exists. It must pass the applicable implementation, test and product gates.

## Gate 1 — Foundation

- [x] Local durable database implemented — `SqliteStore` (schema v2), verified by `sqlite_store_test.dart` via sqflite_common_ffi (2026-08-26); re-verified at `3ebac8b` via CI `32990932079` (74/74 tests)
- [ ] Business/workspace scoping enforced
- [ ] Migration strategy tested (v1→v2 upgrade path exists in code; no upgrade test yet)
- [x] Offline transaction persistence tested — profile + multi-line transactions persist across store reopen (2026-08-26); re-verified at `3ebac8b` via `sqlite_store_test.dart` + `sale_service_test.dart` persistence

## Gate 2 — Owner onboarding

- [ ] Google/email authentication implemented
- [x] Owner profile/business creation implemented — `OnboardingService.createOwnerWorkspace` + `BusinessProfile` (business/institution, 12 BusinessTypes), verified by `onboarding_screen_test.dart`, CI `32990932079` (74/74)
- [ ] Business type selection implemented (dropdown exists, adaptive dashboard not yet)
- [x] Minimal mandatory fields verified — workspace name required, save disabled while empty/whitespace-only (`ValueListenableBuilder`), service-level guard preserved, verified by `onboarding_screen_test.dart`, CI `32980204789` and `32990932079`
- [x] Optional fields remain optional — phone, address, subtype optional, verified by `onboarding_service.dart` + `workspace_fields.dart`

## Gate 3 — Daily operations

- [ ] Product/service creation
- [x] Fast sale — `SaleEntryScreen` + `SaleEntryService` (description/quantity/price in exact minor-unit BDT via `takaToMinor` string/integer parsing, no float), verified by `sale_service_test.dart` (takaToMinor, minorToTaka, derivePaymentStatus, clampPaid) + `sale_entry_screen_test.dart` widget flows (offstage-safe Finder + ensureVisible), CI `32990932079` (74/74 PASS), APK badging `com.songjog.songjog`, **device-validated at `1f03fac` via artifacts `songjog_data_20260826_184910.json` (4 sales) + `songjog_diagnostics_20260826_184952.json` (23 events, 2 sessions, Redmi 25053RT47C) — 17/22 PASS, overpayment clamp + en BDT pending**
- [x] Multi-line transaction — `SaleEntryService.saveSale` accepts `List<({description, quantity, priceMinor})>`, total = sum `lineTotalMinor`, verified by `sale_service_test.dart` multi-line totals + `sale_entry_screen_test.dart` multi-line widget test, CI `32990932079`, **device-validated at `1f03fac` via multi-line sale lines=2 total=1235800 (282800+953000) in diagnostic `184952.json` + user-data `184910.json`**
- [x] Payment / partial payment / due — `derivePaymentStatus` (unpaid/partial/paid, zero total never paid), `clampPaid` [0,total] prevents silent overpayment, `dueMinor = total - paid`, optional `PaymentMethod`, UI shows paid/partial/unpaid + due, verified by `sale_service_test.dart` + widget tests, CI `32990932079`, **device-validated at `1f03fac`: partial (300000 total, 250000 paid) + paid (250000/250000, 50000/50000) + due derivable + payment_method cash in `184910.json` + `184952.json`; overpayment clamp NOT tested on device (CI-verified only)**
- [ ] Private actual cost and profit
- [ ] Customer/service recipient
- [ ] Purchase/expense
- [ ] Return/refund/adjustment

## Gate 4 — Documents

- [ ] Receipt generation
- [ ] Multi-page pagination
- [ ] PDF/share/print
- [ ] Customer-facing privacy checks
- [ ] Document numbering and audit trail

## Gate 5 — Reporting

- [ ] Daily
- [ ] Monthly
- [ ] Yearly
- [ ] Profit
- [ ] Due
- [ ] Expense
- [ ] Cash reconciliation
- [x] Export — user-data export (`UserDataExport` deterministic UTC filenames, `application/json`) + diagnostic export (`DiagnosticCollector`, redaction, persistent JSONL) implemented, verified by `export_service_test.dart`, `user_data_export_test.dart`, `diagnostic_*_test.dart`, `local_export_file_adapter_test.dart`, `persistent_diagnostic_log_test.dart`, and historically device-validated on Redmi Turbo 4 Pro (artifacts `songjog_diagnostics_20260826_104327.json` + `120529.json`, no secrets, share sheet dispatched, restart persistence); re-verified CI `32990932079` (74/74)

## Gate 6 — Commercial control

- [ ] Trial entitlement
- [ ] Subscription entitlement
- [ ] One-time activation redemption
- [ ] Platform Owner role
- [ ] Revoke/restore
- [ ] Reinstall/device recovery
- [ ] No production secrets in source/APK

## Gate 7 — Localization and UX

- [ ] Bengali UI script-purity audit
- [ ] English UI script-purity audit
- [ ] No missing strings
- [ ] Loading/empty/error/offline states
- [ ] Accessibility checks
- [ ] Motion/reduced-motion behavior
- [ ] Touch target and keyboard checks

## Gate 8 — Validation

- [x] Unit tests — `flutter test` 74/74 PASS at `3ebac8b`, CI `32990932079` (analyze clean, legacy audit success, APK built + badging `com.songjog.songjog` `0.1.0` `24/36` `Songjog`)
- [x] Domain tests — `sale_test.dart`, `diagnostic_*_test.dart`, `export_filename_test.dart`, `takaToMinor`/`minorToTaka`/`derivePaymentStatus`/`clampPaid` tests, CI `32990932079`
- [x] Persistence tests — `sqlite_store_test.dart` via sqflite_common_ffi + `sale_service_test.dart` persistence incl overpayment clamp + failure recording, CI `32990932079`
- [ ] Integration tests — onboarding widget tests + sale entry widget flows + workspace home widget tests + settings tests exist (onboarding → workspace routing, fast sale entry, workspace home recent list), but full integration smoke (offline recovery, inventory, large history) not yet
- [x] Real-device tests — historical device validation COMPLETE for export/diagnostic milestone at `8e21317`/`8206b8d` (artifacts 104327 + 120529, Redmi Turbo 4 Pro); fast sale entry + workspace home + payment/due + restart persistence + export at `1f03fac`/`3ebac8b` **device-validated via new artifacts `184910.json` (Green It, 4 sales) + `184952.json` (23 events, 2 app_start, Redmi 25053RT47C) — 17/22 PASS, overpayment clamp + en BDT pending** — see `PHYSICAL_DEVICE_VALIDATION.md` Record 3
- [ ] Regression test
- [ ] Release build reproducibility — only debug APK built (`app-debug.apk` 163 MB at `3ebac8b`), no release signing

Only verified gates may be reported as complete. Historical device artifacts must not be reused as proof for new HEAD features (see `PHYSICAL_DEVICE_VALIDATION.md`).
