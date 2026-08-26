# HisabKitab Product Specification

**Status:** Foundation draft
**Target:** Android-first production app
**Primary market:** Bangladesh small shops, micro-businesses, and SMEs
**Languages:** Bangla first, English supported

## 1. Product thesis

HisabKitab should replace scattered paper khata, calculator, notes, spreadsheets, and messaging workflows with one understandable mobile workspace. It must not feel like enterprise accounting software. A shop owner should be able to open the app and immediately understand three things: how the business is doing, what needs attention today, and what action can be taken next.

The product should support retail, wholesale, distribution, pharmacy, grocery, garments, electronics, hardware, cosmetics, restaurant/cafe, service businesses, online/F-commerce sellers, freelancers, and other small organizations through configurable modules rather than separate apps.

## 2. Core product pillars

1. **Hisab** — sales, purchases, expenses, income, cash, bank, dues.
2. **Bikri** — fast sales/POS, invoice, receipt, discounts, returns.
3. **Stock** — products, variants, units, purchases, adjustments, low-stock and optional batch/expiry.
4. **Customer & Supplier** — profiles, ledger, transaction history, receivable/payable, reminders.
5. **Business Money** — cash accounts, bank accounts, transfers, deposits/withdrawals, reconciliation support.
6. **Reports** — sales, purchases, expenses, gross profit, receivables, payables, stock value, cash movement.
7. **Team** — owner/admin/staff roles, permissions, activity history.
8. **Documents** — invoices, receipts, statements, quotations, delivery challans where applicable.
9. **Insights** — actionable summaries, trends, anomalies, and later AI-assisted natural-language analysis.
10. **Settings & Safety** — business profile, data export, backup/sync, security, subscription, support.

## 3. Authentication and entry experience

### Welcome

On first launch show a polished, lightweight welcome/login screen with:
- brand identity
- short value proposition
- Log in
- Create business account
- Explore demo / optional product tour
- language selector
- privacy/terms entry points

The user may explore a guided demo without an account, but real business data and all service functionality require an authenticated account.

### Account creation

Use phone-first onboarding for Bangladesh, with email as an optional recovery/contact method. Authentication must be abstracted so future providers can be added without rewriting the domain layer.

### Business setup

After authentication, collect business identity and business type. Avoid a giant form. Use progressive disclosure.

Required baseline:
- business name
- owner/contact name
- phone
- business type
- currency (BDT default)
- location/timezone (Bangladesh default)

Optional progressive fields:
- address
- trade license information
- tax/VAT information
- logo
- social/contact links
- financial year preference
- invoice settings
- receipt printer preferences

## 4. Business-type onboarding

Business type is configuration, not a separate app. Suggested categories:

- Grocery / general store
- Super shop / retail
- Pharmacy
- Garments / fashion
- Electronics / mobile
- Hardware / building materials
- Cosmetics
- Furniture
- Restaurant / cafe / fast food
- Wholesale
- Distributor
- Service business
- Online / Facebook seller
- Freelancer / professional service
- Other

The selected type controls recommended modules, terminology, default dashboard cards, product fields, units, workflow shortcuts, and optional advanced features.

Examples:
- Pharmacy: batch/expiry, generic/brand fields, purchase cost, sale, returns, expiry alerts.
- Garments: size/color variants, SKU, stock by variant.
- Restaurant: menu items, recipe/food cost, tables/orders as an optional later module.
- Wholesale/distributor: customer credit limits, purchase orders, delivery challan, route/customer grouping.
- Service: clients, services, quotations, invoices, payment milestones; stock can be disabled.
- Online seller: order status, delivery fee, COD, courier, customer address.

## 5. Dashboard

The dashboard is adaptive, not a fixed accounting screen.

### Primary hierarchy

1. Today at a glance
2. Quick actions
3. Money requiring attention
4. Sales/profit trend
5. Stock alerts
6. Recent activity
7. Business insights

### Recommended quick actions

- New sale
- Add customer
- Add purchase
- Add expense
- Receive payment
- Pay supplier
- Add product
- Scan barcode

Quick actions must be reachable one-handed and customizable later.

### Dashboard cards

Potential cards:
- Today's sales
- Today's expenses
- Estimated gross profit
- Cash on hand
- Customer receivable
- Supplier payable
- Low stock count
- Today's transactions
- Best-selling products
- Sales trend
- Unpaid invoices

Do not overload the initial viewport. The dashboard should prioritize decisions over data density.

## 6. Sales/POS

Requirements:
- product search
- barcode scan
- quantity and unit
- variants
- item-level and bill-level discount
- customer selection
- cash/partial/credit payment
- multiple payment methods
- delivery charge where applicable
- notes
- hold/resume cart
- sale return
- receipt/invoice generation
- share via WhatsApp/Messenger/SMS/share sheet
- optional thermal/A4 printing
- offline transaction creation

The success state should be a deliberate interaction: amount, payment status, receipt/share actions, and new-sale action without forcing the user through a generic dialog.

## 7. Purchases

Requirements:
- supplier
- products and quantities
- purchase price
- discount
- transport/other cost
- payment/credit
- stock update
- purchase return
- purchase history

Later: purchase orders and partial receipt.

## 8. Customer ledger

Each customer has:
- identity/contact
- opening balance
- transaction timeline
- current receivable/payable state
- payments
- invoices
- notes
- optional credit limit
- reminder actions

Generate human-readable statements and reminder messages. Never expose sensitive internal metadata in shareable messages.

## 9. Supplier ledger

Mirror customer capabilities for supplier payable management, with purchase-oriented terminology.

## 10. Expenses and money accounts

Expense categories should be configurable. Support:
- cash
- bank
- mobile financial service account as a record type where legally/technically appropriate
- transfer between own accounts
- deposit
- withdrawal
- expense
- income/other receipt

Every money movement should have an immutable transaction identity and audit trail at the domain level.

## 11. Inventory

Baseline:
- product name
- SKU/barcode
- category
- unit
- purchase price
- sale price
- stock quantity
- minimum stock
- active/inactive

Advanced:
- variants
- batch/lot
- expiry
- damaged/adjustment
- stock valuation
- stock movement ledger
- supplier association

## 12. Invoices, receipts and documents

Templates must be professional, printable, and Bangla-safe.

Document types:
- invoice/cash memo
- money receipt
- customer statement
- supplier statement
- quotation
- delivery challan
- purchase document

Provide configurable business branding, invoice numbering, footer, terms, and contact information.

## 13. Reports

MVP reports:
- daily sales
- sales by period
- purchase summary
- expense summary
- gross profit estimate
- receivable/payable
- cash movement
- stock summary

Advanced reports:
- product profitability
- customer profitability
- category performance
- sales by payment method
- staff sales
- stock valuation
- return analysis
- period comparison

Reports should be explainable. A number such as profit must show how it was calculated and distinguish estimated gross profit from formal accounting profit.

## 14. Team and permissions

Roles:
- Owner
- Admin
- Manager
- Sales staff
- Inventory staff
- Accountant/viewer

Permissions should be granular by domain and action. Example: a cashier may create sales but cannot delete transactions or view supplier financial data.

## 15. Notifications

Useful notifications only:
- low stock
- due payment reminder schedule
- unpaid invoice
- important account/security event
- sync issue
- subscription state

Notification fatigue must be avoided.

## 16. Offline-first behavior

Core business operations must work without internet after initial setup:
- view products/customers
- create sales
- create expenses
- record payments
- view recent reports where data exists locally

Sync must be conflict-aware and auditable. Never silently overwrite business records.

## 17. Search

Global search should find:
- customers
- suppliers
- products
- invoices
- transactions
- documents

Search should tolerate Bangla/English naming differences and common spelling variation where technically feasible.

## 18. AI roadmap

AI is an enhancement, not a dependency for core bookkeeping.

Later capabilities:
- Bangla voice transaction entry
- natural-language report questions
- sales summaries
- unusual expense/sales pattern detection
- customer reminder drafting
- product description/caption generation

Financial figures must remain deterministic and traceable to stored transactions. AI must never become the source of truth for accounting data.

## 19. Monetization

Suggested product model:
- Free core entry tier for habit formation
- Premium for advanced inventory, reports, documents, multi-business/team features, automation, and enhanced backup/sync
- Optional business-specific plans

Avoid paywalling the basic ability to record essential transactions before product-market fit is established.

## 20. UX quality bar

The app should feel premium through hierarchy, spacing, typography, motion, responsive feedback, and clarity—not decoration.

Principles:
- one primary action per screen
- progressive disclosure
- large touch targets
- readable Bangla typography
- meaningful empty states
- skeleton/loading states instead of jarring spinners
- clear success/failure feedback
- undo where safe
- destructive actions require deliberate confirmation
- motion communicates causality
- no animation that delays routine work

## 21. Non-functional requirements

- secure authentication/session handling
- encrypted sensitive local storage where appropriate
- safe server-side authorization
- reliable backups
- export capability
- auditability
- crash/error reporting with privacy controls
- accessibility basics
- responsive layouts for phones and tablets
- low-end Android performance target in addition to flagship devices

## 22. Definition of a successful MVP

A new shop owner can install HisabKitab, create an account, select a business type, finish a short setup, create products/customers, record a sale, record a payment/expense, see the dashboard update, view a ledger, generate a receipt, and understand the day's position without training.
