import 'package:chatapp/screens/contacts_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/screens/recent_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatefulWidget {

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  GlobalKey key ;
  Widget currentPage = RecentChatsScreen();
  int currentPageIndex =  0 ;
  BottomNavigationBar customBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: (int currentIndex) {
        setState(() {
          if (currentIndex == 0 ){
            currentPage = RecentChatsScreen();
            currentPageIndex = 0 ;
          }else if (currentIndex == 1 ){
            currentPage = ContactsScreen();
            currentPageIndex = 1 ;
          }else if (currentIndex == 2 ){
            currentPage = ProfilePage();
            currentPageIndex = 2 ;
          }
        });
        
      },

      items: [
        BottomNavigationBarItem(
         title: Text('Recent'),
         icon: Icon(Icons.chat_rounded),
        ),

        BottomNavigationBarItem(
         title: Text('Contacts',),
         icon: Icon(Icons.people ),
        ),

        BottomNavigationBarItem(
         title: Text('Profile',),
         icon: Icon(Icons.person, ),
        ),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: currentPage,
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }
}