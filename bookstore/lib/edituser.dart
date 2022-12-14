import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String yourName = '';
  String yourAddress = '';
  File? _avatar;

  String urlimgRam = '';

  final _username = TextEditingController();
  final _address = TextEditingController();

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('EditProfile', style: TextStyle(color: Colors.white))),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: imageUser(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Name(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: gender(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: address(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: save(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageUser() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where("uid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              child: snapshot.hasData
                  ? buildimageUser(snapshot.data!)
                  : LinearProgressIndicator());
        });
  }

  Widget buildimageUser(QuerySnapshot data) {
    String urlRam = data.docs.first['urlimage'].toString();
    urlimgRam = urlRam;
    return Container(
      child: urlRam == ''
          ? CircleAvatar(
              maxRadius: 80,
              backgroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/bookstore-56a05.appspot.com/o/userimage%2Fdefalutuser(no%20delete).jpg?alt=media&token=c047db4f-ca54-4a3c-b275-f607534e0d70"),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 50,
                  ),
                  InkWell(
                    onTap: () => onChooseImage(data),
                    child: Icon(Icons.camera),
                  ),
                  InkWell(
                    onTap: () => onChooseImageGallery(data),
                    child: Icon(Icons.folder),
                  )
                ]),
              ]),
            )
          : CircleAvatar(
              maxRadius: 80,
              backgroundImage: NetworkImage("$urlRam"),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                  children: [
                    SizedBox(
                      width: 275,
                      height: 50,
                    ),
                    InkWell(
                      onTap: () => onChooseImageGallery(data),
                      child: Icon(Icons.folder),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 135,
                  ),
                  InkWell(
                    onTap: () => onChooseImage(data),
                    child: Icon(Icons.camera),
                  ),
                ]),
              ]),
            ),
    );
  }

  void onChooseImageGallery(QuerySnapshot data) async {
    FirebaseStorage firebaseStorage = await FirebaseStorage.instance;
    final urlRef = await data.docs.first["urlimage"];
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _avatar = File(pickedFile.path);
        uploadPicture(data);
      } else {
        urlimgRam = urlRef;
        updateimg(data);
      }
    });
  }

  void onChooseImage(QuerySnapshot data) async {
    FirebaseStorage firebaseStorage = await FirebaseStorage.instance;
    final urlRef = await data.docs.first["urlimage"];
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _avatar = File(pickedFile.path);
        uploadPicture(data);
      } else {
        urlimgRam = urlRef;
        updateimg(data);
      }
    });
  }

  Future<void> updateimg(QuerySnapshot data) async {
    String? docId;
    data.docs.forEach((res) {
      docId = res.id;
    });
    Map<String, dynamic> value = {
      'urlimage': urlimgRam,
    };
    await FirebaseFirestore.instance
        .collection('user')
        .doc('$docId')
        .update(value);
  }

  Future<void> uploadPicture(QuerySnapshot data) async {
    Random random = Random();
    int i = random.nextInt(10000000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference storageReference =
        firebaseStorage.ref().child('/userimage/img$i.jpg');
    UploadTask uploadTask = storageReference.putFile(_avatar!);

    final _urlimg = await (await uploadTask).ref.getDownloadURL();
    urlimgRam = _urlimg;
    updateimg(data);
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
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlue,
          onPrimary: Colors.white,
          shadowColor: Colors.greenAccent,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: Size(180, 40),
        ),
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
