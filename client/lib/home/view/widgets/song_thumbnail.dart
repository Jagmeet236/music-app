import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that displays a song thumbnail with optional border
/// radius and dimensions.
class SongThumbnail extends StatelessWidget {
  /// Creates a [SongThumbnail] widget
  const SongThumbnail({
    required this.imageUrl,
    super.key,
    this.width = 180,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? imageUrl;
  final double width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallbackThumbnail();
    }

    // Only apply cacheHeight on real device, not emulator
    final image =
        kIsWeb || defaultTargetPlatform == TargetPlatform.iOS
            ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => _fallbackThumbnail(),
            )
            : Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
              // Avoid cacheHeight to prevent GL mipmap crash in Android emulator
              errorBuilder: (_, __, ___) => _fallbackThumbnail(),
            );

    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius!, child: image)
        : image;
  }

  Widget _fallbackThumbnail() => Container(
    width: width,
    height: height,
    color: Colors.grey.shade800,
    child: const Icon(Icons.music_note, color: Colors.white),
  );
}
