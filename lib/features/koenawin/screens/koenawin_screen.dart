import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../../../core/widgets/stagger_in.dart';
import '../logic/koenawin_controller.dart';
import '../widgets/confirm_sheets.dart';
import '../widgets/stage_card.dart';
import '../widgets/step_detail_sheet.dart';
import '../widgets/today_card.dart';
import 'completed_screen.dart';

/// KoeNaWin / DisplayStep (not joined) and KoeNaWin / StartJoin (joined).
class KoeNaWinScreen extends StatefulWidget {
  const KoeNaWinScreen({super.key});

  @override
  State<KoeNaWinScreen> createState() => _KoeNaWinScreenState();
}

class _KoeNaWinScreenState extends State<KoeNaWinScreen> {
  bool _showingCompletion = false;

  void _handleEvents(KoeNaWinController c) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final missed = c.missedWeekday();
      if (missed != null) {
        c.consumeMissed();
        await showMissedDay(context, missed);
      }
      if (c.status == KoeNaWinStatus.completed &&
          !_showingCompletion &&
          mounted) {
        _showingCompletion = true;
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: AppMotion.pageDuration,
            pageBuilder: (context, _, _) => CompletedScreen(
              startDate: c.startDate!,
              endDate: c.endDate!,
              onBackHome: () {
                c.acknowledgeCompletion();
                Navigator.of(context).pop();
              },
            ),
            transitionsBuilder: (_, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
        _showingCompletion = false;
      }
    });
  }

  Future<void> _startNew(KoeNaWinController c) async {
    if (!c.isMonday) return showNotMonday(context);
    if (await confirmNewJoiner(context)) await c.startNew();
  }

  Future<void> _resume(KoeNaWinController c) async {
    final day = await chooseResumeDay(
      context,
      c.data,
      c.canResumeOn,
      c.today.weekday,
    );
    if (day != null) await c.resumeAt(day);
  }

  Future<void> _leave(KoeNaWinController c) async {
    if (await confirmLeave(context)) await c.leave();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<KoeNaWinController>();
    if (c.status == KoeNaWinStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    _handleEvents(c);

    final text = Theme.of(context).textTheme;
    final today = c.todayDay;
    final joined = c.status == KoeNaWinStatus.active && today != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        if (joined) ...[
          Text.rich(
            TextSpan(
              text: 'ယနေ့ဝင်ရမည့်အဓိဋ္ဌာန် ',
              style: text.titleMedium,
              children: [
                TextSpan(
                  text:
                      '(${c.data.stages[today.stage - 1].name} - ${Myanmar.weekdays[today.weekday]}နေ့)',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TodayCard(day: today, done: c.doneToday, onDone: c.markTodayDone),
          const SizedBox(height: AppSpacing.xl),
        ] else ...[
          Text('ကိုးနဝင်းအဓိဋ္ဌာန်အဆင့်များ', style: text.titleMedium),
          const SizedBox(height: AppSpacing.md),
        ],
        for (final (i, stage) in c.data.stages.indexed) ...[
          StaggerIn(
            index: i,
            child: StageCard(
              stage: stage,
              current: joined && stage.number == today.stage,
              onTap: () => showStepDetail(
                context,
                stage,
                todayNumber: joined ? today.number : null,
                lastCompletedDay: c.lastCompletedDay,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        if (joined)
          FilledButton(
            onPressed: () => _leave(c),
            child: const Text('အဓိဋ္ဌာန်ထွက်မည်'),
          )
        else ...[
          FilledButton(
            onPressed: () => _startNew(c),
            child: const Text('အဓိဋ္ဌာန်စတင်ဝင်မည်'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => _resume(c),
            child: const Text('အဓိဋ္ဌာန်ဆက်ဝင်မည်'),
          ),
        ],
      ],
    );
  }
}
