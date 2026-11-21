import 'package:flutter_test/flutter_test.dart';
import 'package:koenawin_dhamma/core/theme/app_theme.dart';
import 'package:koenawin_dhamma/core/theme/app_tokens.dart';

void main() {
  test('theme uses design tokens', () {
    final theme = AppTheme.light;
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.textTheme.bodyMedium?.fontSize, 15);
    expect(theme.textTheme.bodyMedium?.height, closeTo(26 / 15, 0.001));
    expect(theme.extension<AppExtras>(), isNotNull);
  });
}
