import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/color_util.dart';
import 'package:client/core/utils/media_res.dart';
import 'package:client/core/widgets/song_thumbnail.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays the music player screen.
class MusicPlayer extends ConsumerStatefulWidget {
  /// Creates a [MusicPlayer] widget.
  const MusicPlayer({super.key});

  /// Creates the mutable state for this widget.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MusicPlayerState();
}

/// State class for MusicPlayer widget.
class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  /// Builds the UI for the music player screen.
  @override
  Widget build(BuildContext context) {
    final currentSongState = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    if (currentSongState.song == null) {
      return const SizedBox();
    }

    final song = currentSongState.song!;
    final isPlaying = currentSongState.isPlaying;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(song.hexCode!), const Color(0xFF000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Palette.transparentColor,
        appBar: AppBar(
          backgroundColor: Palette.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  MediaRes.pullDownArrow,
                  color: Palette.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // / Container for displaying the song's artwork.
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-tag',
                  child: SongThumbnail(
                    imageUrl: song.thumbnailUrl,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.artist ?? 'Unknown Artist',
                            style: context.textTheme.titleLarge?.copyWith(
                              color: Palette.whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          Text(
                            song.songName ?? 'Unknown Name',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Palette.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Live progress slider + time labels driven by positionStream
                  StreamBuilder<Duration>(
                    stream: songNotifier.audioPlayer?.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration =
                          songNotifier.audioPlayer?.duration ?? Duration.zero;
                      final durationMs = duration.inMilliseconds;
                      final sliderValue = durationMs == 0
                          ? 0.0
                          : (position.inMilliseconds / durationMs).clamp(
                              0.0,
                              1.0,
                            );

                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Palette.gradient3,
                              inactiveTrackColor: Palette.greyColor,
                              thumbColor: Palette.whiteColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                            ),
                            child: Slider(
                              value: sliderValue,
                              onChanged: durationMs == 0
                                  ? null
                                  : (value) {
                                      final seekPosition = Duration(
                                        milliseconds:
                                            (value * durationMs).round(),
                                      );
                                      songNotifier.seekTo(seekPosition);
                                    },
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _formatDuration(position),
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: Palette.subtitleText,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDuration(duration),
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: Palette.subtitleText,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          MediaRes.shuffle,
                          color: Palette.whiteColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async => songNotifier.playPrevious(),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            MediaRes.previousSong,
                            color: Palette.whiteColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async => songNotifier.playPause(),
                        icon: Icon(
                          isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          color: Palette.whiteColor,
                          size: 80,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async => songNotifier.playNext(),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            MediaRes.nextSong,
                            color: Palette.whiteColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          MediaRes.repeat,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          MediaRes.connectDevice,
                          color: Palette.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          MediaRes.playlist,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a [Duration] into a `m:ss` string (e.g. 3:07).
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
