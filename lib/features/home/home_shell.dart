import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../dhamma/screens/all_dhamma_screen.dart';
import '../koenawin/screens/koenawin_screen.dart';
import '../video/screens/video_list_screen.dart';

/// The three main tabs, with the floating menu_tab from Figma.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = [
    (
      label: 'ကိုးနဝင်း',
      regular: PhosphorIconsRegular.handsPraying,
      fill: PhosphorIconsFill.handsPraying,
    ),
    (
      label: 'တရားတော်',
      regular: PhosphorIconsRegular.flowerLotus,
      fill: PhosphorIconsFill.flowerLotus,
    ),
    (
      label: 'ဗီဒီယို',
      regular: PhosphorIconsRegular.video,
      fill: PhosphorIconsFill.video,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Dark status-bar icons on the cream background (Splash switches them to light).
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _index,
            children: const [
              KoeNaWinScreen(),
              AllDhammaScreen(),
              VideoListScreen(),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              0,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _MenuButton(
                      label: _tabs[i].label,
                      icon: i == _index ? _tabs[i].fill : _tabs[i].regular,
                      selected: i == _index,
                      onTap: () => setState(() => _index = i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    final text = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: AppMotion.pressDuration,
          curve: Easing.standard,
          height: 68,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSizes.icon, color: color),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: (selected ? text.labelLarge : text.labelMedium)
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
