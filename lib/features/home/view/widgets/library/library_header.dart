import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Header row with gradient avatar, "Your Library" title, and search toggle.
class LibraryHeader extends StatelessWidget {
  final bool showSearch;
  final VoidCallback onSearchToggle;

  const LibraryHeader({
    super.key,
    required this.showSearch,
    required this.onSearchToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ColorPallete.gradient1, ColorPallete.gradient2],
              ),
            ),
            child: const Center(
              child: Text(
                'R',
                style: TextStyle(
                  color: ColorPallete.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Your Library',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: ColorPallete.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onSearchToggle,
            icon: Icon(
              showSearch ? CupertinoIcons.xmark : CupertinoIcons.search,
              color: ColorPallete.whiteColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
