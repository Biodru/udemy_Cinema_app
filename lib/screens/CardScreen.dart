import 'package:flutter/material.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_cinema/widgets/Ticket.dart';

class CardScreen extends StatefulWidget {
  static final id = 'CardScreen';

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  UserData _userData = UserData();
  Firestore _firestore = Firestore.instance;

  String _email = '';

  void updateEmail(String email) {
    setState(() {
      this._email = email;
    });
  }

  @override
  void initState() {
    _userData.getEmail().then(updateEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.indigo,
              child: Center(
                child: Text(
                  "Bilety",
                  style: TextStyle(color: Colors.pink, fontSize: 25),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              //Zapytania są opisane w HomeScreen
              stream: _firestore
                  .collection('userData')
                  .document(_email)
                  .collection('tickets')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cards = snapshot.data.documents;
                  List<Ticket> cardWidgets = [];
                  for (var card in cards) {
                    final movie = card.data['movie'];
                    final date = card.data['date'];
                    final row = card.data['row'];
                    final place = card.data['seat'];
                    final cinema = card.data['cinema'];
                    final room = card.data['room'];

                    final cardWidget = Ticket(
                      movie: movie,
                      date: date,
                      row: row,
                      room: room,
                      place: place,
                      cinema: cinema,
                    );
                    cardWidgets.add(cardWidget);
                  }
                  return Column(
                    children: cardWidgets,
                  );
                }
                return Container(
                  child: Text('Brak biletów'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
