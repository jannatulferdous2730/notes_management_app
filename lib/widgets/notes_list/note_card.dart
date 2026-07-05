import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_time_helper.dart';
import '../../utils/app_motion.dart';

/// A single note card shown in the masonry grid.
/// Tapping opens the edit sheet; the delete icon triggers the confirm dialog.
class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(widget.note.colorValue);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Content
                  Expanded(
                    child: AnimatedContainer(
                      duration: AppMotion.fast,
                      color: accentColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 14, 8, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + delete icon row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.note.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                _DeleteButton(onDelete: widget.onDelete),
                              ],
                            ),
                            if (widget.note.description.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                widget.note.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 10),
                            // Timestamp
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 11,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  formatNoteDate(widget.note.updatedAt),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  const _DeleteButton({required this.onDelete});
  final VoidCallback onDelete;

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onDelete,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.error.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 17,
            color: _hovered
                ? AppColors.error
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
