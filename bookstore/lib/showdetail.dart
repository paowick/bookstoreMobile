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
              title: const Text("Detail Books"),
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

    return Center(
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Image.network(
                model['urlimage'],
                height: 200,
                width: 500,
                fit: BoxFit.fitHeight,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model['title']),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model['detail']),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('prise : ' + model['price'].toString() + '  Bath'),
          ],
        ),
        /* ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/addbook");
              },
              child: Text("aadd"))  */

        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => payMentPage(model['title']),
                  ));
            },
            child: Text('Buy'))
      ]),
    );
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
