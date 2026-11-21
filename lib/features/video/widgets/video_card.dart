import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../data/videos.dart';

/// Thumbnail with a play badge, title underneath.
class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.playing = false,
  });

  final DhammaVideo video;
  final VoidCallback onTap;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const ColoredBox(color: AppColors.surfaceContainerHigh),
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : const ColoredBox(
                            color: AppColors.surfaceContainerHigh,
                          ),
                  ),
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        playing
                            ? PhosphorIconsFill.speakerHigh
                            : PhosphorIconsFill.play,
                        color: AppColors.onPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            video.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: playing ? FontWeight.w700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
