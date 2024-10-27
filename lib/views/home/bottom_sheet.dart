import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:astrum_test_app/services/location/cubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatableBottomSheet extends StatelessWidget {
  final double distanceInKM;
  final void Function() onTap;
  const UpdatableBottomSheet({
    super.key,
    required double totalDistance,
    required this.onTap,
  }) : distanceInKM = totalDistance / 1000;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Total distance:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text('${distanceInKM.toStringAsFixed(2)} km'),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Trip price:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text('${(distanceInKM * 5000).toStringAsFixed(2)} UZS'),
        ]),
        24.h,
        ElevatedButton(
          onPressed: onTap,
          child: BlocBuilder<TripCubit, TripState>(
            builder: (context, state) {
              switch (state.status) {
                case TripStatus.started:
                  return const Text('End the trip');
                case _:
                  return const Text('Close the sheet');
              }
            },
          ),
        ),
      ]),
    );
  }
}
