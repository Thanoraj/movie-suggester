import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_palette.dart';
import 'package:frontend/features/auth/view/pages/signin_page.dart';
import 'package:frontend/features/auth/view/widgets/custom_filed.dart';
import 'package:frontend/features/auth/view/widgets/gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                  if (val == null || val.isEmpty) {
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
                  if (val == null || val.isEmpty) {
                    return "Please insert a email";
                  } else if (emailRegex.hasMatch(val)) {
                    return "Please insert a valid email address";
                  }
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
                  if (val == null || val.isEmpty) {
                    return "Please insert a password";
                  } else if (val.length < 8) {
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
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
                    children: [
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
                      builder: (context) => SignInPage(),
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
