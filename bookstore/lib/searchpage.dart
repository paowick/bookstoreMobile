import 'package:bookstore/showdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int? indextemp = 0;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String ram = '';
  final store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (ram.isEmpty) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            indextemp = index;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetail(data['title']),
                                ));
                          },
                          title: Text(data['title']),
                        ),
                      );
                    }
                    if (data['title'].toString().startsWith(ram)) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            indextemp = index;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetail(data['title']),
                                ));
                          },
                          title: Text(data['title']),
                        ),
                      );
                    }
                    return Container();
                  });
        },
      ),
    );
  }

  Widget searchBar() {
    return TextFormField(
      onChanged: (s) {
        setState(() {
          ram = s;
        });
      },
      decoration: InputDecoration(
        labelText: 'book name',
        hintText: 'flutter',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
