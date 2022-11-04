import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class pdfViewPage extends StatefulWidget {
  dynamic _idi;

  pdfViewPage(this._idi, {Key? key}) : super(key: key);

  @override
  State<pdfViewPage> createState() => _pdfViewPageState();
}

class _pdfViewPageState extends State<pdfViewPage> {
  @override
  Widget build(BuildContext context) {
    dynamic _id = widget._idi;
    return Scaffold(
      appBar: AppBar(
        title: Text(_id['title'],style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: PDF().cachedFromUrl(_id['pdf'].toString()),
      ),
    );
  }
}
