# Songjog (সংযোগ) — Android App

Android-first commercial application. Identity is Songjog / সংযোগ;
`HisabKitab` remains only as historical migration terminology
(see `docs/NAME_MIGRATION.md` at the repository root).

## Toolchain (pinned)

- **Flutter 3.47.1** (Dart 3.13.1) — pinned in `.github/workflows/flutter-ci.yml`
  and used for all CI builds. Local development should use the same channel
  (stable) to keep generated scaffolds compatible.
- **AGP 9.1.0 / Gradle 9.3.1 / Kotlin 2.4.0** — from the Flutter 3.47
  Android template (see `android/settings.gradle.kts`).
- `minSdk`/`targetSdk`/`compileSdk` follow the Flutter template defaults
  (`android/app/build.gradle.kts`).

The CI runner uses Java 21 for the Gradle build.

## Build & test

```sh
flutter pub get
flutter analyze
flutter test          # unit + widget tests (SQLite via sqflite_common_ffi, no device needed)
flutter build apk --debug   # produces build/app/outputs/flutter-apk/app-debug.apk
```

CI (`.github/workflows/flutter-ci.yml`) runs analyze, the test suite, a
debug APK build, and a legacy-product-name audit on every push and PR.
The debug APK is uploaded as a build artifact for physical-device testing.

## Structure

- `lib/main.dart` — entry point; global error handlers feed the diagnostic collector
- `lib/app/app_services.dart` — composition root (store, diagnostics, exports, sharing)
- `lib/domain/` — pure Dart domain (models, export service, diagnostics)
- `lib/data/` — SQLite store, persistent diagnostic log, export adapters, sharing
- `lib/application/` — onboarding use cases
- `lib/presentation/` — welcome, onboarding, settings/export screens
- `lib/l10n/app_text.dart` — script-pure Bangla/English UI copy contract

## Release gates

User-data export and diagnostic export are mandatory product capabilities
(`docs/RELEASE_EXPORT_DIAGNOSTICS.md`). Exports are written to the
app-specific external storage `exports/` directory and can be saved or
shared from Settings. Diagnostic exports are secret-redacted by
`DiagnosticRedaction` and include version/build, platform/device, runtime
mode, and bounded structured events (operation ids, errors, stack traces).
