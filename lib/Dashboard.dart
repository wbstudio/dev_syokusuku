import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syokusuku_app/main.dart';

import 'main.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String email = "";

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email')!;
    });
  }

  Future logOut(BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    Fluttertoast.showToast(
        msg: "Logout Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(),),);
  }


  @override
  void initState() {
    super.initState();
    getEmail();
  }

  int _currentIndex = 0;
  final screens =[
    Center(child: Text("Home",style: TextStyle(fontSize: 45),),),
//    HomePage(),  :別ダートファイル作成
    Center(child: Text("Map Page",style: TextStyle(fontSize: 45),),),
//    MapPage(),  :別ダートファイル作成
    Center(child: Text("Search Page",style: TextStyle(fontSize: 45),),),
//    SearchPage(),  :別ダートファイル作成
    Center(child: Text("QRcodePage",style: TextStyle(fontSize: 45),),),
//    QRcodePage(),  :別ダートファイル作成
    Center(child: Text("StripePage",style: TextStyle(fontSize: 45),),),
//    StripePage(),  :別ダートファイル作成
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Myページ"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard(),)
                )
              },
            ),
            ListTile(
              title: Text("履歴"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("プロフィール"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("お問い合わせ"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("規約"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("使い方"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),

//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Center(child: email == '' ? Text('') : Text(email)),
//          SizedBox(height: 20,),
//          MaterialButton(
//            color: Colors.purple,
//            onPressed: (){
//              logOut(context);
//            },
//            child: Text("Log Out",style: TextStyle(color: Colors.white),),),
//        ],
//      ),
      body: screens[_currentIndex],
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
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  void _onItemTapped(int index) => setState(() => _currentIndex = index );
  
}

