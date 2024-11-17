import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/models/user_details.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/user_details/model/genre.dart';
import 'package:frontend/features/user_details/model/language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_view_model.g.dart';

@riverpod
class UserDetailsViewModel extends _$UserDetailsViewModel {
  late User? _currentUser;

  List<Language> languges = [];
  List<Genre> genres = [];

  @override
  Future<UserDetails> build() async {
    _currentUser = ref.watch(currentUserNotifierProvider);
    UserDetails userDetails = getUserPreference();
    return userDetails;
  }

  getUserPreference() {
    return UserDetails(preferredGenres: [], preferredLanguages: []);
  }
}
