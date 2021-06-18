import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:math';

import '../globals.dart';

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
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("set").getAt(0) as Setup;
        final bool isEn = setup.lang.contains("en");

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: GestureDetector(
              onTap: () => speak(isEn ? "Account settings" : "Configuraciones de la cuenta"),
              child: Text(isEn ? "Account settings" : "Configuraciones de la cuenta")), backgroundColor: Color(setup.color)
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment(-1.0, 0.0),
                    child: GestureDetector(
                      onTap: () => speak(isEn
                          ? "Email and phone numbers are used to send confirmations for successful reports!"
                          : "El correo electrónico y los números de teléfono se utilizan para enviar confirmaciones para informes exitosos."),
                      child: Text(
                        isEn ? "Email and phone numbers are used to send confirmations for successful reports!"
                             : "El correo electrónico y los números de teléfono se utilizan para enviar confirmaciones para informes exitosos.",
                        style: TextStyle(fontSize: setup.fontSize + 5, color: Colors.grey[600])
                      ),
                    )
                  )
                ),
                _buildEmailAndPhone(isEmail: true),
                _buildEmailAndPhone(isEmail: false),
                _buildConfirmButton(),

                Text("Pro tip: type 1 for email and 1 for phone number and press Confirm to access a cool feature"),

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
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    final _random = random.nextInt(15) + 1;

    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () => speak(isEn ? "Welcome ADMIN!" : "¡Bienvenidos ADMIN!"),
            child: Text(
              isEn ? "Welcome ADMIN!" : "¡Bienvenidos ADMIN!",
              style: TextStyle(fontSize: setup.fontSize + 5)
            )
          )
        ),

        //Container(height: 15),

        Padding(
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () => speak(isEn
                ? "There's been a total of $_random reports recently."
                : "Recientemente ha habido un total de $_random informes."),
            child: Text(
              isEn ? "There's been a total of $_random reports recently."
                   : "Recientemente ha habido un total de $_random informes.",
              style: TextStyle(fontSize: setup.fontSize)
            )
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
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        controller: isEmail ? addressController : phoneController,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          labelText: isEmail
            ? isEn ? "Email address" : "Correo Electrónico"
            : isEn ? "Phone number" : "Número de telefono"
        )
      )
    );
  }

  Widget _buildConfirmButton() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

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
          child: Text(isEn ? "Confirm" : "Confirmar", style: TextStyle(fontSize: setup.fontSize)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(setup.color))
          )
        )
      )
    );
  }
}
