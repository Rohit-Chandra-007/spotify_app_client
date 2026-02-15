import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the user's uploaded songs, or an empty state placeholder.
class MyUploadsList extends ConsumerWidget {
  final String? userId;

  const MyUploadsList({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 1, color: ColorPallete.borderColor),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.music_mic,
                    color: ColorPallete.gradient3,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'My Uploads',
                    style: textTheme.titleLarge?.copyWith(
                      color: ColorPallete.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        ref
            .watch(getAllSongsProvider)
            .when(
              data: (allSongs) {
                final mySongs = userId != null
                    ? allSongs.where((s) => s.userId == userId).toList()
                    : [];

                if (mySongs.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: mySongs
                      .map((song) => _UploadTile(song: song))
                      .toList(),
                );
              },
              error: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Could not load uploads',
                  style: TextStyle(color: ColorPallete.greyColor),
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorPallete.gradient2,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorPallete.cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(
              CupertinoIcons.music_note_2,
              color: ColorPallete.greyColor.withValues(alpha: 0.5),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No uploads yet',
              style: TextStyle(color: ColorPallete.subtitleText, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Your uploaded songs will appear here',
              style: TextStyle(
                color: ColorPallete.greyColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final dynamic song;

  const _UploadTile({required this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorPallete.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
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
                  color: ColorPallete.greyColor.withValues(alpha: 0.3),
                  child: Icon(
                    CupertinoIcons.music_note,
                    color: ColorPallete.greyColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: ColorPallete.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: ColorPallete.subtitleText,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ColorPallete.greenColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Uploaded',
                style: TextStyle(
                  color: ColorPallete.greenColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
