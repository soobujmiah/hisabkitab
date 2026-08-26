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
    switch (type) {
      case BusinessType.retail:
        return const WorkspaceFieldConfig(fields: [
          OnboardingField.name,
          OnboardingField.phone,
          OnboardingField.address,
        ]);
      case BusinessType.service:
        return const WorkspaceFieldConfig(fields: [
          OnboardingField.name,
          OnboardingField.phone,
          OnboardingField.address,
          OnboardingField.subtype,
        ]);
      case BusinessType.education:
        return const WorkspaceFieldConfig(fields: [
          OnboardingField.name,
          OnboardingField.phone,
          OnboardingField.address,
          OnboardingField.subtype,
        ]);
      case BusinessType.healthcare:
        return const WorkspaceFieldConfig(fields: [
          OnboardingField.name,
          OnboardingField.phone,
          OnboardingField.address,
          OnboardingField.subtype,
        ]);
      case BusinessType.other:
        return const WorkspaceFieldConfig(fields: [
          OnboardingField.name,
          OnboardingField.phone,
          OnboardingField.address,
        ]);
    }
  }
}
