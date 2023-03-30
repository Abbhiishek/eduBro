import 'package:flutter/material.dart';
import './HomePage.dart';
class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int curInd = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("eduBro"),
          ),
          body: Container(
              child: curInd == 0 ? HomePage()
                  : curInd == 1 ? Column(
                children: const [
                  Text("Lessons",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20))
                ],
              )
                  : Column(
                children: const [
                  Text("Student Profile",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20))
                ],
              )

          ),
          bottomNavigationBar: BottomNavigationBar(items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label:"Home",activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.file_copy_outlined),label:"Lessons",activeIcon: Icon(Icons.file_copy)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label:"Student Profile",activeIcon: Icon(Icons.account_circle)),
          ],
            currentIndex: curInd,
            onTap:(int Index){
              setState(() {
                curInd = Index;
              });
            },
          ),
        )
    );
  }
}
