import 'dart:developer';

import 'package:chatapp/configuration/config.dart';
import 'package:chatapp/providers/chat_provider.dart';
import 'package:chatapp/providers/contacts_provider.dart';
import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/screens/sign_in_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:chatapp/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersProvider>(
            create:(context) => UsersProvider(),
          ),
          ChangeNotifierProxyProvider<UsersProvider, ContactProvider>(
            create: (context) => ContactProvider(),
            update: (ctx, users, previousContact) {
                 return ContactProvider(
                    contactUID:  users.contacts ??previousContact.contactUID,
                    uid: users.uid ??previousContact.uid,
                    contats: previousContact  == null ?[] 
                                :previousContact.contats ,
                
                  );
          }
        ),
        ChangeNotifierProxyProvider<UsersProvider, ChatProvider>(
          create: (context) => ChatProvider(),
          update: (ctx, users,  previousChat) {
                return ChatProvider(
                  uid: users.uid ??previousChat.uid,
                  name: users.name ??previousChat.name,
                  imgUrl:users.imageUrl ??previousChat.imgUrl,
                  recentChatsUID: users.chats ??previousChat.recentChatsUID,
                  recentChats:  previousChat.recentChats ??[],
                  recieverData:  previousChat.recieverData 
                );
              }
          ),
        ],
        child: MaterialApp(
           debugShowCheckedModeBanner: false,
            title: Config.appName,
            theme: Config.appTheme,
            home: SplashScreen(),
      ),
    );
  }
}
