/// Myanmar digits, weekday and month names.
class Myanmar {
  static const _digits = ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'];

  static String digits(int value) =>
      value.toString().split('').map((c) => _digits[int.parse(c)]).join();

  /// DateTime.weekday (1 = Monday) → Myanmar name.
  static const weekdays = {
    DateTime.monday: 'တနင်္လာ',
    DateTime.tuesday: 'အင်္ဂါ',
    DateTime.wednesday: 'ဗုဒ္ဓဟူး',
    DateTime.thursday: 'ကြာသပတေး',
    DateTime.friday: 'သောကြာ',
    DateTime.saturday: 'စနေ',
    DateTime.sunday: 'တနင်္ဂနွေ',
  };

  static const _months = [
    'ဇန်နဝါရီ', 'ဖေဖော်ဝါရီ', 'မတ်', 'ဧပြီ', 'မေ', 'ဇွန်', //
    'ဇူလိုင်', 'ဩဂုတ်', 'စက်တင်ဘာ', 'အောက်တိုဘာ', 'နိုဝင်ဘာ', 'ဒီဇင်ဘာ',
  ];

  /// e.g. "၂၃ နိုဝင်ဘာ ၂၀၂၆ (တနင်္လာ)"
  static String date(DateTime d) =>
      '${digits(d.day)} ${_months[d.month - 1]} ${digits(d.year)} (${weekdays[d.weekday]})';
}
