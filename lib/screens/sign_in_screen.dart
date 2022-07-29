import 'dart:developer';

import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/utils/next_screens.dart';
import 'package:chatapp/utils/snack_bar.dart';
import 'package:chatapp/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false ;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height ;
    double width =  MediaQuery.of(context).size.width;
    return Scaffold(
      body:  Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height:  height * 0.7,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal :16, vertical: 36),
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  Text("What is Lorem Ipsum", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. ",
                   textAlign: TextAlign.center,
                   style: TextStyle(color: Colors.white, fontSize: 18, ),
                  ),
                  SizedBox(height: 15,),
                  Text("Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                   textAlign: TextAlign.center,
                   style: TextStyle(color: Colors.white, fontSize: 18, ),
                  ),
              ],),
            ),

            Container(
              color: Colors.white,
              height:  height * 0.3,
              child: Center(
                child: Container(
                  height: height * 0.07,
                  width: width * 0.8,
                  child: isLoading?Center(child: CircularProgressIndicator()):
                     RaisedButton.icon(
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16) 
                    ),
                    color: Theme.of(context).primaryColor,
                    icon: Icon(FontAwesomeIcons.google, color: Colors.white,), 
                    label: Text("Sign in with google", style: TextStyle(color: Colors.white, fontSize: 18),),
                    onPressed: (){
                       signInWithGoogle(context);
                    },
                     ),
                ),
              ),
            )
          ],
        ),
    );
  }

  void signInWithGoogle(BuildContext context) async{

    UsersProvider userProvider =Provider.of<UsersProvider>(context, listen: false) ;
    setState(() {
      isLoading = true;
    });
    try{
      await userProvider.signInWithGoogle();
      bool userExists= await userProvider.checkUserExists();
      if (userExists){
        await userProvider.getUserData(userProvider.uid);
      }else{ //create new user
        await userProvider.saveToFirebase();
      }
      await userProvider.saveDataToSP();
      await userProvider.setSignIn();
      nextScreenCloseOthers(context, NavBar());
    }catch(e){
      log(e.toString());
      openToast1(context, "error");
    }
    
    setState(() {
      isLoading = false;
    });
  }
}