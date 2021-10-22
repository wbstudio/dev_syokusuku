import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'BillPage.dart';
import 'MapPage.dart';
import 'SearchPage.dart';
import 'TicketPage.dart';
import 'include/Drawer.dart';
import '../Config/Config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String email = "";

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email')!;
    });
  }


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


  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('原チケHOME'),
          backgroundColor: Settings.MAIN_COLOR,
      ),
      drawer:DrawerWidget(),

      body: Column(
        children: [
          Center(child: email == '' ? Text('a') : Text(email)),
          Text("$id $nameさん $ticket $email"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_outlined),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_search),
              title: Text('Search')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              title: Text('Ticket')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_score_rounded),
              title: Text('Bill')
          ),
        ],
        currentIndex: _currentIndex,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          print(index); // デバッグ用に出力（タップされたボタンによって数値がかわる）
          if(index == 0){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }
          else if(index == 1){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MapPage();
            }));
          }
          else if(index == 2){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SearchPage();
            }));
          }
          else if(index == 3){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TicketPage();
            }));
          }
          else if(index == 4){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BillPage();
            }));
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
