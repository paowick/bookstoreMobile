import 'dart:async';

import 'package:bookstore/addaddress.dart';
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
        title: Text('payment'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/bookstore-56a05.appspot.com/o/bookimage%2FTotally_not_a_Rickroll_QR_code.png?alt=media&token=e7152467-5783-4ee4-8cf0-316b31183b69')),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [detailStream(_id)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [bulidPayBotton(_id)],
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
              onPressed: (() {
                Navigator.pushNamed(context, '/addaddress');
              }),
              child: Text('book')),
          SizedBox(width: 50),
          Text('Ebook in collection')
        ],
      );
    } else {
      return Row(
        children: [
          ElevatedButton(
              onPressed: (() {
                Navigator.pushNamed(context, '/addaddress');
              }),
              child: Text('book')),
          SizedBox(width: 50),
          ElevatedButton(
              onPressed: (() {
                list.add(databook.docs.first['title']);
                update(list, datauser);
                Navigator.maybePop(context, (route) => '/book');
              }),
              child: Text('EBook')),
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

Widget detailStream(String id) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("books")
        .where("title", isEqualTo: id)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return Container(
        child: snapshot.hasData
            ? detail(snapshot.data!)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    },
  );
}

Widget detail(QuerySnapshot data) {
  return Column(
    children: data.docs.map((document) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(document["title"]), Text(document['detail'])],
        ),
      );
    }).toList(),
  );
}
