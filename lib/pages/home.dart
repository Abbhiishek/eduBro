import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'lessons.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:EduBro/components/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _curInd = 0;
  @override
  Widget build(BuildContext context) {
    // get the user from firebase
    final User? user = context.watch<User?>();
    // if the user is not present from firebase then navigate to login page
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
    final email = user?.email ?? 'Email';
    final name = user?.displayName ?? 'Name';
    final photoURL = user?.photoURL ?? 'Photo URL';

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("EduBro"),
            ),
            drawer: Drawer(
                child: ListView(children: [
              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(photoURL),
                ),
                currentAccountPictureSize: const Size(75, 75),
                arrowColor: Colors.indigoAccent,
              )
            ])),
            body: Container(
                child: _curInd == 0
                    ? const DashboardPage()
                    : _curInd == 1
                        ? AssignmentScreen()
                        : Profile()),
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
