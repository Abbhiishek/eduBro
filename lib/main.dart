import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'sensei',
            channelName: 'Sensei Channel Delivery Service',
            channelDescription: 'Made with Love by Sensei',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      debug: true);

  runApp(const ProviderScope(child: MyApp()));
  // debugDumpApp();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:
    //         NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:
    //         NotificationController.onNotificationDisplayedMethod,
    //     onDismissActionReceivedMethod:
    //         NotificationController.onDismissActionReceivedMethod);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MyApp.context = context; // Set the context variable in the build method
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            title: 'Sensei',
            key: MyApp.navigatorKey,
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
