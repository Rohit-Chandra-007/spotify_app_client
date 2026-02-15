import 'package:client/core/theme/color_pallete.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/view/pages/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings section with action tiles and logout button.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
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
            ],
          ),
        ),

        // Settings tiles
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
        _SettingsTile(icon: CupertinoIcons.info, title: 'About', onTap: () {}),

        const SizedBox(height: 8),

        // Logout button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                      color: ColorPallete.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorPallete.errorColor.withValues(alpha: 0.3),
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
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: ColorPallete.subtitleText),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authLocalRepositoryProvider).removeToken();
              if (ctx.mounted) {
                Navigator.pop(ctx);
              }
              if (context.mounted) {
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
