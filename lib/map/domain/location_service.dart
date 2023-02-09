import 'package:geolocator/geolocator.dart';
import 'package:yandex_map_example/map/domain/app_latitude_longitude.dart';
import 'package:yandex_map_example/map/domain/app_location.dart';

class ServiceLocation implements AppLocation {
  @override
  Future<AppLatitudeLongitude> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return AppLatitudeLongitude(
          latitude: value.latitude, longitude: value.longitude);
    }).catchError(
      (_) => AppLatitudeLongitude(
          latitude: MoscowLocation().latitudeMoscow,
          longitude: MoscowLocation().longitudeMoscow),
    );
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
