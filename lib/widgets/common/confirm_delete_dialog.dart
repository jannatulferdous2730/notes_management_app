import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Shows a confirmation dialog before deleting a note.
/// Returns `true` if the user confirms, `false` if they cancel.
Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Delete note?',
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        'This action cannot be undone.',
        style: GoogleFonts.nunito(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
          ),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}
