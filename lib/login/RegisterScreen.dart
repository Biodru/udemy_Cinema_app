import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:udemy_cinema/screens/supporting/Navigation.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserData _userData = UserData();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  bool card = false;
  String _email;
  String _password;
  String _name;
  String _surName;

  bool _allow = false;

  void checkAllow() {
    if ((_email != null) &&
        (_password != null) &&
        (_name != null) &&
        (_surName != null)) {
      setState(() {
        _allow = true;
      });
    } else {
      setState(() {
        _allow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Email',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 25),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              onChanged: (input) {
                                _email = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Hasło',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 25),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              obscureText: true,
                              onChanged: (input) {
                                _password = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Imię',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 25),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              onChanged: (input) {
                                _name = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Nazwisko',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 25),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              onChanged: (input) {
                                _surName = input;
                                checkAllow();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Specjalne uprawnienia',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 25),
                          ),
                          Container(
                            width: 100,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  card = !card;
                                });
                              },
                              child: card
                                  ? Icon(
                                      Icons.local_play,
                                      color: Colors.indigo,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: Colors.indigo,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      _allow
                          ? RaisedButton(
                              onPressed: () async {
                                _userData.saveLogged(true);
                                try {
                                  final newUser = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: _email, password: _password);
                                  _firestore
                                      .collection('userData')
                                      .document(_email)
                                      .setData({
                                    'name': _name,
                                    'surname': _surName,
                                    'card': card
                                  });
                                  if (newUser != null) {
                                    _userData.saveEmail(_email);
                                    _userData.savePassword(_password);

                                    Navigator.pushNamed(context, Navigation.id);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Zarejestruj'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
