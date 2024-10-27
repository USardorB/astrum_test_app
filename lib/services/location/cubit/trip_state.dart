part of 'trip_cubit.dart';

class TripState extends Equatable {
  final double totalDistance;
  final TripStatus status;
  final LatLng? currentLocation;

  const TripState({
    this.totalDistance = 0.0,
    this.status = TripStatus.stable,
    this.currentLocation,
  });

  TripState copyWith({
    double? totalDistance,
    TripStatus? status,
    LatLng? location,
  }) {
    return TripState(
      totalDistance: totalDistance ?? this.totalDistance,
      status: status ?? this.status,
      currentLocation: location ?? currentLocation,
    );
  }

  @override
  List<Object?> get props => [totalDistance, status, currentLocation];
}

enum TripStatus { started, ended, stable }
