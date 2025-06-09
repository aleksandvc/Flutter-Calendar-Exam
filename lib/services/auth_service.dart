import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerWithEmail(String email, String password, String name) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user!;
    await user.updateDisplayName(name);

    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      name: name,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }

    return UserModel(
      uid: user.uid,
      email: user.email!,
      name: user.displayName ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user != null && user.email != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }
        return UserModel(
          uid: user.uid,
          email: user.email!,
          name: user.displayName ?? '',
          createdAt: user.metadata.creationTime ?? DateTime.now(),
        );
      }
      return null;
    });
  }
}
