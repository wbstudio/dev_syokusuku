import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syokusuku_app/DashBoard/DrawerMenu/Contact.dart';
import '../../main.dart';

class DrawerWidget extends StatelessWidget {

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context)=>Login(),),
            (_) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("履歴"),
            trailing: Icon(Icons.arrow_forward),
//              onTap: () => {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => Dashboard(),)
//                )
//              },
          ),
          ListTile(
            title: Text("プロフィール"),
            trailing: Icon(Icons.arrow_forward),
//              onTap: () => {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => Dashboard(),)
//                )
//              },
          ),
          ListTile(
            title: Text("お問い合わせ"),
            trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contact(),)
                )
              },
          ),
          ListTile(
            title: Text("規約"),
            trailing: Icon(Icons.arrow_forward),
//              onTap: () => {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => Dashboard(),)
//                )
//              },
          ),
          ListTile(
            title: Text("使い方"),
            trailing: Icon(Icons.arrow_forward),
//              onTap: () => {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => Dashboard(),)
//                )
//              },
          ),
          ListTile(
            title: Text("ログアウト"),
            trailing: Icon(Icons.arrow_forward),
            onTap: (){
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
