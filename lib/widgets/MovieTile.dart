import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:udemy_cinema/widgets/Bottom.dart';

class MovieTile extends StatefulWidget {
  final String url;
  final String title;

  const MovieTile({Key key, this.url, this.title}) : super(key: key);

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  String image;

  Future downloadImage() async {
    StorageReference _ref = FirebaseStorage.instance.ref().child(widget.url);
    String downloadedURL = await _ref.getDownloadURL();

    setState(() {
      image = downloadedURL;
    });
  }

  @override
  void initState() {
    downloadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Bottom(
                  url: image,
                  title: widget.title,
                );
              });
        },
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.network(image),
          ),
          width: MediaQuery.of(context).size.width / 4,
        ),
      ),
    );
  }
}
