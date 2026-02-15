import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A horizontal scrolling section with a title and song cards
class SongSection extends ConsumerWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<SongModel> songs;
  final bool useLargeCards;

  const SongSection({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.songs,
    this.useLargeCards = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final double cardWidth = useLargeCards ? 160 : 140;
    final double imageHeight = useLargeCards ? 160 : 140;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorPallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal List
        SizedBox(
          height: imageHeight + 58,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              final isPlaying = currentSong?.id == song.id;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _SongCard(
                  song: song,
                  width: cardWidth,
                  imageHeight: imageHeight,
                  isPlaying: isPlaying,
                  onTap: () {
                    ref.read(currentSongProvider.notifier).updateSong(song);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual song card for horizontal lists
class _SongCard extends StatelessWidget {
  final SongModel song;
  final double width;
  final double imageHeight;
  final bool isPlaying;
  final VoidCallback onTap;

  const _SongCard({
    required this.song,
    required this.width,
    required this.imageHeight,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play overlay
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isPlaying
                            ? hexToColor(
                                song.colorHexCode,
                              ).withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.25),
                        blurRadius: isPlaying ? 16 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      song.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: ColorPallete.cardColor,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.music_note,
                            color: ColorPallete.greyColor,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Play / Pause button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? ColorPallete.gradient2
                          : ColorPallete.greenColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      color: isPlaying ? ColorPallete.whiteColor : Colors.black,
                      size: 16,
                    ),
                  ),
                ),
                // Active border
                if (isPlaying)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorPallete.gradient2.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Song title
            Text(
              song.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isPlaying
                    ? ColorPallete.gradient2
                    : ColorPallete.whiteColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Artist
            Text(
              song.artist,
              style: TextStyle(fontSize: 12, color: ColorPallete.subtitleText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
