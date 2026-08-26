# HisabKitab Android Owner Edition

This directory is reserved for the Android-first commercial application.

## First vertical slice

1. Welcome / optional tour
2. Sign in / account creation
3. Business onboarding and business type
4. Owner dashboard
5. Product/service setup
6. Fast sale/service entry
7. Payment capture
8. Transaction number + customer document
9. Customer history / due
10. Expense
11. Profit and daily report

## UX contract

- Fast path must require only the minimum information needed to post a valid transaction.
- Optional details are progressively disclosed.
- Actual cost and internal margin are never customer/public data.
- Every posted transaction has a stable unique identifier.
- Financial calculations are deterministic; AI is never authoritative for money.
- Android is the first client; the business data model remains multi-platform.

The actual Flutter project will be introduced as the next implementation commit once the repository toolchain and CI skeleton are established.