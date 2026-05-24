import 'package:flutter/material.dart';

@immutable
class SmartPermissionFlowOptions {
  final bool skipExplanation;
  final bool useBottomSheet;
  final bool barrierDismissible;
  final bool showSuccessState;
  final String continueButtonText;
  final String retryButtonText;
  final String openSettingsButtonText;
  final String cancelButtonText;
  final String doneButtonText;
  final Color? primaryColor;
  final Color? successColor;
  final Color? warningColor;
  final Color? sheetBackgroundColor;
  final Color? iconBackgroundColor;
  final BorderRadius? borderRadius;
  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? secondaryButtonStyle;
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;
  final TextStyle? permissionTitleTextStyle;
  final TextStyle? permissionDescriptionTextStyle;

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
