import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message ; 
  final bool isMe ;
  final Key key ;
  final int date ;

  MessageBubble(this.message , this.isMe , this.key , this.date);
  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: isMe?MainAxisAlignment.end :MainAxisAlignment.start,
        children :<Widget>[ Container(
      decoration: BoxDecoration(
        color: !isMe ?Theme.of(context).primaryColor : Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12)  ,topRight: Radius.circular(12) , 
         bottomLeft : isMe ?Radius.circular(12) :Radius.circular(0),
         bottomRight : !isMe ?Radius.circular(12) :Radius.circular(0),
        ),
      ),
      width: 170,
      padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 16 , horizontal: 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
 
            Text(message , 
            textAlign: isMe?TextAlign.start :TextAlign.end,
            style: TextStyle(
              color:Colors.grey[100]  /*isMe ?Theme.of(context).accentColor : Theme.of(context).primaryColor*/,
            ),),
            SizedBox(height: 10,),
            Text( DateFormat('EEEE hh:mm').format(DateTime.fromMillisecondsSinceEpoch(date)) , 
            textAlign: isMe?TextAlign.start :TextAlign.end,
            style: TextStyle(
              fontSize: 10,
              color:Colors.grey[100] ,
            ),),
          ],
      ),
    )],
      );
  }
}