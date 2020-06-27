import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  String text;

  bool passWord;

  Object onChanged;

  int maxLength;

  double height;

  TextEditingController controller;

  TextInput({ this.text = '输入内容', this.passWord = false, this.onChanged = null, this.maxLength = 1, this.height = 55, this.controller= null });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      decoration: BoxDecoration(
          border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
      child: TextField(
        controller: this.controller,
        autofocus: false,
        maxLines: this.maxLength,
        obscureText: this.passWord,
        decoration: InputDecoration(
          hintText: this.text,
          border: OutlineInputBorder(
              borderSide: BorderSide.none
          )
        ),
        onChanged: this.onChanged,
        
      ),
    );
  }
}
