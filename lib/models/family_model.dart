class FamilyModel {
  final int id;
  final String familyCode; // 8-character family identifier
  final DeviceMode deviceMode;
  final int primaryParentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyModel({
    required this.id,
    required this.familyCode,
    required this.deviceMode,
    required this.primaryParentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] as int,
      familyCode: json['family_code'] as String,
      deviceMode:
          DeviceMode.fromString(json['device_mode'] as String? ?? 'personal'),
      primaryParentId: json['primary_parent_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_code': familyCode,
      'device_mode': deviceMode.value,
      'primary_parent_id': primaryParentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FamilyModel copyWith({
    int? id,
    String? familyCode,
    DeviceMode? deviceMode,
    int? primaryParentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      familyCode: familyCode ?? this.familyCode,
      deviceMode: deviceMode ?? this.deviceMode,
      primaryParentId: primaryParentId ?? this.primaryParentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPersonalDevice => deviceMode == DeviceMode.personal;
  bool get isSharedDevice => deviceMode == DeviceMode.shared;
}

enum DeviceMode {
  personal('personal'),
  shared('shared');

  const DeviceMode(this.value);
  final String value;

  static DeviceMode fromString(String value) {
    return DeviceMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => DeviceMode.personal,
    );
  }

  String get displayName {
    switch (this) {
      case DeviceMode.personal:
        return 'Personal Device';
      case DeviceMode.shared:
        return 'Shared Device';
    }
  }

  String get description {
    switch (this) {
      case DeviceMode.personal:
        return 'One family per device with auto-login';
      case DeviceMode.shared:
        return 'Multiple families can use this device';
    }
  }
}
