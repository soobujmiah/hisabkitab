# Songjog Owner Edition — World-Class UX & Admin Surface Specification

**Status:** Release-critical product specification
**Target:** Android-first Owner Edition
**Principle:** Maximum business capability with minimum cognitive and data-entry burden.

## 1. Entry experience

### Welcome
- premium brand introduction
- clear value proposition in concise Bangla
- Log in
- নতুন অ্যাকাউন্ট খুলুন
- অ্যাপটি ঘুরে দেখুন
- language selector
- privacy/terms links

### Optional tour
A short, skippable tour explains:
1. দ্রুত বিক্রি ও সেবা লিপিবদ্ধ করা
2. বাকি ও টাকা আদায়
3. পণ্য, খরচ ও মজুত
4. লাভ ও রিপোর্ট
5. রসিদ/চালান তৈরি ও শেয়ার

Tour never blocks account creation or sign-in.

## 2. Authentication

- Google sign-in
- email/password where enabled
- account recovery
- secure session persistence
- explicit sign-out
- account/business distinction
- useful authentication errors in Bengali

The first release is owner-centric. Do not expose staff management in the main navigation until Team Edition is activated.

## 3. Business onboarding

The owner selects a business category and optionally sub-types. Examples include:

- মুদি/জেনারেল স্টোর
- কাপড়/গার্মেন্টস
- ইলেকট্রনিক্স
- মোবাইল/অ্যাক্সেসরিজ
- ফার্মেসি
- কম্পিউটার/মোবাইল সার্ভিস
- প্রিন্টিং/ফটোকপি/ডিজিটাল সেবা
- বিকাশ/নগদ/রিচার্জ/Flexiload/এজেন্ট সেবা
- রেস্টুরেন্ট/খাবার
- ফার্নিচার
- হার্ডওয়্যার/নির্মাণ সামগ্রী
- পাইকারি/ডিস্ট্রিবিউশন
- অনলাইন/F-commerce
- পেশাগত/ব্যক্তিগত সেবা
- অন্যান্য/কাস্টম ব্যবসা

The category configures terminology, shortcuts, dashboard cards, suggested fields, and recommended modules without changing the common financial engine.

## 4. Dashboard

The default dashboard must answer within seconds:

- আজ কত বিক্রি হয়েছে?
- আজ কত টাকা এসেছে?
- আজকের লাভ কত?
- কত টাকা বাকি?
- কত খরচ হয়েছে?
- হাতে/অ্যাকাউন্টে কত টাকা থাকার কথা?
- গুরুত্বপূর্ণ alerts কী?

Primary actions should be immediately reachable:

- দ্রুত বিক্রি
- সেবা বিক্রি
- টাকা গ্রহণ
- খরচ যোগ
- বাকি আদায়
- পণ্য যোগ

Dashboard is adaptive by business type and usage frequency.

## 5. Global search

One search entry should find:

- product/service
- customer
- supplier
- transaction number
- invoice/receipt
- mobile number
- reference number
- due record

Search should tolerate natural Bengali input and common number formatting where technically safe.

## 6. Fast transaction composer

The default transaction path must be extremely short.

### Minimum viable sale
- select product/service
- quantity where relevant
- confirm amount
- payment state
- complete

Everything else is optional or prefilled.

### Cart
A transaction may contain an arbitrary practical number of line items. Users can add/remove/edit/reorder items, apply item-level or transaction-level discounts where configured, and split/settle payment without losing line-item history.

### Payment
Support the business's configured payment methods, including:
- cash
- bank/account
- bKash/Nagad/other recorded methods where applicable
- mixed payment
- due

## 7. Customer and supplier

Customer profile can contain:
- name
- mobile
- address
- notes
- transaction timeline
- due
- payments
- returns/refunds
- documents

All non-essential fields are optional.

Supplier profile supports purchase history, payable balance, payments, and documents.

## 8. Products & services

Common fields:
- name
- category
- unit
- selling price
- private actual cost/cost basis
- stock configuration where applicable
- barcode/SKU optional
- image optional
- active state

Service fields may include duration, service status, job information, or commission basis when relevant.

Public catalog fields must be separate from private cost/margin data.

## 9. Documents

The document engine supports:
- receipt
- sales invoice
- service receipt
- quotation
- payment receipt
- job/service document
- delivery document
- customer statement

Documents dynamically paginate to any required number of pages while maintaining a consistent visual system. No customer document may expose private cost, margin, internal notes, or other restricted fields.

Documents support preview, share, print, and PDF generation where available.

## 10. Money & ledger surfaces

Owner can inspect:
- sales
- purchases
- expenses
- customer payments
- supplier payments
- income/other receipts
- refunds
- returns
- transfers
- withdrawals
- cash reconciliation

Financial records are chronological, traceable, and correction-safe.

## 11. Inventory

Where applicable:
- stock in/out
- purchase cost
- current quantity
- low-stock alerts
- returns
- stock adjustments
- stock valuation basis

Inventory is not forced on service-only businesses.

## 12. Profit & reporting

Reports:
- today
- yesterday
- week
- month
- quarter
- year
- custom period

Breakdowns:
- revenue/recorded sales
- gross profit
- product profit
- service profit
- commission profit
- expenses
- net operating result when inputs support it
- best-selling items
- most profitable items/services
- customer dues
- supplier payables
- cash movement

Reports must clearly distinguish gross profit from net result.

## 13. Daily closing

A guided closing flow should calculate expected cash and allow actual cash entry, producing variance and a closing note. The owner can review the day's complete transaction summary before closing.

## 14. Returns, refunds & corrections

No destructive deletion of posted financial history. Use controlled correction, return, refund, void, or adjustment records. Original references remain searchable.

## 15. Notifications & alerts

Useful alerts only:
- customer due reminders
- overdue balances
- low stock
- unusual cash variance
- unsaved/offline sync state
- backup/sync attention

Avoid notification spam.

## 16. Settings

Owner settings include:
- business profile
- logo/branding
- receipt/invoice appearance
- currency and number formatting
- payment methods
- transaction numbering/prefixes
- tax/discount settings where enabled
- default customer/payment behavior
- backup/sync
- account/security
- language
- data export
- data recovery
- help/support

## 17. Security & privacy

- business data isolation
- authenticated access
- least privilege foundations
- protected private cost/margin fields
- secure local storage for sensitive session material
- audit metadata
- safe logout/account recovery
- no private cost in public documents

## 18. Premium interaction system

The interface should feel calm, fast, and trustworthy rather than decorative.

Use motion for:
- page transitions
- successful transaction confirmation
- cart changes
- payment completion
- due settlement
- report period changes
- loading/progress

Animation must be short, purposeful, interruptible, and respect reduced-motion preferences.

## 19. Empty/loading/error states

Every important screen needs:
- useful empty state
- meaningful loading state
- recoverable error state
- offline state where relevant
- Bengali copy
- next action

Never show raw exception text to business users.

## 20. Accessibility & usability

- readable typography
- sufficient touch target size
- clear hierarchy
- high contrast
- screen-reader labels
- reduced motion
- keyboard/focus support on future computer client
- one-handed Android workflows

## 21. Release boundary

### Must ship in Owner Edition
Authentication, onboarding, business configuration, dashboard, products/services, fast transactions, payments, customers, suppliers, dues, expenses, receipts/invoices, returns/refunds, reports, daily closing, backup/sync foundation, Bengali UI, private cost/margin boundary, search, security baseline.

### Deferred but architecturally prepared
Staff/team roles, public storefront, online ordering, advanced integrations, AI assistance, broad multi-user collaboration.

## 22. Definition of world-class

A new shop owner should be able to install the app, understand the first screen without training, create a business, add one product/service, complete a sale in seconds, give the customer a polished receipt, and immediately understand today's financial position.

Power features must remain discoverable without overwhelming the fast path.
