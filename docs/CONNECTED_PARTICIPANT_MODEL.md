# Connected Participant Model

HisabKitab is not only an internal ledger for the business/institution. Relevant counterparties can optionally use the same platform through their own account and can be connected to a business or institution.

## Core principle

A person may have one HisabKitab identity and participate in different roles without creating duplicate records unnecessarily.

Examples:

- Student / Trainee
- Parent / Guardian
- Customer / Service recipient
- Client
- Supplier
- Staff member
- Teacher / Trainer

The role is contextual to a relationship, not a separate person identity.

## Institution side

An institution can invite or connect a student/trainee account. A student can optionally connect a guardian account. The institution controls the institutional relationship and sees only information permitted by that relationship.

Typical connected capabilities:

- Enrollment/program/trade information
- Fee schedule
- Payment and due status
- Receipts
- Notices/documents
- Payment confirmation
- Profile information supplied by the participant

Institutional users must not automatically receive access to unrelated accounting, payroll, expense, supplier, or administrative data.

## Business/service side

A customer or service recipient can optionally have a HisabKitab account and be linked to the business transaction/customer record.

Possible capabilities:

- Service/order reference
- Receipt/invoice
- Payment history
- Due balance
- Service status where applicable
- Shared documents
- Notifications
- Future loyalty/warranty/service history features

A customer account is never mandatory merely to complete a sale unless the business's configured workflow requires it.

## Linking rules

- Linking is explicit and consent-aware.
- A business cannot silently claim an arbitrary person's account.
- Invitation/acceptance or a verified contact mechanism is used for account linking.
- A participant may disconnect where policy permits.
- Historical financial records remain auditable after disconnection.
- Private business cost, margin, internal notes, supplier data and administrative data never become visible to a connected customer/student merely because accounts are linked.

## Product architecture

```text
                         HisabKitab Identity
                                  |
             +--------------------+--------------------+
             |                    |                    |
         Institution           Business             Personal
             |                    |                    |
        Student/Guardian      Customer/Client       Profile
             |                    |
       Trade/Batch/Fee       Service/Sale/Payment
```

The same authentication/account layer can support both sides. The workspace determines permissions and the relationship determines what data is visible.

## MVP boundary

The first Owner Edition should support storing and referencing counterparties robustly. Full participant-facing portals, invitations, messaging, notifications and two-sided self-service should be introduced incrementally after the owner workflow is stable. The data model must not block them.
