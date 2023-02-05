import 'package:geolocator/geolocator.dart';
import 'package:yandex_map_example/map/domain/app_latitude_longitude.dart';
import 'package:yandex_map_example/map/domain/app_location.dart';

class ServiceLocation implements AppLocation {
  static const double latitudeMoscow = 55.7522200;
  static const double longitudeMoscow = 37.6155600;

  @override
  Future<AppLatitudeLongitude> getCurrentLocation() async {
    return Geolocator.getCurrentPosition()
        .timeout(const Duration(seconds: 10))
        .then((value) {
      return AppLatitudeLongitude(lang: value.latitude, long: value.longitude);
    }).catchError((_) => const AppLatitudeLongitude(
            lang: latitudeMoscow, long: longitudeMoscow));
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }
}
