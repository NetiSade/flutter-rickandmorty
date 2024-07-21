import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/character_provider.dart';
import '../../../models/character.dart';
import '../widgets/character_image.dart';
import 'widgets/loading_state.dart';
import 'widgets/character_info.dart';

/// A screen that displays the details of a single character.
/// It allows the user to navigate to the previous and next characters in the list.
/// The screen uses a Hero widget to animate the transition between the character's image in the list and the details screen.
class CharacterDetailsScreen extends StatefulWidget {
  final Character initialCharacter;

  const CharacterDetailsScreen({Key? key, required this.initialCharacter})
      : super(key: key);

  @override
  CharacterDetailsScreenState createState() => CharacterDetailsScreenState();
}

class CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late Character currentCharacter;

  @override
  void initState() {
    super.initState();
    currentCharacter = widget.initialCharacter;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(provider),
      body: provider.isLoading ? const LoadingState() : _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCharacterImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CharacterInfo(character: currentCharacter, context: context),
          ),
        ],
      ),
    );
  }

  void _loadPreviousCharacter(CharacterProvider provider) {
    final prevCharacter = provider.getPreviousCharacter(currentCharacter.id);
    if (prevCharacter != null) {
      setState(() {
        // if the previous character is not null, update the current character
        currentCharacter = prevCharacter;
      });
    }
  }

  Future<void> _loadNextCharacter(CharacterProvider provider) async {
    final nextCharacter =
        await provider.fetchNextPageAndGetNextCharacter(currentCharacter.id);
    if (nextCharacter != null) {
      setState(() {
        // if the next character is not null, update the current character
        currentCharacter = nextCharacter;
      });
    }
  }

  AppBar _buildAppBar(CharacterProvider provider) {
    return AppBar(
      title: const Text('Character Details'),
      actions: [
        IconButton(
            // Disable the button if the current character is the first one
            onPressed: provider.isFirstCharacter(currentCharacter.id)
                ? null
                : () => _loadPreviousCharacter(provider),
            icon: const Icon(Icons.arrow_back)),
        IconButton(
            //  Disable the button if the current character is the last one
            onPressed: provider.isLastCharacter(currentCharacter.id)
                ? null
                : () => _loadNextCharacter(provider),
            icon: const Icon(Icons.arrow_forward))
      ],
    );
  }

  Hero _buildCharacterImage() {
    // Wrap the image in a Hero widget to enable the transition animation
    return Hero(
      tag: 'character-${currentCharacter.id}',
      child: AspectRatio(
        // Use an aspect ratio of 1 to make the image square
        aspectRatio: 1,
        child: CharacterImage(
          imageUrl: currentCharacter.image,
          // Use BoxFit.contain to avoid cropping the image
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
