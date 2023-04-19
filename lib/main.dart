import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/models/user_model.dart';
import 'package:sensei/router.dart';
import 'package:sensei/theme/pallete.dart';
import 'package:sensei/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Show a popup with the message details
    print(message);
  });
  runApp(const ProviderScope(child: MyApp()));
  // debugDumpApp();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static BuildContext? context;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUser(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MyApp.context = context; // Set the context variable in the build method
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            title: 'Sensei',
            debugShowCheckedModeBanner: false,
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getData(ref, data);
                if (userModel != null) {
                  return loggedInRoute;
                }
              }
              return loggedOutRoute;
            }),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
