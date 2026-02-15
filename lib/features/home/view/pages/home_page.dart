import 'package:client/features/home/view/pages/account_page.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/song_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final page = const [SongPage(), LibraryPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          page[_selectedIndex],
          const Positioned(bottom: 0, child: MusicSlab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _selectedIndex == 0
                    ? 'assets/images/home_filled.png'
                    : 'assets/images/home_unfilled.png',
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/library.png')),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? CupertinoIcons.person_circle_fill
                  : CupertinoIcons.person_circle,
            ),
            label: "Account",
          ),
        ],
        onTap: (value) {
          _onItemTapped(value);
        },
      ),
    );
  }
}
