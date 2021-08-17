import 'package:flutter/material.dart';

class HeaderBackButton extends StatelessWidget {
  var icon;
  var onPress;

  HeaderBackButton({this.icon,this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth:30,
        splashColor: Colors.grey,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xffffff),
          onPressed: onPress,
          child: icon,
        ),
      ),
    );
  }
}