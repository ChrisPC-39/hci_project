import 'package:hive/hive.dart';

part 'setup.g.dart';

@HiveType(typeId: 0)
class Setup {
  @HiveField(0)
  final bool isFirstTime;

  @HiveField(1)
  final String lang;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final bool isLobitos;

  @HiveField(4)
  final double fontSize;

  Setup(this.isFirstTime, this.lang, this.color, this.isLobitos, this.fontSize);
}