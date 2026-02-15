import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/material.dart';

/// Profile header with gradient avatar, name and email.
class ProfileHeader extends StatelessWidget {
  final String? name;
  final String? email;

  const ProfileHeader({super.key, this.name, this.email});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName = name ?? 'User';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          // Gradient avatar
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
                _getInitials(displayName),
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
            displayName,
            style: textTheme.headlineSmall?.copyWith(
              color: ColorPallete.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email ?? '',
            style: textTheme.bodyMedium?.copyWith(
              color: ColorPallete.subtitleText,
            ),
          ),

          const SizedBox(height: 24),
          Container(height: 1, color: ColorPallete.borderColor),
        ],
      ),
    );
  }
}
