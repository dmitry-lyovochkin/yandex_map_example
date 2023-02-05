abstract class AppLocation {
  Future<void> getCurrentLocation();

  Future<bool> requestPermission();

  Future<bool> checkPermission();
}


