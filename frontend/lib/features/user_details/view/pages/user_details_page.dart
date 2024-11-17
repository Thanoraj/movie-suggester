import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/user_details/view_model/genre_language_view_model.dart';
import 'package:frontend/features/user_details/view_model/user_details_view_model.dart';

import '../widgets/detail_widget.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  const UserDetailsPage({super.key});

  @override
  ConsumerState<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserNotifier = ref.watch(userDetailsViewModelProvider).value;
    final genreLanguageNotifier =
        ref.watch(genreLanguageViewModelProvider).value;
    print(genreLanguageNotifier);

    return Scaffold(
      body: SafeArea(
          child: currentUserNotifier != null
              ? ListView(
                  padding: const EdgeInsets.all(20),
                  children: const [
                    DetailWidget(),
                  ],
                )
              : Center(child: CircularProgressIndicator.adaptive())),
    );
  }
}
