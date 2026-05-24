import 'dart:io' show Platform;

import '../models/smart_permission_type.dart';

class PlatformTexts {
  const PlatformTexts._();

  static String explanationTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Required';
    }
    return 'Permissions Required';
  }

  static String retryTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Was Denied';
    }
    return 'Permissions Were Denied';
  }

  static String settingsTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Enable Permission in Settings';
    }
    return 'Enable Permissions in Settings';
  }

  static String successTitle(int permissionCount) {
    if (permissionCount == 1) {
      return 'Permission Ready';
    }
    return 'Permissions Ready';
  }

  static String explanationMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'Review why this access is needed before continuing.';
    }
    return 'Review why these permissions are needed before continuing.';
  }

  static String retryMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'This permission was denied. You can try again to continue.';
    }
    return 'Some permissions were denied. You can try again to continue.';
  }

  static String settingsMessage(int permissionCount) {
    final location = Platform.isIOS ? 'iOS Settings' : 'app settings';
    if (permissionCount == 1) {
      return 'This permission can only be enabled from $location.';
    }
    return 'These permissions can only be enabled from $location.';
  }

  static String successMessage(int permissionCount) {
    if (permissionCount == 1) {
      return 'You are all set. This feature is ready to use.';
    }
    return 'You are all set. These features are ready to use.';
  }

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
