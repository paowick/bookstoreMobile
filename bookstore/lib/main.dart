import 'package:bookstore/addaddress.dart';
import 'package:bookstore/payment.dart';
import 'package:bookstore/searchpage.dart';
import 'package:bookstore/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bookstore/register.dart';
import 'package:bookstore/addbook.dart';
import 'package:bookstore/book.dart';
import 'package:bookstore/resetpass.dart';
import 'package:bookstore/edituser.dart';

final appName = 'Michael Hart project';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => (FirebaseAuth.instance.currentUser == null)
            ? LoginPage()
            : BookPage(),
        '/register': (context) => RegisterPage(),
        '/addbook': (context) => AddBookPage(),
        '/book': (context) => BookPage(),
        '/resetpass': (context) => Resetpass(),
        '/setting': (context) => settingPage(),
        '/edituser': (context) => EditUser(),
        '/searchpage': (context) => SearchPage(),
        '/addaddress':(context) => addAddressPage(),
      },
    );
  }
}
