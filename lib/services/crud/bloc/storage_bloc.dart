import 'dart:async';

import 'package:astrum_test_app/services/crud/record_model.dart';
import 'package:astrum_test_app/services/crud/storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final _storage = StorageService();
  List<RecordModel> _records = [];
  int id = 0;
  StorageBloc()
      : super(const StorageState(records: [], status: StorageStatus.initial)) {
    on<StorageEventInit>(_init);

    on<StorageEventStart>(_start);
    on<StorageEventReadAll>(_readAll);
    on<StorageEventEnd>(_end);
  }

  Future<void> _init(StorageEventInit event, Emitter<StorageState> emit) async {
    await _storage.open();
    _records = await _storage.readAllRecords();
    emit(StorageState(records: _records, status: StorageStatus.stable));
  }

  Future<void> _start(
    StorageEventStart event,
    Emitter<StorageState> emit,
  ) async {
    try {
      if (event.record.id == -5) {
        await _storage.updateRecord(RecordModel(
            id: id, distance: event.record.distance, date: event.record.date!));
      } else {
        id = await _storage.createRecord(event.record);
      }
      _records = await _storage.readAllRecords();
      emit(StorageState(records: _records, status: StorageStatus.updating));
      state;
    } catch (_) {}
  }

  Future<void> _end(
    StorageEventEnd event,
    Emitter<StorageState> emit,
  ) async {
    _records = await _storage.readAllRecords();
    id = 0;
    emit(StorageState(records: _records, status: StorageStatus.stable));
  }

  Future<void> _readAll(
    StorageEventReadAll event,
    Emitter<StorageState> emit,
  ) async {
    _records = await _storage.readAllRecords();
    emit(StorageState(records: _records, status: StorageStatus.stable));
  }
}
