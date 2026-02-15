import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/view/pages/sign_in_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Profile Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          ColorPallete.gradient1,
                          ColorPallete.gradient2,
                          ColorPallete.gradient3,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPallete.gradient2.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(user?.name ?? 'U'),
                        style: textTheme.headlineMedium?.copyWith(
                          color: ColorPallete.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user?.name ?? 'User',
                    style: textTheme.headlineSmall?.copyWith(
                      color: ColorPallete.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    user?.email ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorPallete.subtitleText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  Container(height: 1, color: ColorPallete.borderColor),
                ],
              ),
            ),
          ),

          // ── Upload Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Upload Card
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UploadSongPage(),
                        ),
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
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: ColorPallete.gradient2.withValues(
                                alpha: 0.2,
                              ),
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
            ),
          ),

          // ── My Uploads Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
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
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // Uploaded songs list
          _buildMyUploads(ref, user?.id),

          // ── Settings Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: ColorPallete.borderColor),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.gear_solid,
                        color: ColorPallete.subtitleText,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Settings',
                        style: textTheme.titleLarge?.copyWith(
                          color: ColorPallete.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Settings items
          SliverToBoxAdapter(
            child: Column(
              children: [
                _SettingsTile(
                  icon: CupertinoIcons.person,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: CupertinoIcons.bell,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: CupertinoIcons.shield,
                  title: 'Privacy',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: CupertinoIcons.info,
                  title: 'About',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                // Logout
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Consumer(
                    builder: (context, ref, _) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleLogout(context, ref),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: ColorPallete.errorColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorPallete.errorColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.square_arrow_right,
                                  color: ColorPallete.errorColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: ColorPallete.errorColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildMyUploads(WidgetRef ref, String? userId) {
    return ref
        .watch(getAllSongsProvider)
        .when(
          data: (allSongs) {
            final mySongs = userId != null
                ? allSongs.where((s) => s.userId == userId).toList()
                : [];

            if (mySongs.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
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
                          style: TextStyle(
                            color: ColorPallete.subtitleText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your uploaded songs will appear here',
                          style: TextStyle(
                            color: ColorPallete.greyColor.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final song = mySongs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
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
                              color: ColorPallete.greyColor.withValues(
                                alpha: 0.3,
                              ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorPallete.greenColor.withValues(
                              alpha: 0.15,
                            ),
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
              }, childCount: mySongs.length),
            );
          },
          error: (_, __) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Could not load uploads',
                style: TextStyle(color: ColorPallete.greyColor),
              ),
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(color: ColorPallete.gradient2),
              ),
            ),
          ),
        );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPallete.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: TextStyle(color: ColorPallete.whiteColor),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: ColorPallete.subtitleText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: ColorPallete.subtitleText),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authLocalRepositoryProvider).removeToken();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                  (_) => false,
                );
              }
            },
            child: Text(
              'Log Out',
              style: TextStyle(
                color: ColorPallete.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Tile ──
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: ColorPallete.subtitleText, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: ColorPallete.whiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: ColorPallete.greyColor.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
