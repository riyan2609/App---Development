import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class VipProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isVip = false;
  DateTime? _vipExpiryDate;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isVip => _isVip;
  DateTime? get vipExpiryDate => _vipExpiryDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Check VIP status
  Future<void> checkVipStatus(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.vipSubscriptionsCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _vipExpiryDate = DateTime.parse(data['expiryDate']);
        _isVip = _vipExpiryDate!.isAfter(DateTime.now());
      } else {
        _isVip = false;
        _vipExpiryDate = null;
      }
      notifyListeners();
    } catch (e) {
      _isVip = false;
      _vipExpiryDate = null;
    }
  }

  // Subscribe to VIP
  Future<bool> subscribeToVip(String userId, String plan) async {
    try {
      _setLoading(true);

      int durationDays = plan == 'monthly' ? 30 : 365;
      DateTime expiryDate = DateTime.now().add(Duration(days: durationDays));

      await _firestore
          .collection(AppConstants.vipSubscriptionsCollection)
          .doc(userId)
          .set({
            'userId': userId,
            'plan': plan,
            'subscribedAt': DateTime.now().toIso8601String(),
            'expiryDate': expiryDate.toIso8601String(),
            'isActive': true,
            'price': plan == 'monthly'
                ? AppConstants.vipMonthlyPrice
                : AppConstants.vipYearlyPrice,
          });

      // Update user document
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
            'isVip': true,
            'vipExpiryDate': expiryDate.toIso8601String(),
          });

      _isVip = true;
      _vipExpiryDate = expiryDate;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to subscribe to VIP');
      _setLoading(false);
      return false;
    }
  }

  // Cancel VIP subscription
  Future<bool> cancelVipSubscription(String userId) async {
    try {
      _setLoading(true);

      await _firestore
          .collection(AppConstants.vipSubscriptionsCollection)
          .doc(userId)
          .update({'isActive': false});

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'isVip': false});

      _isVip = false;
      _vipExpiryDate = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to cancel subscription');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
