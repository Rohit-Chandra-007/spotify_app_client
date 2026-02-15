import 'package:client/features/home/model/song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  // ignore: avoid_public_notifier_properties
  AudioPlayer? audioPlayer;

  // ignore: avoid_public_notifier_properties
  bool isPlaying = false;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    // first check if same song is playing or not
    if (audioPlayer != null && state?.id == song.id) {
      // Haan, same gaana hai. Ab Play/Pause toggle karo.
      if (audioPlayer!.playing) {
        audioPlayer!.pause();
        isPlaying = false;
      } else {
        audioPlayer!.play();
        isPlaying = true;
      }
      state = state?.copyWith(colorHexCode: state?.colorHexCode);

      return;
    }

    // this code for the first time song is playing

    // Step B: Purane player ko roko aur dispose karo (agar koi hai toh).
    if (audioPlayer != null) {
      audioPlayer!.stop();
      audioPlayer!.dispose();
    }

    // Step C: Naya player banao aur naya gaana play karo.
    try {
      audioPlayer = AudioPlayer();
      final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
      await audioPlayer!.setAudioSource(audioSource);
      audioPlayer!.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
          state = state?.copyWith(colorHexCode: state?.colorHexCode);
        }
      });
      audioPlayer!.play();
      isPlaying = true;
      state = song;
    } catch (e) {
      rethrow;
    }
  }

  void playOrPause() {
    if (isPlaying) {
      audioPlayer!.pause();
    } else {
      audioPlayer!.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(colorHexCode: state?.colorHexCode);
  }

  void seek(double value) {
    audioPlayer?.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).round(),
      ),
    );
  }
}
