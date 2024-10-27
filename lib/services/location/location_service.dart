import 'dart:async';
import 'package:astrum_test_app/extensions/position_extensions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;

  final List<LatLng> _logOfLatLngs = [];

  LocationService._() {
    _requestLocationPermission();
    _locationStream.listen((latLng) => _logOfLatLngs.add(latLng));
  }
  late final Stream<LatLng> _locationStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(distanceFilter: 10),
  ).map((position) => LatLng(position.latitude, position.longitude));

  Stream<LatLng> get locationStream => _locationStream;

  void addLog(LatLng latLng) => _logOfLatLngs.add(latLng);
  void clearLog() => _logOfLatLngs.clear();

  List<LatLng> get getLogs => _logOfLatLngs;

  Future<LatLng> getCurrentLocation() async {
    await _requestLocationPermission();
    final position = await Geolocator.getCurrentPosition();
    return position.toLatLng;
  }

  double calculateTotalDistance() {
    if (_logOfLatLngs.isEmpty) return 0;
    double totalDistance = 0;
    for (int i = 1; i < _logOfLatLngs.length; i++) {
      totalDistance += Geolocator.distanceBetween(
        _logOfLatLngs[i - 1].latitude,
        _logOfLatLngs[i - 1].longitude,
        _logOfLatLngs[i].latitude,
        _logOfLatLngs[i].longitude,
      );
    }
    return totalDistance;
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }
  }
}
