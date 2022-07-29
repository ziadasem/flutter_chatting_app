import 'dart:developer';

import '../widgets/message_bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
 final String chatID ;
 final String recieverUID ;
 final Function crateDocumentFunction ;
 final Function updateLastMessage ;

  const Messages({this.chatID, this.recieverUID,  
                  this.crateDocumentFunction, this.updateLastMessage });


  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chats').document(chatID).collection('chats').orderBy('sent' , descending: true).snapshots(),
      builder: (context , data) {
        if (data.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else{
            final documents = data.data.documents ;
            if (documents.length == 1 ){
                crateDocumentFunction(documents[0].data['text']);
            }
            if(documents.isNotEmpty){
              updateLastMessage(documents.first.data);
            }
            
             return  ListView.builder(
                reverse: true,
                padding:  EdgeInsets.all(8.0),
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                    return  MessageBubble(documents[index].data['text'].toString().isEmpty
                                 ?"!Something happend with this message.....!" :documents[index].data['text'] ,
                                 documents[index].data['uid'] != recieverUID  ,
                                 ValueKey(documents[index].documentID + documents[index].data['text']),
                                 documents[index].data['sent']
                            );
                    },
             );
         }
        });
  }
}