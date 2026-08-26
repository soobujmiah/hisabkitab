# HisabKitab UX & Interaction System

## Product feeling

Target feeling: **calm, trustworthy, fast, premium, familiar**.

A merchant should feel that the app understands business work rather than presenting accounting jargon.

## Navigation

Recommended primary navigation:
- Home
- Sales
- Money
- Stock
- More

Contextual shortcuts can expose customers, suppliers, reports, and documents without turning the bottom navigation into a crowded menu.

## Visual hierarchy

Use a strong type scale and restrained surfaces. Cards should group information, not decorate it. Reserve emphasis for money requiring attention, primary actions, warnings, and completed outcomes.

Bangla text must be tested for line height, numeral rendering, mixed Bangla/Latin labels, and PDF output.

## Motion language

Motion should have a reason:
- screen enter: short fade/translate, not theatrical
- card expansion: shared-position or size transition
- transaction success: brief confirmation animation with amount emphasis
- navigation: continuity-preserving transitions
- list insertion: subtle position/opacity transition
- destructive action: no celebratory animation; use clear confirmation and undo

Avoid continuous decorative animations, bouncing controls, or long transitions that slow cash-counter workflows.

## Signature interaction ideas

### 1. Quick-add radial/cluster
A single primary add button expands into contextual actions such as Sale, Expense, Customer, Purchase, and Payment. The expansion should remain fast and accessible.

### 2. Transaction success sheet
After a sale/payment, show a compact success surface with:
- amount
- payment status
- customer
- Share receipt
- View transaction
- New sale

### 3. Due-to-paid transition
When a customer pays a due, animate the ledger balance from old value to new value and show the exact payment event. The animation reinforces causality.

### 4. Dashboard attention rail
A horizontally compact attention section can surface: “3 customers have due”, “5 products low in stock”, “Today's sales are 18% above your recent average”. Each item is actionable.

### 5. Smart empty states
Every empty state answers: what is empty, why it matters, and what to do next.

## Onboarding

1. Welcome
2. Login / create account
3. Business type
4. Business identity
5. Recommended setup checklist
6. Optional tour
7. Dashboard

The tour should be skippable and replayable. Do not block the user with a long tutorial before they can reach the product.

## Business-type personalization

The same shell can change:
- quick actions
- terminology
- dashboard cards
- product fields
- recommended reports
- optional modules

Examples:
- Pharmacy emphasizes expiry and stock.
- Restaurant emphasizes sales, menu/food cost, and expenses.
- Service business emphasizes clients, quotations, invoices, and payments.

## Forms

Use progressive disclosure. Keep first-use forms short. Group related fields and show advanced settings only when relevant.

Validation should be immediate but not noisy. Preserve entered data when an error occurs.

## Accessibility

- touch targets appropriate for mobile use
- readable contrast
- support system font scaling
- do not encode meaning using color alone
- semantic labels for icons
- motion reduction support
- keyboard-aware forms

## Performance UX

Perceived speed is part of the premium experience. Prefer immediate local UI updates for local operations, optimistic interaction where safe, and background synchronization. Clearly indicate unsynced state when it affects reliability.
