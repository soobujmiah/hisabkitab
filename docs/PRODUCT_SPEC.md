# Songjog (সংযোগ) Product Specification

**Status:** Foundation draft
**Target:** Android-first production app
**Primary market:** Bangladesh small shops, micro-businesses, SMEs, service businesses, educational/training institutions, and healthcare institutions
**Languages:** Bengali first, English supported

## Product identity

Songjog (সংযোগ) is the canonical product name. The previous working name, HisabKitab, is legacy project terminology and must not be used as the current user-facing product identity.

## 1. Product thesis

Songjog should replace scattered paper khata, calculator, notes, spreadsheets, and messaging workflows with one understandable mobile workspace. It must not feel like enterprise software. A user should be able to open the app and immediately understand what needs attention today and what action can be taken next.

The product supports configurable workflows for retail, wholesale, distribution, pharmacy, grocery, garments, electronics, hardware, cosmetics, restaurant/cafe, service businesses, online sellers, freelancers, educational/training institutions, and healthcare institutions.

## 2. Core product pillars

1. **Hisab** — sales, purchases, expenses, income, cash, bank, dues.
2. **Bikri** — fast sales/POS, invoice, receipt, discounts, returns.
3. **Stock** — products, variants, units, purchases, adjustments, low-stock and optional batch/expiry.
4. **People & Relationships** — customers, suppliers, students, guardians, patients, staff, teachers, and service recipients as applicable.
5. **Business Money** — cash accounts, bank accounts, transfers, deposits/withdrawals, reconciliation support.
6. **Reports** — sales, purchases, expenses, gross profit, receivables, payables, stock value, cash movement, and domain-specific reports.
7. **Team** — owner/admin/staff/teacher/employee roles and permissions.
8. **Documents** — invoices, receipts, statements, notices, results, certificates, testimonials, quotations, delivery challans, and other custom documents.
9. **Insights** — actionable summaries, trends, anomalies, and later AI-assisted natural-language analysis.
10. **Settings & Safety** — business/institution profile, data export, backup/sync, security, subscription, support.

## 3. Authentication and entry experience

On first launch show a polished lightweight welcome/login screen with brand identity, value proposition, Log in, Create account, optional demo/tour, language selector, and privacy/terms entry points.

Real business, institution, healthcare, and service functionality requires an authenticated account.

## 4. Configurable organization types

Organization type is configuration, not a separate app. Suggested categories include retail, wholesale, distributor, pharmacy, restaurant/cafe, service business, online seller, freelancer/professional service, educational/training institution, healthcare institution, and other organizations.

The selected type controls recommended modules, terminology, dashboard cards, data fields, workflow shortcuts, and optional advanced features.

### Education/training

Support organization-to-person relationships for students, guardians, teachers, and staff. Institutions can send notices, results, certificates, testimonials, receipts, and custom documents. Guardians may be linked to a student's account with explicit authorization and see permitted student reports.

Student financial records include fees, payments, outstanding balances, and downloadable receipts.

### Service businesses

Support service providers and service recipients as connected parties. Recipients can have service history, invoices, payments, receipts, and relevant documents without requiring the provider to use a separate application.

### Healthcare

Support configurable healthcare workflows including patients, appointments, beds, admissions, staff, doctors, nursing/service records, pharmacy/medicine where applicable, billing, payments, receipts, discharge documents, ambulance records, and operational reports. Healthcare deployments must apply appropriate privacy and access controls.

## 5. Dashboard

The dashboard is adaptive, not a fixed accounting screen. Primary hierarchy: today's position, quick actions, money requiring attention, operational alerts, recent activity, and insights.

## 6. Sales/POS

Requirements include product/service search, barcode where applicable, quantity/unit, variants, customer selection, discounts, cash/partial/credit payment, multiple payment methods, delivery charge where applicable, notes, hold/resume, returns, invoice/receipt generation, sharing, optional printing, and offline transaction creation.

## 7. Purchases and expenses

Support suppliers, products, quantities, purchase price, discounts, additional costs, payment/credit, stock updates, returns, purchase history, configurable expense categories, and cash/bank/mobile-financial-service records where legally and technically appropriate.

## 8. Relationship ledgers

People and organizations can have identity/contact data, opening balance where relevant, transaction timeline, current receivable/payable state, payments, documents, notes, and permitted reminders or relationship links.

## 9. Inventory

Baseline: product name, SKU/barcode, category, unit, purchase price, sale price, stock quantity, minimum stock, active/inactive. Advanced: variants, batch/lot, expiry, damaged/adjustment, valuation, movement ledger, supplier association.

## 10. Documents

Templates must be professional, printable, shareable, and Bengali-safe. Document types are configurable by organization type and may include invoice/cash memo, money receipt, statements, quotations, delivery challan, purchase documents, notices, results, certificates, testimonials, discharge documents, and custom templates.

## 11. Reports and export

Reports must be explainable and traceable to stored records. User data export and diagnostic export are mandatory product capabilities. Diagnostic exports must exclude secrets and credentials.

## 12. Team and permissions

Roles may include Owner, Admin, Manager, Staff, Accountant/Viewer, Teacher, Employee, Doctor, Nurse, and other organization-specific roles. Permissions must be granular by domain and action.

## 13. Notifications

Useful notifications include low stock, due payments, unpaid invoices, important security/account events, sync issues, subscription state, institutional notices, and other explicitly configured operational notifications.

## 14. Offline-first behavior

Core configured operations should remain useful without internet after initial setup. Sync must be conflict-aware and auditable; records must never be silently overwritten.

## 15. Search

Global search should find relevant people, organizations, products, services, invoices, transactions, documents, patients/students where permitted, and other domain records. Bangla/English naming variation should be tolerated where technically feasible.

## 16. AI roadmap

AI is an enhancement, not a dependency for core records. Financial and operational figures remain deterministic and traceable to stored data.

## 17. Monetization

Suggested model: free core entry tier, premium advanced modules/reports/documents/team/automation/backup features, and optional organization-specific plans.

## 18. UX quality bar

Premium quality comes from hierarchy, spacing, typography, motion, responsive feedback, and clarity. Bengali-first and English-first modes remain pure for application-owned UI text.

## 19. Non-functional requirements

Secure authentication/session handling, appropriate encryption, server-side authorization, reliable backups, export capability, auditability, privacy-controlled diagnostic reporting, accessibility basics, responsive phone/tablet layouts, and strong low-end Android performance.

## 20. Definition of a successful MVP

A user can create an account, configure an organization, perform its primary daily workflow, record money and relationship events, generate/share relevant documents, review reports, and export their data without training.
