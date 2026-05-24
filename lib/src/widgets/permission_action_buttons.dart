import 'package:flutter/material.dart';

import '../models/smart_permission_flow_options.dart';

/// Action button group used by the built-in permission sheet.
///
/// The widget adapts the primary button label and icon for explanation, retry,
/// settings, and success states.
class PermissionActionButtons extends StatelessWidget {
  /// Visual and text options for the permission flow.
  final SmartPermissionFlowOptions options;

  /// Called when the secondary cancel action is pressed.
  final VoidCallback? onCancel;

  /// Called when the user continues from the explanation step.
  final VoidCallback? onContinue;

  /// Called when the user retries denied permissions.
  final VoidCallback? onRetry;

  /// Called when the user chooses to open app settings.
  final VoidCallback? onOpenSettings;

  /// Called when the success state is dismissed.
  final VoidCallback? onDone;

  /// Whether the buttons should show retry copy and behavior.
  final bool showRetry;

  /// Whether the buttons should show settings recovery copy and behavior.
  final bool showOpenSettings;

  /// Whether the buttons should show success completion copy and behavior.
  final bool showSuccess;

  /// Creates permission action buttons.
  const PermissionActionButtons({
    super.key,
    required this.options,
    this.onCancel,
    this.onContinue,
    this.onRetry,
    this.onOpenSettings,
    this.onDone,
    this.showRetry = false,
    this.showOpenSettings = false,
    this.showSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showSuccess) {
      return _PressableButton(
        child: FilledButton.icon(
          style: _primaryStyle(theme),
          onPressed: onDone,
          icon: const Icon(Icons.check_rounded),
          label: Text(options.doneButtonText),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PressableButton(
          child: FilledButton.icon(
            style: _primaryStyle(theme),
            onPressed: _primaryAction,
            icon: Icon(_primaryIcon),
            label: Text(_primaryText),
          ),
        ),
        const SizedBox(height: 6),
        _PressableButton(
          pressedScale: 0.99,
          child: TextButton(
            style: options.secondaryButtonStyle ??
                TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  textStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
            onPressed: onCancel,
            child: Text(options.cancelButtonText),
          ),
        ),
      ],
    );
  }

  ButtonStyle _primaryStyle(ThemeData theme) {
    final primaryColor = options.primaryColor ?? theme.colorScheme.primary;

    return options.primaryButtonStyle ??
        FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        );
  }

  VoidCallback? get _primaryAction {
    if (showOpenSettings) {
      return onOpenSettings;
    }
    if (showRetry) {
      return onRetry;
    }
    return onContinue;
  }

  IconData get _primaryIcon {
    if (showOpenSettings) {
      return Icons.settings_outlined;
    }
    if (showRetry) {
      return Icons.refresh_rounded;
    }
    return Icons.arrow_forward_rounded;
  }

  String get _primaryText {
    if (showOpenSettings) {
      return options.openSettingsButtonText;
    }
    if (showRetry) {
      return options.retryButtonText;
    }
    return options.continueButtonText;
  }
}

class _PressableButton extends StatefulWidget {
  final Widget child;
  final double pressedScale;

  const _PressableButton({
    required this.child,
    this.pressedScale = 0.97,
  });

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerCancel: (_) => setState(() => _pressed = false),
      onPointerUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        scale: _pressed ? widget.pressedScale : 1,
        child: widget.child,
      ),
    );
  }
}
