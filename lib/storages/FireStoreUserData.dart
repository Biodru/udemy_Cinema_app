import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Klasa ułatwiająca zdobywanie konkretnych danych o użytkowniku z bazy
class FirestoreUserData {
  FirebaseUser _firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  Future<String> getUserName() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .document(_firebaseUser.email)
            .get();
        return userData.data['name'].toString();
      }
    } catch (e) {
      print(e);
      return "Generyczne Imię";
    }
  }

  Future<String> getUserSurName() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .document(_firebaseUser.email)
            .get();
        return userData.data['surname'].toString();
      }
    } catch (e) {
      print(e);
      return "Generyczne Nazwisko";
    }
  }

  Future<bool> getUserCard() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _firebaseUser = user;
        final userData = await _firestore
            .collection('userData')
            .document(_firebaseUser.email)
            .get();
        return userData.data['card'];
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
