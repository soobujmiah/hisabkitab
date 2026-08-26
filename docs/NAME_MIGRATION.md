# HisabKitab to Songjog Naming Migration

## Canonical product identity

- Product name: **Songjog**
- Bengali name: **সংযোগ**
- Repository: `soobujmiah/songjog`

## Migration rule

`HisabKitab` / `hisabkitab` must not remain as a current product name in user-facing UI, current documentation titles, package metadata, export filenames, or release artifacts.

Historical references may remain only when they are explicitly describing project history, migration provenance, or compatibility behavior.

## Audit findings

A repository-wide search on 2026-08-26 found legacy `HisabKitab`/`hisabkitab` references in the current documentation tree, including:

- `README.md`
- `docs/PRODUCT_SPEC.md`
- `docs/ROADMAP.md`
- `docs/RESEARCH.md`
- `docs/DATA_MODEL.md`
- `docs/BUSINESS_TYPES.md`
- `docs/FINANCIAL_MODEL.md`
- `docs/KNOWLEDGE_RETURN.md`
- `docs/SECURITY.md`
- `docs/DOMAIN_FOUNDATION.md`
- `docs/UX_SYSTEM.md`
- `docs/ARCHITECTURE.md`
- `docs/SYNC_AND_PLATFORM.md`

These references must be classified before replacement: current product identity should become Songjog/সংযোগ; historical/compatibility references should be retained only where semantically necessary.

## Release gate

Before an APK is considered release-ready, search the repository and generated Android artifacts for legacy product-name leakage. No unintended current-facing `HisabKitab` identity may remain.
