# Brand and Localization Policy

## Brand

- Working product brand: **Songjog**
- Bengali display name: **সংযোগ**
- English display name: **Songjog**
- The logo asset will be supplied separately and must not be replaced with a generated placeholder.
- Repository renaming and package/application identity changes are deferred until brand availability and release readiness are verified.

## Product language

The product supports Bengali and English as first-class UI languages.

### Bengali mode

All application-authored UI text must be Bengali. No English UI letters are permitted in Bengali mode.

### English mode

All application-authored UI text must be English. No Bengali UI letters are permitted in English mode.

### User-owned data exception

Names, business names, product names, identifiers, email addresses, URLs, transaction references and other user-entered/external values are data, not translated UI labels. Their original representation is preserved.

## Documentation language

Engineering, architecture, API, security, licensing and repository documentation will use English as the canonical documentation language for precision and collaboration. Product-facing copy remains subject to the UI language policy.

## Localization quality gate

Every new feature must provide both Bengali and English UI strings. CI/release validation should detect missing translations and unexpected script mixing in application-authored strings.
