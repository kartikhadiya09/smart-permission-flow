import 'package:meta/meta.dart';

import 'smart_permission.dart';

@immutable
class SmartPermissionResult {
  final bool allGranted;
  final List<SmartPermission> grantedPermissions;
  final List<SmartPermission> deniedPermissions;
  final List<SmartPermission> permanentlyDeniedPermissions;

  const SmartPermissionResult({
    required this.allGranted,
    required this.grantedPermissions,
    required this.deniedPermissions,
    required this.permanentlyDeniedPermissions,
  });

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

  bool get hasDeniedPermissions => deniedPermissions.isNotEmpty;

  bool get hasPermanentlyDeniedPermissions =>
      permanentlyDeniedPermissions.isNotEmpty;
}
