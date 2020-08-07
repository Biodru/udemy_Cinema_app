import 'package:flutter/material.dart';
import 'package:udemy_cinema/screens/HomeScreen.dart';
import 'package:udemy_cinema/screens/CardScreen.dart';
import 'package:udemy_cinema/screens/SettingsScreen.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigation extends StatefulWidget {
  static final id = 'Navigation';

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  //Lista ekranów i index, pokazujący, który ekran jest obecnie wybrany
  int _selectedIndex = 1;
  List<Widget> pages = [CardScreen(), HomeScreen(), SettingsScreen()];

  //Instancje klas
  UserData _userData = UserData();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';

  //Funkcje aktualizujące dane

  void updateEmail(String email) {
    setState(() {
      this._email = email;
    });
  }

  void updatePassword(String password) {
    setState(() {
      this._password = password;
    });
  }

  //Funkcja próbująca zalogować użytkownika z zapisanymi danymi
  void tryLogIn(String email, String password) async {
    if (email != '' && password != '') {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print('Zalogowano');
      } catch (e) {
        print(e);
      }
    }
  }

  //initState odpala się przy pojawieniu się danego widgetu
  @override
  void initState() {
    _userData.getEmail().then(updateEmail);
    _userData.getPassword().then(updatePassword);
    tryLogIn(_email, _password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('KINO!!!'),
      ),
      //ciało zmienia się w zaleźności od wybranego widgetu
      body: pages[_selectedIndex],
      //Personalizacja panelu nawigacyjnego
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pink,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Przyciski do przełączania stron
              FlatButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Icon(
                  Icons.local_play,
                  //Operator tenarny Warunek ? Jeśli prawda : Jeśli fałsz
                  size: _selectedIndex == 0 ? 35 : 25,
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey,
                ),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: _selectedIndex == 1 ? 35 : 25,
                  color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                ),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Icon(
                  Icons.settings,
                  size: _selectedIndex == 2 ? 35 : 25,
                  color: _selectedIndex == 2 ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
