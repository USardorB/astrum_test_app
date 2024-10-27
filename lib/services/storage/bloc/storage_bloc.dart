import 'dart:async';

import 'package:astrum_test_app/services/storage/record_model.dart';
import 'package:astrum_test_app/services/storage/storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final _storage = StorageService();
  List<RecordModel> _records = [];
  StorageBloc()
      : super(const StorageState(records: [], status: StorageStatus.initial)) {
    on<StorageEventInit>(_init);

    on<StorageEventStart>(_start);
    on<StorageEventReadAll>(_readAll);
    on<StorageEventEnd>(_end);
  }

  Future<void> _init(StorageEventInit event, Emitter<StorageState> emit) async {
    try {
      await _storage.open();
      _records = await _storage.readAllRecords();
      emit(StorageState(records: _records, status: StorageStatus.stable));
    } catch (e) {
      print('object');
    }
  }

  Future<void> _start(
    StorageEventStart event,
    Emitter<StorageState> emit,
  ) async {
    try {
      if (event.record.id == 0) {
        await _storage.createRecord(event.record);
      } else {
        await _storage.updateRecord(event.record);
      }
      _records = await _storage.readAllRecords();
      emit(StorageState(records: _records, status: StorageStatus.updating));
    } catch (_) {
      print('object');
    }
  }

  Future<void> _end(
    StorageEventEnd event,
    Emitter<StorageState> emit,
  ) async {
    _records = await _storage.readAllRecords();
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
