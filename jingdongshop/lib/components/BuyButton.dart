import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {

  final Color color;
  final String text;
  final Object callback;

  BuyButton({this.color,this.text,this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.callback,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
