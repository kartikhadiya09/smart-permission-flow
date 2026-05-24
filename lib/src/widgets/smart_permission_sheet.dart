import 'package:flutter/material.dart';

import '../models/smart_permission.dart';
import '../models/smart_permission_flow_options.dart';
import '../utils/platform_texts.dart';
import 'permission_action_buttons.dart';
import 'permission_icon.dart';

class SmartPermissionSheet extends StatefulWidget {
  final List<SmartPermission> permissions;
  final SmartPermissionFlowOptions options;
  final VoidCallback? onContinue;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onDone;
  final bool showRetry;
  final bool showOpenSettings;
  final bool showSuccess;

  const SmartPermissionSheet({
    super.key,
    required this.permissions,
    this.options = const SmartPermissionFlowOptions(),
    this.onContinue,
    this.onCancel,
    this.onRetry,
    this.onOpenSettings,
    this.onDone,
    this.showRetry = false,
    this.showOpenSettings = false,
    this.showSuccess = false,
  });

  @override
  State<SmartPermissionSheet> createState() => _SmartPermissionSheetState();
}

class _SmartPermissionSheetState extends State<SmartPermissionSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.985, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.options;
    final tint = _stateColor(theme);
    final background =
        options.sheetBackgroundColor ?? theme.colorScheme.surfaceContainerLow;
    final borderRadius = options.borderRadius ??
        const BorderRadius.vertical(top: Radius.circular(24));

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _fade,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha:
                            theme.brightness == Brightness.dark ? 0.32 : 0.12,
                      ),
                      blurRadius: 26,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.72,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      14 + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _DragIndicator(color: theme.colorScheme.outlineVariant),
                        const SizedBox(height: 14),
                        PermissionIcon(
                          icon: _stateIcon,
                          color: tint,
                          backgroundColor: widget.options.iconBackgroundColor ??
                              tint.withValues(alpha: 0.10),
                          size: 56,
                          elevated: false,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _title,
                          textAlign: TextAlign.center,
                          style: options.titleTextStyle ??
                              theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.12,
                                color: theme.colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: options.messageTextStyle ??
                              theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.32,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: _PermissionList(
                            permissions: widget.permissions,
                            options: options,
                            tint: tint,
                          ),
                        ),
                        const SizedBox(height: 16),
                        PermissionActionButtons(
                          options: options,
                          showRetry: widget.showRetry,
                          showOpenSettings: widget.showOpenSettings,
                          showSuccess: widget.showSuccess,
                          onCancel: widget.onCancel,
                          onContinue: widget.onContinue,
                          onRetry: widget.onRetry,
                          onOpenSettings: widget.onOpenSettings,
                          onDone: widget.onDone,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _title {
    if (widget.showSuccess) {
      return PlatformTexts.successTitle(widget.permissions.length);
    }
    if (widget.showOpenSettings) {
      return PlatformTexts.settingsTitle(widget.permissions.length);
    }
    if (widget.showRetry) {
      return PlatformTexts.retryTitle(widget.permissions.length);
    }
    return PlatformTexts.explanationTitle(widget.permissions.length);
  }

  String get _message {
    if (widget.showSuccess) {
      return PlatformTexts.successMessage(widget.permissions.length);
    }
    if (widget.showOpenSettings) {
      return PlatformTexts.settingsMessage(widget.permissions.length);
    }
    if (widget.showRetry) {
      return PlatformTexts.retryMessage(widget.permissions.length);
    }
    return PlatformTexts.explanationMessage(widget.permissions.length);
  }

  IconData get _stateIcon {
    if (widget.showSuccess) {
      return Icons.check_rounded;
    }
    if (widget.showOpenSettings) {
      return Icons.settings_outlined;
    }
    if (widget.showRetry) {
      return Icons.refresh_rounded;
    }
    if (widget.permissions.length == 1) {
      return widget.permissions.first.icon;
    }
    return Icons.verified_user_outlined;
  }

  Color _stateColor(ThemeData theme) {
    if (widget.showSuccess) {
      return widget.options.successColor ?? const Color(0xFF16A34A);
    }
    if (widget.showOpenSettings || widget.showRetry) {
      return widget.options.warningColor ?? const Color(0xFFD97706);
    }
    return widget.options.primaryColor ?? theme.colorScheme.primary;
  }
}

class _DragIndicator extends StatelessWidget {
  final Color color;

  const _DragIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _PermissionList extends StatelessWidget {
  final List<SmartPermission> permissions;
  final SmartPermissionFlowOptions options;
  final Color tint;

  const _PermissionList({
    required this.permissions,
    required this.options,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.58),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: permissions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            indent: 62,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          itemBuilder: (context, index) {
            return _AnimatedPermissionRow(
              index: index,
              permission: permissions[index],
              options: options,
              tint: tint,
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedPermissionRow extends StatelessWidget {
  final int index;
  final SmartPermission permission;
  final SmartPermissionFlowOptions options;
  final Color tint;

  const _AnimatedPermissionRow({
    required this.index,
    required this.permission,
    required this.options,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + index * 35),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 6 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _PermissionRow(
        permission: permission,
        options: options,
        tint: tint,
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final SmartPermission permission;
  final SmartPermissionFlowOptions options;
  final Color tint;

  const _PermissionRow({
    required this.permission,
    required this.options,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PermissionIcon(
            icon: permission.icon,
            color: tint,
            backgroundColor:
                options.iconBackgroundColor ?? tint.withValues(alpha: 0.09),
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission.title,
                  style: options.permissionTitleTextStyle ??
                      theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.18,
                        color: theme.colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  permission.reason.isEmpty
                      ? PlatformTexts.defaultMessage(permission.type)
                      : permission.reason,
                  style: options.permissionDescriptionTextStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.28,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
