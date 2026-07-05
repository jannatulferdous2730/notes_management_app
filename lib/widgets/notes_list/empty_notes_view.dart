import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Shows a contextual empty state message depending on whether there is an
/// active search query (no results) or the collection is genuinely empty.
class EmptyNotesView extends StatelessWidget {
  const EmptyNotesView({super.key, required this.isSearchActive});

  /// `true` when a non-empty search query produced zero results.
  final bool isSearchActive;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearchActive
                  ? Icons.search_off_rounded
                  : Icons.note_add_outlined,
              size: 72,
              color: AppColors.textSecondary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 20),
            Text(
              isSearchActive
                  ? 'No notes match your search'
                  : 'No notes yet',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSearchActive
                  ? 'Try a different keyword or clear the search.'
                  : 'Tap + to create your first note.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
