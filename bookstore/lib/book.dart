import 'package:flutter/material.dart';
import 'package:bookstore/showdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int? indextemp = 0;

class BookPage extends StatelessWidget {
  BookPage({Key? key}) : super(key: key);

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
          actions: <Widget>[signOutButton(context)],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.book),
            ),
            Tab(icon: Icon(Icons.store)),
            Tab(icon: Icon(Icons.settings)),
          ]),
        ),
        body: TabBarView(
          children: [Text('Mybook'), snapBook(), Text('Settings')],
        ),
      ),
    );
  }
//
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

  IconButton signOutButton(context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, '/');
      },
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
