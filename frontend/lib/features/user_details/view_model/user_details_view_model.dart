import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/models/user_details.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/user_details/model/detail.dart';
import 'package:frontend/features/user_details/repositories/user_details_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_view_model.g.dart';

@riverpod
class UserDetailsViewModel extends _$UserDetailsViewModel {
  User? _currentUser;

  @override
  AsyncValue<UserDetails> build() {
    state = AsyncValue.data(UserDetails(
      preferredGenres: [],
      preferredLanguages: [],
    ));
    _currentUser = ref.watch(currentUserNotifierProvider);

    getUserPreference();
    return state;
  }

  getUserPreference() async {
    final res = await ref
        .read(userDetailsRepositoryProvider)
        .getUserPreferences(_currentUser!.token!);

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(UserDetails.fromMap(r)),
    };
  }

  saveUserPreference(UserDetails userDetails) async {
    state = const AsyncValue.loading();

    List<String> listGenres =
        userDetails.preferredGenres.map((detail) => detail.name).toList();
    List<String> listLanguages =
        userDetails.preferredLanguages.map((detail) => detail.name).toList();

    final res = await ref
        .read(userDetailsRepositoryProvider)
        .saveUserPreferences(_currentUser!.token!, listGenres, listLanguages);

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final _) => getUserPreference(),
    };
  }

  Map<String, List<Detail>> constructDataTypeList(Map data) {
    // Transforming the Map
    Map<String, List<Detail>> detailsMap = data.map((key, value) {
      late List<Detail> val; // Declare the list

      // Handle known types
      if (key == "genres" && value is List) {
        val = value.map((name) => Genre(name: name)).toList();
      } else if (key == "languages" && value is List) {
        val = value.map((name) => Language(name: name)).toList();
      } else {
        throw ArgumentError("Unknown details type for key: $key");
      }

      // Return the transformed entry
      return MapEntry(key.toString(), val);
    });

    // Wrap result in AsyncValue
    return detailsMap;
  }
}
