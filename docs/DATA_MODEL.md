# HisabKitab Domain Data Model

The model is business-scoped. A user may eventually belong to multiple businesses, while each business owns its operational records.

## Identity

- User
- Session
- BusinessMembership
- Role
- Permission

## Business

- Business
- BusinessProfile
- BusinessSettings
- BusinessTypeConfig

## Catalog

- Product
- ProductVariant
- Category
- Unit
- Price
- Barcode
- StockPolicy

## Parties

- Customer
- Supplier
- ContactAddress
- PartyNote

## Commerce

- Sale
- SaleLine
- SalePayment
- SaleReturn
- Purchase
- PurchaseLine
- PurchasePayment
- PurchaseReturn

## Money

- MoneyAccount
- MoneyTransaction
- Transfer
- Expense
- Income

## Inventory

- StockMovement
- StockAdjustment
- Batch/Lot (optional)
- ExpiryRecord (optional)

## Documents

- Invoice
- Receipt
- Quotation
- Statement
- DeliveryChallan

## Operational metadata

Most mutable business records should include:
- id
- businessId
- createdAt
- updatedAt
- createdBy
- updatedBy
- status/version where appropriate

Financial records additionally need stable transaction identity and audit metadata.

## Money invariants

- currency is explicit
- monetary arithmetic is deterministic
- negative/positive semantics are documented per transaction type
- totals are derived from line items and adjustments
- payments cannot silently exceed applicable balances unless the business policy explicitly supports overpayment

## Ledger invariant

A party's balance must be derivable from its opening balance and posted transactions. Cached balances may exist for performance but must be rebuildable.

## Inventory invariant

Stock is derived from stock movements or an equivalent auditable movement model. Direct quantity mutation without an explainable adjustment record should be avoided.

## Deletion policy

Posted financial records should normally be voided/reversed rather than hard-deleted. Master data such as inactive products may be archived.
