import 'dart:convert';

import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/view/widgets/model/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}/auth/sign-in'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      final userResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(message: userResponse['detail']));
      }

      return Right(
        UserModel.fromMap(
          userResponse['user'],
        ).copyWith(token: userResponse['token']),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}/auth/sign-up'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final userResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(AppFailure(message: userResponse['detail']));
      }
      return Right(UserModel.fromMap(userResponse));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUser({
    required String authToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/auth/'),
        headers: {
          "Content-Type": "application/json",
          'x-auth-token': authToken,
        },
      );
      final userResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(message: userResponse['detail']));
      }
      return Right(UserModel.fromMap(userResponse).copyWith(token: authToken));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
