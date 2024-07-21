import 'package:flutter/material.dart';

import '../../../../models/character.dart';

/// A widget that displays the character's information in a centered column.
class CharacterInfo extends StatelessWidget {
  const CharacterInfo({
    super.key,
    required this.character,
    required this.context,
  });

  final Character character;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCentredText(character.name,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        _buildCentredText('Status: ${character.status}'),
        _buildCentredText('Species: ${character.species}'),
        _buildCentredText('Gender: ${character.gender}'),
        _buildCentredText('Type: ${character.type}'),
        _buildCentredText('Location: ${character.location.name}'),
        _buildCentredText('Origin: ${character.origin.name}'),
      ],
    );
  }

  Text _buildCentredText(String text, {TextStyle? style}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: style,
    );
  }
}
