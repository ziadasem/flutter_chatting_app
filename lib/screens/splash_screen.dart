import 'dart:convert';

import 'package:chatapp/configuration/config.dart';
import 'package:chatapp/model/db_functions.dart';
import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/screens/sign_in_screen.dart';
import 'package:chatapp/utils/next_screens.dart';
import 'package:chatapp/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    Future.delayed(Duration(milliseconds: 2000), () async{    
        bool isSignIn = await usersProvider.checkSignIn();
        await openDB();
        if (isSignIn == true){
            await usersProvider.getFromSP() ;
            nextScreenCloseOthers(context, NavBar());
            
        }else{
            final SharedPreferences sp = await SharedPreferences.getInstance();
            bool isFirstTime = sp.getBool('isfirstTime') ??true;
            if (isFirstTime){
              await initTables();
              sp.setBool('isfirstTime', false);
            }
            nextScreenCloseOthers(context, SignInScreen());
        }
    });
    return Scaffold(
      body:Container(color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(Config.appName, 
                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),),
      )
    )
  );
  }

  Future initTables() async{
      await createTable("chats", "reciver_id int, receiver_name varchar(200), message varchar(200), img_url varchar(200), sent int, id varchar(200)");
      await createTable("contacts",
        "name varchar(200), img_url varchar(200), uid varchar(200)");
  }
}