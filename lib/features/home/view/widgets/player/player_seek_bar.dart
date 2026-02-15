import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable seek/progress bar used by both MusicPlayer and MusicSlab.
class PlayerSeekBar extends ConsumerWidget {
  /// If true, shows a slim LinearProgressIndicator (for slab).
  /// If false, shows a full Slider with time labels (for player).
  final bool compact;

  const PlayerSeekBar({super.key, this.compact = false});

  String _formatDuration(Duration? d) {
    if (d == null) return '0:00';
    return '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songNotifier = ref.read(currentSongProvider.notifier);

    return StreamBuilder<Duration?>(
      stream: songNotifier.audioPlayer?.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data;
        final duration = songNotifier.audioPlayer?.duration;
        double progress = 0.0;

        if (position != null &&
            duration != null &&
            duration.inMilliseconds > 0) {
          progress = (position.inMilliseconds / duration.inMilliseconds).clamp(
            0.0,
            1.0,
          );
        }

        if (compact) {
          return LinearProgressIndicator(
            value: progress,
            backgroundColor: ColorPallete.inactiveSeekColor,
            valueColor: const AlwaysStoppedAnimation<Color>(
              ColorPallete.whiteColor,
            ),
            minHeight: 2.5,
            borderRadius: BorderRadius.circular(10),
          );
        }

        // Full seek bar with time labels
        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                trackHeight: 3,
              ),
              child: Slider(
                value: progress,
                min: 0,
                max: 1,
                onChanged: (value) {
                  // Real-time feedback handled by stream
                },
                onChangeStart: (_) {
                  songNotifier.audioPlayer?.pause();
                },
                onChangeEnd: (value) {
                  songNotifier.seek(value);
                  songNotifier.audioPlayer?.play();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(
                      color: ColorPallete.subtitleText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: ColorPallete.subtitleText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
