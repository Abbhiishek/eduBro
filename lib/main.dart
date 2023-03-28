import 'package:flutter/material.dart';
import 'components/splash.dart';
import './pages/home.dart';

main(){
  runApp(Land());
}

class Land extends StatefulWidget {
  const Land({super.key});
  @override
  State<Land> createState() => _LandState();
}

class _LandState extends State<Land> {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'eduBro',
    initialRoute: '/',
    routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => homePage(),
      }
  );
  }
}

