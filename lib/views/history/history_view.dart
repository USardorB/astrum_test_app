import 'package:astrum_test_app/services/crud/record_model.dart';
import 'package:astrum_test_app/views/history/history_item.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  final List<RecordModel> records;
  static Route route(List<RecordModel> records) {
    return MaterialPageRoute(builder: (context) {
      return HistoryView(records: records);
    });
  }

  const HistoryView({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История Поездок')),
      body: ListView.builder(
        itemCount: records.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return HistoryItem(
            date: records[index].date!,
            distance: records[index].distance,
            fare: records[index].fare,
          );
        },
      ),
    );
  }
}
