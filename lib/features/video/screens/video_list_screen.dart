import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/stagger_in.dart';
import '../data/videos.dart';
import '../widgets/video_card.dart';
import 'video_player_screen.dart';

/// Video / List / Morning and Video / List / Evening.
class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoSession _session = VideoSession.morning;

  @override
  Widget build(BuildContext context) {
    final videos = videosBySession[_session]!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        Text('ဗီဒီယို', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xl),
        _SessionTabs(
          selected: _session,
          onChanged: (s) => setState(() => _session = s),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final (i, video) in videos.indexed)
          Padding(
            key: ValueKey(video.youtubeId),
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: StaggerIn(
              index: i,
              child: VideoCard(
                video: video,
                onTap: () => openVideoPlayer(context, _session, i),
              ),
            ),
          ),
      ],
    );
  }
}

/// VideoTab component pair inside the rounded tab bar.
class _SessionTabs extends StatelessWidget {
  const _SessionTabs({required this.selected, required this.onChanged});

  final VideoSession selected;
  final ValueChanged<VideoSession> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          for (final session in VideoSession.values)
            Expanded(
              child: Semantics(
                selected: session == selected,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(session),
                  child: AnimatedContainer(
                    duration: AppMotion.pressDuration,
                    curve: Easing.standard,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: session == selected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      session.label,
                      style: text.labelLarge?.copyWith(
                        color: session == selected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
