# Implementation Plan — Owner Edition

## Objective

Ship a usable Android-first Owner/Admin commercial release as quickly as practical without creating architectural debt that forces a rewrite.

## Vertical slices

### Slice 0 — App shell
- Flutter Android application
- theme, typography, spacing, navigation
- splash/welcome/tour
- error/loading/empty states

### Slice 1 — Identity + onboarding
- email/password and Google provider boundary
- session persistence
- business creation
- business type selection
- minimal business profile

### Slice 2 — Local domain foundation
- business-scoped IDs
- precise money type
- product/service catalog
- customer/supplier
- transaction repository
- deterministic calculation engine

### Slice 3 — Fast transaction
- fast sale screen
- product/service selection
- quantity/amount
- payment
- transaction number
- optional details
- local persistence

### Slice 4 — Business ledger
- customer balances
- supplier balances
- expenses
- cash/account movements
- daily activity timeline

### Slice 5 — Documents
- receipt/invoice/service document templates
- preview
- PDF/print/share boundary
- public/private field filtering

### Slice 6 — Profit + dashboard
- daily metrics
- gross profit
- service/commission profit
- expenses
- receivables
- cash summary
- monthly/yearly/custom reports

### Slice 7 — Returns + closing
- sale returns
- service refund
- adjustments
- daily cash reconciliation
- close-day workflow

### Slice 8 — Cloud sync
- authenticated cloud business storage
- sync metadata
- retry/idempotency
- restore/new-device continuity
- sync status UI

### Slice 9 — Commercial hardening
- migration tests
- security checks
- performance
- accessibility
- localization
- backup/export
- release build
- pilot checklist

## Scope discipline

Do not implement staff UI, public storefront, official payment-provider integrations, or AI before the Owner Edition acceptance contract is satisfied.

Do not build category-specific forks when configuration can express the workflow.

Do not use AI for authoritative financial calculation.

## Definition of Done for Owner Edition

A real owner can install the Android app, create an account/business, configure products/services, record a normal day's sales and expenses, record customer payments and dues, see profit where cost data exists, generate customer documents, review daily/monthly/yearly reports, close the day, and recover the same business data on another authenticated client.
