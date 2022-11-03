import 'package:bookstore/main.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();

  String? email;

  String? password;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formstate,
        child: ListView(
          children: <Widget>[
            Image.asset("assets/images/logo.png"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: emailTextFormField(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: passwordTextFormField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginButton(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                registerButton(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                forgotpassword(context),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  ElevatedButton forgotpassword(BuildContext context) {
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
        child: Center(
            child: Text(
          'Reset password',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins-Bold",
              fontSize: 13,
              letterSpacing: 1.0),
        )),
        onPressed: () {
          Navigator.pushNamed(context, '/resetpass');
        });
  }

  ElevatedButton registerButton(BuildContext context) {
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
        child: Center(
            child: Text(
          'Sign up',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins-Bold",
              fontSize: 13,
              letterSpacing: 1.0),
        )),
        onPressed: () {
          print('Goto Regis pagge');

          Navigator.pushNamed(context, '/register');
        });
  }

  ElevatedButton loginButton() {
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
        child: Center(
            child: Text(
          'Login',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins-Bold",
              fontSize: 20,
              letterSpacing: 1.0),
        )),
        onPressed: () async {
          if (_formstate.currentState!.validate()) {
            print('Valid Form');

            _formstate.currentState!.save();

            try {
              await auth
                  .signInWithEmailAndPassword(
                      email: email!, password: password!)
                  .then((value) {
                if (value.user!.emailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Pass")));
                  Navigator.pushReplacementNamed(context, '/book');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please verify email")));
                }
              }).catchError((reason) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login or Password Invalid")));
              });
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          } else
            print('Invalid Form');
        });
  }

  bool passhid = true;

  TextFormField passwordTextFormField() {
    return TextFormField(
        onSaved: (value) {
          password = value!.trim();
        },
        validator: (value) {
          if (value!.length < 8)
            return 'Please Enter more than 8 Character';
          else
            return null;
        },
        obscureText: passhid,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          labelText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          suffixIcon: InkWell(
            child: Icon(
                passhid ? Icons.visibility : Icons.visibility_off_outlined),
            onTap: () {
              setState(() {
                passhid = !passhid;
              });
            },
          ),
        ));
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      onSaved: (value) {
        email = value!.trim();
      },
      validator: (value) {
        if (!validateEmail(value!))
          return 'Please fill in E-mail field';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        labelText: 'E-mail',
        icon: Icon(
          Icons.email,
          color: Colors.black,
        ),
        hintText: 'Type Your Email',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }
}
