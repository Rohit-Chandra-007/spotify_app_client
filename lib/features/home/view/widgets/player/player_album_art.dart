import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';

/// Clean album art — simple rounded image, no glow, no extra decoration.
class PlayerAlbumArt extends StatelessWidget {
  final SongModel song;

  const PlayerAlbumArt({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final artSize = screenWidth - 56;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Hero(
        tag: song.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            song.thumbnailUrl,
            width: artSize,
            height: artSize,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: artSize,
              height: artSize,
              decoration: BoxDecoration(
                color: ColorPallete.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.music_note,
                  color: ColorPallete.greyColor,
                  size: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
