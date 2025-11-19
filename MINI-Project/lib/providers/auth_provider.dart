import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Email & Password Login
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fetchUserData(userCredential.user!.uid);
      await _saveLoginState();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(AppConstants.errorGeneric);
      _setLoading(false);
      return false;
    }
  }

  // Email & Password Signup
  Future<bool> signupWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? department,
    String? classId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user document
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
        phone: phone,
        department: department,
        classId: classId,
        createdAt: DateTime.now(),
        isVip: false,
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(newUser.id)
          .set(newUser.toJson());

      _currentUser = newUser;
      await _saveLoginState();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(AppConstants.errorGeneric);
      _setLoading(false);
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Check if user exists, if not create new
      DocumentSnapshot userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'User',
          role: AppConstants.roleStudent,
          profilePicture: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
          isVip: false,
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(newUser.id)
            .set(newUser.toJson());

        _currentUser = newUser;
      } else {
        await _fetchUserData(userCredential.user!.uid);
      }

      await _saveLoginState();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(AppConstants.errorAuth);
      _setLoading(false);
      return false;
    }
  }

  // Phone Authentication - Send OTP
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(_getAuthErrorMessage(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(AppConstants.errorGeneric);
      _setLoading(false);
      return false;
    }
  }

  // Phone Authentication - Verify OTP
  Future<bool> verifyOTP(String otp, {String? name, String? role}) async {
    try {
      _setLoading(true);
      _clearError();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Check if user exists
      DocumentSnapshot userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          email: '',
          phone: userCredential.user!.phoneNumber,
          name: name ?? 'User',
          role: role ?? AppConstants.roleStudent,
          createdAt: DateTime.now(),
          isVip: false,
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(newUser.id)
            .set(newUser.toJson());

        _currentUser = newUser;
      } else {
        await _fetchUserData(userCredential.user!.uid);
      }

      await _saveLoginState();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Invalid OTP');
      _setLoading(false);
      return false;
    }
  }

  // Forgot Password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.sendPasswordResetEmail(email: email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(AppConstants.errorGeneric);
      _setLoading(false);
      return false;
    }
  }

  // Guest Login
  Future<bool> continueAsGuest() async {
    try {
      _currentUser = UserModel(
        id: 'guest',
        email: '',
        name: 'Guest User',
        role: AppConstants.roleGuest,
        createdAt: DateTime.now(),
        isVip: false,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Fetch User Data
  Future<void> _fetchUserData(String uid) async {
    DocumentSnapshot userDoc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (userDoc.exists) {
      _currentUser = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

      // Update last login
      await _firestore.collection(AppConstants.usersCollection).doc(uid).update(
        {'lastLogin': DateTime.now().toIso8601String()},
      );
    }
  }

  // Save Login State
  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setString(AppConstants.keyUserId, _currentUser!.id);
    await prefs.setString(AppConstants.keyUserRole, _currentUser!.role);
    await prefs.setBool(AppConstants.keyIsVip, _currentUser!.isVip);
  }

  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      String? userId = prefs.getString(AppConstants.keyUserId);
      if (userId != 'guest') {
        await _fetchUserData(userId!);
        return true;
      }
    }
    return false;
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed';
    }
  }
}
