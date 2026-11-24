import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get isOnlineStream {
    return _connectivity.onConnectivityChanged.map((results) {
      if (results.isEmpty) return false;
      return results.any((r) => r != ConnectivityResult.none);
    });
  }

  Future<bool> checkIsOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }
}
