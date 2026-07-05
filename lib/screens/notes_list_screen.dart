import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_motion.dart';
import '../utils/note_colors.dart';
import '../widgets/add_edit/color_picker_row.dart';
import '../widgets/add_edit/note_form_field.dart';
import '../widgets/add_edit/save_button.dart';
import '../widgets/common/confirm_delete_dialog.dart';
import '../widgets/notes_list/empty_notes_view.dart';
import '../widgets/notes_list/note_card.dart';
import '../widgets/notes_list/notes_list_loading.dart';
import '../widgets/notes_list/notes_search_bar.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  void _showNoteSheet(BuildContext context, {NoteModel? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoteSheet(existingNote: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App bar area
            _AppHeader(onNewNote: () => _showNoteSheet(context)),
            // Search bar
            const NotesSearchBar(),
            const SizedBox(height: 12),
            // Main content
            Expanded(
              child: Consumer<NotesProvider>(
                builder: (context, provider, _) {
                  Widget body;

                  if (provider.isLoading) {
                    body = const NotesListLoading(key: ValueKey('loading'));
                  } else if (provider.filteredNotes.isEmpty) {
                    body = EmptyNotesView(
                      key: const ValueKey('empty'),
                      isSearchActive: provider.searchQuery.isNotEmpty,
                    );
                  } else {
                    body = _NotesGrid(
                      key: const ValueKey('grid'),
                      notes: provider.filteredNotes,
                      onTap: (note) => _showNoteSheet(context, note: note),
                      onDelete: (note) =>
                          _handleDelete(context, provider, note),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: AppMotion.medium,
                    switchInCurve: AppMotion.curve,
                    switchOutCurve: Curves.easeIn,
                    child: body,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note'),
        heroTag: 'fab_new_note',
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    NotesProvider provider,
    NoteModel note,
  ) async {
    final confirmed = await showConfirmDeleteDialog(context);
    if (!confirmed) return;

    final success = await provider.deleteNote(note.id);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note deleted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to delete note'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// ─── App Header ─────────────────────────────────────────────────────────────

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.onNewNote});
  final VoidCallback onNewNote;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Notes',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Consumer<NotesProvider>(
                  builder: (_, p, _) {
                    final count = p.notes.length;
                    return Text(
                      count == 0
                          ? 'No notes yet'
                          : '$count ${count == 1 ? 'note' : 'notes'}',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notes Grid ─────────────────────────────────────────────────────────────

class _NotesGrid extends StatelessWidget {
  const _NotesGrid({
    super.key,
    required this.notes,
    required this.onTap,
    required this.onDelete,
  });

  final List<NoteModel> notes;
  final ValueChanged<NoteModel> onTap;
  final ValueChanged<NoteModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        // Staggered fade+slide in — capped at index 10 so long lists stay snappy
        final delay = Duration(milliseconds: (index.clamp(0, 10) * 40));
        return _StaggeredCard(
          delay: delay,
          child: NoteCard(
            note: note,
            onTap: () => onTap(note),
            onDelete: () => onDelete(note),
          ),
        );
      },
    );
  }
}

class _StaggeredCard extends StatefulWidget {
  const _StaggeredCard({required this.delay, required this.child});
  final Duration delay;
  final Widget child;

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppMotion.medium);
    _opacity = CurvedAnimation(parent: _ctrl, curve: AppMotion.curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: AppMotion.curve));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── Add / Edit Bottom Sheet ─────────────────────────────────────────────────

class _NoteSheet extends StatefulWidget {
  const _NoteSheet({this.existingNote});
  final NoteModel? existingNote;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late int _selectedColorValue;

  bool get _isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existingNote?.title ?? '');
    _descCtrl = TextEditingController(
      text: widget.existingNote?.description ?? '',
    );
    _selectedColorValue =
        widget.existingNote?.colorValue ?? defaultNoteColorValue;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<NotesProvider>();
    final title = _titleCtrl.text.trim();
    final description = _descCtrl.text.trim();

    bool success;
    if (_isEditing) {
      success = await provider.updateNote(
        widget.existingNote!.id,
        title,
        description,
        _selectedColorValue,
      );
    } else {
      success = await provider.addNote(title, description, _selectedColorValue);
    }

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Something went wrong'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final isSaving = provider.isSaving;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Text(
                _isEditing ? 'Edit Note' : 'New Note',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),
              // Title field
              NoteFormField(
                controller: _titleCtrl,
                label: 'Title',
                hint: 'Give your note a title…',
                autofocus: !_isEditing,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 14),
              // Description field
              NoteFormField(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Write something…',
                maxLines: 5,
                minLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 20),
              // Color picker
              Text(
                'Color',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ColorPickerRow(
                selectedColorValue: _selectedColorValue,
                onColorSelected: (v) => setState(() => _selectedColorValue = v),
              ),
              const SizedBox(height: 24),
              // Save button
              SaveButton(
                onPressed: () => _save(context),
                isSaving: isSaving,
                label: _isEditing ? 'Update Note' : 'Save Note',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
