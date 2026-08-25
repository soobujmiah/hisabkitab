# HisabKitab Architecture

## Goals

- Android-first performance and UX
- deterministic financial domain logic
- offline-first operation
- testable modules
- business-type configuration without branching the codebase per industry
- replaceable infrastructure
- future cloud sync and AI without coupling the core domain to either

## Recommended stack

### App

Flutter is the preferred initial client direction because it supports a polished Android-first UI while retaining a path to additional platforms. Keep platform-specific integrations behind interfaces.

### Layers

```text
Presentation
  ├── Screens
  ├── Widgets
  ├── Design system
  └── View models / controllers

Application
  ├── Use cases
  ├── Commands / queries
  └── Business workflows

Domain
  ├── Entities
  ├── Value objects
  ├── Invariants
  ├── Policies
  └── Domain services

Data
  ├── Local database
  ├── Repositories
  ├── Sync engine
  ├── Remote API
  └── Serialization

Infrastructure
  ├── Authentication
  ├── Notifications
  ├── File/PDF generation
  ├── Barcode/scanner
  └── Platform integrations
```

## Domain modules

- identity
- business
- catalog
- customers
- suppliers
- sales
- purchases
- inventory
- money
- expenses
- documents
- reports
- team
- notifications
- subscription
- sync

Each module should have explicit public interfaces and avoid reaching directly into another module's storage implementation.

## Financial integrity

Money should not be represented as floating-point values in the domain. Use integer minor units or a decimal representation with explicit currency precision.

Transactions should have stable IDs, timestamps, actor identity, source, and references to related business objects. Corrections should preferably be modeled as reversing/adjusting transactions rather than destructive edits to posted financial history.

Reports should derive from deterministic domain data and expose their calculation basis.

## Offline-first data flow

```text
User action
   ↓
Use case
   ↓
Domain validation
   ↓
Local transaction
   ↓
UI state update
   ↓
Sync queue
   ↓
Remote API
   ↓
Server acknowledgement / conflict
```

The local database is the immediate operational source for offline-supported workflows. The sync engine must retain operation identity and idempotency keys so retries do not duplicate sales or payments.

## Sync requirements

- per-operation unique ID
- idempotent server writes
- version/revision metadata
- retry with backoff
- explicit conflict policy
- tombstones for deletes where necessary
- observable sync state
- safe recovery after app termination

For financial records, silent last-write-wins is not acceptable as the only conflict strategy.

## Business-type configuration

Use a configuration model such as:

```text
BusinessProfile
  type
  enabledModules
  terminology
  dashboardPreset
  productSchema
  defaultUnits
  recommendedReports
  featureFlags
```

Business type must never alter core accounting invariants.

## Security boundaries

Authentication proves identity. Authorization proves access to a business and its resources. Every remote business operation must enforce tenant/business ownership server-side.

Local secrets/tokens must use platform secure storage. Sensitive data should not be written to logs.

## Documents

PDF/document generation must be deterministic and tested with Bangla text, mixed numerals, long names, long addresses, and different paper sizes.

## Observability

Use structured error categories rather than arbitrary strings. Capture non-sensitive diagnostics for crashes, sync failures, and critical workflow failures. Provide a way to correlate a user-visible failure with an internal operation ID without exposing private data.

## Testing strategy

### Domain
- unit tests for all monetary calculations
- property/invariant tests where useful
- ledger balance tests
- inventory movement tests

### Application
- use-case tests
- permission tests
- workflow tests

### UI
- widget tests for critical components
- golden tests for stable visual surfaces where practical
- integration tests for onboarding, sale, payment, inventory, and offline recovery

### Release
- static analysis
- formatting
- unit tests
- integration smoke tests
- APK build
- install/launch smoke test on representative Android devices

## Dependency discipline

Prefer stable, well-maintained packages. Pin or constrain versions intentionally. Avoid adding a package for a trivial capability that can be implemented locally without maintenance cost.
