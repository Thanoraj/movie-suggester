import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/auth/model/user.dart';
import 'package:frontend/features/auth/repositories/auth_local_repository.dart';
import 'package:frontend/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<User>? build() {
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
      Right(value: final r) => await _storeTokenSecurely(r),
    };
    print(val);
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
        Left(value: final _) => null,
        Right(value: final r) => _currentUserNotifier.updateUser(r),
      };
    }
  }

  Future<AsyncValue<User>> _storeTokenSecurely(User user) async {
    ref.read(authLocalRepositoryProvider).setToken(user.token);
    _currentUserNotifier.updateUser(user);
    return state = AsyncValue.data(user);
  }
}
