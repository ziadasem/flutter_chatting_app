import 'package:chatapp/providers/users_provider.dart';
import 'package:chatapp/screens/sign_in_screen.dart';
import 'package:chatapp/utils/next_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UsersProvider usersProvider;
  @override
  void initState() {
    usersProvider = Provider.of<UsersProvider>(context, listen: false);
    usersProvider.getFromSP();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Color(0xffefeff9),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile" , style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Card(
                   elevation: 8,
                   child: Container(
                     alignment: Alignment.center,
                     padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(usersProvider.imageUrl ??""),
                          ),
                          SizedBox(height :10),
                          Text(usersProvider.name ??"", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height :10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),


                  Text("email", style: TextStyle(color: Colors.grey, fontSize: 14),),
                  Text(usersProvider.email ??"", style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15,),
                  Text("joining date", style: TextStyle(color: Colors.grey, fontSize: 14),),
                  Text(usersProvider.email ??"", style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20,), 
                  InkWell(
                          child: Text("Share your contact", 
                            style: TextStyle(fontSize: 16,
                            ),
                          ),
                          onTap: (){
                                showDialog(context: context, 
                                  builder: (context) =>
                                       Center(
                                         child: Card(
                                           child: QrImage(
                                           data: usersProvider.uid ??"-1",
                                           version: QrVersions.auto,
                                           size: 200.0,
                                          ),
                                        ),
                                     ),                                
                                 );
                            },
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                          child: Text("Logout", 
                          style: TextStyle(color: Theme.of(context).primaryColor,
                                           fontWeight: FontWeight.bold,fontSize: 16,
                          ),
                    ),
                    onTap: () async{
                      await usersProvider.logout();
                      nextScreenCloseOthers(context, SignInScreen());
                    },
                  ),
                  SizedBox(height: 15,),
            
                ],
            ),
        ),
      ),
    );
  }
}