import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/home/view/widgets/song_card.dart';
import 'package:client/home/viewmodel/home_viewmodel.dart';
import 'package:client/recently_played/view/widgets/recently_played_songs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page that displays a vertical scrollable
/// screen containing horizontal lists of songs.
class SongsPage extends ConsumerStatefulWidget {
  /// Creates a [SongsPage] widget.
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(homeViewModelProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.read(homeViewModelProvider.notifier).fetchSongs(),
        color: Colors.pinkAccent,
        backgroundColor: Colors.grey.shade900,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // 1. Latest Today Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
                child: Text(
                  latestToday,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: context.height * 0.02)),

            // 2. Latest Today List Section (gracefully handles failure)
            SliverToBoxAdapter(
              child: songsAsync.when(
                data: (songs) {
                  return SizedBox(
                    height: context.height * 0.3,
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
                error:
                    (error, _) => SizedBox(
                      height:
                          120, // Small error container, doesn't block screen
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              color: Colors.white54,
                              size: 30,
                            ),
                            SizedBox(height: context.height * 0.01),
                            Text(
                              errCouldNotLoadLatestSongs,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                loading:
                    () => SizedBox(
                      height: context.height * 0.3,
                      child: const Center(child: Loader()),
                    ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: context.height * 0.02)),

            // 3. Recently Played Songs Section
            // This remains unaffected by API
            // failures and retains its state internally
            const SliverToBoxAdapter(child: RecentlyPlayedSongs()),

            // Bottom padding to ensure last item can be scrolled past the player
            SliverToBoxAdapter(child: SizedBox(height: context.height * 0.15)),
          ],
        ),
      ),
    );
  }
}
