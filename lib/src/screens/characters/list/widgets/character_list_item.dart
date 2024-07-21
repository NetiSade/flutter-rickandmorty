import 'package:flutter/material.dart';

import '../../../../models/character.dart';
import '../../widgets/character_image.dart';

/// A widget that displays a character's information in a ListTile.
class CharacterListItem extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterListItem({
    Key? key,
    required this.character,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Wrap the leading widget with a Hero widget to animate the transition between the character's image in the list and the details screen.
      leading: Hero(
        // Use the character's ID as the tag to ensure that the Hero widgets in the list and details screen match.
        tag: 'character-${character.id}',
        child: ClipOval(
          // Wrap the image with a ClipOval widget to display it as a circle.
          child: SizedBox(
            width: 50,
            height: 50,
            child: CharacterImage(
              imageUrl: character.image,
              // Use BoxFit.cover to scale the image and clip it to fit the circle.
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(character.name),
      subtitle: Text(character.species),
      onTap: onTap,
    );
  }
}
