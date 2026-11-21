import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// App/ListStagger: rises 12px and fades in, [index] × 50ms after the first item.
class StaggerIn extends StatefulWidget {
  const StaggerIn({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.fadeDuration,
  );
  late final _curve = CurvedAnimation(
    parent: _controller,
    curve: Easing.emphasizedDecelerate,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(AppMotion.listStagger * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (_, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - _curve.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
