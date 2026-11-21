import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/stagger_in.dart';
import '../data/gatha.dart';
import 'gatha_screen.dart';

/// Dhamma / AllDhamma: the list of gathas.
class AllDhammaScreen extends StatelessWidget {
  const AllDhammaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return FutureBuilder<List<Gatha>>(
      future: Gatha.loadAll(),
      builder: (context, snapshot) {
        final gathas = snapshot.data;
        if (gathas == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Text('တရားတော်များ', style: text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final (i, gatha) in gathas.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: StaggerIn(
                  index: i,
                  child: _GathaTile(
                    title: gatha.title,
                    onTap: () => openGatha(context, gathas, i),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GathaTile extends StatelessWidget {
  const _GathaTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.secondaryContainer),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.button),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: AppSizes.icon,
                  color: AppColors.onSurface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
