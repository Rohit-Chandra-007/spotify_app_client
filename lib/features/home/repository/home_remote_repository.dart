import 'dart:convert';
import 'dart:io';

import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  Future<Either<AppFailure, String>> uploadSong(
    File selectedSong,
    File selectedImage,
    String title,
    String artistName,
    String colorHexCode,
    String token,
  ) async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverUrl}/song/upload'),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedSong.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'title': title,
          'artist': artistName,
          'color_hex_code': colorHexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(message: 'Something went wrong'));
      }

      final response = await res.stream.bytesToString();
      return Right(response);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSong({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/song/list'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // Replace with your actual token
        },
      );
      final data = json.decode(res.body);
      if (res.statusCode != 200) {
        final failureRes = data as Map<String, dynamic>;
        return Left(AppFailure(message: failureRes['detail']));
      }
      final songs = (data as List)
          .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
