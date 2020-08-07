import 'package:flutter/material.dart';
import 'LogInScreen.dart';
import 'RegisterScreen.dart';

class LogRegScreen extends StatelessWidget {
  static const String id = 'log_reg_screen';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Masz już konto?",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, LogInScreen.id);
                },
                child: Text(
                  "Zaloguj",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "lub",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
                child: Text(
                  "Zarejestruj",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
