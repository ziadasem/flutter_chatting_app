import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void nextScreen(BuildContext context , Widget page){
  Navigator.push(context , MaterialPageRoute(
    builder: (context) => page));
}

void nextScreenCloseOthers (BuildContext context, Widget  page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace (BuildContext context, Widget page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup (BuildContext context,Widget  page){
  Navigator.push(context, MaterialPageRoute(
    fullscreenDialog: true,
    builder: (context) => page),
  );
}

void closeScreen(BuildContext context){
  Navigator.pop(context);
}