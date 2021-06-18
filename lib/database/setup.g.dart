// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetupAdapter extends TypeAdapter<Setup> {
  @override
  final int typeId = 0;

  @override
  Setup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setup(
      fields[0] as bool,
      fields[1] as String,
      fields[2] as int,
      fields[3] as bool,
      fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Setup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isFirstTime)
      ..writeByte(1)
      ..write(obj.lang)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.isLobitos)
      ..writeByte(4)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
