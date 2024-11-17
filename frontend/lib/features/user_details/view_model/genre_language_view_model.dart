import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/user_details/model/detail.dart';
import 'package:frontend/features/user_details/repositories/static_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'genre_language_view_model.g.dart';

@riverpod
class GenreLanguageViewModel extends _$GenreLanguageViewModel {
  User? _currentUser;

  @override
  AsyncValue<Map<String, List<Detail>>> build() {
    state = AsyncValue.loading();
    _currentUser = ref.watch(currentUserNotifierProvider);

    loadOptions();
    return state;
  }

  loadOptions() async {
    final res = await ref
        .read(staticDataRepositoryProvider)
        .getAvailableGenresAndLanguages(_currentUser!.token!);

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = constructDataTypeList(r),
    };
  }

  constructDataTypeList(Map data) {
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
    return AsyncValue.data(detailsMap);
  }
}
