import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Icon(
                  Icons.change_circle_outlined,
                  size: 50,
                  color: Colors.yellow,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
