import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Bottom sheet shell from Figma: gold handle, centred title, content below.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  bool scrollable = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.pageDuration,
      curve: Easing.emphasizedDecelerate,
      reverseCurve: Easing.emphasizedAccelerate,
    ),
    builder: (context) {
      final content = Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: builder(context),
      );
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (scrollable)
              Flexible(child: SingleChildScrollView(child: content))
            else
              content,
          ],
        ),
      );
    },
  );
}

/// Cancel / confirm pair used at the bottom of confirmation sheets.
class SheetActions extends StatelessWidget {
  const SheetActions({
    super.key,
    required this.confirmLabel,
    this.cancelLabel = 'ပယ်ဖျက်မည်',
    this.onConfirm,
    this.enabled = true,
  });

  final String confirmLabel;
  final String? cancelLabel;

  /// Defaults to closing the sheet with `true`.
  final VoidCallback? onConfirm;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (cancelLabel != null) ...[
          Expanded(
            child: OutlinedButton(
              // Closes with null so it works for sheets of any result type.
              onPressed: () => Navigator.pop(context),
              child: Text(cancelLabel!),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          child: FilledButton(
            onPressed: !enabled
                ? null
                : onConfirm ?? () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
