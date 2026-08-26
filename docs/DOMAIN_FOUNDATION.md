# Songjog Domain Foundation

## Goal

Keep the first Owner Edition simple for daily use while giving the accounting core enough structure to support shops, service businesses, MFS/recharge, printing/computer services, and later institutions without rewriting the financial model.

## Workspace model

A signed-in owner owns or is authorized for a Business Profile. A profile has a workspace kind and business type. The business type changes presentation, shortcuts, suggested fields and optional modules; it does not create a separate accounting engine.

Mandatory data must remain minimal. Optional metadata is captured only when useful to the business.

## Institution extension

Institution is a workspace kind, not merely a shop category. Institution-specific programs are represented separately as Trade/Course/Program. An institution can create its own programs rather than depending on a hard-coded national list.

Student/trainee, batch and fee-plan entities will attach to these programs in the institution module. The first Owner Edition does not need to expose the institution module until its workflow is production-ready.

## Transaction model

A transaction has a stable internal ID and human-facing number. Sales can contain multiple lines. A line has quantity, public selling price and an optional private actual-cost basis. Gross profit is calculated from cost when cost is known; missing cost does not prevent a sale.

Payment is separate from the sale so the system can represent full payment, partial payment, due, mixed payment and later settlement. Reference fields are optional unless a workflow explicitly requires them.

For MFS/recharge/service businesses, a service transaction may record amount/quantity and an optional customer/reference value such as a mobile number. The external MFS provider remains the authoritative source for its own transfer; Songjog records the business's operational sale/service history and profit where applicable.

## Privacy boundary

Actual cost and margin are owner/private fields. Customer-facing receipts, invoices and public product/service views must use selling price and permitted information only.

## Financial integrity

Posted transactions are not destructively deleted. Corrections use return, refund, void or adjustment records with references to the original transaction. This preserves auditability and reporting correctness.

## Reporting foundation

Daily, monthly, yearly and custom-period reports derive from the same transaction ledger rather than parallel hand-maintained totals. Revenue, gross profit, expenses and net operating result remain explicitly distinguishable.
