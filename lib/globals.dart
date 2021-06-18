import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';

import 'database/setup.dart';

TextControllers ctrl = TextControllers();
Booleans select = Booleans();

class TextControllers {
  TextEditingController addressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
}

class Booleans {
  List<bool> filledForms = List.filled(5, false);
  List<bool?> checkedTrash = List.filled(6, false);

  bool selectedAddress = false;
  bool selectedImage = false;
  bool selectedMap = false;
  bool canSendReport = false;
}

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