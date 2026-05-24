import 'dart:io' show Platform;

import '../models/smart_permission_type.dart';

/// Default English copy used by the built-in permission UI.
class PlatformTexts {
  /// Prevents creating instances of [PlatformTexts].
  const PlatformTexts._();

  /// Returns the explanation title for the number of requested permissions.
  static String explanationTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Required';
    }
    return 'Permissions Required';
  }

  /// Returns the retry title for denied permissions.
  static String retryTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Was Denied';
    }
    return 'Permissions Were Denied';
  }

  /// Returns the settings recovery title for permanently denied permissions.
  static String settingsTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Enable Permission in Settings';
    }
    return 'Enable Permissions in Settings';
  }

  /// Returns the success title for granted permissions.
  static String successTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Ready';
    }
    return 'Permissions Ready';
  }

  /// Returns the explanation message for requested permissions.
  static String explanationMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'Review why this access is needed before continuing.';
    }
    return 'Review why these permissions are needed before continuing.';
  }

  /// Returns the retry message for denied permissions.
  static String retryMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'This permission was denied. You can try again to continue.';
    }
    return 'Some permissions were denied. You can try again to continue.';
  }

  /// Returns the settings recovery message for permanently denied permissions.
  static String settingsMessage(int permissionCount) {
    final location = Platform.isIOS ? 'iOS Settings' : 'app settings';
    if (permissionCount == 1) {
      return 'This permission can only be enabled from $location.';
    }
    return 'These permissions can only be enabled from $location.';
  }

  /// Returns the success message for granted permissions.
  static String successMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'You are all set. This feature is ready to use.';
    }
    return 'You are all set. These features are ready to use.';
  }

  /// Returns the default permission title for [type].
  static String defaultTitle(SmartPermissionType type) {
    return switch (type) {
      SmartPermissionType.camera => 'Camera Access',
      SmartPermissionType.location => 'Location Access',
      SmartPermissionType.microphone => 'Microphone Access',
      SmartPermissionType.notification => 'Notification Access',
      SmartPermissionType.photos => 'Photo Library Access',
      SmartPermissionType.storage => 'Storage Access',
    };
  }

  /// Returns the default permission explanation for [type].
  static String defaultMessage(SmartPermissionType type) {
    return switch (type) {
      SmartPermissionType.camera =>
        'Camera access is used to capture photos from inside the app.',
      SmartPermissionType.location =>
        'Location access is used to show nearby and location-aware results.',
      SmartPermissionType.microphone =>
        'Microphone access is used to record audio when you choose to do so.',
      SmartPermissionType.notification => Platform.isIOS
          ? 'Notification access is used to send timely updates on iOS.'
          : 'Notification access is used to send timely updates.',
      SmartPermissionType.photos => Platform.isIOS
          ? 'Photo library access is used to let you choose images from your library.'
          : 'Photos access is used to let you choose images from your device.',
      SmartPermissionType.storage =>
        'Storage access is used to read and save files you select.',
    };
  }
}
