# Songjog Implementation Sequence

## Objective

Reach a releasable Owner Edition quickly without creating architectural debt that blocks staff, participant, institution or healthcare expansion.

## Phase 0 — Governance and foundation

- Brand/localization rules
- Domain invariants
- Workspace/module catalog
- Security boundaries
- Licensing model
- Release gates
- Documentation index

## Phase 1 — Local persistence

- Select and configure durable local database
- Schema/migrations
- Workspace-scoped repositories
- Transaction persistence
- Product/service persistence
- Person/customer persistence
- Settings persistence
- Audit records
- Backup/export format

Acceptance:
- Data survives process/device restart.
- Workspace records cannot cross-contaminate.
- Monetary values are lossless integer minor units.
- Migration tests exist.

## Phase 2 — Authentication and onboarding

- Google sign-in provider
- Email/account fallback as supported
- Owner identity
- Workspace creation
- Business/institution type selection
- Minimal onboarding fields
- Optional profile fields
- Session persistence

Acceptance:
- First login creates/retrieves the correct identity.
- Owner workspace is isolated.
- No production secret is embedded in the APK.

## Phase 3 — Daily transaction engine

- Quick sale/service entry
- Multi-line transaction
- Quantity
- Selling price
- Private actual cost
- Automatic gross profit
- Payment/due
- Customer/reference optionality
- MFS/recharge service details
- Expense/purchase
- Return/refund/adjustment
- Daily closing

Acceptance:
- A common transaction can be entered in seconds.
- Basic sale works without unnecessary customer fields.
- Profit is mathematically correct.
- Customer output never exposes private cost/margin.

## Phase 4 — Owner dashboard and adaptive workspace

- Today's sales
- Profit
- Expense
- Due
- Cash position
- Quick actions
- Recent transactions
- Workspace-specific shortcuts
- Empty/loading/error/offline states

Acceptance:
- New owner can understand today's business immediately.
- Unused modules stay out of the primary flow.

## Phase 5 — Documents

- Receipt/invoice renderer
- Branding
- Multi-page pagination
- Customer copy
- Download/share/print
- Document numbering
- Reprint/reissue rules
- Custom document templates

Acceptance:
- Long invoices paginate cleanly.
- Every page is visually consistent.
- Private financial fields never leak.

## Phase 6 — Reports and export

- Daily/monthly/yearly
- Sales/service/profit/expense/due
- Inventory
- Customer statements
- Export
- Backup

## Phase 7 — Commercial control

- Trial entitlement
- Subscription plans
- Account-bound activation
- Server-authoritative entitlement
- Platform Owner role
- Session/refresh/recovery
- Expiry UX
- Export-before-expiry policy

## Phase 8 — Localization and premium UX

- Bengali complete UI
- English complete UI
- Script-purity validation
- Typography and spacing
- Motion/interaction system
- Accessibility
- Performance
- Tablet/desktop responsive layout

## Phase 9 — Staff and participant expansion

- Staff roles
- Teacher/trainer
- Customer portal
- Student/guardian relationship
- Notices
- Results
- Certificates/testimonials
- Salary statements
- Service history

## Phase 10 — Vertical expansion

Enable specialized workspaces progressively:

1. Repair/service center
2. Printing/computer/local service
3. Education/training
4. Hospital/clinic
5. Diagnostic/lab
6. Pharmacy
7. Restaurant/café
8. Wholesale/distribution
9. Online seller
10. Other researched verticals

## Release rule

Do not expand vertical scope at the cost of breaking the daily Owner workflow. A smaller reliable commercial core is preferable to a broad but unstable release.
