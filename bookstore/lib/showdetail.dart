import 'dart:io';

import 'package:bookstore/book.dart';
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
      return (BookPage().buildBookList(data));
    }
    var model = data.docs.elementAt(indextemp!);

    
    return Center(
      child: Column(
        children: [
          Text(model['title']),
          Text(model['detail']),
          Text('prise : ' + model['price'].toString() + '  Bath'),
        ],
      ),
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
