# Persistence Contract

## Goal

The application must be offline-first for normal owner operations. UI and domain code must not depend directly on a specific database engine.

## Required guarantees

1. Every saved business/workspace record has an explicit owner/workspace scope.
2. Transaction IDs are stable and unique.
3. Monetary values use integer minor units.
4. Writes are atomic at the transaction boundary.
5. A successful write is durable before the UI reports success.
6. Re-opening the application must recover saved records.
7. Schema changes use explicit migrations.
8. Deletes of posted financial records are prohibited; corrective records are used instead.
9. Export must produce a portable, human-readable representation plus a machine-restorable representation where supported.
10. Sensitive local data is protected by the platform's secure storage/encryption capabilities where available.

## Current implementation boundary

`LocalStore` is the application storage abstraction. `SqliteStore` (`songjog.db`, schema v2, foreign_keys ON, indexes on `transaction_lines.transaction_id`, `transactions.created_at`, `transactions.customer_id`) is the durable production implementation, verified by `sqlite_store_test.dart` via sqflite_common_ffi and re-verified at `9e25997` via CI `33006998608` (92/92). `InMemoryStore` is retained as in-memory fallback when SQLite open fails (with diagnostic `database_open` error record) and as test fake without real I/O. Completed sales have no delete method — immutable per policy.

Transaction persistence for business profile + multi-line transactions + payment/due + returnable (clamped paid, returnable = entered - total) has been verified at the domain level (`sale_service_test.dart` persistence incl overpayment clamp + returnable + failure recording) and via widget flows (`sale_entry_screen_test.dart` save → loadTransactions, returnable UI). Completed sales are immutable — no delete API in `LocalStore`/`BusinessRepository`, `saveTransaction` uses replace only for same ID (correction via new ID, not hard-delete), consistent with data-model policy (void/reversal future). Full guarantees (workspace isolation, migration, interrupted write recovery, export/import round trip, large history) remain to be explicitly tested.

## Testing gates — current status at `9e25997`, CI `33006998608` (92/92)

- Save and reload after process restart — VERIFIED historically via device artifacts (persistent JSONL log survived force-stop → restart, all session-1 events survived, transactions survived) + unit tests via store reopen + device Record 3 (2 app_start + 4 sales survived restart)
- Multiple workspace isolation — FUTURE (single profile currently)
- Transaction ordering — VERIFIED via `loadTransactions` ordered `created_at DESC`
- Duplicate ID prevention — VERIFIED via `removeWhere` + replace + `saveTransaction` validation at least one line
- Migration from each supported schema version — UNVERIFIED (v1→v2 path exists, no upgrade test)
- Interrupted write recovery — UNVERIFIED
- Export/import round trip — PARTIAL (export verified, import not)
- Large transaction history performance — UNVERIFIED
