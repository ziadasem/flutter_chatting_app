

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void openSnacbar(_scaffoldKey, snacMessage , {Function onclick  }){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: Text(
        snacMessage,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'Ok',
      textColor: Colors.blueAccent,
      onPressed: onclick ?? (){},
    ),
  )
    );
  
  

}
//sort length
void openToast(context, message){
  Toast.show(message, context, textColor: Colors.white, backgroundRadius: 20, duration: Toast.LENGTH_SHORT);
  }

//long length
void openToast1(context, message){
  Toast.show(message, context, textColor: Colors.white, backgroundRadius: 20, duration: Toast.LENGTH_LONG);
  
  }