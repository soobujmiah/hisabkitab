# Songjog Hospital Management Specification

## Scope

Hospital and clinic workflows are a first-class workspace capability. The common identity, relationship, transaction, payment, document, reporting and permission engines are reused, while clinical workflows remain isolated from ordinary retail/service workflows.

## Core hospital areas

### Patient management

- Patient registration and unique patient ID
- Demographics and contact information
- Emergency contact / guardian
- Optional medical identifiers
- Visit history
- Admission and discharge history
- Referring source
- Patient documents

### Bed and ward management

- Ward/department
- Room
- Bed
- Bed availability status
- Occupancy
- Admission assignment
- Bed transfer
- Discharge and bed release
- Bed/room charge configuration

### Clinical service workflow

- Outpatient visit
- Inpatient admission
- Emergency visit
- Doctor consultation
- Nursing/service entries
- Procedures
- Diagnostic/laboratory service entries
- Imaging service entries
- Pharmacy/medicine charges where legally and operationally appropriate
- Service packages
- Referrals

The system is an administrative/financial management platform. It must not make autonomous clinical diagnoses or treatment decisions.

### Billing and payments

- Patient invoice
- Service-wise charges
- Bed/room charges
- Doctor/service charges
- Diagnostic charges
- Medicine/product charges where configured
- Discounts
- Partial payment
- Due
- Refund
- Payment methods
- Payment references
- Receipt number
- Patient/guardian receipt copy
- Daily/monthly/yearly revenue reports

Actual cost and internal margin remain private to authorized management roles.

### Ambulance

- Ambulance registry
- Vehicle/identifier
- Driver assignment
- Trip record
- Pickup/drop-off details
- Patient reference
- Emergency/non-emergency classification
- Distance/route fields where useful
- Fare configuration
- Fuel/operating cost for authorized internal accounting
- Payment/receipt
- Ambulance availability/status

### Staff and payroll

- Doctor
- Nurse
- Technician
- Reception/admin staff
- Driver
- Other staff roles
- Attendance foundation
- Salary/payments
- Advance
- Allowance
- Deduction
- Salary statement/receipt

Role permissions must prevent staff from seeing unrelated payroll, financial or patient information.

### Documents

Configurable professional documents may include:

- Admission form
- Patient receipt
- Invoice
- Payment statement
- Discharge-related administrative document
- Test/report attachment where supplied by the institution
- Referral document
- Ambulance receipt
- Salary statement
- Custom institutional documents

Documents must support multi-page pagination with consistent headers/footers and must not expose private financial fields to patients.

## Privacy and access control

Hospital data is sensitive. Access must be explicitly role-scoped and workspace-scoped.

- Patient-facing accounts see only their permitted records.
- Guardian access is relationship- and consent-aware.
- Doctors/staff receive only the minimum necessary information for their assigned function.
- Financial administrators do not automatically receive unrestricted clinical information.
- Clinical staff do not automatically receive unrestricted payroll or business-owner financial data.
- Audit logs record sensitive administrative changes.
- Data export follows authorization rules.

## MVP boundary

The Owner Edition should establish the hospital workspace/domain model and core administrative/financial workflows without delaying the first general business release. Clinical records and advanced hospital integrations can be phased after the core commercial release.

## Safety boundary

This product manages administrative, financial and operational workflows. It is not a medical device, diagnostic engine, or substitute for qualified clinical judgment. Any future clinical functionality requires a separate safety, regulatory and privacy review before release.
