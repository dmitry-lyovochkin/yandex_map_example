import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/location_service.dart';
import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final YandexMapController _mapController;
  late final BuildContext _context;

  @override
  void initState() {
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Текущее местоположение'),
      ),
      body: YandexMap(onMapCreated: (controller) {
        _mapController = controller;
        _context = context;
        // show(context);
      }),
    );
  }

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> _initPermission() async {
    if (await ServiceLocation().checkPermission()) {
      await _getCurrentPosition();
    } else if (await ServiceLocation().requestPermission()) {
      await _getCurrentPosition();
    }
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _getCurrentPosition() async {
    await ServiceLocation().getCurrentLocation().then((position) {
      _showPosition(_mapController, position.lang, position.long).catchError(
        (_) => _showPosition(
          _mapController,
          ServiceLocation.latitudeMoscow,
          ServiceLocation.longitudeMoscow,
        ),
      );
    });
  }

  Future<void> _showPosition(
    YandexMapController mapController,
    double latitude,
    double longitude,
  ) async {
    // Проверка, смонтирован ли виджет
    if (mounted) {
      await mapController
          .moveCamera(
            animation:
                const MapAnimation(type: MapAnimationType.linear, duration: 1),
            CameraUpdate.newCameraPosition(CameraPosition(
              target: Point(
                latitude: latitude,
                longitude: longitude,
              ),
              zoom: 12,
            )),
          )
          .timeout(const Duration(seconds: 3))
          .then((value) => showModalBottomSheet(
              context: _context,
              builder: (_) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen())),
                        child: const Text('Далее')),
                  )));
    }
  }
}
