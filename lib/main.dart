import 'package:EduBro/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/AccountSetupForm.dart';
import 'components/splash.dart';
import './pages/home.dart';
import './pages/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Quizes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Land());
}

class Land extends StatefulWidget {
  const Land({super.key});
  @override
  State<Land> createState() => _LandState();
}

class _LandState extends State<Land> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null,
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EduBro',
            initialRoute: '/',
            // home: const AuthWrapper(),
            routes: {
              '/': (context) => SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => homePage(),
              '/quiz': (context) => QuizApp(),
              '/accountsetup': (context) => const AccountSetupForm(),
            }));
  }
}
