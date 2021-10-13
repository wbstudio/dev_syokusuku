import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  String email = "";
  String? id;
  String? name;
  String? ticket;


  Future getUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Uri uri = Uri.parse('http://10.0.2.2/php_syokusuku/dashboard_home.php');
    setState(() {
      email = preferences.getString('email')!;
    });
    var data = {'email': email};
    var response = await http.post(uri, body: json.encode(data));
    var userData = jsonDecode(response.body);
    setState(() {
      id = userData[0]["id"];
      name = userData[0]["name"];
      ticket = userData[0]["ticket"];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: email == '' ? Text('a') : Text(email)),
        Text("$id $name $ticket $email"),
      ],
    );
  }
}
