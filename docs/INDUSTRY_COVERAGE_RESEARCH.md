# Songjog Industry Coverage Research

## Research basis

Current Bangladesh business-software offerings commonly converge on POS, inventory, accounting, HR/payroll, education, healthcare, hospitality, distribution, CRM, service/repair, and logistics. Recent market examples also expose restaurant/hotel, diagnostic, pharmacy, ISP, NGO/non-profit, manufacturing, and e-commerce workflows. Songjog should cover these areas through reusable workspace capabilities rather than creating isolated applications.

## Recommended additional workspaces

### 1. Diagnostic center / laboratory
High priority because it naturally extends the hospital model.

- Patient registration
- Test catalog and pricing
- Sample collection/status
- Lab/report workflow
- Result document delivery
- Referrer/source tracking where appropriate
- Billing, due, refund and receipts
- Staff/technician roles
- Inventory/consumables

### 2. Pharmacy
High priority and closely related to healthcare.

- Medicine/product catalog
- Batch and expiry
- Purchase and supplier
- Stock
- Sales/returns
- Prescription reference
- Customer/patient link
- Profit and reports

### 3. Restaurant / café / food service
High priority for broad SME reach.

- Table/order flow
- Takeaway/delivery
- Kitchen order status
- Menu/modifiers
- Multiple payment methods
- Discounts/service charge/tax configuration
- Inventory and recipe/cost foundation
- Staff shifts
- Daily closing

### 4. Hotel / guesthouse
Medium priority.

- Room inventory
- Reservation
- Check-in/check-out
- Guest profile
- Room charges
- Additional services
- Payments/due/refunds
- Housekeeping status
- Guest receipt/invoice

### 5. Repair and service center
Very high priority for local Bangladesh businesses.

- Device/customer intake
- Job/ticket number
- Problem description
- Estimated cost
- Private actual cost
- Parts used
- Technician assignment
- Status timeline
- Customer approval
- Payment/due
- Delivery receipt
- Warranty/service history

Examples: mobile/computer/electronics/appliance/AC/vehicle service.

### 6. Wholesale / distribution
High priority after core retail.

- Dealer/customer ledger
- Purchase orders
- Sales orders
- Delivery challan
- Stock transfer
- Route/driver assignment
- Receivable/payable
- Collection
- Sales representative
- Commission

### 7. E-commerce / online seller
High priority because many small businesses sell through social channels.

- Online order entry
- Customer history
- Product catalog
- COD
- Courier status/reference
- Delivery charge
- Returns/refunds
- COD reconciliation
- Customer notifications

The first version can manually record orders without depending on external platform integrations.

### 8. Professional services
Broad applicability.

- Client
- Project/job
- Service package
- Quotation
- Invoice
- Advance
- Milestone payment
- Expense
- Document delivery
- Staff/time entry where useful

Examples: consultants, agencies, accountants, lawyers, designers, tutors, IT service providers.

### 9. Salon / beauty / personal care
High-value simple workflow.

- Customer profile
- Service catalog
- Appointment
- Staff/provider
- Service history
- Package/membership
- Product sales
- Payment/receipt
- Commission

### 10. Rental business
Useful reusable workflow.

- Rental item/asset
- Availability
- Booking
- Customer
- Deposit
- Rental period
- Return
- Damage/extra charge
- Invoice/receipt

### 11. Construction / contractor
Medium priority and more complex.

- Project
- Client
- Work order
- Materials
- Labour
- Subcontractor
- Expense
- Progress payment
- Due
- Project profitability

### 12. NGO / non-profit / community organization
Potential later expansion.

- Donor/member
- Fund/project
- Receipts
- Grants
- Restricted/unrestricted fund tracking
- Expense
- Beneficiary records
- Reports

### 13. Agriculture / farm
Potential later expansion.

- Farm/project
- Crop/livestock records
- Input purchases
- Labour
- Production/sales
- Expense
- Stock
- Profitability

### 14. ISP / subscription service
Potential later expansion.

- Customer
- Package
- Subscription
- Monthly billing
- Due
- Payment receipt
- Service status
- Device/reference records

## Reusable platform capabilities required by these workspaces

The following should be built once and reused:

- Person/account identity
- Organization/workspace
- Roles and permissions
- Customer/participant relationship
- Product/service catalog
- Inventory
- Transaction engine
- Payment/due engine
- Document/receipt engine
- Job/order/ticket engine
- Appointment/reservation engine
- Notification engine
- Staff/attendance/payroll
- Reporting/export
- Audit log
- Offline-first persistence and sync
- Subscription/entitlement

## Prioritization rule

Do not turn every industry into a separate codebase. Prefer configurable workspace modules and reusable domain primitives. The first commercial release remains focused on Owner Edition and the highest-frequency Bangladesh SME workflows. Additional verticals are activated incrementally after the common core is reliable.
