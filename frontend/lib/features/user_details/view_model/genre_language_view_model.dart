import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/user_details/repositories/static_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'genre_language_view_model.g.dart';

@riverpod
class GenreLanguageViewModel extends _$GenreLanguageViewModel {
  User? _currentUser;

  @override
  Future<Map?> build() async {
    _currentUser = ref.watch(currentUserNotifierProvider);

    await loadOptions();
    return null;
  }

  loadOptions() async {
    final res = await ref
        .read(staticDataRepositoryProvider)
        .getAvailableGenresAndLanguages(_currentUser!.token!);

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }
}
