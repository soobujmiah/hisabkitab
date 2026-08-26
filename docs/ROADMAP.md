# HisabKitab Roadmap

## Phase 0 — Foundation

- product specification
- UX/motion system
- architecture
- business-type configuration
- data model
- security model
- CI/toolchain policy
- repository conventions

**Exit gate:** documentation reviewed and implementation boundaries agreed.

## Phase 1 — Usable bookkeeping MVP

- welcome/login/create account
- business setup
- business type
- dashboard shell
- customers
- suppliers
- products
- sales
- expenses
- payments
- customer/supplier ledger
- basic reports
- receipt generation
- local persistence

**Exit gate:** a user can run a basic business day without paper for core transactions.

## Phase 2 — Inventory & documents

- barcode scanning
- purchase workflow
- stock movement
- low-stock alerts
- invoice/receipt templates
- statements
- quotation
- returns
- document sharing/printing

## Phase 3 — Cloud and team

- authenticated cloud sync
- backup/restore
- multi-device support
- staff roles
- audit trail
- notification system

## Phase 4 — Business intelligence

- richer reports
- trend comparisons
- product/customer profitability
- business health dashboard
- scheduled summaries

## Phase 5 — AI assistance

- Bangla voice entry
- natural-language reports
- AI-assisted reminders and descriptions
- anomaly explanations

AI must remain an assistive layer; deterministic transaction records remain authoritative.

## Phase 6 — Commercial scale

- subscriptions
- premium feature gating
- business plans
- onboarding experiments
- referral mechanisms
- support/feedback loop
- privacy and retention controls

## Release strategy

Do not wait for every advanced module before shipping. Each phase should produce a genuinely useful product increment with explicit acceptance tests.
