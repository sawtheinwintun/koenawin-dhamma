import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/myanmar.dart';
import '../data/videos.dart';
import '../widgets/youtube_view.dart';

void openVideoPlayer(BuildContext context, VideoSession session, int start) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(session: session, start: start),
      ),
    );

/// Plays the tapped video, then the rest of its session in order, then stops.
/// The screen stays on while it is open: YouTube stops playing when the screen turns off.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.session,
    required this.start,
  });

  final VideoSession session;
  final int start;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final List<DhammaVideo> _queue = videosBySession[widget.session]!;
  late int _current = widget.start;
  bool _finished = false;
  bool _blocked = false;

  /// Bumped by "try again" so the WebView is rebuilt and reloads.
  int _attempt = 0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _onEnded() {
    if (_finished) return;
    setState(() {
      if (_current < _queue.length - 1) {
        _current++;
      } else {
        _finished = true;
      }
    });
  }

  void _play(int index) => setState(() {
    _current = index;
    _finished = false;
    _blocked = false;
  });

  void _retry() => setState(() {
    _blocked = false;
    _attempt++;
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'နောက်သို့',
          icon: const Icon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('ဗီဒီယို · ${widget.session.label}'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          YoutubeView(
            key: ValueKey(_attempt),
            videoId: _queue[_current].youtubeId,
            onEnded: _onEnded,
            onBlocked: () => setState(() => _blocked = true),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_blocked) ...[
                  _VpnHint(onRetry: _retry),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text(_queue[_current].title, style: text.titleMedium),
                if (_finished) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ဗီဒီယိုအားလုံး ဖွင့်ပြီးပါပြီ။',
                    style: text.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                for (final (i, video) in _queue.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _QueueTile(
                      number: i + 1,
                      title: video.title,
                      state: i == _current && !_finished
                          ? _TileState.playing
                          : (i < _current || _finished)
                          ? _TileState.done
                          : _TileState.upNext,
                      onTap: () => _play(i),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when YouTube asks to "confirm you're not a bot", which a VPN usually causes.
class _VpnHint extends StatelessWidget {
  const _VpnHint({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                PhosphorIconsRegular.warningCircle,
                color: AppColors.onSecondaryContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'ဗီဒီယို ဖွင့်၍ မရပါ။\nVPN ဖွင့်ထားပါက ပိတ်ပြီး ပြန်ကြိုးစားပါ။',
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onRetry,
            child: const Text('ပြန်ကြိုးစားမည်'),
          ),
        ],
      ),
    );
  }
}

enum _TileState { playing, done, upNext }

class _QueueTile extends StatelessWidget {
  const _QueueTile({
    required this.number,
    required this.title,
    required this.state,
    required this.onTap,
  });

  final int number;
  final String title;
  final _TileState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final playing = state == _TileState.playing;
    return Material(
      color: playing ? AppColors.primaryContainer : AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: playing ? AppColors.primary : AppColors.secondaryContainer,
        ),
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
                Text(
                  '${Myanmar.digits(number)}။',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(
                  switch (state) {
                    _TileState.playing => PhosphorIconsFill.speakerHigh,
                    _TileState.done => PhosphorIconsFill.checkCircle,
                    _TileState.upNext => PhosphorIconsRegular.play,
                  },
                  size: AppSizes.icon,
                  color: playing ? AppColors.primary : AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
