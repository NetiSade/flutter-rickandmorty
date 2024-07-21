import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/character.dart';
import '../../../../providers/character_provider.dart';
import '../../details/character_details_screen.dart';
import 'character_list_item.dart';
import 'empty_state.dart';
import 'error_state.dart';
import '../../details/widgets/loading_state.dart';

/// A widget that displays a list of characters.
/// The user can tap on a character to view its details.
/// The list supports paging and displays loading and error states.
class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  // Navigate to the character details screen when a character is tapped.
  void _onCharacterTap(BuildContext context, Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CharacterDetailsScreen(initialCharacter: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, provider, child) {
        if (provider.error != null) {
          return const ErrorState();
        }

        if (provider.characters.isEmpty && provider.isLoading) {
          return const LoadingState();
        }

        if (provider.characters.isEmpty) {
          return const EmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          // Add 1 to the itemCount to display a loading indicator at the end of the list when loading more characters.
          itemCount:
              provider.characters.length + (provider.hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.characters.length) {
              // Display a loading indicator at the end of the list when loading more characters.
              return const Center(child: CircularProgressIndicator());
            }

            final character = provider.characters[index];
            return CharacterListItem(
                character: character,
                onTap: () => _onCharacterTap(context, character));
          },
        );
      },
    );
  }
}
