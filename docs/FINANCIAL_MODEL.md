# HisabKitab Financial Model

**Status:** Product requirement / design contract
**Scope:** Product/service sales, commission-based services, private cost, margin, daily/monthly/yearly reporting

## 1. Core principle

HisabKitab is a business bookkeeping layer. It does not need to reproduce transactions already authoritative in external platforms such as bKash, Nagad, mobile recharge, or other service-provider systems.

A business owner may nevertheless record the operational details needed for their own business history and profitability analysis.

## 2. Product/service economics

Every sellable item may be configured as one of:

- Physical product
- Service
- Commission-based service
- Fee-based service
- Other business income item

A sellable item can contain:

- public name
- category
- unit
- selling price
- private actual cost / cost basis
- derived gross profit
- derived gross margin percentage
- active/inactive state

Actual cost is business-private information. Selling price is customer-facing information.

## 3. Private cost vs public price

Customer-facing views may show:

- item/service name
- quantity
- selling price
- discount
- final amount

They must never expose actual cost, internal margin, purchase cost, or private commission basis.

The same rule applies to:

- printed/shared invoices
- receipts
- public online catalog/product pages
- customer order pages
- shareable product cards

Owner/admin views may expose private cost and derived profitability subject to permissions.

Staff permissions may optionally hide private cost and margin while still allowing sales.

## 4. Per-sale override

The configured default cost and selling price are not immutable assumptions.

A sale may optionally specify a transaction-specific cost basis when:

- purchase cost changed
- a special service cost applied
- supplier pricing changed
- the item was acquired unusually
- a commission arrangement differed

The transaction should preserve the cost basis used at the time of sale so historical profit does not silently change when the catalog default is later edited.

## 5. MFS / recharge / agent-style services

HisabKitab does not claim to be the source of truth for an external MFS transaction.

A business user may record an operational service entry such as:

- service type: bKash Send Money
- customer name
- customer mobile number
- transaction amount
- optional reference/notes
- date/time
- private commission/cost basis where applicable
- derived business profit/commission

The transaction amount is useful business history. The app does not need to recreate or reconcile the external provider's ledger unless a future official integration is explicitly implemented.

The same model applies to:

- Nagad
- mobile recharge
- Flexiload
- internet/data/minute recharge
- bill-payment assistance
- other agent/service transactions

## 6. Example

A computer shop sells:

- Mouse: selling ৳850, private cost ৳650 → gross profit ৳200
- Windows setup: selling ৳800, private cost ৳300 → gross profit ৳500
- Printing: 50 pages × ৳3 = ৳150 revenue, private cost 50 × ৳1.20 = ৳60 → gross profit ৳90
- bKash service: customer transaction amount ৳5,000, private commission/profit ৳15

The day's business report can therefore show revenue/recorded transaction value and business profit by product, service, commission, category, and total.

## 7. Reporting periods

Profitability must be available for:

- current transaction
- today
- custom date range
- week
- month
- quarter
- financial year / year

Useful breakdowns:

- product gross profit
- service gross profit
- commission/service profit
- category profitability
- total gross profit
- operating expenses
- net operating result where the available data supports it

Reports must distinguish gross profit from net profit. A gross-profit figure is not presented as formal accounting profit unless all required accounting inputs are available.

## 8. Daily closing

The daily workflow should support:

- opening cash
- recorded sales/service income
- customer payments
- expenses
- supplier payments
- withdrawals/deposits
- transfers
- expected cash
- actual counted cash
- variance
- closing note

This allows the app to replace the end-of-day paper calculation for ordinary small-business use.

## 9. Data integrity

Financial calculations must be deterministic and traceable to stored transactions. Do not use AI to calculate authoritative financial figures.

Money values must use a precise monetary representation, never binary floating-point arithmetic for persisted financial values.

Posted transactions should not be silently mutated. Corrections should use controlled edits, reversals, returns, or adjustment records according to the transaction state.

## 10. Returns and adjustments

Sales returns must reverse the appropriate revenue, cost basis, inventory movement, and customer/payment effect according to the original transaction.

Service cancellations/refunds must support the corresponding financial adjustment without deleting historical evidence.

The resulting reports must reflect returns rather than treating them as unexplained negative expenses.

## 11. Non-goals

For the initial product, HisabKitab does not promise:

- automatic access to private bKash/Nagad provider ledgers
- imitation of external provider transaction systems
- official settlement/reconciliation without an authorized integration
- formal statutory accounting or tax advice

The app records the business's own operational and financial records and remains explicit about the evidence boundary.
