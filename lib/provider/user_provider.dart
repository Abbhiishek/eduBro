import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase.dart';

final firebaseAuthProvider = Provider<FirebaseAuthMethods>((ref) {
  return FirebaseAuthMethods(FirebaseAuth.instance);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authState;
});
