import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/common/sign_in_button.dart';
import 'package:sensei/core/constants/constants.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';

class LoginScrren extends ConsumerWidget {
  const LoginScrren({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Center(
              child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  Constants.loginScreenImage,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome to Sensei !',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Get Started With Your College Real Bro 🫂',
                    style: TextStyle(
                      fontSize: 50,
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const SignInButton(),
                const SizedBox(height: 90),
                const Text(
                  '@sensei 2023',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            )),
    );
  }
}
