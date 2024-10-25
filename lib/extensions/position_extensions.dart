import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

extension PositionExtensions on Position {
  LatLng get toLatLng => LatLng(latitude, longitude);
}
