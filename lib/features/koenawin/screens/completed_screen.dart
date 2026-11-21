import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';

/// KoeNaWin / Completed: shown once after day 81 is marked done, then back to the start page.
class CompletedScreen extends StatelessWidget {
  const CompletedScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onBackHome,
  });

  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rows = [
      ('စတင်ခဲ့သည့်ရက်', Myanmar.date(startDate)),
      ('ပြည့်မြောက်သည့်ရက်', Myanmar.date(endDate)),
      ('ဆောက်တည်ခဲ့သည့်အဆင့်', '(၉) ဆင့် · (၈၁) ရက်'),
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: AppMotion.splashDuration,
                      curve: Easing.emphasizedDecelerate,
                      builder: (_, t, child) => Transform.rotate(
                        angle: (1 - t) * -1.5708,
                        child: Opacity(opacity: t, child: child),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.goldGlow,
                        ),
                        child: SvgPicture.asset(
                          'assets/branding/logo.svg',
                          width: 240,
                          height: 240,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'ကိုးနဝင်းအဓိဋ္ဌာန် ပြည့်မြောက်ပါပြီ',
                      textAlign: TextAlign.center,
                      style: text.headlineMedium?.copyWith(
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'ရက်ပေါင်း (၈၁) ရက်ကို ပြည့်ပြည့်စုံစုံ\nဆောက်တည်နိုင်ခဲ့ပါပြီ။\nသာဓု သာဓု သာဓု',
                      textAlign: TextAlign.center,
                      style: text.bodyLarge?.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.goldLight.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        children: [
                          for (final (label, value) in rows)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xs,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      label,
                                      style: text.bodySmall?.copyWith(
                                        color: AppColors.goldLight,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    value,
                                    style: text.bodySmall?.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: onBackHome,
                      child: const Text('ပင်မစာမျက်နှာသို့ ပြန်သွားမည်'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
