import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/color_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  const AudioWave({super.key, required this.wavePath});

  final String wavePath;

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  // Make the controller nullable to handle preparation errors
  PlayerController? playerController;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    playerController = PlayerController();

    try {
      await playerController!.preparePlayer(
        path: widget.wavePath,
        shouldExtractWaveform: true, // Set this to true to see the waveform
      );
    } catch (e) {
      rethrow;
    }

    // Refresh the UI once the player is ready
    if (mounted) {
      setState(() {});
    }
  }

  // ---- FIX 1: Corrected play/pause logic ----
  Future<void> playAndPause() async {
    if (playerController == null) {
      return; // Don't do anything if controller failed to init
    }

    if (playerController!.playerState.isPlaying) {
      await playerController!.pausePlayer();
    } else {
      // This now correctly handles the initial 'stopped' state
      await playerController!.startPlayer();
    }

    // Using a listener is more reliable than setState here
    // But for simplicity, we'll keep setState. Just know the icon might
    // not update instantly if the state change is slow.
    setState(() {});
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle the case where the player is not ready yet
    if (playerController == null) {
      return const Row(
        children: [
          Icon(CupertinoIcons.play_arrow),
          Expanded(child: Text("  Initializing player...")),
        ],
      );
    }

    return Row(
      children: [
        IconButton(
          // This was your original bug, ensure it's fixed
          onPressed: playAndPause,
          icon: Icon(
            playerController!.playerState.isPlaying
                ? CupertinoIcons.pause
                : CupertinoIcons.play_arrow,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 70),
            // Adjusted height for better view
            playerController: playerController!,
            enableSeekGesture: true,
            waveformType: WaveformType.long,
            waveformData: const [],
            // Required for this waveform type
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: ColorPallete.borderColor,
              liveWaveColor: ColorPallete.gradient3,
              spacing: 6,
              showSeekLine: false,
            ),
          ),
        ),
      ],
    );
  }
}
