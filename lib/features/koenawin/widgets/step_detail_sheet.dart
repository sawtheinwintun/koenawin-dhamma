import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../../../core/widgets/app_sheet.dart';
import '../data/koenawin_models.dart';

/// KoeNaWin / StepDetail: the nine days of a stage. The vegetarian day is highlighted.
Future<void> showStepDetail(
  BuildContext context,
  Stage stage, {
  int? todayNumber,
  int lastCompletedDay = 0,
}) {
  return showAppSheet(
    context,
    title: stage.name,
    scrollable: true,
    builder: (context) {
      final text = Theme.of(context).textTheme;
      return Column(
        children: [
          for (final day in stage.days) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: day.vegetarian
                  ? BoxDecoration(
                      color: AppColors.goldLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    )
                  : null,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Myanmar.weekdays[day.weekday]}နေ့ - ${day.attribute.name}',
                          style: text.titleSmall,
                        ),
                        Text(
                          'ပုတီး (${Myanmar.digits(day.rounds)}) ပတ်'
                          '${day.vegetarian ? ' · သက်သတ်လွတ်စားရမည့်နေ့' : ''}',
                          style: text.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (day.number == todayNumber)
                    _Chip(label: 'ယနေ့')
                  else if (todayNumber != null &&
                      day.number <= lastCompletedDay)
                    const Icon(
                      PhosphorIconsFill.checkCircle,
                      color: AppColors.secondary,
                      size: AppSizes.icon,
                    ),
                ],
              ),
            ),
            // No divider next to the highlighted vegetarian day; stage.days[dayInStage] is the next day.
            if (day != stage.days.last)
              day.vegetarian || stage.days[day.dayInStage].vegetarian
                  ? const SizedBox(height: 1)
                  : const Divider(color: AppColors.secondaryContainer),
          ],
        ],
      );
    },
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary),
      ),
    );
  }
}
