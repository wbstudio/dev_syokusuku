import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Dashboard.dart';
import 'RegistUser.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  runApp(MaterialApp(home: email == null ? Login() : Dashboard(),));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future checkLogin()async{
    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    Uri uri = Uri.parse('http://10.0.2.2/php_syokusuku/login.php');

    // Store all data with Param Name.
    var data = {'email': email, 'password' : password};
    var response = await http.post(uri, body: json.encode(data));
    var message = jsonDecode(response.body);

    if (message == "Success") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', email);

      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(),),);
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
          msg: "Username & Password Invalid!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Login',style: TextStyle(fontSize: 25,fontFamily: 'Nasalization'),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(labelText:'Username'),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText:'Password'),),
          ),
          SizedBox(height: 10,),
          MaterialButton(
            color: Colors.pink,
            onPressed: (){
              checkLogin();
            },child: Text('Login',style: TextStyle(color: Colors.white)),),
          MaterialButton(
            color: Colors.blueAccent,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterUser()),
              );
            },child: Text('SignUp',style: TextStyle(color: Colors.white)),),
        ],
      ),
    );
  }
}

