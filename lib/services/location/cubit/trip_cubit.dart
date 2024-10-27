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
    emit(state.copyWith(isTracking: true));
    _locationSubscription = _locationService.locationStream.listen((event) {
      _locationService.addLog(event);
      _updateDistanceAndEmitState(event);
    }, onError: (asd) => print(asd));
  }

  Future<LatLng> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    emit(state.copyWith(
        location: location, isTracking: false, totalDistance: 0));
    return location;
  }

  void stopTracking() {
    _locationSubscription?.cancel();
    emit(state.copyWith(isTracking: null));
  }

  void resetTrip() {
    _locationService.clearLog();
    emit(const TripState(isTracking: false));
  }

  void _updateDistanceAndEmitState(LatLng x) {
    final totalDistance = _locationService.calculateTotalDistance();
    emit(state.copyWith(
      totalDistance: totalDistance,
      isTracking: state.isTracking,
      location: x,
    ));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
