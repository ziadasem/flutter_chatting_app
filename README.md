## Flutter Chat App
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chat app built with flutter, SQLite and firebase. This is a project from **flutter course -Pixels’22** projects.

**Application functionalities**

 1. Theme and Application identity can be configured from *config.dart*
 2. Authentication using Firebase authentication service
 3. login using  google accounts
 4. load recent chats and contacts from offline DB -SQLite-
 5. synchronize firebase documents with SQLite tables
 6. send and save messages in firestore
 7. adding new contacts by QR code scanning 
 
**Screenshots**
<br/>
![intro screen](https://drive.google.com/uc?id=1wT5G1ibc0_0FVCaW5y0TFeLheTLLWUgv)
<br/>

![sign up screen](https://drive.google.com/uc?id=1e2Z_MjzLtHLYz-kfGVePFCs65JuV9S-f)
<br/>
![Recent chats](https://drive.google.com/uc?id=15C9GTyk4NgtWIdv5cPTWq9v9G15mlRJX)
<br/>
![messages screen](https://drive.google.com/uc?id=12o_u5aXMBZuEDhxVmUjxQs34WreuqsMW)
<br> <br>

![contacts](https://drive.google.com/uc?id=178KAmv9pUhVIqAc9-2cG9vHq_7p2cmTh)
<br> <br>

![QR scanning](https://drive.google.com/uc?id=1wmNuo_gJVCL4TuTkwOwAiEhaTAaHBAQw)
<br><br>

![profile](https://drive.google.com/uc?id=1gCzXUrZ43g6IIm9S_ntikYs4Va8zYErc)
<br><br>

![share contact](https://drive.google.com/uc?id=1cv1ADXnwu6kz0vhp-FFNI0UDgYDSo9bK)
<br>

**Application Architecture**<br>
&nbsp;&nbsp;**Configuration**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *contains config class which contains static properties of application theme data and identity* 

&nbsp;&nbsp;**Model**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *contains DB functions which are functions that do the SQL command in the back scenes and allow the developers to use it without knowledge of SQL commands* 

&nbsp;&nbsp;**Providers**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *state providers that load and save the data from firestore or database and provide them to different screens of application* 

&nbsp;&nbsp;**Screens**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *screens of the application* 

&nbsp;&nbsp;**utils**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *contain utility functions that can be used in different flutter projects* 

&nbsp;&nbsp;**widgets**<br>

&nbsp;&nbsp; &nbsp;&nbsp; *contain different widgets used inside the application* 

