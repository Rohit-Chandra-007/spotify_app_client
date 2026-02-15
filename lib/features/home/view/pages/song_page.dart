import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/view/widgets/greeting_header.dart';
import 'package:client/features/home/view/widgets/quick_pick_grid.dart';
import 'package:client/features/home/view/widgets/song_list_tile.dart';
import 'package:client/features/home/view/widgets/song_section.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getAllSongsProvider)
        .when(
          data: (allSongs) => _buildContent(context, allSongs),
          error: (error, _) => _buildError(context, error),
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorPallete.gradient2),
          ),
        );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.wifi_slash,
              color: ColorPallete.greyColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load songs',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: ColorPallete.whiteColor),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: ColorPallete.greyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<SongModel> allSongs) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Safe area spacer
        const SliverToBoxAdapter(
          child: SafeArea(bottom: false, child: SizedBox.shrink()),
        ),

        // Greeting Header
        const SliverToBoxAdapter(child: GreetingHeader()),

        // Quick Pick Grid
        if (allSongs.isNotEmpty)
          SliverToBoxAdapter(child: QuickPickGrid(songs: allSongs)),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        // Today's Biggest Hits — horizontal scroll
        if (allSongs.isNotEmpty)
          SliverToBoxAdapter(
            child: SongSection(
              title: "Today's Biggest Hits",
              icon: CupertinoIcons.flame_fill,
              iconColor: const Color(0xFFFF6B35),
              songs: allSongs,
              useLargeCards: true,
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        // Fresh Finds — show reversed list for variety
        if (allSongs.length > 1)
          SliverToBoxAdapter(
            child: SongSection(
              title: 'Fresh Finds',
              icon: CupertinoIcons.sparkles,
              iconColor: ColorPallete.gradient2,
              songs: allSongs.reversed.toList(),
              useLargeCards: false,
            ),
          ),

        if (allSongs.length > 1)
          const SliverToBoxAdapter(child: SizedBox(height: 28)),

        // All Songs — section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.music_note_list,
                  color: ColorPallete.gradient1,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'All Songs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorPallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // All Songs — vertical list
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return SongListTile(song: allSongs[index], index: index + 1);
          }, childCount: allSongs.length),
        ),

        // Bottom padding so music slab doesn't cover last items
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}
