import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ SIGN UP METHOD
  Future<void> signupUser(
      BuildContext context,
      String name,
      String username,
      ) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty || username.isEmpty) {
        _showSnackBar(context, 'All fields are required.');
        return;
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': email,
          'name': name,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _saveFcmToken(user);

        await user.sendEmailVerification();
        _showSnackBar(context, 'Verification email sent. Please check your inbox.');
        // ❌ Removed navigation to VerifyEmailScreen — AuthGate will handle this
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, _getAuthError(e.code));
    } catch (e) {
      _showErrorDialog(context, 'Something went wrong. Please try again.');
    }
  }

  /// ✅ LOGIN METHOD
  Future<void> loginUser(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showSnackBar(context, 'Please enter email and password.');
        return;
      }

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      await user?.reload(); // Refresh user info

      if (user != null) {
        await _saveFcmToken(user);

        if (user.emailVerified) {
          _showSnackBar(context, 'Login successful!');
          // ❌ Navigation removed — AuthGate will redirect to HomeView
        } else {
          _showSnackBar(context, 'Email not verified. Verification email sent.');
          await user.sendEmailVerification();
          await _auth.signOut(); // Temporary sign out so AuthGate shows VerifyEmailScreen
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, _getAuthError(e.code));
    }
  }

  /// 🔁 PASSWORD RESET
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔒 LOGOUT
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  /// 📩 RESEND VERIFICATION EMAIL
  Future<void> resendVerificationEmail(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      _showSnackBar(context, 'Verification email sent again.');
    }
  }

  /// 🔥 FCM Token Storage
  Future<void> _saveFcmToken(User user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': fcmToken,
      });
    }
  }

  /// ❌ Error Dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// 🔔 SnackBar Helper
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 🔍 Firebase Error Parser
  String _getAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return 'Authentication error: $code';
    }
  }
}
