import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../globals.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String infoTextEN1 = '''  With this app you can directly report rubbish to the municipalities of '''
                      '''Lobitos and Piedritas. The municipality will take care of clearing the '''
                      '''rubbish by dispatching your report to a rubbish clearing team. The trash '''
                      '''will then usually be removed within one day.''';
  String infoTextEN2 = '''  In order to make your report you first have to specify the location of '''
                       '''the waste, either explicitly or on the map. Next you have to select the '''
                       '''type of waste. You can also include a picture and add extra details that '''
                       '''might be important. If you have entered your email-address and/or phone '''
                       '''number you will receive a confirmation message if your submission was successful.''';

  String infoTextES1 = '''Con este App puede reportar basura directamente a las municipalidades de '''
                       '''Lobitos y Piedritas. La municipalidad se encargará con la limpieza de la '''
                       '''basura, enviando su reporte a un equipo de limpieza. La basura se recogerá durante un día.''';
  String infoTextES2 = '''Para hacer su informe, primero deberá especificar la locación de la basura, como explicar '''
                       '''dónde o mostrar en la mapa. Después deberá seleccionar el tipo de basura. Además puede '''
                       '''incluir fotos y extra detalles que podrían ser importantes. Si usted se ha registrado con '''
                       '''su correo electrónico o/y número de teléfono usted recibirá un mensaje de confirmación si '''
                       '''su sumisión fue exitosa.''';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("set").getAt(0) as Setup;
        final bool isEn = setup.lang.contains("en");

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: GestureDetector(
              onTap: () => speak(isEn ? "Information" : "Información"),
              child: Text(isEn ? "Information" : "Información")),
              backgroundColor: Color(setup.color)
            ),
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () => speak(isEn
                        ? "Thank you for helping us keep our environment clean!"
                        : "Gracias por ayudarnos con sostener nuestro ambiente limpio!"),
                    child: Text(isEn
                        ? "Thank you for helping us keep our environment clean!"
                        : "Gracias por ayudarnos con sostener nuestro ambiente limpio!",
                      style: TextStyle(fontSize: setup.fontSize + 10, fontWeight: FontWeight.bold)),
                  ),
                  Container(height: 5),
                  GestureDetector(
                    onTap: () => speak(isEn ? infoTextEN1 : infoTextES1),
                    child: Text(isEn ? infoTextEN1 : infoTextES1, style: TextStyle(fontSize: setup.fontSize + 5))
                  ),

                  Container(height: 25),

                  GestureDetector(
                    onTap: () => speak(isEn
                        ? "How the app works"
                        : "Como funciona la app"),
                    child: Text(isEn
                        ? "How the app works"
                        : "Como funciona la app?",
                        style: TextStyle(fontSize: setup.fontSize + 10, fontWeight: FontWeight.bold)),
                  ),
                  Container(height: 5),
                  GestureDetector(
                      onTap: () => speak(isEn ? infoTextEN2 : infoTextES2),
                      child: Text(isEn ? infoTextEN2 : infoTextES2, style: TextStyle(fontSize: setup.fontSize + 5))
                  )
                ]
              )
            )
          )
        );
      }
    );
  }
}