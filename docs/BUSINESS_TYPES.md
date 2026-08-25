# Business Types & Configurable Workflows

HisabKitab uses one product with configurable workflows. Business type changes defaults and recommendations; it does not create separate products.

| Type | Primary workflow | Important fields/modules |
|---|---|---|
| Grocery/general | fast retail sale | products, units, stock, barcode, customer due |
| Super shop | POS + inventory | barcode, variants, stock, staff, reports |
| Pharmacy | controlled retail inventory | batch/expiry, purchase cost, stock, returns |
| Garments/fashion | variant retail | size, color, SKU, stock by variant |
| Electronics/mobile | retail + serial/identity | SKU, serial/IMEI as an optional secure field, warranty notes |
| Hardware/building | quantity/measurement sale | units, variants, supplier, stock |
| Cosmetics | retail inventory | SKU, expiry where applicable, variants |
| Furniture | high-value sale | quotation, delivery, customer, installment/payment tracking |
| Restaurant/cafe | order + expense | menu, sale, food cost later, expense, staff |
| Wholesale | bulk sale | customer pricing, credit, stock, delivery |
| Distributor | route/customer operations | customers, purchase, sales, credit limits, delivery |
| Service | service billing | clients, services, quotation, invoice, payment milestones |
| Online/F-commerce | order fulfillment | customer address, order status, delivery/COD, product catalog |
| Freelancer/professional | project billing | client, quotation, invoice, payment, expense |
| Other | configurable general business | generic modules |

## Personalization rules

The first dashboard should show no more than the most useful cards for the selected business type. Users can customize later.

Examples:

**Pharmacy**
- Today sales
- Receivable
- Low stock
- Expiring soon
- Purchase due

**Restaurant**
- Today's sales
- Orders
- Food/operating expense
- Estimated gross margin
- Cash

**Service**
- Unpaid invoices
- Today's receipts
- Active clients
- Quotes awaiting response
- Project/service revenue

**Online seller**
- New orders
- Pending delivery
- COD receivable
- Today's sales
- Top products

## Extensibility

Business-specific capabilities should be implemented as modules with feature flags and configuration schemas. Do not fork the domain model for every trade unless a genuine domain invariant requires it.
