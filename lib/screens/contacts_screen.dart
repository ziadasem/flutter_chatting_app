import 'dart:developer';

import 'package:chatapp/configuration/config.dart';
import 'package:chatapp/model/db_functions.dart';
import 'package:chatapp/providers/chat_provider.dart';
import 'package:chatapp/providers/contacts_provider.dart';
import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/utils/next_screens.dart';
import 'package:chatapp/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget{

  ContactProvider contactProvider;

  List<Map> contact =[] ;

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
    contactProvider = Provider.of<ContactProvider>(context);
    contact = contactProvider.contats ;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async{
            await loadFromFireBase(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addNewContact(context),
          )
        ],
        centerTitle: true,
        title: Text("My Contacts"),
      ),

      body: FutureBuilder(
            future: contactProvider.fetchUsersFromDB(),
              builder: (context,contactFuture ){
              if (contactFuture.connectionState == ConnectionState.waiting){
                  return  Center(child:CircularProgressIndicator());
              }
              contact = contactProvider.contats.isEmpty? contactFuture.data:contactProvider.contats;
              return ListView.builder(
                  itemCount: contact.length,
                  itemBuilder: (context, i) {
                    return Card(
                        child: ListTile(
                            title: Text(contact[i]['name']),
                            leading: CircleAvatar(
                            backgroundImage: NetworkImage(contact[i]['img_url']),
                        ),
                        trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, ),
                              onPressed: () async{
                                 String result =  await startDeleteContact(contact[i]);
                                 openToast1(context, result);  
                              },
                        ),
                  onTap: () {
                   createChat(context, contact[i]['uid']);
                  },
                ),
              );
            });
              }
      ),
    );
  }

  void createChat(BuildContext context, String recieverUID) async {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.setRecieverData(recieverUID);
    await chatProvider.createNewChat();
    nextScreen(context, ChatScreen());
  }

  Future loadFromFireBase(BuildContext context) async{
    UsersProvider usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.getUserData(contactProvider.uid);
    contactProvider.setContactUID = usersProvider.contacts ;
    await contactProvider.fillContactsFromFirestore();
  }

  void addNewContact(BuildContext context) async{
    String uid = await startBarcodeScanStream();
    if (uid !="-1"){
      String result =await contactProvider.addContact(uid);
      openToast1(context, result);
    }
  }

  Future<String> startBarcodeScanStream() async {
    return await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", true, ScanMode.QR);
  }

  Future<String> startDeleteContact(Map deletedContactMap) async{
    String result = await contactProvider.deleteContact(deletedContactMap);
    return result;
  }
}
