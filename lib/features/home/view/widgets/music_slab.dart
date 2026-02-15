import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    if (currentSong == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MusicPlayer(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(
                    0,
                    1,
                  ); // Start from bottom (y = 1 means 100% below screen)
                  const end = Offset.zero; // End at normal position
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
            transitionDuration: Duration(
              milliseconds: 300,
            ), // Adjust duration as needed
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 64,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.colorHexCode),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: currentSong.id,
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: NetworkImage(currentSong.thumbnailUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSong.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: ColorPallete.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorPallete.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.heart),
                    ),
                    IconButton(
                      onPressed: songNotifier.playOrPause,
                      icon: Icon(
                        songNotifier.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: ColorPallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<Duration?>(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data;
                final duration = songNotifier.audioPlayer?.duration;
                double sliderValue = 0.0;

                if (position != null &&
                    duration != null &&
                    duration.inMilliseconds > 0) {
                  sliderValue =
                      (position.inMilliseconds / duration.inMilliseconds).clamp(
                        0.0,
                        1.0,
                      );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(
                    value: sliderValue,
                    backgroundColor: ColorPallete.inactiveSeekColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorPallete.whiteColor,
                    ),
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
