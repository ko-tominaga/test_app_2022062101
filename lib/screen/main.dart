import 'package:flutter/material.dart';
import 'package:test_app_2022062101/screen/first_login_page.dart';
import 'package:test_app_2022062101/screen/login_page.dart';
import 'package:test_app_2022062101/components/login_pw_store.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// 起動時に呼び出される画面のクラス。
///
/// 初めての起動：ログインパスワード入力画面に遷移。
/// 初めての起動意外：ログイン画面に遷移。
class _MyHomePageState extends State<MyHomePage> {

  /// ストアのインスタンス
  final LoginPwStore _store = LoginPwStore();

  /// ユーザが登録しているパスワード。
  late String pw = '';

  @override
  void initState() {
    super.initState();
    Future(() async {
      pw = await _store.getPassword();
      if( pw == '' ) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/home"),
            builder: (BuildContext context) => FirstLoginPage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/home"),
            builder: (BuildContext context) => LoginPage(pw),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.blue,
          height: double.infinity,
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ]
          ),
        )
    );
  }
}


