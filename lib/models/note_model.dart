import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/note_colors.dart';

/// Dart representation of a Firestore note document.
class NoteModel {
  final String id;
  final String title;
  final String description;
  final int colorValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.colorValue,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Build a [NoteModel] from a Firestore [DocumentSnapshot].
  factory NoteModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime ts(String key) {
      final raw = data[key];
      if (raw is Timestamp) return raw.toDate();
      return DateTime.now();
    }

    return NoteModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      // Fall back to the first palette color if colorValue is missing/invalid.
      colorValue: data['colorValue'] as int? ?? defaultNoteColorValue,
      createdAt: ts('createdAt'),
      updatedAt: ts('updatedAt'),
    );
  }

  /// Produces the map written to Firestore on create/update.
  /// Timestamps are intentionally omitted — the service sets them server-side.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'colorValue': colorValue,
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    int? colorValue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
