import 'package:flutter/material.dart';

/// Presentation and behavior options for permission requests.
///
/// Use this class to customize copy, colors, sheet style, button styles, and
/// typography without replacing the built-in permission flow.
@immutable
class SmartPermissionFlowOptions {
  /// Skips the package explanation UI and requests permissions immediately.
  final bool skipExplanation;

  /// Shows the flow in a bottom sheet when true, otherwise uses dialogs.
  final bool useBottomSheet;

  /// Whether users can dismiss the sheet or dialog by tapping outside.
  final bool barrierDismissible;

  /// Whether to show a success state after all permissions are granted.
  final bool showSuccessState;

  /// Text for the initial action that continues to the system prompt.
  final String continueButtonText;

  /// Text for the action that retries denied permissions.
  final String retryButtonText;

  /// Text for the action that opens app settings.
  final String openSettingsButtonText;

  /// Text for the secondary cancel action.
  final String cancelButtonText;

  /// Text for the success-state completion action.
  final String doneButtonText;

  /// Primary brand color used for icons and primary actions.
  final Color? primaryColor;

  /// Color used for granted or success states.
  final Color? successColor;

  /// Color used for retry and settings recovery states.
  final Color? warningColor;

  /// Background color for the permission sheet surface.
  final Color? sheetBackgroundColor;

  /// Background color for permission icons.
  final Color? iconBackgroundColor;

  /// Border radius applied to the sheet or dialog container.
  final BorderRadius? borderRadius;

  /// Custom style for the primary action button.
  final ButtonStyle? primaryButtonStyle;

  /// Custom style for the secondary text button.
  final ButtonStyle? secondaryButtonStyle;

  /// Custom text style for sheet and dialog titles.
  final TextStyle? titleTextStyle;

  /// Custom text style for sheet and dialog descriptions.
  final TextStyle? messageTextStyle;

  /// Custom text style for individual permission titles.
  final TextStyle? permissionTitleTextStyle;

  /// Custom text style for individual permission descriptions.
  final TextStyle? permissionDescriptionTextStyle;

  /// Creates permission flow options.
  const SmartPermissionFlowOptions({
    this.skipExplanation = false,
    this.useBottomSheet = true,
    this.barrierDismissible = true,
    this.showSuccessState = true,
    this.continueButtonText = 'Continue',
    this.retryButtonText = 'Try Again',
    this.openSettingsButtonText = 'Open Settings',
    this.cancelButtonText = 'Not Now',
    this.doneButtonText = 'Done',
    this.primaryColor,
    this.successColor,
    this.warningColor,
    this.sheetBackgroundColor,
    this.iconBackgroundColor,
    this.borderRadius,
    this.primaryButtonStyle,
    this.secondaryButtonStyle,
    this.titleTextStyle,
    this.messageTextStyle,
    this.permissionTitleTextStyle,
    this.permissionDescriptionTextStyle,
  });
}
