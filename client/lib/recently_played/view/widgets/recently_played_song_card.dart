import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/home/view/widgets/song_thumbnail.dart';
import 'package:flutter/material.dart';

/// A widget that displays a single [song] in the recently played list.
/// Includes an animated interactive card and a button to remove it.
class RecentlyPlayedSongCard extends StatelessWidget {
  /// Creates a [RecentlyPlayedSongCard] widget.
  const RecentlyPlayedSongCard({
    required this.song, required this.onDelete, super.key,
  });
  /// getting the song
  final SongModel song;
  /// getting the delete callback
  final VoidCallback onDelete;

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
        width: context.width * 0.38,
        height: context.height * 0.25,
        decoration: BoxDecoration(
          color: Palette.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SongThumbnail(
                    imageUrl: song.thumbnailUrl,
                    height: context.height * 0.16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: context.width * 0.08,
                    ), // Spacing to avoid delete icon overlap
                    child: Text(
                      song.songName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Palette.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: context.width * 0.08,
                    ),
                    child: Text(
                      song.artist ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Palette.subtitleText,
                      ),
                    ),
                  ),
                ],
              ),
              // Delete button at bottom right
              Positioned(
                bottom: context.height * 0.001,
                right: context.width * 0.018,
                child: GestureDetector(
                  onTap: onDelete,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white70,
                      size: 18,
                    ),
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
