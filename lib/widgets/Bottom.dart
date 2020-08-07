import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:udemy_cinema/widgets/Showing.dart';

class Bottom extends StatefulWidget {
  final String url;
  final String title;

  const Bottom({Key key, this.url, this.title}) : super(key: key);

  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  Firestore _firestore = Firestore.instance;
  String _selectedCinema = "--";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.indigo.withOpacity(0.3),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                maxRadius: MediaQuery.of(context).size.height / 6,
                backgroundImage: NetworkImage(widget.url),
              ),
              Text(
                widget.title,
                style: TextStyle(color: Colors.pink, fontSize: 30),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("cinemas").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cards = snapshot.data.documents;
                      List<DropdownMenuItem> cinemas = [];
                      for (var card in cards) {
                        final title = card.documentID;
                        final cardWidget = DropdownMenuItem(
                          child: Text(title),
                          value: "$title",
                        );
                        cinemas.add(cardWidget);
                      }
                      return DropdownButton(
                        items: cinemas,
                        onChanged: (value) {
                          setState(() {
                            _selectedCinema = value;
                          });
                        },
                        style: TextStyle(color: Colors.pink),
                        hint: Text(
                          _selectedCinema,
                          style: TextStyle(color: Colors.pink),
                        ),
                      );
                    } else {
                      return Container(
                        child: Text('Brak kin'),
                      );
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("showings").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final cards = snapshot.data.documents;
                    List<Showing> showings = [];
                    for (var card in cards) {
                      var formatter = new DateFormat('dd/MM/yyyy hh:mm');
                      final date = formatter
                          .format(card.data['start'].toDate())
                          .toString();
                      final movieT = card.data['movie'].toString();
                      final cinemaT = card.data['cinema'].toString();
                      final id = card.documentID.toString();
                      final cardWidget = Showing(
                        date: date,
                        id: id,
                        city: cinemaT,
                        movie: movieT,
                      );
                      if (movieT == widget.title &&
                          cinemaT == _selectedCinema) {
                        showings.add(cardWidget);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: showings,
                      ),
                    );
                  } else {
                    return Container(
                      child: Text('Brak pokazów'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
