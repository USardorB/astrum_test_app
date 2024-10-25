import 'dart:developer';

import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/services/location/cubit/trip_cubit.dart';
import 'package:astrum_test_app/services/storage/bloc/storage_bloc.dart';
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

  @override
  void initState() {
    context.read<StorageBloc>().add(const StorageEventInit());
    _mapController = MapController();
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
      listener: (BuildContext context, TripState state) {
        if (state.totalDistance != 0) {
          log(state.totalDistance.toString());
        } else {
          log('It\'s 0');
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
                  // Navigator.push(context, HistoryView.route(state.records));
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
          bottomSheet: switch (state.isTracking) {
            true => UpdatableBottomSheet(
                totalDistance: state.totalDistance,
                onTap: endTrip,
              ),
            null => UpdatableBottomSheet(
                totalDistance: state.totalDistance,
                onTap: exitTrip,
              ),
            false => null,
          },
          body: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(60, 40),
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
                alignment: state.isTracking ?? false
                    ? const Alignment(0.88, 0.40)
                    : const Alignment(0.88, 0.68),
                child: FloatingActionButton(
                  onPressed: () {
                    _mapController.move(
                        state.currentLocation ??
                            const LatLng(41.316487, 69.248234),
                        16.5);
                  },
                  child: const Icon(Icons.location_searching),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: state.isTracking ?? false
                    ? const Alignment(0, 1)
                    : const Alignment(0, 0.68),
                child: TextButton(
                  onPressed: startTrip,
                  child: const Text(
                    'Начать поездку',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              MarkerLayer(markers: [
                Marker(
                  point: state.currentLocation ??
                      const LatLng(41.316487, 69.248234),
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
    // context.read<StorageBloc>().add(StorageEventStart(RecordModel(
    //       id: 0,
    //       distance: 0,
    //       date: DateTime.now().toIso8601String(),
    //     )));
  }

  void endTrip() {
    context.read<TripCubit>().stopTracking();

    // context.read<StorageBloc>().add(const StorageEventEnd());
  }

  void exitTrip() => context.read<TripCubit>().resetTrip();
}
