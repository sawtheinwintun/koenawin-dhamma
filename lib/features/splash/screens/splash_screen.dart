import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../home/home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.splashDuration,
  );
  late final _curve = CurvedAnimation(
    parent: _controller,
    curve: Easing.emphasizedDecelerate,
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    // ~5 seconds in total: 1s wheel animation, then the splash holds.
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: AppMotion.pageDuration,
        pageBuilder: (_, _, _) => const HomeShell(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App/SplashWheel: rotates in from -90°, fades in and scales 0.8 → 1
                AnimatedBuilder(
                  animation: _curve,
                  builder: (_, child) => Opacity(
                    opacity: _curve.value,
                    child: Transform.rotate(
                      angle: (1 - _curve.value) * -1.5708,
                      child: Transform.scale(
                        scale: 0.8 + 0.2 * _curve.value,
                        child: child,
                      ),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/branding/logo.svg',
                    width: 279,
                    height: 279,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeTransition(
                  opacity: _curve,
                  child: Column(
                    children: [
                      Text(
                        'ကိုးနဝင်းမိုးလင်းမှသိမယ်',
                        textAlign: TextAlign.center,
                        style: text.headlineLarge?.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'ကိုးနဝင်းအဓိဋ္ဌာန် နှင့် တရားတော်',
                        textAlign: TextAlign.center,
                        style: text.bodyLarge?.copyWith(
                          color: AppExtras.of(context).goldLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
