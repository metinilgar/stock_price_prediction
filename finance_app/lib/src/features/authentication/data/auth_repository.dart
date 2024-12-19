import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/src/utils/providers/firebase_firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Auth state changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // Current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'name': name,
        'username': email.split('@').first.toLowerCase(),
        'email': email,
        'photourl':
            'https://github.com/user-attachments/assets/66b1b7dd-1b25-4772-9096-148cebc21eaf',
      });

      await currentUser!.updateDisplayName(name);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
      ref.watch(firebaseAuthProvider), ref.watch(firebaseFirestoreProvider));
}