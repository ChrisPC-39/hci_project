import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';

import 'database/setup.dart';

///These objects are created so the variables inside their classes can be accessed
///from any class/file in lib.

///If, for example we would have just declared "bool canSendReport" without a class,
///the value of "canSendReport" would not be the same for each class because any changed
///to it would be made only locally ("class A" could read true, while "class B" would read false).

TextControllers controller = TextControllers();
Booleans select = Booleans();

class TextControllers {
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController phoneNr = TextEditingController();
}

class Booleans {
  List<bool> filledForms = List.filled(4, false);
  List<bool> checkedTrash = List.filled(6, false);

  bool pinnedMap = false;
  bool selectedImage = false;
  bool canSendReport = false;
  bool writtenAddress = false;
}

///These 2 functions start the Text-To-Speech.
Future<void> speak(String text) async {
  FlutterTts tts = FlutterTts();

  final setup = Hive.box("set").getAt(0) as Setup;
  final String lang = setup.lang.contains("en") ? "en-US" : "es-ES";
  final bool isTTS = setup.lang.contains("v");

  await tts.setLanguage(lang);
  await tts.speak(isTTS ? text : "");
}

Future<void> forceSpeak(String text) async {
  FlutterTts tts = FlutterTts();

  final setup = Hive.box("set").getAt(0) as Setup;
  final String lang = setup.lang.contains("en") ? "en-US" : "es-ES";

  await tts.setLanguage(lang);
  await tts.speak(text);
}