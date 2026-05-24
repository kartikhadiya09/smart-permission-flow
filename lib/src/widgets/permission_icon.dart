import 'package:flutter/material.dart';

/// Compact icon container used by the built-in permission UI.
///
/// This widget is exported so advanced users can reuse the same icon treatment
/// when composing custom permission experiences.
class PermissionIcon extends StatelessWidget {
  /// Icon displayed inside the container.
  final IconData icon;

  /// Icon color. Defaults to the current theme primary color.
  final Color? color;

  /// Background color behind the icon.
  final Color? backgroundColor;

  /// Square size of the icon container.
  final double size;

  /// Whether to draw a subtle elevation shadow.
  final bool elevated;

  /// Creates a permission icon.
  const PermissionIcon({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 56,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveBackground =
        backgroundColor ?? effectiveColor.withValues(alpha: 0.12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: effectiveColor.withValues(alpha: 0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: effectiveColor, size: size * 0.48),
    );
  }
}
