import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String date;
  final double distance;
  final double fare;
  const HistoryItem({
    super.key,
    required this.date,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: ListTile(
        title: Text('${(distance / 1000).scaleToH} km'),
        subtitle: Text('$fare UZS'),
        trailing: Text(date),
      ),
    );
  }
}
