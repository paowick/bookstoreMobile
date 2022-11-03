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

  //asdw

  Widget buildUser(QuerySnapshot data) {
    String urlRam = data.docs.first['urlimage'].toString();
    if (urlRam == "") {
      urlRam =
          "https://firebasestorage.googleapis.com/v0/b/bookstore-56a05.appspot.com/o/userimage%2Fdefalutuser(no%20delete).jpg?alt=media&token=c047db4f-ca54-4a3c-b275-f607534e0d70";
    }
    return Column(
      children: data.docs.map((document) {
        return Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    maxRadius: 80, backgroundImage: NetworkImage("$urlRam")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  document["name"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  document["email"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: editButton(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: signOutButton(context),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  ElevatedButton editButton(context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlue,
          onPrimary: Colors.white,
          shadowColor: Colors.greenAccent,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: Size(180, 40),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/edituser');
        },
        child: Text('Edit'));
  }

  ElevatedButton signOutButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        minimumSize: Size(180, 40),
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, '/');
      },
      child: Text('signOut'),
    );
  }
}
