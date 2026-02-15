import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/view/widgets/account/my_uploads_list.dart';
import 'package:client/features/home/view/widgets/account/profile_header.dart';
import 'package:client/features/home/view/widgets/account/settings_section.dart';
import 'package:client/features/home/view/widgets/account/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Profile ──
            ProfileHeader(name: user?.name, email: user?.email),

            // ── Upload Music ──
            const UploadCard(),

            // ── My Uploads ──
            MyUploadsList(userId: user?.id),

            // ── Settings & Logout ──
            const SettingsSection(),

            // Bottom padding for music slab
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
