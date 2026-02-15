import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/player/player_album_art.dart';
import 'package:client/features/home/view/widgets/player/player_controls.dart';
import 'package:client/features/home/view/widgets/player/player_seek_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);

    if (currentSong == null) {
      return const Scaffold(body: Center(child: Text('No song selected')));
    }

    final songColor = hexToColor(currentSong.colorHexCode);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              songColor.withValues(alpha: 0.45),
              const Color(0xFF121212),
            ],
            stops: const [0.0, 0.45],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ColorPallete.whiteColor,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'PLAYING FROM',
                          style: TextStyle(
                            color: ColorPallete.subtitleText,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your Library',
                          style: TextStyle(
                            color: ColorPallete.whiteColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.ellipsis,
                        color: ColorPallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Album Art — takes available space ──
              Expanded(
                flex: 5,
                child: Center(child: PlayerAlbumArt(song: currentSong)),
              ),

              // ── Song Info + Controls ──
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Song title & heart
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.title,
                                  style: const TextStyle(
                                    color: ColorPallete.whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentSong.artist,
                                  style: const TextStyle(
                                    color: ColorPallete.subtitleText,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.heart,
                              color: ColorPallete.whiteColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Seek bar
                      const PlayerSeekBar(compact: false),

                      const SizedBox(height: 8),

                      // Controls
                      const PlayerControls(),

                      const Spacer(),

                      // Bottom device bar
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.device_phone_portrait,
                                  color: ColorPallete.greenColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'This Device',
                                  style: TextStyle(
                                    color: ColorPallete.greenColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      CupertinoIcons.list_bullet,
                                      color: ColorPallete.whiteColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      CupertinoIcons.share,
                                      color: ColorPallete.whiteColor,
                                      size: 20,
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
