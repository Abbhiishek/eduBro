import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Notifications'),
              leading: const Icon(
                Icons.notifications,
              ),
              onTap: () => 'null',
            ),
            ListTile(
              title: const Text('Account Center'),
              leading: const Icon(
                Icons.person,
              ),
              onTap: () => 'null',
            ),
            ListTile(
              title: const Text('Help'),
              leading: const Icon(
                Icons.help,
              ),
              onTap: () => 'null',
            ),
            ListTile(
              title: const Text('About'),
              leading: const Icon(
                Icons.info,
              ),
              onTap: () => 'null',
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Log Out ${user.name}',
                style: TextStyle(color: Pallete.redColor, fontSize: 16),
              ),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Dark Mode'),
                const SizedBox(width: 10),
                Switch.adaptive(
                  value: ref.watch(themeNotifierProvider.notifier).mode ==
                      ThemeMode.dark,
                  onChanged: (val) => toggleTheme(ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
