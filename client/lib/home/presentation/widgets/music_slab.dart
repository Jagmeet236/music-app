import 'dart:math';

import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/song_thumbnail.dart';
import 'package:client/home/presentation/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays a slab UI for the currently playing song
/// with play/pause and like actions.
class MusicSlab extends ConsumerWidget {
  /// Creates a [MusicSlab] widget.
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongState = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    if (currentSongState.song == null) {
      return const SizedBox();
    }

    final song = currentSongState.song!;
    final isPlaying = currentSongState.isPlaying;

    return GestureDetector(
      onTap: () => navigateToMusicPlayer(context),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 70,
              width: context.width - 16,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'music-tag',
                        child: SongThumbnail(
                          imageUrl: song.thumbnailUrl,
                          width: context.width * .14,
                          height: context.height * .09,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.songName ?? 'N/A',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Palette.whiteColor,
                            ),
                          ),
                          Text(
                            song.artist ?? 'N/A',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Palette.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Handle like toggle
                        },
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async => songNotifier.playPause(),
                        icon: Icon(
                          isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Inactive background progress bar
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: context.width - 22,
              decoration: BoxDecoration(
                color: Palette.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),

          /// Active position progress bar
          StreamBuilder<Duration>(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;

              if (position == null ||
                  duration == null ||
                  duration.inMilliseconds == 0) {
                return const SizedBox();
              }

              final sliderValue = (position.inMilliseconds /
                      duration.inMilliseconds)
                  .clamp(0.0, 1.0);

              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: max(0, sliderValue * (context.width - 22)),
                  decoration: BoxDecoration(
                    color: Palette.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Navigates to the music player screen with
  /// a smooth slide-up + fade animation.
  void navigateToMusicPlayer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<dynamic>(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const MusicPlayer();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide up with a smooth cubic ease
          final slideTween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutCubic));

          // Subtle fade-in layered on top of the slide
          final fadeTween = Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeIn));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
