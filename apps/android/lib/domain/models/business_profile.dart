enum WorkspaceKind { business, institution }

enum BusinessType {
  generalShop,
  retail,
  service,
  mfsRecharge,
  printingDigital,
  computerMobileService,
  restaurant,
  pharmacy,
  wholesale,
  onlineBusiness,
  institution,
  other,
}

class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.name,
    required this.workspaceKind,
    required this.businessType,
    this.subtype,
    this.phone,
    this.address,
  });

  final String id;
  final String name;
  final WorkspaceKind workspaceKind;
  final BusinessType businessType;
  final String? subtype;
  final String? phone;
  final String? address;

  @override
  bool operator ==(Object other) =>
      other is BusinessProfile &&
      other.id == id &&
      other.name == name &&
      other.workspaceKind == workspaceKind &&
      other.businessType == businessType &&
      other.subtype == subtype &&
      other.phone == phone &&
      other.address == address;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        workspaceKind,
        businessType,
        subtype,
        phone,
        address,
      );
}
