import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:math';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Random random = new Random();
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text(isEn ? "Account settings" : "Accounto Settingso"), backgroundColor: Color(setup.color)),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment(-1.0, 0.0),
                    child: Text(
                      isEn ? "Email and phone numbers are used to send confirmations for successful reports!"
                           : "TODO SPANISH",
                      style: TextStyle(fontSize: 25, color: Colors.grey[600])
                    )
                  )
                ),
                _buildEmailAndPhone(isEmail: true),
                _buildEmailAndPhone(isEmail: false),
                _buildConfirmButton(),

                Divider(thickness: 1),

                Visibility(
                  visible: isAdmin,
                  child: _buildAdminView()
                ),
              ]
            )
          )
        );
      }
    );
  }

  Widget _buildAdminView() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    final _random = random.nextInt(15) + 1;

    return Column(
      children: [
        Center(
          child: Text(
            isEn ? "Welcome ADMIN!" : "Wilkommen ADMIN",
            style: TextStyle(fontSize: 25)
          ),
        ),

        //Container(height: 15),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            isEn ? "There's been a total of $_random reports recently."
                 : "Hola mundo gracias $_random reportos mamma mia.",
            style: TextStyle(fontSize: 20)
          )
        ),

        Stack(
          children: [
            Image(image: AssetImage(setup.isLobitos ?  "assets/lobitos.png" : "assets/piedritas.png"), width: 400, height: 300),

            Container(
              height: 300,
              width: 400,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _random,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
                    child: Icon(Icons.pin_drop, color: Colors.red[400])
                  );
                }
              )
            )
          ]
        )
      ]
    );
  }

  Widget _buildEmailAndPhone({required bool isEmail}) {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        controller: isEmail ? addressController : phoneController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          labelText: isEmail
            ? isEn ? "Email address" : "Email addresso si si"
            : isEn ? "Phone number" : "Phone numero"
        )
      )
    );
  }

  Widget _buildConfirmButton() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        height: 50,
        child: ElevatedButton(
          onPressed: () => setState(() {
            if(addressController.text == "1" && phoneController.text == "1")
              isAdmin = true;
            else isAdmin = false;
          }),
          child: Text(isEn ? "Confirm" : "Confirmo", style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(setup.color))
          )
        ),
      )
    );
  }
}
