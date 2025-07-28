import '../../models/auth_models.dart';
import '../../models/child_model.dart';
import '../../models/family_model.dart';
import '../../models/user_model.dart';

abstract class AuthApi {
  // === Parent Authentication Methods ===

  /// Pre-register parent with email (Step 1 of parent registration)
  /// Returns response with OTP sent confirmation
  Future<Map<String, dynamic>> preRegisterParent(String email);

  /// Verify email with OTP (Step 2 of parent registration)
  /// Returns temporary token for profile completion
  Future<AuthResult> verifyEmail(String email, String otp);

  /// Complete parent profile and create family (Step 3 of parent registration)
  /// Returns full authentication with JWT token
  Future<AuthResult> completeParentProfile(ParentProfileCompletion profileData);

  /// Login parent with email and password
  /// Returns Laravel response: { "data": { "token": "...", "user": {...}, "family": {...} } }
  Future<AuthResult> loginParent(String email, String password);

  // === Child Authentication Methods ===

  /// Join family with join code (Step 1 of child onboarding)
  /// Returns provisional token for PIN setup
  Future<AuthResult> joinWithCode(ChildJoinRequest request);

  /// Set up child PIN (Step 2 of child onboarding)
  /// Returns session token and activates child account
  Future<AuthResult> setChildPin(ChildPinSetup pinData);

  /// Authenticate child with PIN (daily login)
  /// Returns session token
  Future<AuthResult> authenticateChildWithPin(ChildPinAuth pinAuth);

  /// Get children profiles for device (shared device mode)
  /// Returns list of children associated with device
  Future<List<ChildModel>> getChildrenForDevice(String deviceFingerprint);

  // === Family Management Methods ===

  /// Get family information with children
  /// Returns family data with children list
  Future<Map<String, dynamic>> getFamilyInfo();

  /// Add new child to family
  /// Returns child profile with PENDING status
  Future<ChildModel> addChild(String nickname, DateTime birthDate);

  /// Update child information
  /// Returns updated child profile
  Future<ChildModel> updateChild(int childId,
      {String? nickname, DateTime? birthDate});

  /// Generate join code for child
  /// Returns 6-digit code with 10-minute expiration
  Future<JoinCode> generateJoinCode(int childId);

  /// Delete/remove child from family
  /// Returns success confirmation
  Future<void> removeChild(int childId);

  // === Session Management Methods ===

  /// Validate parent token
  /// Returns user data if token is valid
  Future<UserModel> validateParentToken(String token);

  /// Validate child session
  /// Returns child data if session is valid
  Future<ChildModel> validateChildSession(String sessionToken);

  /// Refresh session token
  /// Returns new session token
  Future<String> refreshSession();

  /// Logout current user (parent or child)
  Future<void> logout();

  /// Logout child session specifically
  Future<void> logoutChild();

  // === Legacy Methods (for backward compatibility) ===

  /// Login student with email and password (legacy)
  /// Returns Laravel response: { "data": { "token": "...", "user": {...} } }
  Future<Map<String, dynamic>> loginStudent(String email, String password);

  /// Register user with name, email, password, password confirmation and date of birth (legacy)
  /// Returns Laravel response: { "data": { "token": "...", "user": {...} } }
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String dateOfBirth,
  );

  /// Get current authenticated user data (legacy)
  Future<Map<String, dynamic>> getCurrentUser();

  // === Device Management ===

  /// Register device with family (for personal device mode)
  Future<void> registerDevice(String deviceFingerprint, int familyId);

  /// Unregister device from family
  Future<void> unregisterDevice(String deviceFingerprint);

  /// Get device mode for family
  Future<DeviceMode> getDeviceMode(int familyId);

  /// Update family device mode
  Future<void> updateDeviceMode(int familyId, DeviceMode deviceMode);
}
