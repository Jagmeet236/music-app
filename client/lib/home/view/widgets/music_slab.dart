import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class MusicSlab extends ConsumerWidget {
  ///
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    if (currentSong == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: hexToColor(currentSong.hexCode ?? ''),
            borderRadius: BorderRadius.circular(4),
          ),
          height: 86,
          width: context.width - 16,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnailUrl ?? ''),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.songName ?? 'N/A',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Palette.whiteColor,
                        ),
                      ),
                      Text(
                        currentSong.artist ?? 'N/A',
                        style: context.textTheme.titleMedium?.copyWith(
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
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.heart,
                      color: Palette.whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.play_circle_fill,
                      color: Palette.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: 20,
            decoration: BoxDecoration(
              color: Palette.whiteColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: context.width - 32,
            decoration: BoxDecoration(
              color: Palette.inactiveSeekColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
