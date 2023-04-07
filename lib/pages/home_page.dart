import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentTimeOfDay = now.hour < 12
        ? 'Morning'
        : now.hour < 18
            ? 'Afternoon'
            : 'Evening';
    // Get the user from the stream
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? 'User';

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Good $currentTimeOfDay,',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Center(
            child: Text(
              ' $username!',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ), // Add some spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user?.email}',
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                semanticLabel: "Verified",
              ),
            ],
          ),
          // // Add some spacing
          const SizedBox(height: 16), // Add some spacing
          const Text(
            'Welcome to my EDUBRO!',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16), // Add some more spacing
          ElevatedButton(
            onPressed: () {
              // switch to the next page
              Navigator.of(context).pushReplacementNamed('/accountsetup');
            },
            child: const Text('Get started'),
          ),
        ],
      ),
    );
  }
}
