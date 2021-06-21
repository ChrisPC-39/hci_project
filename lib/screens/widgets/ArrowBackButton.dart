import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

class ArrowBackButton extends StatefulWidget {
  final int currPage;
  final Function(int currPage) callback;

  const ArrowBackButton({Key? key, required this.currPage, required this.callback}) : super(key: key);

  @override
  _ArrowBackButtonState createState() => _ArrowBackButtonState();
}

class _ArrowBackButtonState extends State<ArrowBackButton> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;

    return AnimatedOpacity(
      opacity: widget.currPage > 0 ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.06,
        margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
        child: ElevatedButton(
          child: Icon(Icons.arrow_back_ios_rounded,
            size: 35,
            color: Colors.black
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),
            backgroundColor: MaterialStateProperty.all(Color(setup.color))
          ),
          onPressed: () {
            if (widget.currPage > 0) widget.callback(widget.currPage - 1);
          }
        )
      )
    );
  }
}