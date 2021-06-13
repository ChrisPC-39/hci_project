import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/phone_main_screen.dart';
import 'package:hci_project/screens/setup_screen.dart';
import 'package:hci_project/screens/web_main_screen.dart';
import 'package:hci_project/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentDirectory;

  if(kIsWeb) {
    await Hive.initFlutter();
  } else {
    appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  Hive.registerAdapter(SetupAdapter());

  await Hive.openBox("settings");
  final setupBox = Hive.box("settings");

  if(setupBox.isEmpty) {
    setupBox.add(Setup(true, "es", 0xFF2196f3, false));
  }

  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    final setupBox = Hive.box("settings");
    final setup = setupBox.getAt(0) as Setup;

    //This SystemChrome is here to change the colors of the nav bar and status bar
    //on Android phones (the bars that show back/home/menu buttons and the
    //bar that shows time, battery, internet, etc
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.blue,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.blue
    ));

    //This prevents the app from going side-ways if the phone is tilted
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (setup.isFirstTime) {
      return SetupScreen();
    } else {
      if (kIsWeb && MediaQuery.of(context).size.width > 700) {
        return WebMainScreen();
      } else {
        return PhoneMainScreen();
      }
    }

    // return FutureBuilder(
    //   future: Hive.openBox("settings"),
    //   builder: (context, snapshot) {
    //     if(snapshot.connectionState == ConnectionState.done) {
    //       if(snapshot.hasError) return Text(snapshot.error.toString());
    //       else return ValueListenableBuilder(
    //         valueListenable: Hive.box("settings").listenable(),
    //         builder: (context, setupBox, _) {
    //           return setup.isFirstTime ? SetupScreen() : PhoneMainScreen();
    //         }
    //       );
    //     } else return Scaffold(
    //       backgroundColor: Color(0xFF424242),
    //       body: Center(child: CircularProgressIndicator())
    //     );
    //   }
    // );
  }
}