import 'package:flutter/material.dart';

/// Values from docs/design_tokens.md. Keep both in sync.

class AppColors {
  static const primary = Color(0xFF7A4123);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFF3DCCB);
  static const onPrimaryContainer = Color(0xFF3A1A08);
  static const secondary = Color(0xFF8C6A24);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFF5E3B5);
  static const onSecondaryContainer = Color(0xFF3B2A06);
  static const surface = Color(0xFFFFF8F1);
  static const onSurface = Color(0xFF2B1E16);
  static const onSurfaceVariant = Color(0xFF5C4A3E);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFFCF1E7);
  static const surfaceContainer = Color(0xFFF7EADF);
  static const surfaceContainerHigh = Color(0xFFF1E3D6);
  static const surfaceContainerHighest = Color(0xFFEBDCCE);
  static const outline = Color(0xFF8A7466);
  static const outlineVariant = Color(0xFFDCC8B8);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);

  // App/
  static const gold = Color(0xFFC29A45);
  static const goldLight = Color(0xFFE6CB7E);
  static const yogiDark = Color(0xFF5A2E16);

  static const shadow = Color(0xFF3A1A08);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

class AppRadius {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 28.0;
  static const full = 999.0;
}

class AppSizes {
  static const appBar = 64.0;
  static const button = 48.0;
  static const textField = 56.0;
  static const listItem = 72.0;
  static const miniPlayer = 64.0;
  static const bottomNav = 80.0;
  static const icon = 24.0;
  static const touchTarget = 48.0;
}

class AppShadows {
  /// App/GoldGlow
  static const goldGlow = [
    BoxShadow(color: Color(0x73C29A45), blurRadius: 24, spreadRadius: 4),
  ];

  /// Elevation/Level1
  static const level1 = [
    BoxShadow(color: Color(0x4D3A1A08), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(
      color: Color(0x263A1A08),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
  ];
}

class AppMotion {
  static const pressDuration = Durations.short4;
  static const fadeDuration = Durations.medium2;
  static const pageDuration = Durations.medium4;
  static const counterDuration = Durations.long2;
  static const gathaLineDuration = Durations.long4;
  static const splashDuration = Durations.extralong4;
  static const listStagger = Duration(milliseconds: 50);
  static const gathaStagger = Duration(milliseconds: 400);
}
