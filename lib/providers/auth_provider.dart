import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth state
  void initialize() {
    _firebaseService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Set error
  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _clearError();
      _setLoading(true);

      await _firebaseService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _clearError();
      _setLoading(true);

      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _clearError();
      _setLoading(true);

      await _firebaseService.signOut();

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Password reset
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _clearError();
      _setLoading(true);

      await _firebaseService.sendPasswordResetEmail(email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    if (_user == null) return null;

    try {
      return await _firebaseService.getUserData(_user!.uid);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    if (_user == null) return false;

    try {
      _clearError();
      _setLoading(true);

      await _firebaseService.updateUserProfile(uid: _user!.uid, data: data);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }
}
