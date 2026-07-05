import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_motion.dart';

/// Save button that swaps between label text and a spinner via [AnimatedSwitcher].
/// Disabled while [isSaving] to prevent double-firing.
class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.onPressed,
    required this.isSaving,
    this.label = 'Save',
  });

  final VoidCallback? onPressed;
  final bool isSaving;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isSaving ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.seed,
          disabledBackgroundColor: AppColors.seed.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        child: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: isSaving
              ? const SizedBox(
                  key: ValueKey('spinner'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                ),
        ),
      ),
    );
  }
}
