import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../../../core/widgets/app_sheet.dart';
import '../data/koenawin_models.dart';

Text _body(BuildContext context, List<(String, bool)> parts) {
  final style = Theme.of(context).textTheme.bodyMedium;
  return Text.rich(
    TextSpan(
      children: [
        for (final (text, bold) in parts)
          TextSpan(
            text: text,
            style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
          ),
      ],
    ),
    style: style,
    textAlign: TextAlign.center,
  );
}

/// KoeNaWin / ConfirmNewJoiner / CorrectDate
Future<bool> confirmNewJoiner(BuildContext context) async =>
    await showAppSheet<bool>(
      context,
      title: 'အဓိဋ္ဌာန်စတင်ဝင်မည်',
      builder: (context) => Column(
        children: [
          _body(context, [
            (
              'တရားချစ်ခင်သူတော်စင်အနေဖြင့် ကိုးနဝင်းအဓိဋ္ဌာန်ဝင်ရန်သေချာပါသလား။\n'
                  'ရက်ပေါင်း (၈၁) တိတိ မပျက်မကွက် ဆောက်ရွက်ရမည့် ကိစ္စရပ်ဖြစ်သည်။',
              false,
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          const SheetActions(confirmLabel: 'သေချာပါသည်'),
        ],
      ),
    ) ??
    false;

/// KoeNaWin / ConfirmNewJoiner / IncorrectDate
Future<void> showNotMonday(BuildContext context) => showAppSheet<void>(
  context,
  title: 'အဓိဋ္ဌာန်စတင်ဝင်မည်',
  builder: (context) => Column(
    children: [
      _body(context, [
        ('ကိုးနဝင်းအဓိဋ္ဌာန်သည် ', false),
        ('တနင်္လာနေ့', true),
        (' တွင် စတင်ဝင်ရောက်ရခြင်းဖြစ်သည်။\nယနေ့သည် ', false),
        ('တနင်္လာနေ့', true),
        (' မဟုတ်ပါ။', false),
      ]),
      const SizedBox(height: AppSpacing.lg),
      const SheetActions(confirmLabel: 'ကောင်းပြီ', cancelLabel: null),
    ],
  ),
);

/// KoeNaWin / ConfirmOutOfDuty
Future<bool> confirmLeave(BuildContext context) async =>
    await showAppSheet<bool>(
      context,
      title: 'အဓိဋ္ဌာန်ထွက်မည်',
      builder: (context) => Column(
        children: [
          _body(context, [
            ('သင် ကိုးနဝင်းအဓိဋ္ဌာန် ထွက်ရန် သေချာပါသလား။\n', false),
            ('မှတ်တမ်းအားလုံး ပျက်သွားပါမည်။', true),
          ]),
          const SizedBox(height: AppSpacing.lg),
          const SheetActions(confirmLabel: 'သေချာပါသည်'),
        ],
      ),
    ) ??
    false;

/// KoeNaWin / ConfirmMissedDay
Future<void> showMissedDay(BuildContext context, int missedWeekday) {
  final day = '(${Myanmar.weekdays[missedWeekday]}နေ့)';
  return showAppSheet<void>(
    context,
    title: 'အဓိဋ္ဌာန် ပျက်ကွက်သွားပါပြီ',
    builder: (context) => Column(
      children: [
        _body(context, [
          ('', false),
          (day, true),
          (
            ' အဓိဋ္ဌာန် မဝင်ခဲ့သောကြောင့် ကိုးနဝင်းအဓိဋ္ဌာန် ပျက်ကွက်သွားပါပြီ။\n',
            false,
          ),
          ('တနင်္လာနေ့', true),
          (' တွင် အစမှ ပြန်လည်စတင်နိုင်ပါသည်။', false),
        ]),
        const SizedBox(height: AppSpacing.lg),
        const SheetActions(confirmLabel: 'ကောင်းပြီ', cancelLabel: null),
      ],
    ),
  );
}

/// KoeNaWin / ConfirmExistingJoiner: pick the stage, then today's day in it.
/// Returns the chosen day number, or null when cancelled.
Future<int?> chooseResumeDay(
  BuildContext context,
  KoeNaWinData data,
  bool Function(KoeNaWinDay) canResumeOn,
  int todayWeekday,
) => showAppSheet<int>(
  context,
  title: 'အဓိဋ္ဌာန်ဆက်လက်ဝင်မည်',
  scrollable: true,
  builder: (context) => _ResumePicker(
    data: data,
    canResumeOn: canResumeOn,
    todayWeekday: todayWeekday,
  ),
);

class _ResumePicker extends StatefulWidget {
  const _ResumePicker({
    required this.data,
    required this.canResumeOn,
    required this.todayWeekday,
  });

  final KoeNaWinData data;
  final bool Function(KoeNaWinDay) canResumeOn;
  final int todayWeekday;

  @override
  State<_ResumePicker> createState() => _ResumePickerState();
}

class _ResumePickerState extends State<_ResumePicker> {
  Stage? _stage;
  KoeNaWinDay? _day;
  bool _stageOpen = false;
  bool _dayOpen = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Dropdown(
          label: _stage?.name ?? 'အဓိဋ္ဌာန်အဆင့်ရွေးပါ',
          open: _stageOpen,
          onTap: () => setState(() {
            _stageOpen = !_stageOpen;
            _dayOpen = false;
          }),
          children: [
            for (final s in widget.data.stages)
              _Option(
                label: s.name,
                selected: s == _stage,
                onTap: () => setState(() {
                  _stage = s;
                  _day = null;
                  _stageOpen = false;
                  _dayOpen = true;
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Dropdown(
          label: _day == null ? 'ရက်ရွေးပါ' : _dayLabel(_day!),
          open: _dayOpen,
          enabled: _stage != null,
          onTap: () => setState(() {
            _dayOpen = !_dayOpen;
            _stageOpen = false;
          }),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'ယနေ့ (${Myanmar.weekdays[widget.todayWeekday]}နေ့) နှင့် ကိုက်ညီသော ရက်ကိုသာ ရွေးနိုင်ပါသည်။',
                style: text.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            if (_stage != null)
              for (final d in _stage!.days)
                _Option(
                  label: _dayLabel(d),
                  selected: d == _day,
                  enabled: widget.canResumeOn(d),
                  onTap: () => setState(() {
                    _day = d;
                    _dayOpen = false;
                  }),
                ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SheetActions(
          confirmLabel: 'သေချာပါသည်',
          enabled: _day != null,
          onConfirm: () => Navigator.pop(context, _day!.number),
        ),
      ],
    );
  }

  static String _dayLabel(KoeNaWinDay d) =>
      '${Myanmar.digits(d.dayInStage)} ရက်မြောက် – ${Myanmar.weekdays[d.weekday]} – ${d.attribute.name}';
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.open,
    required this.onTap,
    required this.children,
    this.enabled = true,
  });

  final String label;
  final bool open;
  final bool enabled;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.onSurface : AppColors.outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: color),
                  ),
                ),
                Icon(
                  open
                      ? PhosphorIconsRegular.caretUp
                      : PhosphorIconsRegular.caretDown,
                  color: color,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: AppMotion.fadeDuration,
          curve: Easing.emphasizedDecelerate,
          alignment: Alignment.topCenter,
          child: open
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected
        ? AppColors.onPrimary
        : (enabled ? AppColors.onSurface : AppColors.outline);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: selected
            ? AppColors.onSurfaceVariant
            : AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(
            color: enabled ? AppColors.onSurface : AppColors.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.button),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: fg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
