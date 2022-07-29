import 'dart:developer';

import 'package:chatapp/providers/chat_provider.dart';
import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/utils/next_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentChatsScreen extends StatelessWidget {
  
  ChatProvider chatProvider;
  List<Map> chats =[] ;
  
  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);  
    chats =chatProvider.recentChats;
    print("built"); 
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async{
            await loadFromFireBase(context);
          },
        ),
        title: Text("Recent Chats"),
        centerTitle: true,
        
        ),
        body: FutureBuilder(
             future: chatProvider.featchChatsFromDB(),
              builder: (context,chatsFuture ){
              if (chatsFuture.connectionState == ConnectionState.waiting){
                  return  Center(child:CircularProgressIndicator());
              }
              chats =  chatProvider.recentChats.isEmpty ?chatsFuture.data
                        :chatProvider.recentChats;
              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, i) {
                     return Card(
                        child: ListTile(
                            title: Text(chats[i]['receiver_name']),
                            leading: CircleAvatar(
                            backgroundImage: NetworkImage(chats[i]['img_url']),
                        ),
                        subtitle: Text(chats[i]['message']),
                  onTap: () {
                    openChat(context, chats[i]['reciver_id'], chats[i]['id']);
                  },
                ),
              );
            });
              }
      ),
    
    );
  }

  Future loadFromFireBase(BuildContext context) async{
    UsersProvider usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.getUserData(chatProvider.uid);
    chatProvider.setRecentChatsUID = usersProvider.chats ;
    await chatProvider.fillRecentChatsFromFirestore();
  }

  void openChat(BuildContext context, String recieverUID, String chatID) async {

    await chatProvider.setRecieverData(recieverUID);
    chatProvider.currentChatId = chatID;
    nextScreen(context, ChatScreen());
  }

}