import 'dart:ui';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/home/model/song_model.dart';
import 'package:flutter/material.dart';

/// A modern, elevated, glassmorphic-style song card.
class SongCard extends StatelessWidget {
  /// Create the [SongCard] widget
  const SongCard({required this.song, super.key});

  ///
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Base background to prevent black bleed
            Container(
              width: 180,
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1E2E), Color(0xFF2A2A3D)],
                ),
              ),
            ),

            // Semi-transparent gradient layer (optional visual enhancement)
            Container(
              width: 180,
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.03),
                    Color.fromRGBO(255, 255, 255, 0.01),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: const SizedBox(width: 180, height: 260),
            ),

            // Glassmorphic card content
            Material(
              color: const Color.fromRGBO(255, 255, 255, 0.05),
              elevation: 12,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 180,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.15),
                    width: 1.2,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.08),
                      Color.fromRGBO(255, 255, 255, 0.02),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        song.thumbnailUrl ?? '',
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              height: 180,
                              width: 180,
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.music_note,
                                color: Palette.whiteColor,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        song.songName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
