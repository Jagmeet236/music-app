import 'package:client/home/data/models/song_model.dart';
import 'package:equatable/equatable.dart';

/// Represents the state of the currently playing song,
/// including its play status and current index in the queue.
class CurrentSongState extends Equatable {
  /// Creates a [CurrentSongState] with the given parameters.
  const CurrentSongState({
    this.song,
    this.isPlaying = false,
    this.currentIndex,
  });

  /// The currently playing song.
  final SongModel? song;

  /// Whether the song is currently playing.
  final bool isPlaying;

  /// The index of the currently playing song in the playlist.
  /// Stored for display purposes; the actual playlist lives in the notifier.
  final int? currentIndex;

  /// Returns a new [CurrentSongState] with updated values.
  CurrentSongState copyWith({
    SongModel? song,
    bool? isPlaying,
    int? currentIndex,
  }) {
    return CurrentSongState(
      song: song ?? this.song,
      isPlaying: isPlaying ?? this.isPlaying,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [song, isPlaying, currentIndex];
}
