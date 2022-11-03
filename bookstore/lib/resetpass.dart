import 'package:bookstore/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bookstore/main.dart';

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  TextEditingController _email = TextEditingController();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName, style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          children: <Widget>[
            Container(
                height: 200,
                width: 200,
                child: Image.asset("assets/images/lockicon.png")),
            Center(
              child: Container(
                  child: Text(
                'Forgot Your',
                style: TextStyle(fontSize: 40),
              )),
            ),
            Center(
              child: Container(
                  child: Text(
                'password ?',
                style: TextStyle(fontSize: 40),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: emailTextFormField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: sendToEmail(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      controller: _email,
      validator: (value) {
        if (!validateEmail(value!))
          return 'Please fill in E-mail field';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.email),
        hintText: 'Type Your Email',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }

  ElevatedButton sendToEmail(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlue,
          onPrimary: Colors.white,
          shadowColor: Colors.greenAccent,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: Size(250, 40),
        ),
        onPressed: () {
          resetPassword(_email.text);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              ModalRoute.withName('/'));
        },
        child: Text('Send Request'));
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wrong Email")));
      print(e);
    }
  }
}
