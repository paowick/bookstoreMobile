import 'package:bookstore/bookshelf.dart';
import 'package:bookstore/main.dart';
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
      animationDuration: Duration(milliseconds: 200),
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PHOENIX DREAM",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[search(context)],
          bottom: const TabBar(unselectedLabelColor: Colors.white, tabs: [
            Tab(
              icon: Icon(Icons.book),
              text: 'MyBooks',
            ),
            Tab(
              icon: Icon(Icons.store),
              text: 'Store',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'setting',
            ),
          ]),
        ),
        body: TabBarView(
          children: [bookShelfPage(), snapBook(), settingPage()],
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
      onPressed: () {
        Navigator.pushNamed(context, '/searchpage');
      },
    );
  }

  GridView buildBookList(QuerySnapshot data) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 250,
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
            child: Column(
              children: [
                Card(
                  color: Colors.lightBlue.shade600,
                  child: Image.network(
                    model['urlimage'],
                    fit: BoxFit.cover,
                    height: 180,
                    width: 120,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model['title'],
                        maxLines: 1, style: TextStyle(fontSize: 20))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${model["price"].toString()} bath",
                        style: TextStyle(fontSize: 10))
                  ],
                )
              ],
            ),
          );
        });
  }
}
