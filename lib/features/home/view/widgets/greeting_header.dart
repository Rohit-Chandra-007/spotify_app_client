import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getGreeting(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: ColorPallete.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _HeaderIconButton(icon: CupertinoIcons.bell, onTap: () {}),
              const SizedBox(width: 8),
              _HeaderIconButton(icon: CupertinoIcons.search, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: ColorPallete.cardColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: ColorPallete.whiteColor, size: 20),
      ),
    );
  }
}
