import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickPickGrid extends ConsumerWidget {
  final List<SongModel> songs;

  const QuickPickGrid({super.key, required this.songs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    // Show at most 6 songs in the quick pick grid
    final displaySongs = songs.take(6).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: displaySongs.map((song) {
              final isPlaying = currentSong?.id == song.id;
              return SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                height: 56,
                child: _QuickPickCard(
                  song: song,
                  isPlaying: isPlaying,
                  onTap: () {
                    ref.read(currentSongProvider.notifier).updateSong(song);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _QuickPickCard extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final VoidCallback onTap;

  const _QuickPickCard({
    required this.song,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isPlaying
                ? hexToColor(song.colorHexCode).withValues(alpha: 0.35)
                : ColorPallete.cardColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                child: Image.network(
                  song.thumbnailUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: ColorPallete.greyColor.withValues(alpha: 0.3),
                    child: Icon(
                      CupertinoIcons.music_note,
                      color: ColorPallete.greyColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Song title
              Expanded(
                child: Text(
                  song.title,
                  style: TextStyle(
                    color: isPlaying
                        ? ColorPallete.gradient2
                        : ColorPallete.whiteColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Playing indicator
              if (isPlaying)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    CupertinoIcons.waveform,
                    color: ColorPallete.gradient2,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
