import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({
    super.key,
  });

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
    //
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => signInWithGoogle(context, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(0, 255, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        '🚀 Get Started with Google',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
