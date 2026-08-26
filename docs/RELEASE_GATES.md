# Release Gates

A feature is not release-ready because its documentation exists. It must pass the applicable implementation, test and product gates.

## Gate 1 — Foundation

- [x] Local durable database implemented — `SqliteStore` (schema v2), verified by `sqlite_store_test.dart` via sqflite_common_ffi (2026-08-26)
- [ ] Business/workspace scoping enforced
- [ ] Migration strategy tested (v1→v2 upgrade path exists in code; no upgrade test yet)
- [x] Offline transaction persistence tested — profile + multi-line transactions persist across store reopen (2026-08-26)

## Gate 2 — Owner onboarding

- [ ] Google/email authentication implemented
- [ ] Owner profile/business creation implemented
- [ ] Business type selection implemented
- [ ] Minimal mandatory fields verified
- [ ] Optional fields remain optional

## Gate 3 — Daily operations

- [ ] Product/service creation
- [ ] Fast sale
- [ ] Multi-line transaction
- [ ] Payment / partial payment / due
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
- [ ] Export

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

- [ ] Unit tests
- [ ] Domain tests
- [ ] Persistence tests
- [ ] Integration tests
- [ ] Real-device tests
- [ ] Regression test
- [ ] Release build reproducibility

Only verified gates may be reported as complete.
