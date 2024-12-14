import 'package:frontend/core/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  User? build() {
    return null;
  }

  void updateUser(User user) {
    state = user;
    print("user updated");
  }
}
