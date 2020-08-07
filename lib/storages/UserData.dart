import 'package:shared_preferences/shared_preferences.dart';

//Klasa umożliwiająca zapis i odczyt danych z urządzenia użytkownika
class UserData {
  //Klucze utworzony, by nie pomylić się przy wpisywaniu danych za każdym razem ręcznie
  String _email = 'email';
  String _password = 'password';
  String _logged = 'logged';

  //Zapis danych
  saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_email, email);
  }

  savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_password, password);
  }

  saveLogged(bool logged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_logged, logged);
  }

  //Odczyt danych
  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(_email);
    return email;
  }

  Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String password = prefs.getString(_password);
    return password;
  }

  Future<bool> getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logged = prefs.getBool(_logged);
    return logged;
  }
}
