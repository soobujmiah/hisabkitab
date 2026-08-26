# Export & Diagnostics Release Gates

## User data export — mandatory

Songjog must provide an explicit export/backup path for the user's own data.

Required capabilities:

- Export financial records and transaction history.
- Export applicable customer, student, guardian, patient, staff, or service records according to the active workspace type.
- Export receipts and reports.
- Provide CSV-compatible structured export for tabular data.
- Provide PDF/printable document export where applicable.
- Provide complete backup and restore/import.
- Support scoped exports by date, person, transaction type, or relevant workspace filters.
- Keep export available after trial/subscription expiry so the user can retrieve their own data.

## Developer diagnostic export — mandatory

A separate diagnostic export must exist for troubleshooting APK issues.

It may include:

- App version and build number.
- Android version and device model/architecture.
- Crash and exception records captured locally.
- Application error and warning logs.
- Recent failed operations.
- Database and migration status.
- Network/sync diagnostics.
- Non-secret licensing/trial diagnostic state.
- Session and timestamp information.
- A user-entered problem description.

Diagnostics must not export passwords, authentication tokens, API keys, private signing material, or user financial/personal records unless the user explicitly chooses a separate support-data export flow.

## Release validation

The release gate is not satisfied by compiling an APK alone. The APK must be installed and tested through the relevant end-to-end paths, including data creation, receipt generation, user data export, restore/import, diagnostic export, and trial/licensing behavior.
