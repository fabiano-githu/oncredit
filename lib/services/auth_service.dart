// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    return credential.user;
  }

  User? get currentUser => _auth.currentUser;
}
