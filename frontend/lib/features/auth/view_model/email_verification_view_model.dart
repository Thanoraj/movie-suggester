import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/core/repositories/auth_local_repository.dart';
import 'package:frontend/features/auth/model/verification_status.dart';
import 'package:frontend/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_view_model.g.dart';

@riverpod
class EmailVerificationViewModel extends _$EmailVerificationViewModel {
  User? _user;
  Timer? _verificationPollingTimer;

  @override
  AsyncValue<VerificationStatus>? build() {
    _user = ref.watch(currentUserNotifierProvider);

    return null;
  }

  sendVerificationEmail() async {
    state = const AsyncValue.loading();
    print(_user!.email);
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .sendVerificationEmail(_user!.email);

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final _) => startVerificationPolling(_user!.email),
    };
  }

  Future<void> _getVerificationStatus(String email) async {
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .getVerificationStatus(email);

    state = switch (res) {
      Left(value: final l) =>
        AsyncValue.error(_handleVerificationError(l), StackTrace.current),
      Right(value: final r) => AsyncValue.data(_handleVerificationStatus(r)),
    };
  }

  _handleVerificationError(l) {
    stopVerificationPolling();
    return l;
  }

  VerificationStatus _handleVerificationStatus(
      VerificationStatus verificationStatus) {
    print(verificationStatus.toString());
    if (verificationStatus.verified) {
      ref.watch(authLocalRepositoryProvider).setToken(verificationStatus.token);
      ref
          .watch(currentUserNotifierProvider.notifier)
          .updateUser(verificationStatus.user!);
    }
    if (verificationStatus.verified || verificationStatus.expired) {
      stopVerificationPolling();
    }
    return verificationStatus;
  }

  void startVerificationPolling(String email) {
    _verificationPollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        _getVerificationStatus(email);
      } catch (e) {
        AsyncValue.error(e, StackTrace.current);
      }
    });
  }

  void stopVerificationPolling() {
    _verificationPollingTimer?.cancel();
  }
}
