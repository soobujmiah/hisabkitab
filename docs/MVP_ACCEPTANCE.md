# Owner Edition MVP — Acceptance Contract

**Milestone:** Android-first commercial release
**Scope:** One owner/admin can run an ordinary small business without a parallel paper ledger or another bookkeeping app.

## P0 release flows

1. First launch → welcome/tour → optional skip → authentication.
2. Sign in/create account → create business → choose business type → minimal setup → dashboard.
3. Create product/service → optionally configure private cost and selling price → save.
4. Fast sale → select product/service → quantity/amount → complete.
5. Service/agent transaction → select service → transaction amount → optional customer/contact/reference → complete.
6. Customer payment → record amount and method → automatically update due/balance.
7. Expense → quick entry → update business result/cash.
8. Customer/supplier ledger → view balance and history.
9. Returns/refunds → reference original transaction → controlled reversal/adjustment.
10. Receipt/invoice → generate appropriate document → preview → share/print/save.
11. Dashboard → today's activity, sales/service value, gross profit where cost is known, expenses, receivables, cash summary.
12. Reports → daily/monthly/yearly/custom range with product/service/commission breakdown.
13. Closing → expected cash → actual cash → variance → close day.
14. Backup/sync → authenticated business data persists beyond the device.

## Mandatory vs optional input

A normal transaction must require only the minimum information needed for a valid record. Customer identity, mobile number, external reference, note, discount, and other enrichment fields must remain optional unless a specific business rule makes one necessary.

The UI must use progressive disclosure. Advanced fields live behind `More details` rather than blocking the fast path.

## Financial invariants

- Selling price is customer-facing.
- Actual cost/cost basis is private.
- Profit/margin is derived and private.
- Historical posted transactions retain the cost basis used for their calculation.
- Returns/refunds affect the original financial meaning and remain auditable.
- Financial calculations are deterministic and use precise money representation.
- Posted records are not silently hard-deleted.

## Document invariants

Every posted transaction receives a stable unique identifier. The document type is selected from transaction/business context, for example receipt, invoice, service receipt, job card, quotation, or delivery document.

Customer-facing documents must never reveal private cost, internal margin, or confidential business notes.

## Business coverage for first release

The configuration must cover at minimum:

- general/grocery retail
- super shop
- pharmacy
- garments/fashion
- electronics/mobile
- hardware/building materials
- cosmetics
- furniture
- restaurant/cafe
- wholesale
- distributor
- service business
- online/F-commerce seller
- freelancer/professional
- MFS/recharge/Flexiload/local digital service shop
- computer service/printing/photocopy/scan/typing/online service center
- other configurable business

The release does not need a unique screen for every category. It needs a shared transaction engine with category-specific defaults and recommendations.

## Deferred

Staff accounts/roles, public storefront/customer accounts, advanced collaboration, official MFS integrations, AI assistant, and broad accounting/tax features are deferred until Owner Edition usage validates them.

## Release quality bar

The app is not ready for commercial handoff if the fast sale path is slow or confusing, if private cost can leak into customer/public documents, if a normal business cannot record its daily transactions without external paper/software, or if a sync retry can duplicate a financial transaction.
