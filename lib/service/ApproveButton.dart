import 'dart:js';

import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';

// DO NOT DELETE THE CODE
/*class ApproveButton extends StatelessWidget {
  //TO DO fix changing state of button

  final double _width;
  final double _height;
  final bool approved;
  final VoidCallback _approveCallBack;
  final VoidCallback _confirmCallBack;
  String _text;
  Color? _fillColor;

  ApproveButton(this._width, this._height, this._text, this.approved,
      this._approveCallBack, this._confirmCallBack) {
    _fillColor = approved ? Colors.amber : Colors.transparent;
    _text = approved ? _text : 'Approve';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        color: _fillColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: approved ? _confirmCallBack : _approveCallBack,
        child: Text(
          _text,
          style: TextStyle(
            fontSize: 16,
            color: approved ? Colors.black : Colors.amber,
          ),
        ),
      ),
    );
  }
}*/

// This code changes the state of the button
class ApproveButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  const ApproveButton(this.width, this.height, this.text);
  //const ApproveButton(double width, double height, String text, {Key? key}) : super(key: key);

  @override
  _ApproveButtonState createState() => _ApproveButtonState();
}

class _ApproveButtonState extends State<ApproveButton> {

  double width = 0;
  double height = 0;
  String text = "";
  bool approved = true;
  Color? fillcolor;
  Color? textcolor;
  int currentState = 0;
  Widget? dialog;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
    currentState = 0;
  }

  void changeData () {
    text = "Confirm";
    fillcolor = Colors.amber;
    textcolor = Colors.black;
    approved = false;
    // Keep track of how many times the state has changed
    currentState += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        color: fillcolor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          // Testing to see how the popup will work when the state is changed
          if(currentState == 1) {
            Navigator.pop(context);
            showDialog(
            context: context,
            builder: (BuildContext context) =>
                depositConfimed(context));
          }
          //print("Working");
          setState(() {
            changeData();
          });
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textcolor,
          ),
        ),
      ),
    );
  }
  
}