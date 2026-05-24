import 'package:permission_handler/permission_handler.dart';

import '../models/smart_permission_type.dart';

/// Maps [SmartPermissionType] values to `permission_handler` permissions.
class PermissionMapper {
  /// Prevents creating instances of [PermissionMapper].
  const PermissionMapper._();

  /// Returns the `permission_handler` permission for [type].
  static Permission map(SmartPermissionType type) {
    return switch (type) {
      SmartPermissionType.camera => Permission.camera,
      SmartPermissionType.location => Permission.locationWhenInUse,
      SmartPermissionType.microphone => Permission.microphone,
      SmartPermissionType.notification => Permission.notification,
      SmartPermissionType.photos => Permission.photos,
      SmartPermissionType.storage => Permission.storage,
    };
  }
}
