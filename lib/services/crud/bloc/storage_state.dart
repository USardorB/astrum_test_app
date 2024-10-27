part of 'storage_bloc.dart';

final class StorageState extends Equatable {
  final List<RecordModel> records;
  final StorageStatus status;
  const StorageState({
    required this.records,
    required this.status,
  });

  @override
  List<Object> get props => [records, status];
}

enum StorageStatus { initial, stable, updating }
