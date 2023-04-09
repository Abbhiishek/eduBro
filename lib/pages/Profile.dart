import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edubro/components/side_drawer_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase.dart';

final db = FirebaseFirestore.instance;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<Profile> {
  @override
  void dispose() {
    _saveLastVisitedScreen();
    super.dispose();
  }

  Future<void> _saveLastVisitedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', '/profile');
    print('Last visited screen saved to /profile');
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<User?>();
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    String name = user.displayName ?? 'Name';
    String email = user.email ?? 'Email';
    String imageUrl = user.photoURL ?? 'Photo URL';
    String uid = user.uid;

    bool emailVerified = user.emailVerified;
    final lastseen = user.metadata.lastSignInTime ?? DateTime.now();
    const xp = 76;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = formatter.format(lastseen);

    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.keyboard_option_key_outlined),
        title: Text(name),
      ),
      drawer: SideNavBarDrawer(
          email: email, name: name, photoURL: imageUrl, uid: uid),
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
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.green,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              title: const Text('Last Seen'),
              subtitle: Text(formattedDate),
            ),
            const Divider(),
            const XpWidget(xp: xp),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
