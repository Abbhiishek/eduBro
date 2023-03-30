import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();
    final currentTimeOfDay = now.hour < 12 ? 'morning' : now.hour < 18 ? 'afternoon' : 'evening';
    final username = 'Abhishek Kushwaha';

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Good $currentTimeOfDay,',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Center(
            child: Text(
              ' $username!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),// Add some spacing
          SizedBox(height: 16), // Add some spacing
          Text(
            'Welcome to my EDUBRO!',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16), // Add some more spacing
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('App in development'),
                  content: Text('This app is still in development. Thank you for trying it out!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Get started'),
          ),
        ],
      ),
    );
  }
}
