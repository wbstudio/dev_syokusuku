import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class RegisterUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('会員登録')),
            body: Center(
                child: RegisterUserLogic()
            )
        )
    );
  }
}

class RegisterUserLogic extends StatefulWidget {
  RegisterUserLogicState createState() => RegisterUserLogicState();
}

class RegisterUserLogicState extends State {
  bool visible = false ;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future userRegistration() async{

    setState(() {
      visible = true ;
    });

    // Getting value from Controller
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // SERVER API URL
    //
    Uri uri = Uri.parse('http://10.0.2.2/php_syokusuku/index.php');

    // Store all data with Param Name.
    var data = {'name': name, 'email': email, 'password' : password};

    // Starting Web API Call.
    var response = await http.post(uri, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if(response.statusCode == 200){
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON Message.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[

                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('会員情報登録フォーム',
                          style: TextStyle(fontSize: 21))),

                  Divider(),

                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: nameController,
                        autocorrect: true,
                        decoration: InputDecoration(hintText: 'お名前を書いてください。'),
                      )
                  ),

                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: emailController,
                        autocorrect: true,
                        decoration: InputDecoration(hintText: 'Emailアドレスを書いてください。'),
                      )
                  ),

                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: passwordController,
                        autocorrect: true,
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'パスワードを書いてください。'),
                      )
                  ),

                  RaisedButton(
                    onPressed: userRegistration,
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text('全部書いたら押してください。'),
                  ),

                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator()
                      )
                  ),

                ],
              ),
            )));
  }
}