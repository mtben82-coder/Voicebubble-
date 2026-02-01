// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_snapshot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VersionSnapshotAdapter extends TypeAdapter<VersionSnapshot> {
  @override
  final int typeId = 5;

  @override
  VersionSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VersionSnapshot(
      id: fields[0] as String,
      noteId: fields[1] as String,
      content: fields[2] as String,
      formattedContent: fields[3] as String?,
      timestamp: fields[4] as DateTime,
      label: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VersionSnapshot obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.noteId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.formattedContent)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VersionSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
