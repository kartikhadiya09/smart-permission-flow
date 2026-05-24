import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_permission_flow/smart_permission_flow.dart';

void main() {
  group('SmartPermission constructors', () {
    test('camera constructor creates a camera permission', () {
      final permission = SmartPermission.camera(
        reason: 'Camera access is required to capture profile photos.',
      );

      expect(permission.type, SmartPermissionType.camera);
      expect(permission.title, 'Camera Access');
      expect(
        permission.reason,
        'Camera access is required to capture profile photos.',
      );
      expect(permission.icon, Icons.photo_camera_outlined);
    });

    test('location constructor accepts custom presentation values', () {
      final permission = SmartPermission.location(
        title: 'Precise Location',
        icon: Icons.map_outlined,
        reason: 'Location access is required to show nearby stores.',
      );

      expect(permission.type, SmartPermissionType.location);
      expect(permission.title, 'Precise Location');
      expect(permission.icon, Icons.map_outlined);
    });

    test('result object exposes immutable permission lists', () {
      final camera = SmartPermission.camera(
        reason: 'Camera access is required.',
      );
      final result = SmartPermissionResult.fromLists(
        grantedPermissions: [camera],
        deniedPermissions: const [],
        permanentlyDeniedPermissions: const [],
      );

      expect(result.allGranted, isTrue);
      expect(result.grantedPermissions, [camera]);
      expect(
        () => result.grantedPermissions.add(camera),
        throwsUnsupportedError,
      );
    });

    test('result object tracks denied and permanently denied permissions', () {
      final location = SmartPermission.location(
        reason: 'Location access is required.',
      );
      final notification = SmartPermission.notification(
        reason: 'Notification access is required.',
      );

      final result = SmartPermissionResult.fromLists(
        grantedPermissions: const [],
        deniedPermissions: [location],
        permanentlyDeniedPermissions: [notification],
      );

      expect(result.allGranted, isFalse);
      expect(result.hasDeniedPermissions, isTrue);
      expect(result.hasPermanentlyDeniedPermissions, isTrue);
    });
  });
}
