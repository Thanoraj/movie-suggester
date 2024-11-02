import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_palette.dart';
import 'package:frontend/features/auth/view/widgets/custom_filed.dart';
import 'package:frontend/features/auth/view/widgets/gradient_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                    text: "Don\'t have an account?",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
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
