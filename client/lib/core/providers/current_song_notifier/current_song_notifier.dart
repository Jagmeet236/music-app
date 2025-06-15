import 'package:client/home/model/song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
/// Manages the currently playing song in the app.
class CurrentSongNotifier extends _$CurrentSongNotifier {
  ///
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    return null;
  }

  /// Initializes the audio player with the given song.
  /// Updates the current audio player with the given
  /// song if it has a valid URL.
  Future<void> updateSong(SongModel song) async {
    if (song.songUrl == null) return;
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.songUrl!));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.play();
    state = song;
  }
}
