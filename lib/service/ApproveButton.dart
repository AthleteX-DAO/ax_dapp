import 'package:flutter/material.dart';

class ApproveButton extends StatelessWidget {
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
}
