import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// A reusable styled [TextFormField] for the note add/edit form.
class NoteFormField extends StatelessWidget {
  const NoteFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final int? minLines;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      autofocus: autofocus,
      validator: validator,
      style: GoogleFonts.nunito(
        fontSize: 15,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
      ),
    );
  }
}
