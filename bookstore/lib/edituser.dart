import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String yourName = '';
  String yourAddress = '';

  final _username = TextEditingController();
  final _address = TextEditingController();

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EditProfile')),
      body: ListView(
        children: [Name(), gender(), address(), save()],
      ),
    );
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
        child: const Text('Save'),
        onPressed: () async {
          Map<String, dynamic> value = {
            'name': yourName,
            'address': yourAddress,
          };
          try {
            await FirebaseFirestore.instance
                .collection('user')
                .doc('$docId')
                .update(value);

            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error $e'),
              ),
            );
          }
        });
  }

  Widget gender() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("uid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              child: snapshot.hasData
                  ? radioMaleFemale(snapshot.data!)
                  : LinearProgressIndicator());
        });
  }

  Widget Name() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("uid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              child: snapshot.hasData
                  ? buildUserName(snapshot.data!)
                  : LinearProgressIndicator());
        });
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

  TextFormField buildUserName(QuerySnapshot data) {
    yourName = data.docs.first['name'].toString();
    final _username = TextEditingController(text: data.docs.first['name']);
    return TextFormField(
      onChanged: (value) {
        yourName = value;
      },
      controller: _username,
      decoration: const InputDecoration(
        labelText: 'Username',
        icon: Icon(Icons.person),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in your name' : null,
    );
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

  Widget radioMaleFemale(QuerySnapshot data) {
    String? docId;
    data.docs.forEach((res) {
      docId = res.id;
    });
    dynamic sex = data.docs.first['gender'].toString();
    return Row(
      children: [
        Radio(
            value: 'male',
            groupValue: sex,
            onChanged: ((value) {
              setState(() {
                sex = value;
                FirebaseFirestore.instance
                    .collection('user')
                    .doc('$docId')
                    .update({'gender': 'male'});
              });
            })),
        const Text('Male'),
        Radio(
            value: 'female',
            groupValue: sex,
            onChanged: ((value) {
              setState(() {
                sex = value;
                FirebaseFirestore.instance
                    .collection('user')
                    .doc('$docId')
                    .update({'gender': 'female'});
              });
            })),
        const Text('Female'),
      ],
    );
  }
}
