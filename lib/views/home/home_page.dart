import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/services/location/cubit/trip_cubit.dart';
import 'package:astrum_test_app/services/crud/bloc/storage_bloc.dart';
import 'package:astrum_test_app/services/crud/record_model.dart';
import 'package:astrum_test_app/views/history/history_view.dart';
import 'package:astrum_test_app/views/home/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MapController _mapController;
  int id = 0;
  @override
  void initState() {
    context.read<StorageBloc>().add(const StorageEventInit());
    _mapController = MapController();
    context.read<TripCubit>().getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (BuildContext context, TripState state) async {
        switch (state.status) {
          case TripStatus.started:
            if (state.totalDistance == 0.0) {
              context.read<StorageBloc>().add(
                    StorageEventStart(
                      RecordModel(
                        id: 0,
                        distance: 0,
                        date: DateTime.now().toIso8601String(),
                      ),
                    ),
                  );
            } else {
              final record =
                  context.read<StorageBloc>().state.records.lastOrNull;
              if (record != null) {
                context.read<StorageBloc>().add(
                      StorageEventStart(
                        RecordModel(
                          id: -5,
                          distance: state.totalDistance,
                          date: record.date!,
                        ),
                      ),
                    );
              }
            }
          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Trip Recorder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(blurRadius: 20, offset: Offset(0, 5))],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, size: 28, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    HistoryView.route(
                      context.read<StorageBloc>().state.records,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 28, color: Colors.red),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventSignOut());
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          extendBodyBehindAppBar: true,
          bottomSheet: switch (state.status) {
            TripStatus.started => UpdatableBottomSheet(
                totalDistance: state.totalDistance,
                onTap: endTrip,
              ),
            TripStatus.ended => UpdatableBottomSheet(
                totalDistance: state.totalDistance,
                onTap: exitTrip,
              ),
            _ => null,
          },
          body: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(41.2, 69.24),
              initialZoom: 10,
              maxZoom: 23,
              minZoom: 5,
            ),
            mapController: _mapController,
            children: [
              TileLayer(
                panBuffer: 0,
                keepBuffer: 3,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.android.astrum_test_app.example',
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: state.status == TripStatus.started
                    ? const Alignment(0.88, 0.40)
                    : const Alignment(0.88, 0.68),
                child: FloatingActionButton(
                  onPressed: () async {
                    _mapController.move(
                        await context.read<TripCubit>().getCurrentLocation(),
                        16.5);
                  },
                  child: const Icon(Icons.location_searching),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: state.status == TripStatus.started
                    ? const Alignment(0, 1)
                    : const Alignment(0, 0.68),
                child: TextButton(
                  onPressed: startTrip,
                  child: const Text(
                    'Start Trip',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              MarkerLayer(markers: [
                if (context.watch<TripCubit>().state.currentLocation != null)
                  Marker(
                    point: state.currentLocation!,
                    child: const Icon(
                      Icons.navigation_rounded,
                      size: 64,
                      color: Colors.amber,
                      shadows: [Shadow(blurRadius: 50)],
                    ),
                  ),
              ]),
            ],
          ),
        );
      },
    );
  }

  void startTrip() {
    context.read<TripCubit>().startTracking();
  }

  void endTrip() {
    context.read<TripCubit>().stopTracking();
    context.read<StorageBloc>().add(const StorageEventEnd());
  }

  void exitTrip() {
    context.read<TripCubit>().resetTrip();
  }
}
