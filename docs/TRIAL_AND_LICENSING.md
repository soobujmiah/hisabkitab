# HisabKitab Trial & Licensing

## Commercial model

HisabKitab may be distributed as a time-limited trial so the owner can experience the complete Owner Edition before purchasing.

Recommended initial configuration:
- Trial duration is configurable by the product operator (for example 7 days or 30 days).
- Trial starts from first activation, not merely APK installation.
- The app clearly shows remaining trial time.
- The user receives advance, non-blocking reminders before expiry.
- Expiry must be explicit and understandable; never silently disable or delete business data.

## Expiry behavior

When the trial expires, business operations requiring an active license are locked. The user must still be able to:

- sign in
- view a clear expired-trial screen
- access the purchase/activation path
- export their business data in supported formats
- access account/help information

The trial must never destroy, corrupt, hide, or hold the user's records hostage.

## Data portability

Before and after expiry, the owner can export their business records subject to the supported export format. Export should cover the core business history needed for continuity, including transactions, customers, products/services, payments, dues, expenses, and relevant documents/metadata where technically supported.

Exports must be clearly labeled and should include a timestamp and business identity.

## Licensing

The commercial license belongs to the business/account, not permanently to a single phone. A valid license should be restorable after reinstall or device replacement through authenticated account ownership.

The licensing boundary should support:

- trial
- active paid subscription/license
- expired license
- grace period where configured
- cancelled/non-renewing state
- activation on a new device according to plan limits

Exact pricing, duration, device limits, and payment provider are commercial decisions and must remain configurable rather than hard-coded into the domain model.

## Anti-abuse without harming legitimate owners

Do not rely solely on device clock or a local boolean for licensing. Trial/license state must be verifiable against an authoritative service when connectivity is available, with a safe offline policy for already-authorized users.

Do not make ordinary offline business operation fail merely because the network is temporarily unavailable. Licensing checks and financial data synchronization are separate concerns.

## Graceful UX

The app should communicate:
- trial remaining
- trial ending soon
- trial expired
- license active
- renewal/payment issue

Messages must be Bengali-first, respectful, concise, and actionable.

## Commercial conversion flow

Expired trial → **লাইসেন্স কিনুন / চালিয়ে যান** → payment/activation → verified account → business unlocked.

The user should not need to recreate their business or re-enter their data after purchasing.

## Security and integrity

Licensing must not expose private business data to unauthorized parties. Server-side entitlement checks should be authoritative for paid access. Client code may enforce UI/feature gating, but sensitive licensing decisions must not depend exclusively on easily mutable local state.

## Release requirement

Trial/export/licensing is part of the commercial Owner Edition foundation, but payment-provider integration may be added as a separate implementation layer. The domain must support entitlement state without coupling the accounting engine to a specific payment provider.
