import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/providers/current_song_notifier/current_song_notifier.dart';
import 'package:client/core/widgets/app_dialog.dart';
import 'package:client/home/data/models/song_model.dart';
import 'package:client/recently_played/presentation/viewmodels/recently_played_viewmodel.dart';
import 'package:client/recently_played/presentation/widgets/recently_played_song_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Recently played songs widget
class RecentlyPlayedSongs extends ConsumerStatefulWidget {
  /// Creates a [RecentlyPlayedSongs] widget.
  const RecentlyPlayedSongs({super.key});

  @override
  ConsumerState<RecentlyPlayedSongs> createState() =>
      _RecentlyPlayedSongsWidgetState();
}

class _RecentlyPlayedSongsWidgetState
    extends ConsumerState<RecentlyPlayedSongs> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<SongModel> _localSongs = [];
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    // Listen to changes to sync AnimatedList
    ref.listen(recentlyPlayedViewModelProvider, (previous, next) {
      if (next.isLoading) return;

      final newSongs = next.valueOrNull ?? [];

      if (_isFirstLoad) {
        _localSongs = List.from(newSongs);
        _isFirstLoad = false;
        return;
      }

      // Handle Removals
      for (var i = _localSongs.length - 1; i >= 0; i--) {
        if (!newSongs.any((s) => s.id == _localSongs[i].id)) {
          final removed = _localSongs.removeAt(i);
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => _buildItemWithAnimation(removed, animation),
          );
        }
      }

      // Handle Reordering (Moving an existing song to index 0)
      if (newSongs.isNotEmpty && _localSongs.isNotEmpty) {
        if (newSongs.first.id != _localSongs.first.id) {
          final oldIndex = _localSongs.indexWhere(
            (s) => s.id == newSongs.first.id,
          );
          if (oldIndex != -1) {
            final movedItem = _localSongs.removeAt(oldIndex);

            // Remove from old position
            _listKey.currentState?.removeItem(
              oldIndex,
              (context, animation) =>
                  _buildItemWithAnimation(movedItem, animation),
            );

            // Insert at top
            _localSongs.insert(0, movedItem);
            _listKey.currentState?.insertItem(0);
          }
        }
      }

      // Handle Insertions
      for (var i = 0; i < newSongs.length; i++) {
        if (!_localSongs.any((s) => s.id == newSongs[i].id)) {
          _localSongs.insert(i, newSongs[i]);
          _listKey.currentState?.insertItem(i);
        }
      }
    });

    final recentSongsAsync = ref.watch(recentlyPlayedViewModelProvider);

    return recentSongsAsync.when(
      data: (songs) {
        if (_isFirstLoad) {
          _localSongs = List.from(songs);
          _isFirstLoad = false;
        }

        if (_localSongs.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                recentlyPlayed,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            SizedBox(
              height: context.height * 0.25,
              child: AnimatedList(
                key: _listKey,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                initialItemCount: _localSongs.length,
                itemBuilder: (context, index, animation) {
                  return _buildItemWithAnimation(_localSongs[index], animation);
                },
              ),
            ),
            SizedBox(height: context.height * 0.01),
          ],
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _buildItemWithAnimation(SongModel song, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              ref.read(currentSongNotifierProvider.notifier).updateSong(song);
            },
            child: RecentlyPlayedSongCard(
              song: song,
              onDelete: () => _confirmDelete(song),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(SongModel song) {
    showAppDialog<void>(
      context,
      AppDialog(
        title: deleteFromHistoryTitle,
        subtitle: deleteFromHistorySubtitle,
        imagePosition: ImagePosition.aboveText,
        image: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            song.thumbnailUrl ?? '',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.music_note, size: 80),
          ),
        ),
        buttons: [
          AppDialogButton.no(text: cancel, onTap: () => Navigator.pop(context)),
          AppDialogButton.yes(
            text: delete,
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(recentlyPlayedViewModelProvider.notifier)
                  .removeRecentlyPlayedSong(song.id!);
            },
          ),
        ],
      ),
    );
  }
}
