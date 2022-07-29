import 'dart:developer';

import 'package:chatapp/model/db_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ContactProvider with ChangeNotifier{
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
  
    String _uid ;
    String get uid => _uid;

    List _contactUID ;
    List get contactUID => _contactUID;
    set setContactUID(newVal) => _contactUID = newVal ;

    List<Map> _contats = [];
    List<Map> get contats =>_contats ;
    
    ContactProvider({String uid, List contactUID, List<Map> contats}){
      this._contats = contats;
      this._contactUID = contactUID ;
      if (uid != null){
         this._uid = uid;
      }
      if (_contats == null){
      
        _initDB();
        return;
      } 
      if (_contats.isEmpty){
         _initDB();
      }
     
    }

    void _initDB() async{
      try{
        _contats = await readFromDB("contacts");
         notifyListeners();
        
      } catch(error){
         _initTables();
         _contats =[];
         log(error.toString());
      }
     
    }


    Future<void> fillContactsFromFirestore() async{
        _contats = [];
        for (int i = 0 ; i < _contactUID.length ; i++) {
          final DocumentSnapshot values = await Firestore.instance.collection('users').document(_contactUID[i]).get();
          Map<dynamic, dynamic> data ={
            "name" : values.data['name'],
            "img_url":values.data['img_url'],
            "uid" :values.data['uid']
          };
       
          _contats.add(data);
        }
          
        clearTable("contacts");
        for (int i = 0 ; i< _contats.length; i++){
          await _addContactToDB(_contats[i]);
         
        }
        notifyListeners();
    }

    void _initTables(){  
       createTable("contacts",
        "name varchar(200), img_url varchar(200), uid varchar(200)");
    }


  Future<List<Map>> fetchUsersFromDB() async{
      _contats =  await readFromDB("contacts");
      return _contats ;
  }

  Future<String> addContact(String uid) async {
      for (int i=0 ;i < _contats.length ; i++){
        if (_contats[i]['uid'].toString() == uid){
            return "already exists";
        }
      }
      DocumentSnapshot usersData =  await _getUserData(uid);
      if (usersData.data == null){
        return "user not found";
      }
      return _saveContact(usersData.data);
   
    }

    //@ return status message
    Future<String> _saveContact(Map values) async{
      String sqlMessag = await _addContactToDB(values);
      if (sqlMessag != "done"){
        return sqlMessag ;
      }
      String firebaseMessage = await _addContactToFB(values); 
      if (firebaseMessage != "done"){
          await _deleteContactFromDB(values);
        return firebaseMessage ;
      }
      notifyListeners();
      return sqlMessag;
    }

    Future<String> _addContactToFB(Map values) async{
       try{
        await Firestore.instance.collection('users').document(uid)
              .updateData({
                "contacts" : FieldValue.arrayUnion([values['uid']])
              });
        return "done";
       }catch(e){
         log("error in uploading" + e.toString());
         return "error in uploading contact";
       }
        
    }

    //return message
    Future<String> _addContactToDB(Map values) async{
     try{
       List dbData = await readFromDB("contacts");
       dbData.firstWhere((contacts) => 
         (contacts['uid'].toString() == values['uid'].toString()));
          print("done");
        return "already exists";
     }catch(e){
        //log("user not found, searching online");
     }
      bool isSuccess =  await insertToDB("contacts",
                            "'${values['name']}', '${values['img_url']}', '${values['uid']}'" );
      if (isSuccess){
      
        return "done";
      }
      return "error" ;
    }

    //return delete message
    Future<String> deleteContact(Map userData) async{
      Map tempUserData = userData ;
      String dbResult = await _deleteContactFromDB(userData);
      if (dbResult != "done"){
        return dbResult;
      }
      String fbResult = await _deleteContactFromFB(userData['uid']);
      if (fbResult == "error"){
         _addContactToDB(tempUserData);
      }
      notifyListeners();
      return fbResult;
    }

    Future<String> _deleteContactFromDB(Map contact) async{
        return await deleteFromDB("contacts", "uid = '" + contact['uid'] + "'");
    }

    Future<String> _deleteContactFromFB(String contactID) async{
        try{
            await Firestore.instance.collection('users').document(uid).updateData(
              {
                "contacts" : FieldValue.arrayRemove([contactID]),
              }
            );
            return "done";
        } catch(e){
          log("error in delete "+ e.toString());
          return "error";

        }
    }

    Future<DocumentSnapshot> _getUserData(String id) async{
      try{
         final DocumentSnapshot values = await Firestore.instance.collection('users').document(id).get();
         return values;
      }catch(e){
        log(e.toString());
        return null;
      }
      
    }
  

}