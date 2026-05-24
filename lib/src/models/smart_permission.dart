import 'package:flutter/material.dart';

import 'smart_permission_type.dart';

/// Describes a permission request shown by the smart permission flow.
///
/// A permission includes the platform permission [type], a user-facing
/// [reason], and presentation details such as [title] and [icon].
@immutable
class SmartPermission {
  /// The permission category to request.
  final SmartPermissionType type;

  /// A short explanation shown before the system permission prompt.
  final String reason;

  /// The title shown in the permission explanation UI.
  final String title;

  /// The icon used to visually represent this permission.
  final IconData icon;

  /// Creates a custom smart permission descriptor.
  const SmartPermission({
    required this.type,
    required this.reason,
    required this.title,
    required this.icon,
  });

  /// Creates a camera permission request.
  ///
  /// Use this when a feature needs camera access for taking photos,
  /// scanning codes, or capturing media.
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

  /// Creates a location permission request.
  ///
  /// This maps to foreground location access through `permission_handler`.
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

  /// Creates a microphone permission request.
  ///
  /// Use this when recording voice, audio notes, or media with sound.
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

  /// Creates a notification permission request.
  ///
  /// This is especially relevant on iOS and Android 13 or newer.
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

  /// Creates a photo library permission request.
  ///
  /// Use this when users need to select images or media from their device.
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

  /// Creates a storage permission request.
  ///
  /// Use this for file-based flows that require storage access.
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
