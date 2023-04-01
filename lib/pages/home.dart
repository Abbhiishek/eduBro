import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './HomePage.dart';
import './Profile.dart';
import './Lessons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int curInd = 0;
  @override
  Widget build(BuildContext context) {
    // get the user from firebase
    final user = FirebaseAuth.instance.currentUser;
    // if the user is not present from firebase then navigate to login page
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("EduBro"),
          ),
          body: Container(
              child: curInd == 0
                  ? HomePage()
                  : curInd == 1
                      ? AssignmentScreen()
                      : Profile()),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Home",
                  activeIcon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.file_copy_outlined),
                  label: "Lessons",
                  activeIcon: Icon(Icons.file_copy)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  label: "Student Profile",
                  activeIcon: Icon(Icons.account_circle)),
            ],
            currentIndex: curInd,
            onTap: (int Index) {
              setState(() {
                curInd = Index;
              });
            },
          ),
        ));
  }
}
