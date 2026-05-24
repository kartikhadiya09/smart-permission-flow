import 'package:flutter/material.dart';

import 'smart_permission_type.dart';

@immutable
class SmartPermission {
  final SmartPermissionType type;
  final String reason;
  final String title;
  final IconData icon;

  const SmartPermission({
    required this.type,
    required this.reason,
    required this.title,
    required this.icon,
  });

  factory SmartPermission.camera({
    required String reason,
    String title = 'Camera Access',
    IconData icon = Icons.photo_camera_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.camera,
      reason: reason,
      title: title,
      icon: icon,
    );
  }

  factory SmartPermission.location({
    required String reason,
    String title = 'Location Access',
    IconData icon = Icons.location_on_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.location,
      reason: reason,
      title: title,
      icon: icon,
    );
  }

  factory SmartPermission.microphone({
    required String reason,
    String title = 'Microphone Access',
    IconData icon = Icons.mic_none_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.microphone,
      reason: reason,
      title: title,
      icon: icon,
    );
  }

  factory SmartPermission.notification({
    required String reason,
    String title = 'Notification Access',
    IconData icon = Icons.notifications_none_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.notification,
      reason: reason,
      title: title,
      icon: icon,
    );
  }

  factory SmartPermission.photos({
    required String reason,
    String title = 'Photo Library Access',
    IconData icon = Icons.photo_library_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.photos,
      reason: reason,
      title: title,
      icon: icon,
    );
  }

  factory SmartPermission.storage({
    required String reason,
    String title = 'Storage Access',
    IconData icon = Icons.folder_outlined,
  }) {
    return SmartPermission(
      type: SmartPermissionType.storage,
      reason: reason,
      title: title,
      icon: icon,
    );
  }
}
