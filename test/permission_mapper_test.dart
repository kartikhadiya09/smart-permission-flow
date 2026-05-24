import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_permission_flow/smart_permission_flow.dart';

void main() {
  group('PermissionMapper', () {
    test('maps public permission types to permission_handler permissions', () {
      expect(
        PermissionMapper.map(SmartPermissionType.camera),
        Permission.camera,
      );
      expect(
        PermissionMapper.map(SmartPermissionType.location),
        Permission.locationWhenInUse,
      );
      expect(
        PermissionMapper.map(SmartPermissionType.microphone),
        Permission.microphone,
      );
      expect(
        PermissionMapper.map(SmartPermissionType.notification),
        Permission.notification,
      );
      expect(
        PermissionMapper.map(SmartPermissionType.photos),
        Permission.photos,
      );
      expect(
        PermissionMapper.map(SmartPermissionType.storage),
        Permission.storage,
      );
    });
  });
}
