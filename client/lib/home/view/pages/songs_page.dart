import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/home/view/widgets/song_card.dart';
import 'package:client/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page that displays a horizontal list of songs.
class SongsPage extends ConsumerStatefulWidget {
  /// Creates a [SongsPage] widg
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(homeViewModelProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              latestToday,
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),

          songsAsync.when(
            data: (songs) {
              return SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final song = songs[index];

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song);
                      },
                      child: SongCard(song: song),
                    );
                  },
                ),
              );
            },
            error: (error, _) => SizedBox(
              height: 270,
              child: Center(child: Text(error.toString())),
            ),
            loading: () => const SizedBox(
              height: 270,
              child: Center(child: Loader()),
            ),
          ),
        ],
      ),
    );
  }
}
