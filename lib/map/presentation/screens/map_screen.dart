import 'package:flutter/material.dart';
import 'package:yandex_map_example/map/domain/app_latitude_longitude.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/location_service.dart';
import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Текущее местоположение'),
      ),
      body: FutureBuilder(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return YandexMap(
              onMapCreated: (controller) {
                _showLocation(controller, snapshot.data!, context);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await ServiceLocation().checkPermission()) {
      await ServiceLocation().requestPermission();
    }
  }

  Future<AppLatLong> _getCurrentLocation() async {
    await _initPermission();
    return ServiceLocation()
        .getCurrentLocation()
        .then((value) => value)
        .catchError(
          (_) => AppLatLong(
            lat: MoscowLocation().latMoscow,
            long: MoscowLocation().longMoscow,
          ),
        );
  }

  /// Метод для показа текущей позиции
  Future<void> _showLocation(
    YandexMapController mapController,
    AppLatLong appLatLong,
    BuildContext context,
  ) async {
    // Проверка, смонтирован ли виджет
    if (mounted) {
      await mapController
          .moveCamera(
            animation:
                const MapAnimation(type: MapAnimationType.linear, duration: 1),
            CameraUpdate.newCameraPosition(CameraPosition(
              target: Point(
                latitude: appLatLong.lat,
                longitude: appLatLong.long,
              ),
              zoom: 12,
            )),
          )

          /// Показ модального окна
          .then(
            (value) => showModalBottomSheet(
              context: context,
              builder: (_) => Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  ),
                  child: const Text('Далее'),
                ),
              ),
            ),
          );
    }
  }
}
