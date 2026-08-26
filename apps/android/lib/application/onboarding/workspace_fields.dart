import '../../domain/models/business_profile.dart';

enum OnboardingField {
  name,
  phone,
  address,
  subtype,
}

class WorkspaceFieldConfig {
  const WorkspaceFieldConfig({required this.fields});

  final List<OnboardingField> fields;
}

class WorkspaceFieldRegistry {
  const WorkspaceFieldRegistry._();

  static WorkspaceFieldConfig forBusinessType(BusinessType type) {
    // Retail and trade businesses: core fields only.
    const core = [
      OnboardingField.name,
      OnboardingField.phone,
      OnboardingField.address,
    ];
    // Service businesses: subtype refines the offered service.
    const withSubtype = [
      OnboardingField.name,
      OnboardingField.phone,
      OnboardingField.address,
      OnboardingField.subtype,
    ];
    switch (type) {
      case BusinessType.retail:
      case BusinessType.wholesale:
      case BusinessType.restaurant:
      case BusinessType.pharmacy:
      case BusinessType.mfsRecharge:
      case BusinessType.printingDigital:
      case BusinessType.onlineBusiness:
      case BusinessType.other:
        return const WorkspaceFieldConfig(fields: core);
      case BusinessType.generalShop:
      case BusinessType.service:
      case BusinessType.computerMobileService:
      case BusinessType.institution:
        return const WorkspaceFieldConfig(fields: withSubtype);
    }
  }
}
