class ChildModel {
  final int id;
  final int familyId;
  final String nickname;
  final DateTime birthDate;
  final ChildStatus status;
  final bool isPinLocked;
  final DateTime? pinLockedUntil;
  final int pinFailedAttempts;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildModel({
    required this.id,
    required this.familyId,
    required this.nickname,
    required this.birthDate,
    required this.status,
    this.isPinLocked = false,
    this.pinLockedUntil,
    this.pinFailedAttempts = 0,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as int,
      familyId: json['family_id'] as int? ?? 0, // Default to 0 if not provided
      nickname: json['nickname'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      status: ChildStatus.fromString(json['status'] as String? ?? 'pending'),
      isPinLocked: json['is_pin_locked'] as bool? ?? false,
      pinLockedUntil: json['pin_locked_until'] != null
          ? DateTime.parse(json['pin_locked_until'] as String)
          : null,
      pinFailedAttempts: json['pin_failed_attempts'] as int? ?? 0,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.parse(json['created_at']
              as String), // Fallback to created_at if updated_at is missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_id': familyId,
      'nickname': nickname,
      'birth_date':
          birthDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'status': status.value,
      'is_pin_locked': isPinLocked,
      'pin_locked_until': pinLockedUntil?.toIso8601String(),
      'pin_failed_attempts': pinFailedAttempts,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ChildModel copyWith({
    int? id,
    int? familyId,
    String? nickname,
    DateTime? birthDate,
    ChildStatus? status,
    bool? isPinLocked,
    DateTime? pinLockedUntil,
    int? pinFailedAttempts,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      nickname: nickname ?? this.nickname,
      birthDate: birthDate ?? this.birthDate,
      status: status ?? this.status,
      isPinLocked: isPinLocked ?? this.isPinLocked,
      pinLockedUntil: pinLockedUntil ?? this.pinLockedUntil,
      pinFailedAttempts: pinFailedAttempts ?? this.pinFailedAttempts,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool get isActive => status == ChildStatus.active;
  bool get isPending => status == ChildStatus.pending;
  bool get canLogin => isActive && !isPinLocked;

  String get displayInitial =>
      nickname.isNotEmpty ? nickname[0].toUpperCase() : '?';

  Duration? get timeUntilUnlocked {
    if (!isPinLocked || pinLockedUntil == null) return null;
    final now = DateTime.now();
    if (pinLockedUntil!.isBefore(now)) return Duration.zero;
    return pinLockedUntil!.difference(now);
  }

  String get formattedBirthDate {
    return "${birthDate.year}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.day.toString().padLeft(2, '0')}";
  }
}

enum ChildStatus {
  pending('pending'),
  active('active'),
  inactive('inactive');

  const ChildStatus(this.value);
  final String value;

  static ChildStatus fromString(String value) {
    return ChildStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ChildStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case ChildStatus.pending:
        return 'Pending Setup';
      case ChildStatus.active:
        return 'Active';
      case ChildStatus.inactive:
        return 'Inactive';
    }
  }

  bool get requiresSetup => this == ChildStatus.pending;
  bool get canAuthenticate => this == ChildStatus.active;
}
