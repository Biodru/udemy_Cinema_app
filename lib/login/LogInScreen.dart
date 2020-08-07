import 'package:flutter/material.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_cinema/screens/supporting/Navigation.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'LogInScreen';
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  UserData _userData = UserData();
  final _auth = FirebaseAuth.instance;

  bool card = false;
  String _email;
  String _password;

  bool _allow = false;

  void checkAllow() {
    if ((_email != null) && (_password != null)) {
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
                                setState(() {
                                  _email = input;
                                  checkAllow();
                                });
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
                      _allow
                          ? RaisedButton(
                              onPressed: () async {
                                try {
                                  _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);
                                  _userData.saveEmail(_email);
                                  _userData.savePassword(_password);
                                  _userData.saveLogged(true);
                                  Navigator.pushNamed(context, Navigation.id);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Zaloguj'),
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
