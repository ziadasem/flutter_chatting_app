import 'package:chatapp/providers/chat_provider.dart';
import 'package:chatapp/widgets/messages_widget.dart';
import 'package:chatapp/widgets/new_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
        appBar:  AppBar(    
        centerTitle: true,    
        backgroundColor: Theme.of(context).primaryColor, 
        title:Text(chatProvider.recieverData['name']) ),
     
        body: Column(
          children: <Widget>[
          Expanded(child: Messages(
                              crateDocumentFunction : chatProvider.setRecentChat,
                              chatID: chatProvider.currentChatId,
                              recieverUID: chatProvider.recieverData['uid'], 
                              updateLastMessage: chatProvider.updateRecentChat,
                          )
          ),
          NewMessages(  uid: chatProvider.uid,
                        chatID:  chatProvider.currentChatId,
                      ),
        ],)
    );
    
  }
}