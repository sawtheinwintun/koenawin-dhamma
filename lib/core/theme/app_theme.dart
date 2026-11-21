import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_tokens.dart';

const _font = 'Pyidaungsu';

TextStyle _style(double size, double lineHeight, FontWeight weight) =>
    TextStyle(
      fontFamily: _font,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: 0,
    );

const _regular = FontWeight.w400;
const _bold = FontWeight.w700;

/// App/ text styles and colors that Material has no slot for.
@immutable
class AppExtras extends ThemeExtension<AppExtras> {
  const AppExtras({
    required this.gatha,
    required this.counter,
    required this.gold,
    required this.goldLight,
    required this.yogiDark,
  });

  final TextStyle gatha;
  final TextStyle counter;
  final Color gold;
  final Color goldLight;
  final Color yogiDark;

  static AppExtras of(BuildContext context) =>
      Theme.of(context).extension<AppExtras>()!;

  @override
  AppExtras copyWith({
    TextStyle? gatha,
    TextStyle? counter,
    Color? gold,
    Color? goldLight,
    Color? yogiDark,
  }) => AppExtras(
    gatha: gatha ?? this.gatha,
    counter: counter ?? this.counter,
    gold: gold ?? this.gold,
    goldLight: goldLight ?? this.goldLight,
    yogiDark: yogiDark ?? this.yogiDark,
  );

  @override
  AppExtras lerp(AppExtras? other, double t) => other == null
      ? this
      : AppExtras(
          gatha: TextStyle.lerp(gatha, other.gatha, t)!,
          counter: TextStyle.lerp(counter, other.counter, t)!,
          gold: Color.lerp(gold, other.gold, t)!,
          goldLight: Color.lerp(goldLight, other.goldLight, t)!,
          yogiDark: Color.lerp(yogiDark, other.yogiDark, t)!,
        );
}

class AppTheme {
  static const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.secondary,
    onTertiary: AppColors.onSecondary,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
  );

  static final textTheme = TextTheme(
    displayLarge: _style(52, 84, _regular),
    displayMedium: _style(44, 72, _regular),
    displaySmall: _style(36, 60, _regular),
    headlineLarge: _style(30, 52, _bold),
    headlineMedium: _style(26, 44, _bold),
    headlineSmall: _style(22, 38, _bold),
    titleLarge: _style(20, 34, _bold),
    titleMedium: _style(17, 30, _bold),
    titleSmall: _style(15, 26, _bold),
    bodyLarge: _style(17, 30, _regular),
    bodyMedium: _style(15, 26, _regular),
    bodySmall: _style(13, 22, _regular),
    labelLarge: _style(15, 24, _bold),
    labelMedium: _style(13, 20, _regular),
    labelSmall: _style(11, 18, _regular),
  ).apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: _font,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: AppSizes.appBar,
      titleTextStyle: textTheme.titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.button),
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.button),
        textStyle: textTheme.labelLarge,
        foregroundColor: AppColors.onSurface,
        backgroundColor: AppColors.surfaceContainerLowest,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerLowest,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.android: FadeForwardsPageTransitionsBuilder()},
    ),
    extensions: [
      AppExtras(
        gatha: _style(20, 40, _regular).copyWith(color: AppColors.onSurface),
        counter: _style(64, 76, _bold).copyWith(color: AppColors.onSurface),
        gold: AppColors.gold,
        goldLight: AppColors.goldLight,
        yogiDark: AppColors.yogiDark,
      ),
    ],
  );
}
