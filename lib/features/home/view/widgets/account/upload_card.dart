import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Card that navigates to the upload song page.
class UploadCard extends StatelessWidget {
  const UploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Icon(
                CupertinoIcons.cloud_upload_fill,
                color: ColorPallete.gradient2,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Upload Music',
                style: textTheme.titleLarge?.copyWith(
                  color: ColorPallete.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Share your music with the world',
            style: textTheme.bodySmall?.copyWith(
              color: ColorPallete.subtitleText,
            ),
          ),
          const SizedBox(height: 16),

          // Tappable card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadSongPage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorPallete.gradient1.withValues(alpha: 0.15),
                    ColorPallete.gradient2.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorPallete.gradient2.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorPallete.gradient2.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      CupertinoIcons.add,
                      color: ColorPallete.gradient2,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload a New Song',
                          style: textTheme.titleMedium?.copyWith(
                            color: ColorPallete.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add thumbnail, audio & details',
                          style: textTheme.bodySmall?.copyWith(
                            color: ColorPallete.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: ColorPallete.subtitleText,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
