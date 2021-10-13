import 'package:flutter/material.dart';
import 'HomeWidget.dart';
import 'QrCodeWidget.dart';


//Homepageページ呼び出し
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
}

//QRcodeページ呼び出し
class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return QrCodeWidget();
  }
}


