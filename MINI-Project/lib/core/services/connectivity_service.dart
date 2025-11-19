import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _subscription;

  // Check current connectivity status
  static Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Get connectivity type
  static Future<ConnectivityResult> getConnectivityType() async {
    return await _connectivity.checkConnectivity();
  }

  // Listen to connectivity changes
  static Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  // Start listening to connectivity changes
  static void startListening(Function(ConnectivityResult) onChanged) {
    _subscription = _connectivity.onConnectivityChanged.listen(onChanged);
  }

  // Stop listening
  static void stopListening() {
    _subscription?.cancel();
  }

  // Check if WiFi is connected
  static Future<bool> isWifiConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi;
  }

  // Check if mobile data is connected
  static Future<bool> isMobileConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile;
  }
}
