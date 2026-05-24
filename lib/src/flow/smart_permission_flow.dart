import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/smart_permission.dart';
import '../models/smart_permission_flow_options.dart';
import '../models/smart_permission_result.dart';
import '../utils/permission_helpers.dart';
import '../utils/permission_mapper.dart';
import '../utils/platform_texts.dart';
import '../widgets/smart_permission_sheet.dart';

enum _PermissionFlowAction { continueRequest, retry, openSettings, cancel }

/// Entry point for requesting permissions with a guided user experience.
///
/// This class provides a static [request] method that shows explanation UI,
/// requests platform permissions through `permission_handler`, handles retry
/// and settings recovery states, and returns a structured result.
class SmartPermissionFlow {
  /// Prevents creating instances of [SmartPermissionFlow].
  const SmartPermissionFlow._();

  /// Requests one or more permissions using a guided user flow.
  ///
  /// This method automatically:
  /// - shows a permission explanation UI,
  /// - requests permissions,
  /// - handles denied states,
  /// - handles permanently denied states,
  /// - and optionally opens app settings.
  ///
  /// Returns a [SmartPermissionResult] describing the final permission state.
  static Future<SmartPermissionResult> request(
    BuildContext context, {
    required List<SmartPermission> permissions,
    VoidCallback? onAllGranted,
    ValueChanged<SmartPermissionResult>? onResult,
    SmartPermissionFlowOptions options = const SmartPermissionFlowOptions(),
  }) async {
    if (permissions.isEmpty) {
      final result = SmartPermissionResult.fromLists(
        grantedPermissions: const [],
        deniedPermissions: const [],
        permanentlyDeniedPermissions: const [],
      );
      onAllGranted?.call();
      onResult?.call(result);
      return result;
    }

    if (!options.skipExplanation && context.mounted) {
      final action = await _showExplanation(context, permissions, options);
      if (action != _PermissionFlowAction.continueRequest) {
        return _complete(
          SmartPermissionResult.fromLists(
            grantedPermissions: const [],
            deniedPermissions: permissions,
            permanentlyDeniedPermissions: const [],
          ),
          onResult: onResult,
        );
      }
    }

    final granted = <SmartPermission>[];
    final denied = <SmartPermission>[];
    final permanentlyDenied = <SmartPermission>[];

    for (final permission in permissions) {
      final status = await PermissionMapper.map(permission.type).request();

      if (PermissionHelpers.isGranted(status)) {
        granted.add(permission);
      } else if (PermissionHelpers.isPermanentlyDenied(status)) {
        permanentlyDenied.add(permission);
      } else {
        denied.add(permission);
      }
    }

    if (denied.isNotEmpty && context.mounted) {
      final action = await _showRetry(context, denied, options);
      if (action == _PermissionFlowAction.retry) {
        if (!context.mounted) {
          return _complete(
            SmartPermissionResult.fromLists(
              grantedPermissions: granted,
              deniedPermissions: denied,
              permanentlyDeniedPermissions: permanentlyDenied,
            ),
            onResult: onResult,
          );
        }

        final retryResult = await request(
          context,
          permissions: denied,
          options: options.copyWith(skipExplanation: true),
        );
        granted.addAll(retryResult.grantedPermissions);
        denied
          ..clear()
          ..addAll(retryResult.deniedPermissions);
        permanentlyDenied.addAll(retryResult.permanentlyDeniedPermissions);
      }
    }

    if (permanentlyDenied.isNotEmpty && context.mounted) {
      final action = await _showSettings(context, permanentlyDenied, options);
      if (action == _PermissionFlowAction.openSettings) {
        await openAppSettings();
      }
    }

    final result = SmartPermissionResult.fromLists(
      grantedPermissions: granted,
      deniedPermissions: denied,
      permanentlyDeniedPermissions: permanentlyDenied,
    );

    if (result.allGranted && options.showSuccessState && context.mounted) {
      await _showSuccess(context, granted, options);
    }

    if (result.allGranted) {
      onAllGranted?.call();
    }

    return _complete(result, onResult: onResult);
  }

  static Future<_PermissionFlowAction?> _showExplanation(
    BuildContext context,
    List<SmartPermission> permissions,
    SmartPermissionFlowOptions options,
  ) {
    return _showPermissionUi(
      context,
      permissions: permissions,
      options: options,
      mode: _PermissionUiMode.explanation,
    );
  }

  static Future<_PermissionFlowAction?> _showRetry(
    BuildContext context,
    List<SmartPermission> permissions,
    SmartPermissionFlowOptions options,
  ) {
    return _showPermissionUi(
      context,
      permissions: permissions,
      options: options,
      mode: _PermissionUiMode.retry,
    );
  }

  static Future<_PermissionFlowAction?> _showSettings(
    BuildContext context,
    List<SmartPermission> permissions,
    SmartPermissionFlowOptions options,
  ) {
    return _showPermissionUi(
      context,
      permissions: permissions,
      options: options,
      mode: _PermissionUiMode.settings,
    );
  }

  static Future<_PermissionFlowAction?> _showSuccess(
    BuildContext context,
    List<SmartPermission> permissions,
    SmartPermissionFlowOptions options,
  ) {
    return _showPermissionUi(
      context,
      permissions: permissions,
      options: options,
      mode: _PermissionUiMode.success,
    );
  }

  static Future<_PermissionFlowAction?> _showPermissionUi(
    BuildContext context, {
    required List<SmartPermission> permissions,
    required SmartPermissionFlowOptions options,
    required _PermissionUiMode mode,
  }) {
    if (options.useBottomSheet) {
      return showModalBottomSheet<_PermissionFlowAction>(
        context: context,
        isScrollControlled: true,
        showDragHandle: false,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black54,
        isDismissible: options.barrierDismissible,
        enableDrag: options.barrierDismissible,
        builder: (sheetContext) {
          return SmartPermissionSheet(
            permissions: permissions,
            options: options,
            showRetry: mode == _PermissionUiMode.retry,
            showOpenSettings: mode == _PermissionUiMode.settings,
            showSuccess: mode == _PermissionUiMode.success,
            onContinue: () => Navigator.of(
              sheetContext,
            ).pop(_PermissionFlowAction.continueRequest),
            onRetry: () =>
                Navigator.of(sheetContext).pop(_PermissionFlowAction.retry),
            onOpenSettings: () => Navigator.of(
              sheetContext,
            ).pop(_PermissionFlowAction.openSettings),
            onCancel: () =>
                Navigator.of(sheetContext).pop(_PermissionFlowAction.cancel),
            onDone: () =>
                Navigator.of(sheetContext).pop(_PermissionFlowAction.cancel),
          );
        },
      );
    }

    return showDialog<_PermissionFlowAction>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      builder: (dialogContext) {
        return _PermissionDialog(
          permissions: permissions,
          options: options,
          mode: mode,
          onAction: (action) => Navigator.of(dialogContext).pop(action),
        );
      },
    );
  }

  static SmartPermissionResult _complete(
    SmartPermissionResult result, {
    ValueChanged<SmartPermissionResult>? onResult,
  }) {
    onResult?.call(result);
    return result;
  }
}

enum _PermissionUiMode { explanation, retry, settings, success }

extension on SmartPermissionFlowOptions {
  SmartPermissionFlowOptions copyWith({bool? skipExplanation}) {
    return SmartPermissionFlowOptions(
      skipExplanation: skipExplanation ?? this.skipExplanation,
      useBottomSheet: useBottomSheet,
      barrierDismissible: barrierDismissible,
      showSuccessState: showSuccessState,
      continueButtonText: continueButtonText,
      retryButtonText: retryButtonText,
      openSettingsButtonText: openSettingsButtonText,
      cancelButtonText: cancelButtonText,
      doneButtonText: doneButtonText,
      primaryColor: primaryColor,
      successColor: successColor,
      warningColor: warningColor,
      sheetBackgroundColor: sheetBackgroundColor,
      iconBackgroundColor: iconBackgroundColor,
      borderRadius: borderRadius,
      primaryButtonStyle: primaryButtonStyle,
      secondaryButtonStyle: secondaryButtonStyle,
      titleTextStyle: titleTextStyle,
      messageTextStyle: messageTextStyle,
      permissionTitleTextStyle: permissionTitleTextStyle,
      permissionDescriptionTextStyle: permissionDescriptionTextStyle,
    );
  }
}

class _PermissionDialog extends StatelessWidget {
  final List<SmartPermission> permissions;
  final SmartPermissionFlowOptions options;
  final _PermissionUiMode mode;
  final ValueChanged<_PermissionFlowAction> onAction;

  const _PermissionDialog({
    required this.permissions,
    required this.options,
    required this.mode,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message),
            const SizedBox(height: 16),
            for (final permission in permissions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(permission.icon),
                title: Text(permission.title),
                subtitle: Text(permission.reason),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => onAction(_PermissionFlowAction.cancel),
          child: Text(options.cancelButtonText),
        ),
        FilledButton(
          onPressed: () => onAction(_primaryAction),
          child: Text(_primaryText),
        ),
      ],
    );
  }

  String get _title {
    return switch (mode) {
      _PermissionUiMode.explanation => PlatformTexts.explanationTitle(
          permissions.length,
        ),
      _PermissionUiMode.retry => PlatformTexts.retryTitle(permissions.length),
      _PermissionUiMode.settings => PlatformTexts.settingsTitle(
          permissions.length,
        ),
      _PermissionUiMode.success => PlatformTexts.successTitle(
          permissions.length,
        ),
    };
  }

  String get _message {
    return switch (mode) {
      _PermissionUiMode.explanation => PlatformTexts.explanationMessage(
          permissions.length,
        ),
      _PermissionUiMode.retry => PlatformTexts.retryMessage(permissions.length),
      _PermissionUiMode.settings => PlatformTexts.settingsMessage(
          permissions.length,
        ),
      _PermissionUiMode.success => PlatformTexts.successMessage(
          permissions.length,
        ),
    };
  }

  _PermissionFlowAction get _primaryAction {
    return switch (mode) {
      _PermissionUiMode.explanation => _PermissionFlowAction.continueRequest,
      _PermissionUiMode.retry => _PermissionFlowAction.retry,
      _PermissionUiMode.settings => _PermissionFlowAction.openSettings,
      _PermissionUiMode.success => _PermissionFlowAction.cancel,
    };
  }

  String get _primaryText {
    return switch (mode) {
      _PermissionUiMode.explanation => options.continueButtonText,
      _PermissionUiMode.retry => options.retryButtonText,
      _PermissionUiMode.settings => options.openSettingsButtonText,
      _PermissionUiMode.success => options.doneButtonText,
    };
  }
}
