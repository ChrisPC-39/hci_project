import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

class RegionScreen extends StatefulWidget {
  @override
  _RegionScreenState createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final isEn = setup.lang == "en";

    return Column(
      children: [
        Spacer(flex: 1),
        _buildChooseRegion(),
        Container(height: 30),
        Text(isEn
            ? "Your current region is ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}"
            : "Yer currento regiones es ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}",
          style: TextStyle(fontSize: 20),
        ),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildChooseRegion() {
    final setup = Hive.box("settings").getAt(0) as Setup;

    return Column(
      children: [
        Text(
          setup.lang == "en" ? "Select your region" : "Hola mundo",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          )
        ),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(image: AssetImage('assets/lobitos.png'), width: 90, height: 90, fit: BoxFit.fill)
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  onPressed: () => setState(() {
                    Hive.box("settings").putAt(0, Setup(setup.isFirstTime, setup.lang, setup.color, true));
                  })
                ),

                Container(height: 20),
                Text("LOBITOS", style: TextStyle(fontWeight: FontWeight.bold))
              ]
            ),

            Column(
              children: [
                ElevatedButton(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(image: AssetImage('assets/piedritas.png'), width: 90, height: 90, fit: BoxFit.fill)
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  onPressed: () => setState(() {
                    Hive.box("settings").putAt(0, Setup(setup.isFirstTime, setup.lang, setup.color, false));
                  })
                ),

                Container(height: 20),
                Text("PIEDRITAS", style: TextStyle(fontWeight: FontWeight.bold))
              ]
            ),

            SizedBox(width: 20),
          ]
        ),
      ]
    );
  }
}