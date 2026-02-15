import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserProvider)!.token;

  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .getAllSong(token: token);
  return switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw Exception(l.message),
  };
}

@riverpod
class HomeModelView extends _$HomeModelView {
  late HomeRemoteRepository _homeRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artistName,
    required String color,
  }) async {
    state = const AsyncValue.loading();
    final user = _currentUserNotifier.state;
    if (user == null) {
      state = AsyncValue.error('User not logged in', StackTrace.current);
      return;
    }
    final res = await _homeRemoteRepository.uploadSong(
      selectedAudio,
      selectedImage,
      songName,
      artistName,
      color,
      user.token,
    );
    final _ = switch (res) {
      Right(value: final r) => state = AsyncValue.data(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }
}
