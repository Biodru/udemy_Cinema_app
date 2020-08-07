import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:udemy_cinema/storages/FireStoreUserData.dart';
import 'package:udemy_cinema/login/LogRegScreen.dart';

class SettingsScreen extends StatefulWidget {
  static final id = 'SettingsScreen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //Instancje używanych klas
  Firestore _firestore = Firestore.instance;
  FirestoreUserData _firestoreUserData = FirestoreUserData();
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserData _userData = UserData();

  //Zmienne
  String _name = "";
  String _surname = "";
  String _email;
  bool _card;

  TextEditingController _textEditingController = TextEditingController();

  //Alerty do zmiany danych
  _displayNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Zmień dane"),
            content: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: _name),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Zmień'),
                onPressed: () {
                  setState(() {
                    //Odczytanie danych z pola tekstowego
                    _name = _textEditingController.text;
                    //Aktualizacja danych w FireBase
                    _firestore
                        .collection('userData')
                        .document(_email)
                        .updateData({'name': _name});
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child: Text('Anuluj'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displaySurNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Zmień dane"),
            content: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: _surname),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Zmień'),
                onPressed: () {
                  setState(() {
                    _surname = _textEditingController.text;
                    _firestore
                        .collection('userData')
                        .document(_email)
                        .updateData({'surname': _surname});
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child: Text('Anuluj'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayCardDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Zmień dane"),
            content: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _card = true;
                          _firestore
                              .collection('userData')
                              .document(_email)
                              .updateData({'card': _card});
                        });
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.local_play,
                        color: _card ? Colors.indigo : Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _card = false;
                          _firestore
                              .collection('userData')
                              .document(_email)
                              .updateData({'card': _card});
                        });
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: _card == false ? Colors.indigo : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Anuluj'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //Funkcja zwracająca widget w zależności od warości pola card
  Widget content() {
    if (_card == null) {
      Text('Ładowanie');
    } else if (_card == true) {
      return Icon(
        Icons.local_play,
        color: Colors.indigo,
      );
    } else {
      return Icon(
        Icons.close,
        color: Colors.indigo,
      );
    }
  }

//Funkcje aktualizujące dane
  void updateEmail(String email) {
    setState(() {
      this._email = email;
    });
  }

  void updateName(String name) {
    setState(() {
      this._name = name;
    });
  }

  void updateSurName(String surName) {
    setState(() {
      this._surname = surName;
    });
  }

  void updateCard(bool card) {
    setState(() {
      this._card = card;
    });
  }

  void fireBaseUserData(bool logged) {
    if (logged == true) {
      _firestoreUserData.getUserName().then(updateName);
      _firestoreUserData.getUserSurName().then(updateSurName);
      _firestoreUserData.getUserCard().then(updateCard);
      _userData.getEmail().then(updateEmail);
    }
  }

  @override
  void initState() {
    _userData.getLogged().then(fireBaseUserData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.pink,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Imię",
                      style: TextStyle(color: Colors.indigo, fontSize: 20),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          _displayNameDialog(context);
                        },
                        child: Text(
                          _name,
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Nazwisko",
                      style: TextStyle(color: Colors.indigo, fontSize: 20),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          _displaySurNameDialog(context);
                        },
                        child: Text(
                          _surname,
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Uprawnienia",
                      style: TextStyle(color: Colors.indigo, fontSize: 20),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          _displayCardDialog(context);
                        },
                        child: content(),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.red,
                child: Text('Wyloguj'),
                onPressed: () {
                  //Wylogowanie użytkownika z Firbase
                  _auth.signOut();
                  _userData.saveLogged(false);
                  Navigator.pushNamed(context, LogRegScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
