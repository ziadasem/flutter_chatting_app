import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/model/db_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider with ChangeNotifier {
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

  UsersProvider() {
    checkSignIn();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(newVal) => _isSignedIn = newVal;

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(newError) => _hasError = newError;

  String _errorCode;
  String get errorCode => _errorCode;
  set errorCode(newCode) => _errorCode = newCode;

  bool _userExists = false;
  bool get userExists => _userExists;
  set setUserExist(bool value) => _userExists = value;

  String _name;
  String get name => _name;
  set setName(newName) => _name = newName;

  String _uid;
  String get uid => _uid;
  set setUid(newUid) => _uid = newUid;

  String _email;
  String get email => _email;
  set setEmail(newEmail) => _email = newEmail;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  set setImageUrl(newImageUrl) => _imageUrl = newImageUrl;

  String _joiningDate;
  String get joiningDate => _joiningDate;
  set setJoiningDate(newDate) => _joiningDate = newDate;

  List _chats;
  List get chats => _chats;

  List _contacts;
  List get contacts => _contacts;

  void clearUid() {
    _uid = null;
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googlSignIn
        .signIn()
        .catchError((error) => print('error : $error'));
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        FirebaseUser userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoUrl;
        this._uid = userDetails.uid;
        this.isSignedIn = true;
        hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future checkUserExists() async {
    await Firestore.instance
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snap) {
      List values = snap.documents;
      for (int i = 0; i < values.length; i++) {
        if (values[i]['uid'] == _uid) {
          _userExists = true;
          break;
        } else {
          _userExists = false;
        }
      }
      notifyListeners();
    });

    return _userExists;
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        Firestore.instance.collection('users').document(uid);
    await ref.setData({
      'name': _name,
      'email': _email,
      'uid': _uid,
      'img_url': _imageUrl,
      'joining date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'chats': [],
      'contacts': []
    });
  }

  void setCredintialhMail(
      String name, String email, String imageurl, String uid) {
    name = _name;
    email = _email;
    imageurl = _imageUrl;
    uid = _uid;
  }

  Future getJoiningDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd-MM-yyyy').format(now);
    _joiningDate = _date;
    notifyListeners();
  }

  Future saveDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setString('uid', _uid);
    await sharedPreferences.setString('chats', json.encode(_chats));
    await sharedPreferences.setString('contacts', json.encode(_contacts));
  }

  Future getFromSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    this._name = sharedPreferences.getString('name');
    this._email = sharedPreferences.getString('email');
    this._imageUrl = sharedPreferences.getString(
      'image url',
    );
    this._uid = sharedPreferences.getString(
      'uid',
    );
    this._chats = json.decode(sharedPreferences.getString('chats'));
    this._contacts = json.decode(sharedPreferences.getString('contacts'));

    notifyListeners();
    //data need to be refreshed
    if (_name == null ||
        _email == null ||
        _imageUrl == null ||
        _uid == null ||
        _chats == null ||
        _contacts == null) {
      getUserData(_uid);
    }
  }

  Future<Map> getUserData(uid) async {
    var snapp;
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid == null ? sp.getString("uid") : null;
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data['uid'];
      this._name = snap.data['name'];
      this._email = snap.data['email'];
      this._imageUrl = snap.data['img_url'];
      this._joiningDate = snap.data['joining date'];
      this._chats = snap.data['chats'];
      this._contacts = snap.data['contacts'];
      snapp = snap.data;
    });
    saveDataToSP();
    return snapp;
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('sign in', true);
    notifyListeners();
  }

  Future<bool> checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('sign in') ?? false;
    _isSignedIn ? _uid = sp.getString("uid") : null;
    print("Check Signed in is called");
    return sp.getBool('sign in') ?? false;
  }

  Future logout() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await auth.signOut();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    sp.setBool('isFirstTime', false);
    _uid = null;
    clearTable("contacts");
    clearTable("chats");
  }
}
