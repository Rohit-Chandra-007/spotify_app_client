import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String labelText;
  final VoidCallback onPressed;

  const AuthGradientButton({
    super.key,
    required this.labelText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPallete.gradient1,
            ColorPallete.gradient2,
            ColorPallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          transform: GradientRotation(12),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 55),
          backgroundColor: ColorPallete.transparentColor,
          shadowColor: ColorPallete.transparentColor,
        ),
        onPressed: onPressed,
        child: Text(
          labelText,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontSize: 18.0),
        ),
      ),
    );
  }
}
