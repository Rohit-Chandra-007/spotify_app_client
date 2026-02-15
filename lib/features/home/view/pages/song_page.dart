import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Today’s hits', style: textStyle.titleLarge),
          ),
          ref
              .watch(getAllSongsProvider)
              .when(
                data: (data) {
                  return SizedBox(
                    height: 220, // Adjusted height to fit text
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final song = data[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(currentSongProvider.notifier)
                                            .updateSong(song);
                                      },
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              song.thumbnailUrl,
                                            ),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) {
                                              // You can add a placeholder image here on error
                                            },
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.3,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Positioned widget is great for placing items in a Stack
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: ColorPallete.greyColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          CupertinoIcons.play_fill,
                                          color: ColorPallete.whiteColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Song title
                                Text(
                                  song.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Artist name
                                Text(
                                  song.artist,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Text(error.toString());
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
        ],
      ),
    );
  }
}
