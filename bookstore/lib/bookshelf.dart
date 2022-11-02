import 'dart:convert';

import 'package:bookstore/payment.dart';
import 'package:bookstore/pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class bookShelfPage extends StatefulWidget {
  const bookShelfPage({super.key});

  @override
  State<bookShelfPage> createState() => _bookShelfPageState();
}

class _bookShelfPageState extends State<bookShelfPage> {
  List<dynamic> modellist = [];
  final store = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: bulidMyBook(),
    );
  }

  Widget bulidMyBook() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("books").snapshots(),
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
                  ? buildBookList(
                      snapshotbooks.data!,
                      snapshotuser.data!,
                    )
                  : CircularProgressIndicator();
            }),
          );
        });
  }

  void updateList(QuerySnapshot databook, QuerySnapshot datauser) async {
    modellist.clear();
    List<dynamic> list = datauser.docs.first['mybook'];
    for (int i = 0; i < databook.size; i++) {
      var model = databook.docs.elementAt(i);
      if (list.contains(model['title']))
        await {modellist.add(databook.docs.elementAt(i))};
    }
  }

  GridView buildBookList(QuerySnapshot databook, QuerySnapshot datauser) {
    if (modellist.isEmpty) {
      updateList(databook, datauser);
    }
    print(modellist);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 140,
            maxCrossAxisExtent: 100,
            childAspectRatio: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: modellist.length,
        itemBuilder: (BuildContext context, int index) {
          var model = modellist.elementAt(index);
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        pdfViewPage(modellist.elementAt(index)),
                  ));
            },
            child: Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          model['urlimage'],
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(model['title'])],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
