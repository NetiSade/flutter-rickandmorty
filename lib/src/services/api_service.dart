import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

/// Service responsible for fetching data from the API
/// For more information on the API, visit https://rickandmortyapi.com/documentation/#rest
class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  /// Fetches a list of characters from the API based on the page and search query (optional)
  /// Search query is used to filter the results based on the character's name
  Future<Map<String, dynamic>> fetchCharacters(
      {required int page, String searchQuery = ''}) async {
    // Construct the request URL based on the search query
    final request = searchQuery.isNotEmpty
        ? '$_baseUrl/character/?page=$page&name=$searchQuery'
        : '$_baseUrl/character/?page=$page';

    final response = await http.get(Uri.parse(request));
    // If success, return the decoded JSON response
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // If the response is 404, return an empty list of results
      if (response.statusCode == 404) {
        return {'results': [], 'info': {}};
      }
      throw Exception('Failed to load characters');
    }
  }
}
