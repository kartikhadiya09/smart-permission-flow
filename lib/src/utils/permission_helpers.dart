import 'package:permission_handler/permission_handler.dart';

class PermissionHelpers {
  const PermissionHelpers._();

  static bool isGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  static bool isPermanentlyDenied(PermissionStatus status) {
    return status.isPermanentlyDenied || status.isRestricted;
  }
}
