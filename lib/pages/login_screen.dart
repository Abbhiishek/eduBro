import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:EduBro/services/firebase.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future signInWithGoogle(BuildContext context) async {
  await context.read<FirebaseAuthMethods>().signInWithGoogle(context);
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the navigation after the widget has been built
    Future.delayed(Duration.zero, () {
      final User? user = context.read<User?>();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final User? user = context.watch<User?>();
    // if (user != null) {
    //   Navigator.pushReplacementNamed(context, '/home');
    // }
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "The only Bro to help you survive College Life",
          style: TextStyle(
            color: Colors.black, // set the text color
            fontSize: 12, // set the font size
            fontWeight: FontWeight.bold, // set the font weight
            letterSpacing: 1.5, // set the letter spacing
            wordSpacing: 2, // set the word spacing
          ),
        ),
        Image.asset("assets/images/edubro_logo.png"),
        ElevatedButton.icon(
          onPressed: () {
            // add your button's functionality here
            // FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
            signInWithGoogle(context);
            Navigator.pushReplacementNamed(context, '/home');
          },
          label: const Text("Sign With Google"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
        ),
      ],
    )));
  }
}

// create a fucntion to call the sign in with google method

