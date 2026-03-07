import 'package:client/core/theme/app_palette.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/view/widgets/song_thumbnail.dart';
import 'package:flutter/material.dart';

/// A modern neumorphic-style song card that displays a song thumbnail,
/// title, and artist with soft shadows for depth.
class SongCard extends StatelessWidget {
  /// Constructs a [SongCard] with the provided [SongModel] data.
  const SongCard({required this.song, super.key});

  /// The song information including name, artist, and thumbnail URL.
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.95, end: 1),
      builder:
          (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
      child: Container(
        width: 180,
        height: 260,
        decoration: BoxDecoration(
          color: Palette.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            // Top-left light shadow
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.05),
              offset: Offset(-4, -4),
              blurRadius: 6,
            ),
            // Bottom-right dark shadow
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              offset: Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Song thumbnail image
              SongThumbnail(
                imageUrl: song.thumbnailUrl,
                height: 180,

                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),

              const SizedBox(height: 10),

              // Song name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  song.songName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Palette.whiteColor,
                  ),
                ),
              ),

              // Artist name
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Text(
                  song.artist ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Palette.subtitleText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
