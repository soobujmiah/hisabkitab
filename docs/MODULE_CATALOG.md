# Songjog Module Catalog

This document is the canonical functional catalog for the adaptive workspace platform.

## Shared platform modules

### Identity & access
- Account authentication
- Workspace membership
- Role and permission management
- Staff invitations
- Customer/student/guardian relationships
- Session management
- Account recovery

### Organization
- Business/institution profile
- Branches/outlets
- Departments
- Staff
- Operating hours
- Branding
- Document identity

### Financial core
- Sales
- Services
- Purchases
- Expenses
- Income/payment received
- Payments made
- Due/receivable/payable
- Refunds/returns
- Transfers
- Adjustments
- Cash/bank/MFS/card accounts
- Daily closing
- Period summaries

### Catalog & inventory
- Product
- Service
- Variant/unit
- Price
- Private actual cost
- Stock
- Purchase
- Supplier
- Stock movement
- Low-stock/expiry alerts where applicable

### Customer/participant
- Person profile
- Contact information
- Optional account connection
- Relationship history
- Transaction history
- Documents
- Notifications

### Documents
- Receipt
- Invoice
- Quotation
- Payment statement
- Delivery/service document
- Certificate/testimonial
- Custom templates
- Multi-page rendering
- Download/share/print

### Reports
- Daily
- Weekly
- Monthly
- Yearly
- Sales
- Service
- Profit
- Expense
- Due
- Cash flow
- Inventory
- Staff/payroll
- Workspace-specific reports
- Export

## Workspace modules

### General retail / shop
Products, sales, inventory, supplier, customer, due, receipt, profit, daily closing.

### Local service / MFS / recharge
Service catalog, amount/quantity, optional customer/mobile/reference, private cost, selling price, automatic margin, service history, receipt.

### Printing / photocopy / computer service
Job/service ticket, file/page quantity, service type, customer, technician, cost, selling price, delivery/status, receipt.

### Repair & service center
Device/job intake, ticket ID, fault, estimate, parts, technician, status, customer approval, actual cost, selling price, payment, delivery, warranty/service history.

### Education / training institution
Institution, program/trade/course, batch, student/trainee, guardian, teacher/trainer, admission, fees, due, receipts, attendance foundation, result, notice, certificate, testimonial, salary.

### Hospital / clinic
Patient, guardian, visit, admission, ward/room/bed, doctor/service, diagnostics, billing, payment, receipt, ambulance, staff/payroll, administrative documents.

### Diagnostic center / laboratory
Patient, test catalog, sample, workflow/status, report, billing, receipt, technician, consumables, inventory.

### Pharmacy
Medicine/product, batch, expiry, purchase, supplier, stock, sale, return, customer/patient, receipt, profit.

### Restaurant / café
Menu, modifiers, table/order, kitchen status, takeaway/delivery, payment, receipt, stock, staff shift, daily closing.

### Hotel / guesthouse
Room, reservation, guest, check-in/out, room/service charges, payment, receipt, housekeeping status.

### Wholesale / distribution
Dealer, order, purchase, delivery challan, stock transfer, route/driver, collection, receivable/payable, sales representative.

### Online seller
Order, product, customer, COD, courier/reference, delivery charge, return/refund, reconciliation, receipt.

### Professional services
Client, service/project, quotation, invoice, advance, milestone, expense, document, optional staff/time tracking.

### Salon / beauty
Customer, service, appointment, provider, package, membership, product sale, payment, receipt, commission.

### Rental
Asset/item, availability, booking, customer, deposit, rental period, return, damage/extra charge, invoice/receipt.

### Construction / contractor
Project, client, work order, material, labour, subcontractor, expense, progress payment, due, project profitability.

### NGO / community organization
Donor/member, fund/project, receipt, grant, expense, beneficiary, restricted/unrestricted fund tracking, reporting.

### Agriculture / farm
Farm/project, crop/livestock, input purchase, labour, production, sales, expense, stock, profitability.

### ISP / subscription
Customer, package, subscription, recurring billing, due, payment, receipt, service status, device/reference.

## Implementation rule

A workspace should be composed from shared modules plus a small number of specialized modules. Do not duplicate financial, identity, document, reporting or permission logic across verticals.

## MVP rule

The first release prioritizes the Owner Edition and the highest-frequency local business workflows. A module may exist in the domain model and documentation before its full UI is enabled. Documentation must not imply implementation completion.
