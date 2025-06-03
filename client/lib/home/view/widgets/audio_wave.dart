import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// This widget displays an audio waveform visualization.
class AudioWave extends StatefulWidget {
  /// Constructor for [AudioWave]
  const AudioWave({required this.audioPath, super.key});

  /// The path to the audio file to visualize.
  final String audioPath;

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future<void> initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.audioPath);

    playerController.onCompletion.listen((_) async {
      debugPrint('Playback completed');
      await playerController.stopPlayer(); // Reset player state
      setState(() {}); // Refresh UI to update play icon
    });
  }

  Future<void> playAudio() async {
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    } else {
      // Fix: If player is stopped, prepare it again
      if (playerController.playerState.isStopped) {
        await playerController.preparePlayer(path: widget.audioPath);
      }
      await playerController.startPlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAudio,
          icon: Icon(
            playerController.playerState.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Palette.borderColor,
              liveWaveColor: Palette.gradient2,
              spacing: 6,
              showSeekLine: false,
            ),
          ),
        ),
      ],
    );
  }
}
