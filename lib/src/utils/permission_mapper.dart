import 'package:permission_handler/permission_handler.dart';

import '../models/smart_permission_type.dart';

class PermissionMapper {
  const PermissionMapper._();

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
