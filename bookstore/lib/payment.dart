import 'dart:async';

import 'package:bookstore/addaddress.dart';
import 'package:bookstore/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class payMentPage extends StatefulWidget {
  String _idi;

  payMentPage(this._idi, {Key? key}) : super(key: key);

  @override
  State<payMentPage> createState() => _payMentPageState();
}

class _payMentPageState extends State<payMentPage> {
  @override
  Widget build(BuildContext context) {
    String _id = widget._idi;
    return Scaffold(
      appBar: AppBar(
        title: Text('payment', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text(
                  'Name on card',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text(
                  'card number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'MM/YY',
                        label: Text(
                          'Expriry date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'CVE',
                        label: Text(
                          'security code',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [bulidPayBotton(_id)],
            ),
          )
        ],
      ),
    );
  }

  Widget bulidPayBotton(String id) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("books")
            .where("title", isEqualTo: id)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshotbooks) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user")
                .where("uid",
                    isEqualTo:
                        FirebaseAuth.instance.currentUser!.uid.toString())
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshotuser) {
              return snapshotbooks.hasData && snapshotuser.hasData
                  ? paymentButton(
                      snapshotbooks.data!,
                      snapshotuser.data!,
                    )
                  : CircularProgressIndicator();
            }),
          );
        });
  }

  Widget paymentButton(
    QuerySnapshot databook,
    QuerySnapshot datauser,
  ) {
    List<dynamic> list = datauser.docs.first['mybook'];

    if (list.contains(databook.docs.first['title'])) {
      return Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                shadowColor: Colors.greenAccent,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(150, 40),
              ),
              onPressed: (() {
                Navigator.pushReplacementNamed(context, '/addaddress');
              }),
              child: Text('buy a book')),
          SizedBox(width: 50),
          Text('E-book in collection')
        ],
      );
    } else {
      return Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                shadowColor: Colors.greenAccent,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(150, 40),
              ),
              onPressed: (() {
                Navigator.pushReplacementNamed(context, '/addaddress');
              }),
              child: Text('buy a book')),
          SizedBox(width: 50),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                shadowColor: Colors.greenAccent,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(150, 40),
              ),
              onPressed: (() {
                list.add(databook.docs.first['title']);
                update(list, datauser);
              }),
              child: Text('buy a E-Book')),
        ],
      );
    }
  }
}

Future<void> update(dynamic dataString, QuerySnapshot data) async {
  String? docId;
  data.docs.forEach((res) {
    docId = res.id;
  });
  Map<String, dynamic> value = {
    'mybook': dataString,
  };
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc('$docId')
        .update(value);
  } catch (e) {}
}
