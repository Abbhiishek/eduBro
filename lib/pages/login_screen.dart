import 'dart:async';
import 'package:edubro/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edubro/services/firebase.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Future signInWithGoogle(BuildContext context) async {
//   await context.read<FirebaseAuthMethods>().signInWithGoogle(context);
// }

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });
    // Add your Google sign-in code here
    try {
      FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
    } catch (e) {
      print("error ocured in login_Scrren");
    }

    final User? user = context.read<User?>();
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            _signInWithGoogle();
          },
          label: Visibility(
            visible: !_isSigningIn,
            replacement: const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.amber),
            ),
            child: const Text("Sign With Google"),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
        ),
      ],
    )));
  }
}
