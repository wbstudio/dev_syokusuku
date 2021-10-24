import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePage extends StatefulWidget {
  StripePageLogicState createState() => StripePageLogicState();
}

class StripePageLogicState extends State {
  bool loading = false;
  bool isSubscribed = false;

  Future getUserSubscriptionState() async {
    setState(() {
      loading = true;
    });

    // Get user state of subscription.
    Uri uri =
        Uri.parse('http://10.0.2.2/php_syokusuku/get_user_subscription.php');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var email = preferences.getString('email');

    // Store all data with Param Name.
    var data = {'email': email};

    // Starting Web API Call.
    var response = await http.post(uri, body: json.encode(data));

    // Getting Server response into variable.
    var result = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }

    // 継続課金プラン契約中の場
    if (result['subscription']) {
      setState(() {
        isSubscribed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Visibility(
                  visible: !loading && !isSubscribed,
                  child: Container(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            // （2） 実際に表示するページ(ウィジェット)を指定する
                            builder: (context) => SubscriptionContractPage(),
                          ),
                        ),
                        child: const SizedBox(
                          width: 300,
                          height: 100,
                          child: Text('原価チケット定期登録'),
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: !loading && isSubscribed,
                  child: Container(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: const SizedBox(
                          width: 300,
                          height: 100,
                          child: Text('原価チケット定期詳細'),
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: !loading && isSubscribed,
                  child: Container(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            // （2） 実際に表示するページ(ウィジェット)を指定する
                            builder: (context) => SingleContractPage(),
                          ),
                        ),
                        child: const SizedBox(
                          width: 300,
                          height: 100,
                          child: Text('原価チケット追加購入'),
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: loading,
                  child: Container(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserSubscriptionState();
  }
}

class SubscriptionContractPage extends StatefulWidget {
  SubscriptionContractState createState() => SubscriptionContractState();
}

class SubscriptionContractState extends State {
  bool loading = false;
  final formatter = NumberFormat("#,###");
  Map subscriptionProduct = {};
  List<dynamic> description = [];
  List<dynamic> caution = [];
  String stripeCheckoutUrl = '';

  Future getSubscriptionProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('stripe_transaction', '');

    setState(() {
      loading = true;
    });

    // Store all data with Param Name.
    var data = {'item_type': 'subscription_item'};

    // Get user state of subscription.
    Uri uri = Uri.parse('http://10.0.2.2/php_syokusuku/get_stripe_product.php');
    var response = await http.post(uri, body: json.encode(data));

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
    // Getting Server response into variable.
    subscriptionProduct = jsonDecode(response.body);
    subscriptionProduct['total'] =
        formatter.format(subscriptionProduct['total']);
    description = subscriptionProduct['description'];
    caution = subscriptionProduct['caution'];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('原価チケット定期購入'),
      ),
      body: Container(
        padding: new EdgeInsets.all(32.0),
        child: Column(children: [
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("${subscriptionProduct['name']}"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(
              children: List.generate(description.length, (index) {
                return Container(
                  constraints: BoxConstraints(maxWidth: 320.0),
                  child: Text(
                    description[index].toString(),
                  ),
                );
              }),
            ),
          ]),
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("価格（税込）："),
            ]),
            Column(children: <Widget>[
              Text("${subscriptionProduct['total']} 円"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("注意"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(
              children: List.generate(caution.length, (index) {
                return Container(
                  constraints: BoxConstraints(maxWidth: 320.0),
                  child: Text(
                    caution[index].toString(),
                  ),
                );
              }),
            ),
          ]),
          Visibility(
            visible: loading,
            child: Container(child: CircularProgressIndicator()),
          ),
          Container(
            padding: new EdgeInsets.only(top: 30),
            child: Column(children: <Widget>[
              ElevatedButton(
                onPressed: () => redirectToSubscriptionCheckout(context),
                child: Text('購入する'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('戻る'),
              )
            ]),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSubscriptionProduct();
  }
}

class SingleContractPage extends StatefulWidget {
  _SingleContractState createState() => _SingleContractState();
}

class _SingleContractState extends State<SingleContractPage> {
  bool loading = false;
  final formatter = NumberFormat("#,###");
  Map subscriptionProduct = {};
  List<dynamic> description = [];
  List<dynamic> caution = [];
  String stripeCheckoutUrl = '';

  Future getSingleProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('stripe_transaction', '');

    setState(() {
      loading = true;
    });
    // Store all data with Param Name.
    var data = {'item_type': 'single_item'};

    // Get user state of subscription.
    Uri uri = Uri.parse('http://10.0.2.2/php_syokusuku/get_stripe_product.php');
    var response = await http.post(uri, body: json.encode(data));

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
    // Getting Server response into variable.
    subscriptionProduct = jsonDecode(response.body);
    subscriptionProduct['total'] =
        formatter.format(subscriptionProduct['total']);
    description = subscriptionProduct['description'];
    caution = subscriptionProduct['caution'];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('原価チケット追加購入'),
      ),
      body: Container(
        padding: new EdgeInsets.all(32.0),
        child: Column(children: [
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("${subscriptionProduct['name']}"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(
              children: List.generate(description.length, (index) {
                return Container(
                  constraints: BoxConstraints(maxWidth: 320.0),
                  child: Text(
                    description[index].toString(),
                  ),
                );
              }),
            ),
          ]),
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("価格（税込）："),
            ]),
            Column(children: <Widget>[
              Text("${subscriptionProduct['total']} 円"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(children: <Widget>[
              Text("注意"),
            ]),
          ]),
          Row(children: <Widget>[
            Column(
              children: List.generate(caution.length, (index) {
                return Container(
                  constraints: BoxConstraints(maxWidth: 320.0),
                  child: Text(
                    caution[index].toString(),
                  ),
                );
              }),
            ),
          ]),
          Visibility(
            visible: loading,
            child: Container(child: CircularProgressIndicator()),
          ),
          Container(
            padding: new EdgeInsets.only(top: 30),
            child: Column(children: <Widget>[
              ElevatedButton(
                onPressed: () => redirectToSingleCheckout(context),
                child: Text('購入する'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('戻る'),
              )
            ]),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSingleProduct();
  }
}

void redirectToSubscriptionCheckout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  preferences.setString('stripe_transaction', 'start');

  // Store all data with Param Name.
  var data = {'email': email, 'item_type': 'subscription_item'};

  // Get user state of subscription.
  Uri uri = Uri.parse(
      'http://10.0.2.2/php_syokusuku/src/get_stripe_checkout_url.php');
  var response = await http.post(uri, body: json.encode(data));

  final String stripeCheckoutUrl = jsonDecode(response.body);

  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(stripeCheckoutUrl: stripeCheckoutUrl),
  ));
}

void redirectToSingleCheckout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  preferences.setString('stripe_transaction', 'start');

  // Store all data with Param Name.
  var data = {'email': email, 'item_type': 'single_item'};

  // Get user state of subscription.
  Uri uri = Uri.parse(
      'http://10.0.2.2/php_syokusuku/src/get_stripe_checkout_url.php');
  var response = await http.post(uri, body: json.encode(data));

  final String stripeCheckoutUrl = jsonDecode(response.body);

  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(stripeCheckoutUrl: stripeCheckoutUrl),
  ));
}

class CheckoutPage extends StatefulWidget {
  final String stripeCheckoutUrl;

  const CheckoutPage({Key? key, required this.stripeCheckoutUrl})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: widget.stripeCheckoutUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          String uri = request.url;
          if (uri.contains('http://localhost:8080/#/success')) {
            List urlList = uri.split('?');
            List paramList = urlList[1].split('&');
            List sessionList = paramList[0].split('=');
            String sessionId = sessionList[1];
            List itemTypeList = paramList[1].split('=');
            String itemType = itemTypeList[1];
            Navigator.of(context).pushReplacementNamed(
                SuccessStripePage.routeName,
                arguments: SuccessStripeArguments(sessionId, itemType));
          } else if (uri.contains('http://localhost:8080/#/cancel')) {
            Navigator.of(context).pop();
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }
}

class SuccessStripePage extends StatelessWidget {
  static const routeName = '/successStripe';

  Future<String> _getFutureValue(sessionId, itemType) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var email = preferences.getString('email');
      var stripeTransaction = preferences.getString('stripe_transaction');
      preferences.setString('stripe_transaction', '');

      // セッションが切れている場合は、処理をスルー
      if (stripeTransaction != 'start') {
        return Future.value("success");
      }

      // Store all data with Param Name.
      var data = {
        'email': email,
        'session_id': sessionId,
        'item_type': itemType
      };

      // Get user state of subscription.
      Uri uri =
          Uri.parse('http://10.0.2.2/php_syokusuku/src/sccess_stripe.php');
      var response = await http.post(uri, body: json.encode(data));

      final String result = jsonDecode(response.body);
      if (result == 'success') {
        return Future.value("success");
      } else {
        return Future.error('エラーが発生しました');
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SuccessStripeArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('支払完了'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getFutureValue(args.sessionId, args.itemType),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            // 通信中はスピナーを表示
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }

            // エラー発生時はエラーメッセージを表示
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // データがnullでないかチェック
            if (snapshot.hasData) {
              return Container(
                child: Center(
                  child: Column(
                    children: [
                      Text('支払が完了しました'),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/dashboard'),
                        child: Text('ホームに戻る'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text("データが存在しません");
            }
          },
        ),
      ),
    );
  }
}

// 1. 引数を定義したクラス
class SuccessStripeArguments {
  final String sessionId;
  final String itemType;

  SuccessStripeArguments(this.sessionId, this.itemType);
}
