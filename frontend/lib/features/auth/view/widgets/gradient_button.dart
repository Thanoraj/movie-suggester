import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_palette.dart';
import 'package:frontend/features/auth/view_model/auth_view_model.dart';

class GradientButton extends ConsumerStatefulWidget {
  const GradientButton({super.key, this.onPressed, required this.buttonText});
  final Function()? onPressed;
  final String buttonText;

  @override
  ConsumerState<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends ConsumerState<GradientButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
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
        onPressed: widget.onPressed,
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Text(
                widget.buttonText,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
