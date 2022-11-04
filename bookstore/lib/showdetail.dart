import 'package:bookstore/addbook.dart';
import 'package:bookstore/book.dart';
import 'package:bookstore/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class BookDetail extends StatefulWidget {
  final String _idi;
  //if you have multiple values add here

  BookDetail(this._idi, {Key? key})
      : super(key: key); //add also..example this.abc,this...

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String _id = widget._idi;

    indextemp = 0;

    return StreamBuilder(
        stream: getBook(_id),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Detail Books",
                  style: TextStyle(color: Colors.white)),
            ),
            body: snapshot.hasData
                ? buildBook(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }

  buildBook(QuerySnapshot data) {
    if (data.docs.isEmpty) {
      return (BookPage() /* .buildBookList(data)*/);
    }
    var model = data.docs.elementAt(indextemp!);

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model['title'],
                style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Poppins-Bold",
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Image.network(
              model['urlimage'],
              fit: BoxFit.cover,
              height: 180,
              width: 120,
            ),
          )
        ],
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(180, 40),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => payMentPage(model['title']),
                      ));
                },
                child: Text('Buy ${model['price'].toString()} Bath')),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Text(
            model['detail'],
            maxLines: 30,
          ),
        ),
      ),

      /*ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addbook");
          },
          child: Text("aadd")),*/
    ]);
  }

  Future<void> deleteValue(String titleName) async {
    await _firestore
        .collection('books')
        .doc(titleName)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getBook(String titleName) {
// Firestore _firestore = Firestore.instance;
    return _firestore
        .collection('books')
        .where('title', isEqualTo: titleName)
        .snapshots();
  }
}
