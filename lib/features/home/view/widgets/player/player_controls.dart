import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Playback control row: shuffle, previous, play/pause, next, repeat.
class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songNotifier = ref.read(currentSongProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          _ControlButton(icon: CupertinoIcons.shuffle, size: 22, onTap: () {}),
          // Previous / Rewind
          _ControlButton(
            icon: CupertinoIcons.backward_fill,
            size: 28,
            onTap: () {},
          ),
          // Play / Pause — large center button
          GestureDetector(
            onTap: songNotifier.playOrPause,
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPallete.whiteColor,
              ),
              child: Icon(
                songNotifier.isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          // Next / Forward
          _ControlButton(
            icon: CupertinoIcons.forward_fill,
            size: 28,
            onTap: () {},
          ),
          // Repeat
          _ControlButton(icon: CupertinoIcons.repeat, size: 22, onTap: () {}),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: ColorPallete.whiteColor, size: size),
      ),
    );
  }
}
