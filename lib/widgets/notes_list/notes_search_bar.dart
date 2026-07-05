import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/notes_provider.dart';
import '../../theme/app_colors.dart';

/// Floating search bar pinned below the AppBar.
/// Calls [NotesProvider.updateSearchQuery] on every keystroke.
class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({super.key});

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends State<NotesSearchBar> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _clear() {
    _ctrl.clear();
    context.read<NotesProvider>().updateSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final query = context.select<NotesProvider, String>((p) => p.searchQuery);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _ctrl,
        onChanged: (v) => context.read<NotesProvider>().updateSearchQuery(v),
        textInputAction: TextInputAction.search,
        style: GoogleFonts.nunito(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search notes…',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: query.isNotEmpty
                ? IconButton(
                    key: const ValueKey('clear'),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _clear,
                    tooltip: 'Clear search',
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ),
      ),
    );
  }
}
