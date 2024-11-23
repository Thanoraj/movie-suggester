import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/repositories/auth_local_repository.dart';
import 'package:frontend/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<bool>? build() {
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();

    await Future.delayed(
      const Duration(seconds: 3),
    );

    final res = await ref
        .read(authRemoteRepositoryProvider)
        .signUp(name, email, password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final _) => state =
          AsyncValue.data(_handleSignupSuccess(name, email)),
    };
    print(val);
  }

  bool _handleSignupSuccess(name, email) {
    User tempUser = User(name: name, email: email, id: "0");
    _currentUserNotifier.updateUser(tempUser);
    return true;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();

    final res =
        await ref.read(authRemoteRepositoryProvider).signIn(email, password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l,
          StackTrace.current,
        ),
      Right(value: final r) => await _storeTokenSecurely(r),
    };
    print(val);
  }

  Future getSignedInUser() async {
    String? token = await ref.read(authLocalRepositoryProvider).getToken();
    if (token != null) {
      final res = await ref.read(authRemoteRepositoryProvider).getUser(token);
      var _ = switch (res) {
        Left(value: final _) => _signoutUser(),
        Right(value: final r) => _currentUserNotifier.updateUser(r),
      };
    } else {
      state = null;
    }
  }

  Future _signoutUser() async {
    ref.read(authLocalRepositoryProvider).setToken(null);
    state = null;
  }

  Future<AsyncValue<bool>> _storeTokenSecurely(User user) async {
    ref.read(authLocalRepositoryProvider).setToken(user.token);
    _currentUserNotifier.updateUser(user);
    return state = const AsyncValue.data(true);
  }
}
