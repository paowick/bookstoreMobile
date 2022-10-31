import 'package:bookstore/edituser.dart';
import 'package:bookstore/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/setting.dart';
import 'package:bookstore/edituser.dart';

class settingPage extends StatefulWidget {
  settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  String temp = FirebaseAuth.instance.currentUser!.uid.toString();

  final store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [snapUser()],
      ),
    );
  }

  Widget snapUser() {
    return StreamBuilder(
      stream:
          store.collection('user').where("uid", isEqualTo: temp).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container(
          child: snapshot.hasData
              ? buildUser(snapshot.data!)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  Widget buildUser(QuerySnapshot data) {
    return Column(
      children: data.docs.map((document) {
        return Container(
          child: Column(
            children: [
              Text(document["name"]),
              Text(document["email"]),
              editButton(context),
              signOutButton(context)
            ],
          ),
        );
      }).toList(),
    );
  }

  ElevatedButton editButton(context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/edituser');
        },
        child: Text('Edit'));
  }

  ElevatedButton signOutButton(context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, '/');
      },
      child: Text('signOut'),
    );
  }
}
