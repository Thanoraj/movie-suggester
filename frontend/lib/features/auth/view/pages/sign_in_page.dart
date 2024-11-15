import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:frontend/core/theme/app_palette.dart';
import 'package:frontend/features/auth/view/widgets/custom_filed.dart';
import 'package:frontend/features/auth/view/widgets/gradient_button.dart';
import 'package:frontend/features/auth/view_model/auth_view_model.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("sign in page");

    ref.listen(authViewModelProvider, (previous, next) {
      next?.when(
          data: (data) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((error as Failure).message)),
            );
          },
          loading: () {});
      if (next != null && next.hasValue) {
        // Navigate to HomePage if authenticated
      } else if (next != null && next.hasError) {
        // Show an error message if authentication failed
      }
    });
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                hintText: "Email",
                controller: emailController,
                validator: (String? val) {
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
                validator: (String? val) {
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                buttonText: "Sign In",
                onPressed: () async {
                  ref.read(authViewModelProvider.notifier).signIn(
                        emailController.text.trim().toLowerCase(),
                        passwordController.text.trim(),
                      );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: " Sign Up",
                        style: TextStyle(color: AppPalette.gradient2),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
