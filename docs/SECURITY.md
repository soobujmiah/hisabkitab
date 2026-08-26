# HisabKitab Security & Privacy Baseline

## Principles

- least privilege
- business/tenant isolation
- secure authentication
- secure local secret storage
- no sensitive data in logs
- auditable financial changes
- explicit export/delete controls

## Authentication

Phone-first authentication is a product preference, not a security shortcut. OTP/session design must use secure backend verification and short-lived access tokens with safe refresh handling.

The client must never be trusted to decide business ownership or permissions.

## Authorization

Every business-scoped API operation must validate that the authenticated principal has access to the requested business and action. Role checks belong server-side even if the UI hides unavailable actions.

## Local data

Use platform-backed secure storage for credentials/tokens. Encrypt sensitive local data where appropriate. Avoid storing authentication secrets in ordinary preferences.

## Backups and sync

Backups must be authenticated and business-scoped. Restore must not accidentally merge data into the wrong business. Sync retries must be idempotent.

## Sharing

Receipts/statements shared through messaging apps should contain only the business/customer information required for the document. Internal IDs, auth tokens, staff metadata, or diagnostics must never be embedded.

## Auditability

Critical operations should produce an audit event or immutable history entry, including actor and timestamp. Examples: voiding a sale, changing a posted payment, changing permissions, exporting business data.

## Privacy

Collect only information needed for product operation. Clearly explain why optional profile, business, and analytics data are requested. Provide account/business data export and deletion workflows subject to legitimate retention requirements.

## Payment integrations

Recording a bKash/Nagad/bank payment method is different from operating a payment service. Any live payment collection or payment initiation integration requires provider approval, API/security review, and applicable regulatory/legal review before production use.

## Security release gate

Before production:
- review authentication/session flows
- review authorization on every business-scoped endpoint
- test account/business isolation
- test logout/token invalidation
- test backup/restore boundaries
- inspect logs for sensitive data
- verify document sharing does not leak internal data
- perform dependency and secret scanning
