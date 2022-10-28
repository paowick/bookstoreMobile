import 'package:bookstore/setting.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/showdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookstore/setting.dart';

int? indextemp = 0;

class BookPage extends StatefulWidget {
  BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(milliseconds: 100),
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Books"),
          actions: <Widget>[search(context)],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.book),
            ),
            Tab(icon: Icon(Icons.store)),
            Tab(icon: Icon(Icons.settings)),
          ]),
        ),
        body: TabBarView(
          children: [Text('Mybook'), snapBook(), settingPage()],
        ),
      ),
    );
  }

  Widget snapBook() {
    return StreamBuilder(
        stream: store.collection('books').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
            child: snapshot.hasData
                ? buildBookList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }

  IconButton search(context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    );
  }

  GridView buildBookList(QuerySnapshot data) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data.docs.elementAt(index);
        return InkWell(
          onTap: () {
            indextemp = index;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetail(model['title']),
                ));
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(model['title']),
          ),
        );
      },
    );
  }
}
