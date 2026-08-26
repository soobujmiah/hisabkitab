import '../../data/repositories/business_repository.dart';
import '../../domain/models/business_profile.dart';

class OnboardingService {
  const OnboardingService(this._repository);

  final BusinessRepository _repository;

  Future<BusinessProfile?> existingProfile() => _repository.getProfile();

  Future<BusinessProfile> createOwnerWorkspace({
    required String name,
    required WorkspaceKind workspaceKind,
    required BusinessType businessType,
    String? subtype,
    String? phone,
    String? address,
  }) async {
    final profile = BusinessProfile(
      id: _newId(),
      name: name.trim(),
      workspaceKind: workspaceKind,
      businessType: businessType,
      subtype: _optional(subtype),
      phone: _optional(phone),
      address: _optional(address),
    );
    if (profile.name.isEmpty) {
      throw ArgumentError('Workspace name is required.');
    }
    await _repository.saveProfile(profile);
    return profile;
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  String? _optional(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
