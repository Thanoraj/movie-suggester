import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_palette.dart';
import 'package:frontend/features/auth/view/pages/sign_in_page.dart';
import 'package:frontend/features/auth/view/widgets/custom_filed.dart';
import 'package:frontend/features/auth/view/widgets/gradient_button.dart';
import 'package:frontend/features/auth/view_model/auth_view_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("sign up page");
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
                "Sign Up.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hintText: "Name",
                controller: nameController,
                validator: (String? val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please insert a name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                hintText: "Email",
                controller: emailController,
                validator: (String? val) {
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (val == null || val.trim().isEmpty) {
                    return "Please insert an email";
                  } else if (!emailRegex.hasMatch(val.trim())) {
                    return "Please insert a valid email address";
                  }
                  return null; // No error, email is valid
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
                  if (val == null || val.trim().isEmpty) {
                    return "Please insert a password";
                  } else if (val.trim().length < 8) {
                    return "Please insert a password has at least 8 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                buttonText: "Sign Up",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ref.read(authViewModelProvider.notifier).signUp(
                          nameController.text.trim(),
                          emailController.text.trim().toLowerCase(),
                          passwordController.text.trim(),
                        );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: " Sign in",
                        style: TextStyle(color: AppPalette.gradient2),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
