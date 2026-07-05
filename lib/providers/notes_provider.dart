import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';

/// Central state manager for notes, search, and async operation flags.
/// UI should always read [filteredNotes], never [notes] directly.
class NotesProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription<List<NoteModel>>? _subscription;

  List<NoteModel> _notes = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Live-filtered list the UI reads from. Always use this, not [notes].
  List<NoteModel> get filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    final q = _searchQuery.toLowerCase();
    return _notes
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.description.toLowerCase().contains(q),
        )
        .toList();
  }

  NotesProvider() {
    _subscribe();
  }

  void _subscribe() {
    _isLoading = true;
    _subscription = _service.streamNotes().listen(
      (notes) {
        _notes = notes;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Updates the search query and triggers a UI rebuild.
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clears any previously stored error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Creates a new note. Returns `true` on success so the caller can close the sheet.
  Future<bool> addNote(
    String title,
    String description,
    int colorValue,
  ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.addNote(title, description, colorValue);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Updates an existing note. Returns `true` on success.
  Future<bool> updateNote(
    String id,
    String title,
    String description,
    int colorValue,
  ) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.updateNote(id, title, description, colorValue);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Deletes a note. Returns `true` on success.
  Future<bool> deleteNote(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.deleteNote(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
