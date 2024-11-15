import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/view/pages/sign_up_page.dart';
import 'package:frontend/features/auth/view_model/auth_view_model.dart';
import 'package:frontend/features/user_details/view/pages/user_details_page.dart';

import 'core/models/user.dart';

User? user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).getSignedInUser();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    print("My App $user");
    return MaterialApp(
      title: 'Movie Suggester',
      theme: AppTheme.darkTheme,
      home: user != null ? const UserDetailsPage() : const SignUpPage(),
    );
  }
}
