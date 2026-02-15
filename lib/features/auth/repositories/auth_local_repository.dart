import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreference;

  Future<void> init() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) _sharedPreference.setString('x-auth-token', token);
  }

  String? getToken() {
    return _sharedPreference.getString('x-auth-token');
  }

  Future<void> removeToken() async {
    await _sharedPreference.remove('x-auth-token');
  }
}
