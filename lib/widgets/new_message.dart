import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewMessages extends StatefulWidget {
  final String uid ;
  final String chatID;
  NewMessages({this.uid, this.chatID});
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
String enterdMessage = ""  ;
final _controller = TextEditingController();

void sendMessage() async{
  FocusScope.of(context).unfocus();
  
  Firestore.instance.collection('chats').document(widget.chatID).collection('chats').document().setData({
    'text' : enterdMessage ,
    'sent' : Timestamp.now().millisecondsSinceEpoch,
    'uid' : widget.uid
  });

  Firestore.instance.collection('chats').document(widget.chatID).updateData({
    'message' : enterdMessage ,
    'sent' : DateTime.now().millisecondsSinceEpoch
  });
  setState(() {
    enterdMessage = "";
    _controller.text = "";
  });
}



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top :8),
      padding: EdgeInsets.all(8),
      child: Row(children: <Widget>[
        Expanded(child: //take the space
           TextField(
             controller: _controller,
             decoration: InputDecoration(labelText: "Write ..."),
             onChanged: (text){
             setState((){
               enterdMessage = text ;
             });
             },
           ),),
           IconButton(icon: Icon(Icons.send , color: Theme.of(context).primaryColor,),
                      onPressed: enterdMessage.trim().isEmpty ?null : sendMessage
          ),
       
      ],),
    );
  }
}