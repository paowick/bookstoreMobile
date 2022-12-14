import 'package:bookstore/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/main.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formstate = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController name = TextEditingController();

  final store = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appName, style: TextStyle(color: Colors.white)),
        ),
        body: Form(
          key: _formstate,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        child: Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildnameField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildEmailField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildPasswordField(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildRegisterButton(),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  ElevatedButton buildRegisterButton() {
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
      child: const Text('Sign up'),
      onPressed: () async {
        print('regis new Account');
        if (_formstate.currentState!.validate()) {
          print(email.text);
          print(password.text);
          final _user = await auth.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
          _user.user!.sendEmailVerification();

          Map<String, dynamic> data = {
            'email': auth.currentUser!.email.toString(),
            'uid': auth.currentUser!.uid.toString(),
            'name': name.text.trim(),
            'mybook': [],
            'gender': "",
            'address': "",
            'urlimage': "",
          };
          DocumentReference ref = await store.collection('user').add(data);
          print('save id = ${ref.id}');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              ModalRoute.withName('/'));
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value!.isEmpty)
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

  TextFormField buildnameField() {
    return TextFormField(
      controller: name,
      validator: (value) {
        if (value!.isEmpty)
          return 'Please fill in Username field';
        else
          return null;
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Username',
        icon: Icon(Icons.person),
        hintText: 'Username',
      ),
    );
  }
}
