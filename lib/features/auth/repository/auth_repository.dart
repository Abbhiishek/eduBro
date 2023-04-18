import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sensei/core/constants/firebase_constants.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/core/providers/firebase_provider.dart';
import 'package:sensei/core/type_defs.dart';
import 'package:sensei/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider),
    ));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;
      // print(userCredential.user);
      if (userCredential.additionalUserInfo!.isNewUser) {
        // print('New User detected');
        userModel = UserModel(
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          profilePic: userCredential.user!.photoURL ?? '',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
          bio: '',
          username: '',
          level: 0,
          posts: {},
          replies: {},
          subjects: {},
          communities: {},
          followers: {},
          following: {},
          notifications: {},
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUser(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUser(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }
}
