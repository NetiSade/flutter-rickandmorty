import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/api_service.dart';

/// A provider that manages the state of the characters.
/// It fetches characters from the API and updates the state accordingly.
/// It also provides helper methods to navigate through the list of characters.
class CharacterProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Character> _characters = [];

  bool _isLoading = false;
  bool _hasNextPage = true;
  String? _error;
  String _searchQuery = '';
  int _currentPage = 1;

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasNextPage => _hasNextPage;

  /// Fetches characters from the API based on the search query(optional) and page number. and updates the state.
  Future<void> fetchCharacters({String searchQuery = ''}) async {
    if (searchQuery != _searchQuery) {
      // If the search query has changed, reset the state and start from the first page
      resetState();
    }

    // If we are already loading or there are no more pages to fetch, return
    if (_isLoading || !_hasNextPage) return;

    // Set the loading state and search query
    _isLoading = true;
    _error = null;
    _searchQuery = searchQuery;
    // Notify listeners to update the UI
    notifyListeners();

    try {
      final result = await _apiService.fetchCharacters(
          page: _currentPage, searchQuery: _searchQuery);
      final List<dynamic> results = result['results'];
      // decode the JSON response and add the characters to the list
      _characters.addAll(results.map((json) => Character.fromJson(json)));
      // Update the current page and check if there is a next page
      _currentPage++;
      _hasNextPage = result['info']['next'] != null;
    } catch (e) {
      _error = 'Failed to load characters: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to get the index of a character in the list
  int getCharacterIndex(int id) {
    return _characters.indexWhere((character) => character.id == id);
  }

  // Helper methods to get the next character
  Character? getNextCharacter(int currentId) {
    int currentIndex = getCharacterIndex(currentId);
    if (currentIndex < _characters.length - 1) {
      return _characters[currentIndex + 1];
    }
    return null;
  }

  // Helper methods to get the previous character
  Character? getPreviousCharacter(int id) {
    int currentIndex = getCharacterIndex(id);
    if (currentIndex > 0) {
      return _characters[currentIndex - 1];
    }
    return null;
  }

  // Helper methods to check if the character is the last on the list (and last page)
  bool isLastCharacter(int id) {
    return !_hasNextPage && getCharacterIndex(id) == _characters.length - 1;
  }

  // Helper methods to check if the character is the first on the list
  bool isFirstCharacter(int id) {
    return getCharacterIndex(id) == 0;
  }

  // Helper method to get the next character, even if it is on the next page
  Future<Character?> fetchNextPageAndGetNextCharacter(int currentId) async {
    Character? nextCharacter = getNextCharacter(currentId);
    if (nextCharacter == null && _hasNextPage) {
      await fetchCharacters(searchQuery: _searchQuery); // Fetch the next page
      nextCharacter =
          getNextCharacter(currentId); // Try to get the next character again
    }
    return nextCharacter;
  }

  // Helper method to reset the state of the provider
  void resetState() {
    _characters = [];
    _isLoading = false;
    _error = null;
    _searchQuery = '';
    _currentPage = 1;
    _hasNextPage = true;
    notifyListeners();
  }
}
