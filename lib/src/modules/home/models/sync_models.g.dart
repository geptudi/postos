// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncTypeAdapter extends TypeAdapter<SyncType> {
  @override
  final int typeId = 1;

  @override
  SyncType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncType(
      synckey: fields[0] as String,
      syncValue: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SyncType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.synckey)
      ..writeByte(1)
      ..write(obj.syncValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
