import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(user.name),
                accountEmail: Text(user.email),
                otherAccountsPictures: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).logout(),
                  )
                ],
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      user.profilePic,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      user.banner,
                    ),
                    fit: BoxFit.cover,
                  ),
                )),
            const SizedBox(height: 20),
            const Text(
              '"Always dare to dream"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () => navigateToHome(context),
            ),
            ListTile(
              title: const Text('Explore (Coming Soon)'),
              leading: const Icon(
                Icons.explore,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Create (Coming Soon)'),
              leading: const Icon(
                Icons.add,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Messages (Coming Soon)'),
              leading: const Icon(
                Icons.message,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Notifications (Coming Soon)'),
              leading: const Icon(
                Icons.notifications,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Attendance (Beta)'),
              leading: const Icon(
                Icons.calendar_today,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Assignmnets (Coming Soon)'),
              leading: const Icon(
                Icons.work,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(
                Icons.settings,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Help'),
              leading: const Icon(
                Icons.help,
              ),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
          ],
        ),
      ),
    );
  }

  navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }
}
