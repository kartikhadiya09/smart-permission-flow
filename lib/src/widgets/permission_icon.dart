import 'package:flutter/material.dart';

class PermissionIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final bool elevated;

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
