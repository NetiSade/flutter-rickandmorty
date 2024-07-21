import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/character_provider.dart';
import '../../../utils/debouncer.dart';
import 'widgets/app_drawer.dart';
import 'widgets/character_list.dart';

/// A screen that displays a list of characters.
/// The user can search for characters and scroll to load more.
/// The screen also contains a drawer for navigation.
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  CharacterListScreenState createState() => CharacterListScreenState();
}

class CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  // The debouncer is used to delay the search query
  final Debouncer _debouncer =
      Debouncer(milliseconds: 500); // Initialize the debouncer

  @override
  void initState() {
    super.initState();
    // Listen to scroll events
    _scrollController.addListener(_onScroll);
    // Fetch characters after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchCharacters(searchQuery: _searchController.text);
    });
    // Listen to changes in the search query
    _searchController.addListener(_onSearchQueryChange);
  }

  void _onSearchQueryChange() {
    // Call the debouncer to delay the search query
    _debouncer.run(() {
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchCharacters(searchQuery: _searchController.text);
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and listeners
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more characters when the user reaches the end of the list
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchCharacters(searchQuery: _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      drawer: const AppDrawer(),
      body: CharacterList(scrollController: _scrollController),
    );
  }

  TextField _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Search Characters',
        border: InputBorder.none,
      ),
    );
  }
}
