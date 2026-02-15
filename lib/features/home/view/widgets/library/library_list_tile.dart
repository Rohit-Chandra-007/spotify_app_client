import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single song row used in the library list view.
class LibraryListTile extends ConsumerWidget {
  final SongModel song;

  const LibraryListTile({super.key, required this.song});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song.thumbnailUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: ColorPallete.cardColor,
                    child: Icon(
                      CupertinoIcons.music_note,
                      color: ColorPallete.greyColor,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: isPlaying
                            ? ColorPallete.greenColor
                            : ColorPallete.whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isPlaying) ...[
                          Icon(
                            CupertinoIcons.waveform,
                            color: ColorPallete.greenColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            'Song • ${song.artist}',
                            style: TextStyle(
                              color: isPlaying
                                  ? ColorPallete.greenColor
                                  : ColorPallete.subtitleText,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
