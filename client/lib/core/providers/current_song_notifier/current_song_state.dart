import 'package:client/home/data/models/song_model.dart';
import 'package:equatable/equatable.dart';

/// Represents the state of the currently playing song,
/// including its play status.
class CurrentSongState extends Equatable {
  /// Creates a [CurrentSongState] with the given [song] and [isPlaying] flag.
  const CurrentSongState({this.song, this.isPlaying = false});

  /// The currently playing song.
  final SongModel? song;

  /// Whether the song is currently playing.
  final bool isPlaying;

  /// Returns a new [CurrentSongState] with updated values.
  CurrentSongState copyWith({SongModel? song, bool? isPlaying}) {
    return CurrentSongState(
      song: song ?? this.song,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [song, isPlaying];
}
