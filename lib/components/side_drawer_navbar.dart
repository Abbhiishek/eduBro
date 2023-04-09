import 'package:edubro/pages/login_screen.dart';
import 'package:edubro/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:edubro/pages/profile.dart';
import 'package:edubro/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:edubro/pages/profile_settings.dart';

class SideNavBarDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String photoURL;
  final String uid;

  const SideNavBarDrawer(
      {super.key,
      required this.name,
      required this.email,
      required this.photoURL,
      required this.uid});

  @override
  State<SideNavBarDrawer> createState() => _SideNavBarDrawerState();
}

class _SideNavBarDrawerState extends State<SideNavBarDrawer> {
  final List<Map<String, dynamic>> drawerItems = [
    {
      'icon': Icons.home,
      'title': 'Home',
      'destination': const HomePage(),
    },
    {
      'icon': Icons.person,
      'title': 'Profile',
      'destination': const Profile(),
    },
    {
      'icon': Icons.book,
      'title': 'Lessons',
      'destination': const Profile(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(widget.name),
                  accountEmail: Text(widget.email),
                  otherAccountsPictures: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                      onPressed: () {
                        // navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileSettingsPage(uuid: widget.uid)),
                        );
                      },
                    ),
                  ],
                  decoration: const BoxDecoration(color: Colors.indigoAccent),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.photoURL),
                  ),
                  currentAccountPictureSize: const Size(75, 75),
                  arrowColor: Colors.indigoAccent,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = drawerItems[index];
                    return ListTile(
                      leading: Icon(item['icon'], color: Colors.indigo),
                      title: Text(item['title'],
                          style: const TextStyle(color: Colors.indigoAccent)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => item['destination']),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: ListTile(
              trailing: Text(widget.name.toLowerCase(),
                  style: const TextStyle(color: Colors.black, fontSize: 12)),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                context.read<FirebaseAuthMethods>().signOut(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
