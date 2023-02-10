import 'package:flutter/material.dart';
import 'package:yandex_map_example/map/domain/app_latitude_longitude.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final YandexMapController _mapController;

  @override
  void initState() {
    super.initState();
    _initPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Текущее местоположение'),
      ),
      body: YandexMap(
        onMapCreated: (controller) {
          _mapController = controller;
          // show(context);
        },
      ),
    );
  }

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
      await _getCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _getCurrentLocation() async {
    await LocationService().getCurrentLocation().then((position) {
      try {
        _showLocation(AppLatLong(
          lat: position.lat,
          long: position.long,
        ));
      } on Exception catch (_) {
        _showLocation(AppLatLong(
          lat: MoscowLocation().latMoscow,
          long: MoscowLocation().longMoscow,
        ));
      }
    });
  }

  /// Метод для показа текущей позиции
  Future<void> _showLocation(
    AppLatLong appLatLong,
  ) async {
    // Проверка, смонтирован ли виджет
    if (mounted) {
      await _mapController.moveCamera(
        animation:
            const MapAnimation(type: MapAnimationType.linear, duration: 1),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: appLatLong.lat,
              longitude: appLatLong.long,
            ),
            zoom: 12,
          ),
        ),
      );
    }
  }
}
