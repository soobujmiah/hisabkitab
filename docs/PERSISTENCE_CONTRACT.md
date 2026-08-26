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

`LocalStore` is the application storage abstraction. `InMemoryStore` is a temporary implementation for domain/UI development and is **not** production persistence.

The next implementation replaces it with a durable on-device database, migration tests, and recovery tests before commercial release.

## Testing gates

- Save and reload after process restart
- Multiple workspace isolation
- Transaction ordering
- Duplicate ID prevention
- Migration from each supported schema version
- Interrupted write recovery
- Export/import round trip
- Large transaction history performance
