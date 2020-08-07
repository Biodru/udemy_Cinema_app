import 'package:flutter/material.dart';
import 'screens/supporting/Navigation.dart';
import 'screens/HomeScreen.dart';
import 'screens/CardScreen.dart';
import 'screens/SettingsScreen.dart';
import 'login/LogRegScreen.dart';
import 'login/LogInScreen.dart';
import 'login/RegisterScreen.dart';
import 'package:udemy_cinema/storages/UserData.dart';

UserData _userData = UserData();
Widget _defaultHome = LogRegScreen();

void main() async {
  //Sprawdzamy czy user jest zalogowany. Jeśli tak, to idzie do ekranu głównego
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await _userData.getLogged();
  if (_result) {
    _defaultHome = Navigation();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _defaultHome,
      routes: {
        Navigation.id: (context) => Navigation(),
        HomeScreen.id: (context) => HomeScreen(),
        CardScreen.id: (context) => CardScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        LogRegScreen.id: (context) => LogRegScreen(),
        LogInScreen.id: (context) => LogInScreen(),
        RegisterScreen.id: (context) => RegisterScreen()
      },
    );
  }
}
