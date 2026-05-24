import 'package:permission_handler/permission_handler.dart';

/// Helper methods for interpreting `permission_handler` statuses.
class PermissionHelpers {
  /// Prevents creating instances of [PermissionHelpers].
  const PermissionHelpers._();

  /// Whether [status] should be treated as available for app use.
  static bool isGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  /// Whether [status] requires the user to update app settings.
  static bool isPermanentlyDenied(PermissionStatus status) {
    return status.isPermanentlyDenied || status.isRestricted;
  }
}
