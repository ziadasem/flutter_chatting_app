import 'dart:developer';

import 'package:chatapp/model/db_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ChatProvider with ChangeNotifier {

 bool _disposed = false;
    @override
  void dispose() {
    _disposed = true;
  super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  String _uid;

  String get uid => _uid;

  String _name;

  String get name => _name;

  String _imgUrl ;

  String get imgUrl => _imgUrl;
  

  List<Map<dynamic, dynamic>> _recentChats;

  List<Map<dynamic, dynamic>> get recentChats => _recentChats;




  DocumentSnapshot _recieverData;
  
  DocumentSnapshot get recieverData => _recieverData;

  String currentChatId ;
  void  setCurrentChatId (newVal) => currentChatId =newVal ;

  List _recentChatsUID;
  List get recentChatsUID => _recentChatsUID;
  set setRecentChatsUID(newVal) => _recentChatsUID = newVal;

  ChatProvider({String uid , String name, String imgUrl,
               List<Map<dynamic, dynamic>> recentChats,   DocumentSnapshot recieverData ,
              List recentChatsUID}){

      this._uid = uid;
      this._name = name;
      this._imgUrl = imgUrl;
      this._recentChats = recentChats;
      this._recieverData = recieverData;
      this._recentChatsUID = recentChatsUID;

      if (_recentChats == null){
          _initDB();
      }
  }

  void _initDB() async{
      try{
        _recentChats = await readFromDB("chats");
      } catch(error){
         _initTables();
         log(error.toString());
      }
        
  }

  Future<void> fillRecentChatsFromFirestore() async{
     _recentChats = [] ;
     for (int i = 0 ; i <_recentChatsUID.length; i++) {
        final DocumentSnapshot values = await Firestore.instance.collection('chats').document(_recentChatsUID[i]).get();
        List temp  = values.data['user_data'].keys.toList();
        String recieverUID = temp.firstWhere((element) => element != uid);

        Map data ={
          "user_data" : values['user_data'][recieverUID],
          "message" :values['message'],
          "sent": values['sent'],
          "id" : values['id'],
        };
        _recentChats.add(data);
      }
      clearTable("chats");
      for (int i = 0 ; i< _recentChats.length; i++){
        await _addRecentChatToDB(_recentChats[i]);
      }
     notifyListeners();
  }

  //return status message
  Future<String> _addRecentChatToDB(Map recentValue) async{
      try{
       List dbData = await readFromDB("chats");
       dbData.firstWhere((chats) => 
         (chats['id'].toString() == recentValue['id'].toString()));
        return "already exists";
     }catch(e){
       // log("user not found, searching online");
     }
   
      bool isSuccess =  await insertToDB("chats",
      " '${recentValue['user_data']['uid']}' ,'${recentValue['user_data']['name']}', '${recentValue['message']}', '${recentValue['user_data']['img_url']}' ,  ${recentValue['sent']}, '${recentValue['id']}'" );
      if (isSuccess){
        return "done";
      }
      return "error" ;
    }
  
  Future<void> updateRecentChat(Map recentValue) async{
      await updateDB("chats", 
      " sent = ${recentValue['sent']}, message = '${recentValue['text']}' ",
       "id =  '$currentChatId'");
       notifyListeners();
  }

  Future<String> createNewChat() async{
    for (int i= 0 ; i <recentChats.length ; i++){
      if (recentChats[i]['uid'].toString() == _recieverData['uid'].toString()){
        return recentChats[i]['chatID'].toString(); //document is initialized 
      }
    }
    // initalize document
    String chatID = _uid+ _recieverData['uid'] + "@#";
    
    await Firestore.instance.collection('chats').document(chatID).setData({
        "user_data" :
               {
                 _uid:{
                   "uid" : _uid,
                   "name" : _name ,
                   "img_url" : _imgUrl
                 },
                 _recieverData['uid']: {
                    "uid" : _recieverData['uid'],
                    "name" : _recieverData['name'] ,
                    "img_url" : _recieverData['img_url']
                 }
                },
        "message" :"",
        "sent": DateTime.now().millisecondsSinceEpoch,
        "id" : chatID
    });
 
    this.currentChatId =  chatID;
    return chatID;
  }

  Future setRecieverData(String uid) async{
   _recieverData = await Firestore.instance.collection('users').document(uid).get();
  }

  Future setRecentChat(String message) async{
       await Firestore.instance.collection('users').document(_uid).updateData({
        "chats" : FieldValue.arrayUnion( [currentChatId])
      });
      //add recent chat and contact to reciever
      await Firestore.instance.collection('users').document(_recieverData['uid']).updateData({
        "chats" : FieldValue.arrayUnion( [currentChatId]),
        "contacts" : FieldValue.arrayUnion( [_uid]),
      });
      
      Map data ={
          "user_data" :{
                    "uid" : _recieverData.data['uid'],
                    "name" : _recieverData.data['name'] ,
                    "img_url" : _recieverData.data['img_url'],
          },
          "message" :message,
          "sent": DateTime.now().millisecondsSinceEpoch,
          "id" : currentChatId,
      };
     await _addRecentChatToDB(data);
  notifyListeners();
  }
 

  void _initTables(){
       createTable("chats", "reciver_id int, receiver_name varchar(200), message varchar(200), img_url varchar(200), sent int, id varchar(200)");
  }

  Future< List<Map> > featchChatsFromDB() async{
      _recentChats =  await readFromDB("chats order by sent desc");
      return _recentChats ;
  }

}