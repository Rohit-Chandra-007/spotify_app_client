import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single song card used in the library grid view.
class LibraryGridCard extends ConsumerWidget {
  final SongModel song;

  const LibraryGridCard({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final isPlaying = currentSong?.id == song.id;

    return GestureDetector(
      onTap: () {
        ref.read(currentSongProvider.notifier).updateSong(song);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: isPlaying
                        ? Border.all(
                            color: ColorPallete.greenColor.withValues(
                              alpha: 0.6,
                            ),
                            width: 2,
                          )
                        : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isPlaying ? 6 : 8),
                    child: Image.network(
                      song.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: ColorPallete.cardColor,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.music_note,
                            color: ColorPallete.greyColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Play indicator
                if (isPlaying)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ColorPallete.greenColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.waveform,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            song.title,
            style: TextStyle(
              color: isPlaying
                  ? ColorPallete.greenColor
                  : ColorPallete.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Artist
          Text(
            song.artist,
            style: TextStyle(color: ColorPallete.subtitleText, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
