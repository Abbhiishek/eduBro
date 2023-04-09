import 'package:edubro/pages/profile.dart';
import 'package:edubro/pages/profile_settings.dart';
import 'package:edubro/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/splash.dart';
import './pages/home.dart';
import 'pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final lastScreen = prefs.getString('lastScreen');
  setPathUrlStrategy();
  runApp(Land(initialRoute: lastScreen));
  // Provider
  //
}

class Land extends StatefulWidget {
  final String? initialRoute;

  const Land({super.key, this.initialRoute});
  @override
  State<Land> createState() => _LandState();
}

class _LandState extends State<Land> {
  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<User?>();
    final uid = user?.uid;

    return MultiProvider(
        providers: [
          Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
          ),
          StreamProvider<User?>(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EduBro',
          // theme: ThemeData(primarySwatch: MyColors.primaryColor),
          initialRoute: widget.initialRoute ?? '/',
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomePage(),
            '/settings': (context) => const LoginScreen(),
            '/profile/settings': (context) => ProfileSettingsPage(uuid: uid),
            '/profile': (context) => const Profile(),
          },
        ));
  }
}
