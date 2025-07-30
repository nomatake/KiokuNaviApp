import 'user_model.dart';
import 'family_model.dart';
import 'child_model.dart';

/// Authentication result model for API responses
class AuthResult {
  final String? token;
  final String? sessionToken;
  final String? provisionalToken;
  final UserModel? user;
  final ChildModel? child;
  final FamilyModel? family;
  final String? message;

  AuthResult({
    this.token,
    this.sessionToken,
    this.provisionalToken,
    this.user,
    this.child,
    this.family,
    this.message,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    return AuthResult(
      token: data?['token'] as String?,
      sessionToken: data?['session_token'] as String?,
      provisionalToken: data?['provisional_token'] as String?,
      user: data?['user'] != null
          ? UserModel.fromJson(data!['user'] as Map<String, dynamic>)
          : null,
      child: data?['child'] != null
          ? ChildModel.fromJson(data!['child'] as Map<String, dynamic>)
          : null,
      family: data?['family'] != null
          ? FamilyModel.fromJson(data!['family'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  bool get isSuccess => token != null || sessionToken != null;
  bool get hasUser => user != null;
  bool get hasChild => child != null;
  bool get hasFamily => family != null;
}

/// OTP verification model
class OtpVerification {
  final String email;
  final String otp;

  OtpVerification({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

/// Parent profile completion model
class ParentProfileCompletion {
  final String tempToken;
  final String name;
  final String password;
  final String passwordConfirmation;
  final DeviceMode deviceMode;

  ParentProfileCompletion({
    required this.tempToken,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
    required this.deviceMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'temp_token': tempToken,
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'device_mode': deviceMode.value,
    };
  }
}

/// Child join request model
class ChildJoinRequest {
  final String code;
  final DeviceInfo deviceInfo;

  ChildJoinRequest({
    required this.code,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'device_fingerprint': deviceInfo.fingerprint,
      'device_platform': deviceInfo.platform,
      'device_version': deviceInfo.version,
      'device_model': deviceInfo.model,
    };
  }
}

/// Child PIN setup model
class ChildPinSetup {
  final String provisionalToken;
  final String pin;

  ChildPinSetup({
    required this.provisionalToken,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'provisional_token': provisionalToken,
      'pin': pin,
    };
  }
}

/// Child PIN authentication model
class ChildPinAuth {
  final int childId;
  final String pin;
  final DeviceInfo deviceInfo;

  ChildPinAuth({
    required this.childId,
    required this.pin,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'child_id': childId,
      'pin': pin,
      'device_fingerprint': deviceInfo.fingerprint,
      'device_platform': deviceInfo.platform,
      'device_version': deviceInfo.version,
      'device_model': deviceInfo.model,
    };
  }
}

/// Device information model
class DeviceInfo {
  final String fingerprint;
  final String platform;
  final String version;
  final String model;

  DeviceInfo({
    required this.fingerprint,
    required this.platform,
    required this.version,
    required this.model,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      fingerprint: json['fingerprint'] as String,
      platform: json['platform'] as String,
      version: json['version'] as String,
      model: json['model'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fingerprint': fingerprint,
      'platform': platform,
      'version': version,
      'model': model,
    };
  }

  Map<String, String> toHeaders() {
    return {
      'X-Device-Fingerprint': fingerprint,
      'X-Device-Platform': platform,
      'X-Device-Version': version,
      'X-Device-Model': model,
    };
  }
}

/// Join code model
class JoinCode {
  final String code;
  final String childNickname;
  final int expiresInMinutes;
  final DateTime expiresAt;

  JoinCode({
    required this.code,
    required this.childNickname,
    required this.expiresInMinutes,
    required this.expiresAt,
  });

  factory JoinCode.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    final code = json['join_code'] as String? ?? json['code'] as String;
    final childData = json['child'] as Map<String, dynamic>?;
    final childNickname = childData?['nickname'] as String? ?? 'Child';
    final expiresInMinutes = json['expires_in_minutes'] as int;

    // Calculate expires_at if not provided
    final expiresAt = json['expires_at'] != null
        ? DateTime.parse(json['expires_at'] as String)
        : DateTime.now().add(Duration(minutes: expiresInMinutes));

    return JoinCode(
      code: code,
      childNickname: childNickname,
      expiresInMinutes: expiresInMinutes,
      expiresAt: expiresAt,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get formattedCode {
    // Format as XXX-XXX for better readability
    if (code.length == 6) {
      return '${code.substring(0, 3)}-${code.substring(3)}';
    }
    return code;
  }
}

/// Authentication state for app management
class AuthState {
  final bool isAuthenticated;
  final UserModel? currentUser;
  final ChildModel? currentChild;
  final FamilyModel? currentFamily;
  final List<ChildModel> familyChildren;
  final DeviceMode? deviceMode;
  final String? authToken;
  final String? sessionToken;

  AuthState({
    this.isAuthenticated = false,
    this.currentUser,
    this.currentChild,
    this.currentFamily,
    this.familyChildren = const [],
    this.deviceMode,
    this.authToken,
    this.sessionToken,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? currentUser,
    ChildModel? currentChild,
    FamilyModel? currentFamily,
    List<ChildModel>? familyChildren,
    DeviceMode? deviceMode,
    String? authToken,
    String? sessionToken,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      currentChild: currentChild ?? this.currentChild,
      currentFamily: currentFamily ?? this.currentFamily,
      familyChildren: familyChildren ?? this.familyChildren,
      deviceMode: deviceMode ?? this.deviceMode,
      authToken: authToken ?? this.authToken,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  bool get isParentAuthenticated =>
      isAuthenticated && currentUser != null && currentUser!.isParent;
  bool get isChildAuthenticated => isAuthenticated && currentChild != null;
  bool get hasFamily => currentFamily != null;
  bool get isPersonalDevice => deviceMode == DeviceMode.personal;
  bool get isSharedDevice => deviceMode == DeviceMode.shared;
}
