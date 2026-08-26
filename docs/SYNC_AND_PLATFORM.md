# Sync, Identity & Multi-Platform Strategy

**Status:** Product requirement / architecture contract
**Initial target:** Android-first Owner Edition

## Product principle

Songjog is mobile-first, not mobile-only. A business owner must be able to begin on Android and later continue from a computer without creating a second business ledger.

## Identity

The account layer should support:

- email/password where appropriate
- Google sign-in
- future additional identity providers through a provider-neutral authentication boundary
- secure session management
- account recovery

A user identity is distinct from a business. One user may eventually own or belong to multiple businesses.

## Business data ownership

Business records belong to a Business entity, not directly to a device. Devices are clients of the same business data.

This enables:

- Android phone → computer continuation
- phone replacement without losing cloud-backed business records
- multiple devices later
- future staff access without redesigning ownership

## Offline-first

The Android application should remain useful when connectivity is poor or temporarily unavailable for ordinary local operations.

Transactions created offline must receive a local stable identity and synchronization metadata. When connectivity returns, the sync engine reconciles them with the authoritative cloud record without silently duplicating or losing transactions.

Financial records must be idempotently synchronized. A retry must not create a second sale/payment merely because the network request was repeated.

## Cloud synchronization

Cloud backup/sync is part of the product foundation because cross-device continuity is a core requirement. It is not merely an optional export feature.

The initial commercial release should keep the synchronization implementation as small and reliable as possible: business-scoped records, deterministic conflict rules, audit metadata, retries, and clear sync status.

## Computer access

The first target remains Android. Computer use should be supported through a responsive web application/PWA or equivalent browser-based client using the same backend/domain contracts.

The desktop client must not become a separate product or maintain a separate accounting model.

Priority order:

1. Android Owner Edition
2. Shared cloud identity/data model
3. Responsive computer/web client after the Android vertical slice is stable

## Cross-platform UX

Mobile is optimized for fast one-handed transaction entry. Computer is optimized for keyboard, tables, bulk data entry, reporting, printing, and document management.

Both clients must preserve the same business rules and financial calculations.

## Security

Authentication, authorization, business isolation, encrypted transport, secure token/session handling, least-privilege data access, and auditability are mandatory foundations.

Actual cost, internal margin, and other private business data must remain protected on every client, including public/shared views.

## Deferred capabilities

The initial Owner Edition does not need staff accounts, public storefronts, or broad multi-user collaboration UI. The identity and business boundaries must nevertheless make those additions possible without a domain rewrite.

## Acceptance criteria

A release candidate is not considered cross-platform-ready unless:

- an owner can create/sign into an account
- the business is associated with that account
- business records are cloud-backed
- an Android-created transaction can later be retrieved on another client
- ordinary offline transactions can synchronize safely
- duplicate financial transactions are not produced by sync retries
- private cost/profit never appears in public/customer documents
- a user can recover access without relying on a single device
