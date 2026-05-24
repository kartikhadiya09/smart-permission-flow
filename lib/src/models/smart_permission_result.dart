import 'package:meta/meta.dart';

import 'smart_permission.dart';

/// Final outcome returned by the smart permission flow.
///
/// The result separates granted, denied, and permanently denied permissions so
/// apps can decide how to continue after the guided flow completes.
@immutable
class SmartPermissionResult {
  /// Whether every requested permission was granted.
  final bool allGranted;

  /// Permissions that were granted or treated as usable by the platform.
  final List<SmartPermission> grantedPermissions;

  /// Permissions that were denied but may be requested again.
  final List<SmartPermission> deniedPermissions;

  /// Permissions that require the user to enable access in app settings.
  final List<SmartPermission> permanentlyDeniedPermissions;

  /// Creates a permission result.
  const SmartPermissionResult({
    required this.allGranted,
    required this.grantedPermissions,
    required this.deniedPermissions,
    required this.permanentlyDeniedPermissions,
  });

  /// Creates an immutable result from permission lists.
  ///
  /// [allGranted] is computed from the denied and permanently denied lists.
  factory SmartPermissionResult.fromLists({
    required List<SmartPermission> grantedPermissions,
    required List<SmartPermission> deniedPermissions,
    required List<SmartPermission> permanentlyDeniedPermissions,
  }) {
    return SmartPermissionResult(
      allGranted:
          deniedPermissions.isEmpty && permanentlyDeniedPermissions.isEmpty,
      grantedPermissions: List.unmodifiable(grantedPermissions),
      deniedPermissions: List.unmodifiable(deniedPermissions),
      permanentlyDeniedPermissions: List.unmodifiable(
        permanentlyDeniedPermissions,
      ),
    );
  }

  /// Whether one or more permissions can still be retried.
  bool get hasDeniedPermissions => deniedPermissions.isNotEmpty;

  /// Whether one or more permissions require app settings.
  bool get hasPermanentlyDeniedPermissions =>
      permanentlyDeniedPermissions.isNotEmpty;
}
