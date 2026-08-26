# Implementation Roadmap

## Release objective

Deliver a production-quality Owner Edition quickly without compromising financial correctness, Bengali-first UX, data integrity, security, or customer-document quality.

## Phase 1 — Core domain

- Business and institution workspace identity
- Product/service lines
- Multi-line transactions
- Private actual cost and automatic gross profit
- Payment, partial payment and due
- Expense, purchase, refund, return and adjustment primitives
- Customer/reference metadata as optional fields

## Phase 2 — Local persistence

- Durable local database
- Transaction repository
- Business-scoped data isolation
- Migration/versioning strategy
- Audit-safe correction model
- Offline-first write path

## Phase 3 — Owner experience

- First-launch onboarding
- Language selection with strict UI-language purity
- Business-type selection
- Adaptive dashboard
- Fast sale/service entry
- Customer and supplier workflows
- Daily closing and reconciliation

## Phase 4 — Documents and reporting

- Receipt/invoice templates
- Multi-page pagination
- Customer copy vs private internal copy
- Print/share/export
- Daily, monthly and yearly reports
- Profit, due, expense and cash summaries

## Phase 5 — Commercial control

- Authentication
- Business identity
- Trial entitlement
- Subscription entitlement
- One-time activation redemption
- Platform-owner role
- Admin console
- Export before/after entitlement expiry

## Phase 6 — Hardening

- Offline/online reconciliation
- Backup and recovery
- Security review
- Localization audit
- Accessibility audit
- Performance and animation review
- Real-device validation

## Explicit non-goals for first commercial release

Staff management, public marketplace/storefront, advanced institution management and third-party payment automation must not delay the Owner Edition unless a dependency is required by the core architecture.
