import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/gradient_button.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';
import 'package:frontend/features/user_details/view_model/genre_language_view_model.dart';
import 'package:frontend/features/user_details/view_model/user_details_view_model.dart';

import '../widgets/detail_widget.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  const UserDetailsPage({super.key});

  @override
  ConsumerState<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  bool isSaving = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = ref.watch(userDetailsViewModelProvider);
    final genreAndLanguagesProvider = ref.watch(genreLanguageViewModelProvider);
    ref.listen<AsyncValue<void>>(userDetailsViewModelProvider,
        (previous, next) {
      print(isSaving);
      if (isSaving) {
        if (next is AsyncData) {
          // Navigate to the home screen on successful save
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (next is AsyncError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to save preferences: ${next.error}')),
          );
        }
      }
    });
    return Scaffold(
      body: SafeArea(
        child: genreAndLanguagesProvider.hasValue &&
                userDetailsProvider.hasValue
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DetailWidget(
                      label: "Languages",
                      detailsList:
                          genreAndLanguagesProvider.value!['languages']!,
                      selectedList:
                          userDetailsProvider.value?.preferredLanguages ?? [],
                    ),
                    DetailWidget(
                      label: "Genres",
                      detailsList: genreAndLanguagesProvider.value!['genres']!,
                      selectedList:
                          userDetailsProvider.value?.preferredGenres ?? [],
                    ),
                    const Spacer(),
                    GradientButton(
                      loadingProvider: userDetailsViewModelProvider,
                      buttonText: "Next",
                      onPressed: () {
                        isSaving = true;
                        ref
                            .read(userDetailsViewModelProvider.notifier)
                            .saveUserPreference(
                                userDetailsProvider.valueOrNull!);
                      },
                    ),
                  ],
                ),
              )
            : genreAndLanguagesProvider.hasError
                ? const Center(
                    child: Text("Error Occurred"),
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
      ),
    );
  }
}
