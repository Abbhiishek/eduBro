import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/features/auth/screens/login_screen.dart';
import 'package:sensei/features/home/screen/home_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScrren()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});
