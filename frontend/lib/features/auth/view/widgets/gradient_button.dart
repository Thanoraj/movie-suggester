import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_palette.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, this.onPressed, required this.buttonText});
  final Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppPalette.gradient1,
              AppPalette.gradient2,
            ],
          ),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
