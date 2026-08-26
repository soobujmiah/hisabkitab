# Knowledge Return — Songjog (সংযোগ)

**Date:** 2026-08-26
**Status:** Open engineering knowledge-return record

## New product decisions

1. Add a first-class **Local Service / MFS / Digital Shop** business category.
2. Cover bKash/Nagad-style service records, Flexiload/recharge, computer service, printing, photocopy, scan, typing/composition, lamination, online service centers, accessories, and mixed local businesses.
3. Songjog records the business owner's operational details for external services; it does not pretend to replace or become the authoritative ledger of the external provider.
4. MFS/service records may include customer name, mobile number, transaction/service amount, reference, date/time, and private commission/cost basis.
5. Product and service definitions support a **private actual cost/cost basis** and a **public/customer selling price**.
6. Profit/margin is derived automatically and retained in business-private financial reporting.
7. Public/shared/printed product and service views must never expose actual cost or internal margin.
8. Authorized owner/admin views may expose cost and margin; staff access is permission-controlled.
9. Historical sales preserve the cost basis used at the time of the transaction so later catalog changes do not silently rewrite historical profitability.
10. Reports must provide daily, weekly, monthly, yearly and custom-period profitability, including product, service and commission breakdowns.
11. Returns/refunds/adjustments must reverse or adjust the appropriate financial effects while preserving historical evidence.
12. The daily workflow should be sufficient for ordinary business operation without requiring a parallel paper khata for routine bookkeeping.
13. Bengali-first and English-first UI modes must keep application-owned UI text pure to the selected language.
14. User-data export and diagnostic export are mandatory product capabilities; diagnostic exports must redact secrets and credentials.

## SKB return

This record is a deliberate knowledge-return artifact: the product decisions above must remain available to future AI sessions through the project repository and should be reflected back into the broader SKB project knowledge when the Songjog milestone is closed.

## Evidence boundary

No implementation, test result, CI result, provider integration, or external transaction access is claimed by this document. These are product/architecture decisions pending implementation and verification.

## Next milestone

Update the domain/data model and acceptance criteria for private cost, selling price, service transaction details, commission-based services, profit calculation, returns, education workflows, healthcare workflows, and export/diagnostic capabilities before beginning the production UI implementation.
