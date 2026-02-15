import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Flutter widget that replicates the provided music player UI.
///
/// This widget is self-contained and can be directly used in a Flutter application.
/// It uses a gradient background, displays album art, song information,
/// playback controls, and other UI elements as seen in the screenshot.
class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);

    if (currentSong == null) {
      return const Scaffold(body: Center(child: Text("No song selected")));
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(currentSong.colorHexCode), Color(0xFF1E1E1E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.chevron_down, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            // Album Art
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Hero(
                    tag: currentSong.id,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Album Art Placeholder
                          Image.network(
                            currentSong.thumbnailUrl,
                            // Replace with actual asset
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white70),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'LYRICS',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // Song Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSong.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    currentSong.artist,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Progress Bar
                  StreamBuilder(
                    stream: songNotifier.audioPlayer?.positionStream,
                    builder: (context, asyncSnapshot) {
                      final position = asyncSnapshot.data;
                      final duration = songNotifier.audioPlayer?.duration;
                      double sliderValue = 0.0;

                      if (position != null &&
                          duration != null &&
                          duration.inMilliseconds > 0) {
                        sliderValue =
                            (position.inMilliseconds / duration.inMilliseconds)
                                .clamp(0.0, 1.0);
                      }

                      return Row(
                        children: [
                          Text(
                            position != null
                                ? "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}"
                                : '0:00',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white30,
                                thumbColor: Colors.white,
                                trackHeight: 2,
                              ),
                              child: Slider(
                                value:
                                    sliderValue, // 0:52 of 4:04 is approximately 0.13
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  sliderValue = value;
                                },
                                onChangeStart: (value) {
                                  songNotifier.audioPlayer?.pause();
                                },
                                onChangeEnd: (value) {
                                  songNotifier.seek(value);
                                  songNotifier.audioPlayer?.play();
                                },
                              ),
                            ),
                          ),
                          Text(
                            duration != null
                                ? "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}"
                                : '0:00',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () {},
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        songNotifier.playOrPause();
                      },
                      icon: Icon(
                        songNotifier.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Bottom Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.laptop, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'JUANFTP10_RS',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
