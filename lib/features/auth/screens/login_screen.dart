import 'package:flutter/material.dart';
import 'package:sensei/core/constants/constants.dart';

class LoginScrren extends StatelessWidget {
  const LoginScrren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',
            style: TextStyle(
                // color: Colors.black,
                )),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Sign Up',
            ),
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset(
            Constants.loginScreenImage,
          ),
          const SizedBox(height: 30),
          const Text(
            'Welcome to Sensei',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Text(
              'Get Started With Your College Real Bro',
              style: TextStyle(
                fontSize: 50,
                overflow: TextOverflow.clip,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '🚀 Sign In with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Dialog(
                    child: Container(
                      height: 200,
                      width: 200,
                      child: const Text('Hello'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 255, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '😎 Sign Up with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
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
