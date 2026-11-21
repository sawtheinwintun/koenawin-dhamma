import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../data/koenawin_models.dart';

/// today-task: today's attribute, its meaning, bead rounds, and the done button.
class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.day,
    required this.done,
    required this.onDone,
  });

  final KoeNaWinDay day;
  final bool done;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: AppMotion.counterDuration,
      curve: Easing.standard,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: done ? AppColors.gold : AppColors.secondaryContainer,
        ),
        boxShadow: done ? AppShadows.goldGlow : null,
      ),
      child: Column(
        children: [
          Text(
            day.attribute.name,
            style: text.titleMedium,
            textAlign: TextAlign.center,
          ),
          AnimatedSize(
            duration: AppMotion.counterDuration,
            curve: Easing.standard,
            alignment: Alignment.topCenter,
            child: done
                ? const SizedBox(width: double.infinity)
                : Column(
                    children: [
                      Text(
                        day.attribute.meaning,
                        textAlign: TextAlign.center,
                        style: text.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'ပုတီးစိပ်ရမည့်အပတ်ရေ - (${Myanmar.digits(day.rounds)}) ပတ်',
                        style: text.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      if (day.vegetarian)
                        Text(
                          'ယနေ့ သက်သတ်လွတ်စားရမည့်နေ့ ဖြစ်ပါသည်။',
                          style: text.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSwitcher(
            duration: AppMotion.counterDuration,
            switchInCurve: Easing.emphasizedDecelerate,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 0.92, end: 1.0).animate(animation),
                child: child,
              ),
            ),
            child: done
                ? Container(
                    key: const ValueKey('done'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      'သင် အဓိဋ္ဌာန်ဝင်ပြီးပါပြီ။',
                      style: text.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : FilledButton(
                    key: const ValueKey('todo'),
                    onPressed: onDone,
                    child: const Text('ယနေ့အဓိဋ္ဌာန်ဝင်ပြီးပြီ'),
                  ),
          ),
        ],
      ),
    );
  }
}
