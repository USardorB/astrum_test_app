import 'dart:async';

import 'package:astrum_test_app/services/location/location_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  final LocationService _locationService = LocationService();
  StreamSubscription<LatLng>? _locationSubscription;

  TripCubit() : super(const TripState());

  void startTracking() {
    emit(state.copyWith(status: TripStatus.started));
    _locationSubscription = _locationService.locationStream.listen((event) {
      _locationService.addLog(event);
      _updateDistanceAndEmitState(event);
    });
  }

  void askForLocationPermissions() async {
    bool isPermitted = await _locationService.requestLocationPermission();
    while (!isPermitted) {
      isPermitted = await _locationService.requestLocationPermission();
    }
    if (isPermitted) await getCurrentLocation();
  }

  Future<LatLng> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    emit(state.copyWith(location: location));
    return location;
  }

  void stopTracking() {
    emit(state.copyWith(status: TripStatus.ended));
  }

  void resetTrip() {
    _locationService.clearLog();
    emit(TripState(
      status: TripStatus.stable,
      currentLocation: state.currentLocation,
    ));
  }

  void _updateDistanceAndEmitState(LatLng x) {
    final totalDistance = _locationService.calculateTotalDistance();
    emit(state.copyWith(
      totalDistance: totalDistance,
      status: state.status,
      location: x,
    ));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
