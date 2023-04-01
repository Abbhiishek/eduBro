import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:EduBro/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          onPressed: () async {
            // add your button's functionality here
            // FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
            await context.read<FirebaseAuthMethods>().signInWithGoogle(context);

            final user = context.watch<User?>();
            if (user != null) {
              final QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: user!.uid)
                  .get();
              final List<DocumentSnapshot> documents = result.docs;
              if (documents.isEmpty) {
                // User is new, create a new document in the users collection
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  'name': user.displayName,
                  'email': user.email,
                  'photoUrl': user.photoURL,
                  'xp': 0 // New users start with 0 XP
                });
              } else {
                // User is old, update their XP
                // final int currentXP = documents[0].data()?['xp'] ?? 0;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({'xp': 50});
              }
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          label: Text("Sign With Google"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.black),
        ),
      ],
    )));
  }
}
