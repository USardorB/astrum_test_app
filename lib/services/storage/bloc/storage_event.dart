part of 'storage_bloc.dart';

sealed class StorageEvent {
  const StorageEvent();
}

class StorageEventInit extends StorageEvent {
  const StorageEventInit();
}

class StorageEventStart extends StorageEvent {
  final RecordModel record;
  const StorageEventStart(this.record);
}

class StorageEventEnd extends StorageEvent {
  const StorageEventEnd();
}

class StorageEventReadAll extends StorageEvent {
  const StorageEventReadAll();
}
