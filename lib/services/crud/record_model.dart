import 'package:astrum_test_app/extensions/num_extensions.dart';
import 'package:astrum_test_app/services/crud/storage_constants.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class RecordModel {
  final int id;
  final double distance;
  final double fare;
  final String? date;

  RecordModel({
    required this.id,
    required double distance,
    required String date,
  })  : distance = distance.scaleToH,
        fare = distance.toInt() * 5
          ..scaleToH,
        date = '${date.substring(0, 10)}/${date.substring(11, 16)}';

  RecordModel copyWith(double distance) =>
      RecordModel(id: id, distance: distance, date: date!);

  Map<String, Object?> toRow() => {distanceColumn: distance, dateColumn: date};

  static RecordModel fromRow(Map<String, Object?> map) => RecordModel(
        id: map[idColumn] as int,
        distance: map[distanceColumn] as double,
        date: map[dateColumn] as String,
      );
}
