import 'package:bookstore/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class addAddressPage extends StatefulWidget {
  const addAddressPage({super.key});

  @override
  State<addAddressPage> createState() => _addAddressPageState();
}

class _addAddressPageState extends State<addAddressPage> {
  String yourAddress = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('fill address'),
        ),
        body: Column(
          children: [address(), save()],
        ));
  }

  Widget address() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("uid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              child: snapshot.hasData
                  ? buildAddress(snapshot.data!)
                  : LinearProgressIndicator());
        });
  }

  TextFormField buildAddress(QuerySnapshot data) {
    yourAddress = data.docs.first['address'].toString();
    final _address = TextEditingController(text: data.docs.first['address']);
    return TextFormField(
        onChanged: (value) {
          yourAddress = value;
        },
        controller: _address,
        decoration: const InputDecoration(
          labelText: 'America, New York City',
          icon: Icon(Icons.home),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Please fill in your address' : null,
        maxLines: 5);
  }

  Widget save() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("uid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              child: snapshot.hasData
                  ? buildSaveButton(snapshot.data!)
                  : LinearProgressIndicator());
        });
  }

  ElevatedButton buildSaveButton(QuerySnapshot data) {
    String? docId;
    data.docs.forEach((res) {
      docId = res.id;
    });
    return ElevatedButton(
        child: const Text('send infomation'),
        onPressed: () async {
          Map<String, dynamic> value = {
            'address': yourAddress,
          };
          try {
            //=============================================notification here=====================

            await FirebaseFirestore.instance
                .collection('user')
                .doc('$docId')
                .update(value);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BookPage()),
                ModalRoute.withName('/'));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error $e'),
              ),
            );
          }
        });
  }
}
