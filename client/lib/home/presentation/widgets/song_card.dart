import 'package:client/core/theme/app_palette.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/presentation/widgets/song_thumbnail.dart';
import 'package:flutter/material.dart';

/// A modern flat-style song card with a subtle white border
/// and clean dark surface. No elevation or shadows are used.
class SongCard extends StatelessWidget {
  /// Creates a [SongCard] widget.
  const SongCard({required this.song, super.key});

  /// Song data
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 180,
        height: 260,
        decoration: BoxDecoration(
          color: Palette.cardColor,
          borderRadius: BorderRadius.circular(20),

          /// Clean white border
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Song Thumbnail
              SongThumbnail(
                imageUrl: song.thumbnailUrl,
                height: 180,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),

              const SizedBox(height: 12),

              /// Song Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

              const SizedBox(height: 4),

              /// Artist Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
