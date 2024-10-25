part of 'trip_cubit.dart';

class TripState extends Equatable {
  final double totalDistance;
  final bool? isTracking;
  final LatLng? currentLocation;

  const TripState({
    this.totalDistance = 0.0,
    this.isTracking = false,
    this.currentLocation,
  });

  TripState copyWith(
      {double? totalDistance, bool? isTracking, LatLng? location}) {
    return TripState(
      totalDistance: totalDistance ?? this.totalDistance,
      isTracking: isTracking,
      currentLocation: location ?? currentLocation,
    );
  }

  @override
  List<Object?> get props => [totalDistance, isTracking, currentLocation];
}
