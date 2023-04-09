import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'lessons.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edubro/components/bottom_navigation_bar.dart';
import 'package:edubro/components/side_drawer_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _curInd = 0;

  @override
  void dispose() {
    _saveLastVisitedScreen();
    super.dispose();
  }

  Future<void> _saveLastVisitedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', '/home');
    print('Last visited screen saved to /home');
  }

  @override
  Widget build(BuildContext context) {
    late String email;
    late String name;
    late String photoURL;
    late String uid;
    // get the user from firebase
    final User? user = context.watch<User?>();
    // if the user is not present from firebase then navigate to login page
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else {
      email = user.email ?? 'Email';
      name = user.displayName ?? 'Name';
      photoURL = user.photoURL ?? 'Photo URL';
      uid = user.uid;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.pink),
        home: Scaffold(
            drawer: SideNavBarDrawer(
                email: email, name: name, photoURL: photoURL, uid: uid),
            body: Container(
                child: _curInd == 0
                    ? const DashboardPage()
                    : _curInd == 1
                        ? const AssignmentScreen()
                        : const Profile()),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _curInd,
              onIndexChanged: (index) {
                setState(() {
                  _curInd = index;
                });
              },
            )));
  }
}
