import 'package:flutter/material.dart';
import 'package:smart_permission_flow/smart_permission_flow.dart';

void main() {
  runApp(const SmartPermissionExampleApp());
}

class SmartPermissionExampleApp extends StatelessWidget {
  const SmartPermissionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF375DFB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Permission Flow Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF7F8FB),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8EA2FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1018),
      ),
      home: const PermissionShowcaseHome(),
    );
  }
}

class PermissionShowcaseHome extends StatefulWidget {
  const PermissionShowcaseHome({super.key});

  @override
  State<PermissionShowcaseHome> createState() => _PermissionShowcaseHomeState();
}

class _PermissionShowcaseHomeState extends State<PermissionShowcaseHome> {
  SmartPermissionResult? _lastResult;
  String _lastAction = 'Ready';

  Future<void> _requestPermissions(
    String action,
    List<SmartPermission> permissions,
  ) async {
    final theme = Theme.of(context);
    final result = await SmartPermissionFlow.request(
      context,
      permissions: permissions,
      options: SmartPermissionFlowOptions(
        primaryColor: const Color(0xFF375DFB),
        successColor: const Color(0xFF16A34A),
        warningColor: const Color(0xFFD97706),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.12,
        ),
        messageTextStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.32,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _lastAction = action;
      _lastResult = result;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          result.allGranted
              ? 'Permissions are ready.'
              : 'Permission flow completed.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 28 : 16,
            vertical: 16,
          ),
          children: [
            const _ShowcaseHeader(),
            const SizedBox(height: 14),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _DemoGrid(onRun: _requestPermissions),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: _ResultPanel(
                      action: _lastAction,
                      result: _lastResult,
                    ),
                  ),
                ],
              )
            else ...[
              _DemoGrid(onRun: _requestPermissions),
              const SizedBox(height: 14),
              _ResultPanel(action: _lastAction, result: _lastResult),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShowcaseHeader extends StatelessWidget {
  const _ShowcaseHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return _Surface(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TintIcon(
            icon: Icons.verified_user_outlined,
            color: const Color(0xFF375DFB),
            size: 44,
            iconSize: 23,
            radius: 13,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Permission Flow',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Compact, modern permission UX for production Flutter apps.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(label: 'Material 3', dark: dark),
                    _Tag(label: 'Retry flow', dark: dark),
                    _Tag(label: 'Settings recovery', dark: dark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoGrid extends StatelessWidget {
  final Future<void> Function(String action, List<SmartPermission> permissions)
      onRun;

  const _DemoGrid({required this.onRun});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 540;

        return GridView.builder(
          itemCount: _demos.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: twoColumns ? 2 : 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 124,
          ),
          itemBuilder: (context, index) {
            final demo = _demos[index];
            return _DemoCard(
              demo: demo,
              onPressed: () => onRun(demo.title, demo.permissions),
            );
          },
        );
      },
    );
  }

  List<_PermissionDemo> get _demos {
    return [
      _PermissionDemo(
        title: 'Camera',
        subtitle: 'Capture profile photos',
        icon: Icons.photo_camera_outlined,
        color: const Color(0xFF375DFB),
        permissions: [
          SmartPermission.camera(
            reason: 'Camera access is required to capture profile photos.',
          ),
        ],
      ),
      _PermissionDemo(
        title: 'Location',
        subtitle: 'Show nearby stores',
        icon: Icons.location_on_outlined,
        color: const Color(0xFF0F766E),
        permissions: [
          SmartPermission.location(
            reason: 'Location access is required to show nearby stores.',
          ),
        ],
      ),
      _PermissionDemo(
        title: 'Notifications',
        subtitle: 'Send account updates',
        icon: Icons.notifications_none_outlined,
        color: const Color(0xFF7C3AED),
        permissions: [
          SmartPermission.notification(
            reason: 'Notification access is required to send account updates.',
          ),
        ],
      ),
      _PermissionDemo(
        title: 'Full flow',
        subtitle: 'Camera, location, notifications',
        icon: Icons.bolt_outlined,
        color: const Color(0xFFEA580C),
        permissions: [
          SmartPermission.camera(
            reason: 'Camera access is required to capture profile photos.',
          ),
          SmartPermission.location(
            reason: 'Location access is required to show nearby stores.',
          ),
          SmartPermission.notification(
            reason: 'Notification access is required to send order updates.',
          ),
        ],
      ),
    ];
  }
}

class _DemoCard extends StatefulWidget {
  final _PermissionDemo demo;
  final VoidCallback onPressed;

  const _DemoCard({required this.demo, required this.onPressed});

  @override
  State<_DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<_DemoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerCancel: (_) => setState(() => _pressed = false),
      onPointerUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        scale: _pressed ? 0.99 : 1,
        child: _Surface(
          padding: const EdgeInsets.all(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onPressed,
            child: Row(
              children: [
                _TintIcon(
                  icon: widget.demo.icon,
                  color: widget.demo.color,
                  size: 44,
                  iconSize: 23,
                  radius: 13,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.demo.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.demo.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _CountBadge(count: widget.demo.permissions.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final String action;
  final SmartPermissionResult? result;

  const _ResultPanel({required this.action, required this.result});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _Surface(
        key: ValueKey(result == null ? 'empty' : action),
        padding: const EdgeInsets.all(16),
        child: result == null
            ? const _EmptyState()
            : _CompletedState(action: action, result: result!),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _TintIcon(
          icon: Icons.insights_outlined,
          color: theme.colorScheme.primary,
          size: 42,
          iconSize: 22,
          radius: 12,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Result preview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Run a flow to see the compact result summary.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompletedState extends StatelessWidget {
  final String action;
  final SmartPermissionResult result;

  const _CompletedState({required this.action, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = result.allGranted
        ? const Color(0xFF16A34A)
        : result.hasPermanentlyDeniedPermissions
            ? const Color(0xFFD97706)
            : const Color(0xFF375DFB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _TintIcon(
              icon: result.allGranted
                  ? Icons.check_rounded
                  : result.hasPermanentlyDeniedPermissions
                      ? Icons.settings_outlined
                      : Icons.refresh_rounded,
              color: color,
              size: 42,
              iconSize: 22,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.allGranted
                        ? 'Everything is ready.'
                        : 'Some permissions need follow-up.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Granted',
                value: result.grantedPermissions.length,
                color: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                label: 'Denied',
                value: result.deniedPermissions.length,
                color: const Color(0xFF375DFB),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Metric(
                label: 'Settings',
                value: result.permanentlyDeniedPermissions.length,
                color: const Color(0xFFD97706),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Surface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _Surface({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Material(
      color: dark ? const Color(0xFF171B26) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.58),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.18 : 0.045),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _TintIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double radius;

  const _TintIcon({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool dark;

  const _Tag({required this.label, required this.dark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionDemo {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<SmartPermission> permissions;

  const _PermissionDemo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.permissions,
  });
}
