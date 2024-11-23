import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:frontend/core/widgets/gradient_button.dart';
import 'package:frontend/features/auth/model/verification_status.dart';
import 'package:frontend/features/auth/view_model/email_verification_view_model.dart';
import 'package:frontend/features/user_details/view/pages/user_details_page.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({
    super.key,
    required this.verificationMessage,
  });
  final String verificationMessage;

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    final VerificationStatus? verificationStatus =
        ref.watch(emailVerificationViewModelProvider)?.valueOrNull;
    print("verificationStatus $verificationStatus");

    // if (verificationStatus?.verified == true) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const UserDetailsPage(),
    //     ),
    //   );
    // }

    ref.listen(emailVerificationViewModelProvider, (previous, next) {
      next?.when(
          data: (data) {
            if (data.verified) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UserDetailsPage(),
                ),
              );
            }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.verificationMessage,
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              if (verificationStatus?.expired != false)
                GradientButton(
                  loadingProvider: emailVerificationViewModelProvider,
                  buttonText: "Send email",
                  onPressed: () {
                    ref
                        .read(emailVerificationViewModelProvider.notifier)
                        .sendVerificationEmail();
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
