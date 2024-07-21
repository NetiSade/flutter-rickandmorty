import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// A widget that displays a character's image and handles loading from the cache and network.
class CharacterImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CharacterImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileInfo?>(
      future: DefaultCacheManager().getFileFromCache(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // If the image is loaded from the cache, display it using the Image.file widget.
          return Image.file(
            snapshot.data!.file,
            width: width,
            height: height,
            fit: fit,
          );
        } else {
          // If the image is not in the cache, load it from the network using the Image.network widget.
          return Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: width ?? 100);
            },
          );
        }
      },
    );
  }
}
