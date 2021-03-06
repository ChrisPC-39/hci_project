import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/phone_main_screen.dart';
import 'package:hci_project/screens/setup_screen.dart';
import 'package:hci_project/screens/web_main_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  ///This bit is just to initialize the database. It's not important to understand.
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentDirectory;

  if(kIsWeb) {
    await Hive.initFlutter();
  } else {
    appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  Hive.registerAdapter(SetupAdapter());

  await Hive.openBox("set");
  final setupBox = Hive.box("set");

  if(setupBox.isEmpty) {
    setupBox.add(Setup(true, "es", 0xFF2196f3, false, 20));
  }

  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  ///This widget is the root of the application.
  ///The "build" function starts rendering everything on the screen
  @override
  Widget build(BuildContext context) {
    final setupBox = Hive.box("set");
    final setup = setupBox.getAt(0) as Setup;

    ///This SystemChrome is here to change the colors of the nav bar and status bar
    ///on Android phones (the bars that show back/home/menu buttons and the
    ///bar that shows time, battery, internet, etc
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.blue,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.blue
    ));

    if (setup.isFirstTime) return SetupScreen();
    else if (kIsWeb && MediaQuery.of(context).size.width > 700)
      return WebMainScreen();
    else return PhoneMainScreen();
  }
}