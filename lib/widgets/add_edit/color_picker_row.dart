import 'package:flutter/material.dart';
import '../../utils/note_colors.dart';
import '../../utils/app_motion.dart';

/// A horizontal row of tappable color swatches.
/// The selected swatch shows a ring and scales up slightly.
class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.selectedColorValue,
    required this.onColorSelected,
  });

  final int selectedColorValue;
  final ValueChanged<int> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: noteColorPalette.map((color) {
        final isSelected = color.toARGB32() == selectedColorValue;
        return GestureDetector(
          onTap: () => onColorSelected(color.toARGB32()),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.curve,
            width: isSelected ? 36 : 32,
            height: isSelected ? 36 : 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
