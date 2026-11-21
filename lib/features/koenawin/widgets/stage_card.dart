import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../data/koenawin_models.dart';

/// KoeNaWinStep component: number badge, stage name, its vegetarian weekday, caret.
class StageCard extends StatelessWidget {
  const StageCard({
    super.key,
    required this.stage,
    required this.onTap,
    this.current = false,
  });

  final Stage stage;
  final VoidCallback onTap;

  /// Highlights the stage today falls in.
  final bool current;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: current
          ? AppColors.secondaryContainer
          : AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: current ? AppColors.gold : AppColors.secondaryContainer,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              StepNo(number: stage.number),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stage.name, style: text.titleSmall),
                    Text(
                      '${Myanmar.weekdays[stage.vegetarianDay.weekday]}နေ့ - သက်သတ်လွတ်စားရမည့်နေ့',
                      style: text.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                PhosphorIconsRegular.caretDown,
                size: AppSizes.icon,
                color: AppColors.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepNo extends StatelessWidget {
  const StepNo({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.onSurface,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        Myanmar.digits(number),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onPrimary,
          height: 1.2,
        ),
      ),
    );
  }
}
