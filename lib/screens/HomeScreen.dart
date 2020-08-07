import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_cinema/widgets/MovieTile.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.indigo),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Repertuar'),
            ),
            StreamBuilder<QuerySnapshot>(
              //Zapytanie do bazy. Zrzut kolekcji z filmami
              stream: _firestore.collection("movies").snapshots(),
              builder: (context, snapshot) {
                //Sprawdzenie czy w odpowiedzi na zapytanie dostaliśmy dane
                if (snapshot.hasData) {
                  //Przypisanie dokumentów do stałej
                  final cards = snapshot.data.documents;
                  //Pusta liczba widgetów, które będą wyświetlone. Wywołanie listy to: List<Typ> nazwa = [];
                  List<MovieTile> cardWidgets = [];

                  //pętla wyodrębniająca dane z każdego otrzymanego dokumentu
                  for (var card in cards) {
                    final name = card.data["name"].toString();
                    final url = card.data["image"].toString();
                    var now = DateTime.now();
                    final date = card.data['date'].toDate();
                    final diff = now.difference(date).inSeconds;
                    //Sprawdzenie czy film miał swoją premierę
                    if (diff > 0) {
                      //Utworzenie widgetu
                      final cardWidget = MovieTile(
                        title: name,
                        url: url,
                      );
                      //Dodanie widgetu
                      cardWidgets.add(cardWidget);
                    }
                  }
                  //ListView potrzebuje określonego rozmiaru, więc zastosowałem widget Expanded, który da jej całe wolne miejsce
                  return Expanded(
                    flex: 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: cardWidgets,
                    ),
                  );
                }
                //Jeśli nie otrzymamy danych z bazy to zwrócony zostanie napis Brak filmów
                return Container(
                  child: Text("Brak filmów"),
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Zobacz już wkrótce'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("movies").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cards = snapshot.data.documents;
                  List<MovieTile> cardWidgets = [];

                  for (var card in cards) {
                    final name = card.data["name"].toString();
                    final url = card.data["image"].toString();
                    var now = DateTime.now();
                    final date = card.data['date'].toDate();
                    final diff = now.difference(date).inSeconds;
                    if (diff < 0) {
                      final cardWidget = MovieTile(
                        title: name,
                        url: url,
                      );
                      cardWidgets.add(cardWidget);
                    }
                  }
                  return Expanded(
                    flex: 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: cardWidgets,
                    ),
                  );
                }
                return Container(
                  child: Text("Brak filmów"),
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Zobacz przedpremierowo!'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("movies").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cards = snapshot.data.documents;
                  List<MovieTile> cardWidgets = [];
                  for (var card in cards) {
                    final name = card.data["name"].toString();
                    final url = card.data["image"].toString();
                    var now = DateTime.now();
                    final date = card.data['date'].toDate();
                    final early = card.data['early'];
                    final diff = now.difference(date).inSeconds;
                    if (diff < 0 && early) {
                      final cardWidget = MovieTile(
                        title: name,
                        url: url,
                      );
                      cardWidgets.add(cardWidget);
                    }
                  }
                  return Expanded(
                    flex: 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: cardWidgets,
                    ),
                  );
                }
                return Container(
                  child: Text("Brak filmów"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
