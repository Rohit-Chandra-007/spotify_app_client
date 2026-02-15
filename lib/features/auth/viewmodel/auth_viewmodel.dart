import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/model/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    // ignore: only_use_keep_alive_inside_keep_alive
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> initSharedPreference() async {
    await _authLocalRepository.init();
  }

  Future<void> userSignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final _ = switch (res) {
      Right() => await login(email: email, password: password),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final _ = switch (res) {
      Right(value: final r) => state = _loginSuccess(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }

  AsyncValue<UserModel> _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  /// can be null if user logged in for the first time
  Future<UserModel?> getCurrentUser() async {
    final token = _authLocalRepository.getToken();
    if (token == null) {
      state = null;
      return null;
    }

    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.getCurrentUser(authToken: token);
    final val = switch (res) {
      Right(value: final r) => state = _getDataSuccess(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };

    return val.value;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return AsyncValue.data(user);
  }
}
