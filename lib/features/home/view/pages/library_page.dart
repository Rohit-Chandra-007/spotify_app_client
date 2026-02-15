import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/view/widgets/library/library_filter_chips.dart';
import 'package:client/features/home/view/widgets/library/library_grid_card.dart';
import 'package:client/features/home/view/widgets/library/library_header.dart';
import 'package:client/features/home/view/widgets/library/library_list_tile.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  int _selectedFilter = 0;
  bool _isGridView = false;
  String _searchQuery = '';
  bool _showSearch = false;

  static const _filters = ['All', 'Recently Played', 'Artists'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          LibraryHeader(
            showSearch: _showSearch,
            onSearchToggle: () => setState(() => _showSearch = !_showSearch),
          ),

          // ── Filter chips ──
          LibraryFilterChips(
            filters: _filters,
            selectedIndex: _selectedFilter,
            onSelected: (i) => setState(() => _selectedFilter = i),
          ),

          const SizedBox(height: 4),

          // ── Search bar (toggled) ──
          if (_showSearch) _buildSearchBar(),

          // ── Sort row ──
          _buildSortRow(),

          // ── Song list ──
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // ── Search bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: ColorPallete.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: ColorPallete.whiteColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search in Your Library',
            hintStyle: TextStyle(
              color: ColorPallete.subtitleText,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              color: ColorPallete.subtitleText,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // ── Sort / view toggle row ──
  Widget _buildSortRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.arrow_up_arrow_down,
            color: ColorPallete.subtitleText,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'Recents',
            style: TextStyle(
              color: ColorPallete.subtitleText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(
              _isGridView
                  ? CupertinoIcons.list_bullet
                  : CupertinoIcons.square_grid_2x2,
              color: ColorPallete.subtitleText,
              size: 20,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  // ── Song content (list / grid / empty / error / loading) ──
  Widget _buildContent() {
    return ref
        .watch(getAllSongsProvider)
        .when(
          data: (songs) {
            var filtered = songs;
            if (_searchQuery.isNotEmpty) {
              final q = _searchQuery.toLowerCase();
              filtered = songs
                  .where(
                    (s) =>
                        s.title.toLowerCase().contains(q) ||
                        s.artist.toLowerCase().contains(q),
                  )
                  .toList();
            }

            if (filtered.isEmpty) return _buildEmptyState();
            if (_isGridView) return _buildGrid(filtered);
            return _buildList(filtered);
          },
          error: (_, __) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.wifi_slash,
                  color: ColorPallete.greyColor,
                  size: 44,
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not load library',
                  style: TextStyle(color: ColorPallete.subtitleText),
                ),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorPallete.gradient2),
          ),
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.music_note_list,
              color: ColorPallete.greyColor.withValues(alpha: 0.4),
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results found'
                  : 'Your library is empty',
              style: TextStyle(
                color: ColorPallete.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Songs you play will appear here',
              style: TextStyle(color: ColorPallete.subtitleText, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<SongModel> songs) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      itemCount: songs.length,
      itemBuilder: (_, i) => LibraryListTile(song: songs[i]),
    );
  }

  Widget _buildGrid(List<SongModel> songs) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.8,
      ),
      itemCount: songs.length,
      itemBuilder: (_, i) => LibraryGridCard(song: songs[i]),
    );
  }
}
