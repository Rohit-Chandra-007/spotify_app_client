import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single song row for the vertical "All Songs" list
class SongListTile extends ConsumerWidget {
  final SongModel song;
  final int index;

  const SongListTile({super.key, required this.song, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final isPlaying = currentSong?.id == song.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(currentSongProvider.notifier).updateSong(song);
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isPlaying
                ? hexToColor(song.colorHexCode).withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Index or waveform icon
              SizedBox(
                width: 24,
                child: isPlaying
                    ? Icon(
                        CupertinoIcons.waveform,
                        color: ColorPallete.gradient2,
                        size: 16,
                      )
                    : Text(
                        '$index',
                        style: TextStyle(
                          color: ColorPallete.subtitleText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(width: 12),
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.thumbnailUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: ColorPallete.cardColor,
                    child: Icon(
                      CupertinoIcons.music_note,
                      color: ColorPallete.greyColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Song info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isPlaying
                            ? ColorPallete.gradient2
                            : ColorPallete.whiteColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      song.artist,
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorPallete.subtitleText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // More options
              IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: ColorPallete.subtitleText,
                  size: 18,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
