import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../../../core/widgets/stagger_in.dart';
import '../data/gatha.dart';
import '../logic/reading_settings.dart';

Route<void> _route(List<Gatha> gathas, int index) => PageRouteBuilder(
  transitionDuration: AppMotion.pageDuration,
  pageBuilder: (_, _, _) => GathaScreen(gathas: gathas, index: index),
  // App/PageEnter: slides in from 30px right and fades in
  transitionsBuilder: (_, animation, _, child) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Easing.emphasizedDecelerate,
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0.07, 0),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  },
);

void openGatha(BuildContext context, List<Gatha> gathas, int index) =>
    Navigator.of(context).push(_route(gathas, index));

/// Dhamma / Metta (and every other gatha): text, size controls, previous/next.
class GathaScreen extends StatelessWidget {
  const GathaScreen({super.key, required this.gathas, required this.index});

  final List<Gatha> gathas;
  final int index;

  Gatha get gatha => gathas[index];

  void _go(BuildContext context, int to) =>
      Navigator.of(context).pushReplacement(_route(gathas, to));

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ReadingSettings>();
    final text = Theme.of(context).textTheme;
    final body = text.bodyLarge!.copyWith(
      fontSize: text.bodyLarge!.fontSize! * settings.scale,
    );
    final heading = text.titleSmall!.copyWith(
      fontSize: text.titleSmall!.fontSize! * settings.scale,
    );
    final hasPrev = index > 0;
    final hasNext = index < gathas.length - 1;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'နောက်သို့',
          icon: const Icon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(gatha.title, style: text.titleMedium),
        actions: [
          IconButton(
            tooltip: 'စာလုံး သေးမည်',
            onPressed: settings.canShrink ? () => settings.change(-1) : null,
            icon: const Icon(PhosphorIconsRegular.magnifyingGlassMinus),
          ),
          IconButton(
            tooltip: 'စာလုံး ကြီးမည်',
            onPressed: settings.canGrow ? () => settings.change(1) : null,
            icon: const Icon(PhosphorIconsRegular.magnifyingGlassPlus),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            for (final (i, item) in gatha.items.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: StaggerIn(
                  index: i < 8 ? i : 8,
                  child: item.isHeading
                      ? Text(
                          item.text,
                          style: heading,
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          item.number == null
                              ? gatha.display(item)
                              : '${Myanmar.digits(item.number!)}။ ${gatha.display(item)}',
                          style: body,
                        ),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (hasPrev)
                  Expanded(
                    child: _NavButton(
                      label: gathas[index - 1].title,
                      icon: PhosphorIconsRegular.caretLeft,
                      onTap: () => _go(context, index - 1),
                    ),
                  ),
                if (hasPrev && hasNext) const SizedBox(width: AppSpacing.md),
                if (hasNext)
                  Expanded(
                    child: _NavButton(
                      label: gathas[index + 1].title,
                      icon: PhosphorIconsRegular.caretRight,
                      trailing: true,
                      onTap: () => _go(context, index + 1),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.trailing = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool trailing;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 18);
    final labelWidget = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: trailing
            ? [labelWidget, const SizedBox(width: AppSpacing.xs), iconWidget]
            : [iconWidget, const SizedBox(width: AppSpacing.xs), labelWidget],
      ),
    );
  }
}
