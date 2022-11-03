import 'package:bookstore/book.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class addAddressPage extends StatefulWidget {
  const addAddressPage({super.key});

  @override
  State<addAddressPage> createState() => _addAddressPageState();
}

class _addAddressPageState extends State<addAddressPage> {
  String name = FirebaseAuth.instance.currentUser!.displayName.toString();
  int _counter = 0;
  String? message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  String yourAddress = '';

  initState() {
    message = "No message.";
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notiicon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      print("onDidReceiveLocalNotification called.");
    });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
// when user tap on notification.

      print("onSelectNotification called.");

      setState(() {
        message = payload.payload;
      });
    });

    super.initState();
  }

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

  sendNotification() async {
    const BigPictureStyleInformation bigPictureStyleInformation =
        const BigPictureStyleInformation(
            DrawableResourceAndroidBitmap('notiicon'),
            largeIcon: const DrawableResourceAndroidBitmap('flutter'),
            contentTitle: 'สวัสดีคุณลูกค้า ',
            summaryText: 'เราจะส่งหนังสึอไห้คุณ ในเร็วๆนี่');

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '10000',
      'FLUTTER_NOTIFICATION_CHANNEL',
      channelDescription: 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, 'เเจ้งเตือนการส่งสิ่นค้า', '', platformChannelSpecifics,
        payload: '');
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
            sendNotification();
            await FirebaseFirestore.instance
                .collection('user')
                .doc('$docId')
                .update(value);
            Navigator.pop(context, '/book');
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
