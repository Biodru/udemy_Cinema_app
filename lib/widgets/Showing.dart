import 'package:flutter/material.dart';
import 'package:udemy_cinema/storages/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Showing extends StatefulWidget {
  final String date;
  final String movie;
  final String city;
  final String id;

  const Showing({Key key, this.date, this.movie, this.city, this.id})
      : super(key: key);

  @override
  _ShowingState createState() => _ShowingState();
}

class _ShowingState extends State<Showing> {
  Firestore _firestore = Firestore.instance;
  UserData _userData = UserData();

  String _selectedRow = "--";
  String _selectedPlace = "--";
  String _email;

  bool _allow = false;

  void checkAllow() {
    if (_selectedPlace != '--' && _selectedRow != '--') {
      setState(() {
        _allow = true;
      });
    }
  }

  void updateEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  @override
  void initState() {
    _userData.getEmail().then(updateEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            //Alert mogący używać setState
            context: context,
            builder: (_) => StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Kupujesz bilet?'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Film: ${this.widget.movie}\nData: ${this.widget.date}\nKino: ${this.widget.city}\nRząd: $_selectedRow Miejsce: $_selectedPlace",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                //Zapytanie do bazy
                                stream: _firestore
                                    .collection("showings")
                                    .document(this.widget.id)
                                    .collection("seats")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  //Sprawdzamy czy otrzymaliśmy odpowiedź
                                  if (snapshot.hasData) {
                                    //Przypisuję otrzymane dokumenty do stałej
                                    final cards = snapshot.data.documents;
                                    //Lista widgetów, które mają być pokazane
                                    List<DropdownMenuItem> seats = [];
                                    //Pętla tworząca widget dla każdego otrzymanego dokumentu
                                    for (var card in cards) {
                                      final title = card.documentID.toString();
                                      final cardWidget = DropdownMenuItem(
                                        child: Text(title),
                                        value: "$title",
                                      );
                                      //Dodanie stworzonego widgetu do listy widgetów
                                      seats.add(cardWidget);
                                    }
                                    return DropdownButton(
                                      style: TextStyle(color: Colors.indigo),
                                      items: seats,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRow = value;
                                        });
                                        checkAllow();
                                      },
                                      hint: Text(
                                        _selectedRow,
                                        style: TextStyle(color: Colors.indigo),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Text('Brak miejsc'),
                                    );
                                  }
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection("showings")
                                    .document(this.widget.id)
                                    .collection("seats")
                                    .document(_selectedRow)
                                    .collection("place")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final cards = snapshot.data.documents;
                                    List<DropdownMenuItem> seats = [];
                                    for (var card in cards) {
                                      final title = card.documentID.toString();
                                      final available = card.data["available"];
                                      final cardWidget = DropdownMenuItem(
                                        child: Text(title),
                                        value: "$title",
                                      );
                                      seats.add(cardWidget);
                                    }
                                    return DropdownButton(
                                      style: TextStyle(color: Colors.indigo),
                                      items: seats,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPlace = value;
                                        });
                                        checkAllow();
                                      },
                                      hint: Text(
                                        _selectedPlace,
                                        style: TextStyle(color: Colors.indigo),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      child: Text('Brak miejsc'),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        color: _allow ? Colors.pink : Colors.grey,
                        onPressed: () {
                          if (_allow) {
                            //Zastąpienie / przez '', gdyż / może powodować problemy
                            String data =
                                widget.date.replaceAll('/', '').trim();
                            //zapisywanie danych
                            _firestore
                                .collection("userData")
                                .document(_email)
                                .collection("tickets")
                                .document(data.replaceAll(" ", ""))
                                .setData({
                              'date': widget.date,
                              'movie': widget.movie,
                              'cinema': widget.city,
                              'row': _selectedRow,
                              'seat': _selectedPlace
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Tak!',
                          style: TextStyle(
                              //Operator tenarny. Warunek ? Jeśli prawda : Jeśli fałsz
                              color: _allow ? Colors.indigo : Colors.black),
                        ),
                      ),
                      FlatButton(
                        color: Colors.pink,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Anuluj',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                    ],
                  );
                }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Container(
          child: Text(
            widget.date,
            style: TextStyle(color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
