import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/firebase.dart';

final db = FirebaseFirestore.instance;

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<User?>();

    final imageUrl = user?.photoURL ?? 'https://i.imgur.com/BoN9kdC.png';
    final emailVerified = user?.emailVerified ?? false;
    final lastseen = user?.metadata.lastSignInTime ?? DateTime.now();
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? 'Email';
    final uuid = user?.uid ?? null;
    final xp = 123;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = formatter.format(lastseen);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.firaMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: GoogleFonts.firaMono(
                fontSize: 16,
              ),
            ),
            // render the email verfied text
            emailVerified
                ? Text(
                    'Email verified',
                    style: GoogleFonts.firaMono(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  )
                : Text(
                    'Email not verified',
                    style: GoogleFonts.firaMono(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().signOut(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Log out'),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(
                Icons.calendar_today,
                color: Colors.green,
                semanticLabel: "Last Seen",
              ),
              title: const Text('Last Seen'),
              subtitle: Text(formattedDate),
            ),
            const Divider(),
            XpWidget(xp: xp),
          ],
        ),
      ),
    );
  }
}

class XpWidget extends StatelessWidget {
  final int xp;

  const XpWidget({Key? key, required this.xp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP',
            style: GoogleFonts.firaMono(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$xp',
                style: GoogleFonts.firaMono(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: LinearProgressIndicator(
                  value: xp / 1000,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '1000 XP',
                style: GoogleFonts.firaMono(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
