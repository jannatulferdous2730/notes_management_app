import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import '../utils/constants.dart';

/// The single point of contact with Cloud Firestore.
/// Providers call this service; nothing else imports cloud_firestore directly.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns a live stream of all notes, newest first.
  Stream<List<NoteModel>> streamNotes() {
    return _db
        .collection(notesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(NoteModel.fromSnapshot).toList(),
        );
  }

  /// Adds a new note document. Timestamps are set server-side.
  Future<void> addNote(
    String title,
    String description,
    int colorValue,
  ) async {
    try {
      await _db.collection(notesCollection).add({
        'title': title,
        'description': description,
        'colorValue': colorValue,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to add note: ${e.message}');
    }
  }

  /// Updates an existing note's content. Only [updatedAt] changes server-side.
  Future<void> updateNote(
    String id,
    String title,
    String description,
    int colorValue,
  ) async {
    try {
      await _db.collection(notesCollection).doc(id).update({
        'title': title,
        'description': description,
        'colorValue': colorValue,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to update note: ${e.message}');
    }
  }

  /// Permanently deletes a note document by its Firestore [id].
  Future<void> deleteNote(String id) async {
    try {
      await _db.collection(notesCollection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete note: ${e.message}');
    }
  }
}
