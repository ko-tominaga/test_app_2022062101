///起動時に開く画面。
///パスワード認証を行う。
import 'package:flutter/material.dart';
import 'package:test_app_2022062101/screen/pw_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  /// ログインパスワード。
  final String? password;

  /// コンストラクタ
  /// ログインパスワードを設定する。
  const LoginPage(this.password);

  @override
  _LoginPage createState() => _LoginPage();
}

/// 起動時に呼び出される画面のクラス。
///
/// 初めての起動：ログインパスワード入力画面に遷移。
/// 初めての起動意外：ログイン画面に遷移。
class _LoginPage extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ユーザが入力したパスワード。
  late String? _inputPw;

  /// ログインボタンの活性、非活性を管理する。
  /// True：非活性　False：活性
  late bool _isDisabled = false;

  /// 登録されているパスワード。
  late String? _nowPw;

  @override
  void initState() {
    super.initState();
    _nowPw = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ログイン画面'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'パスワードを入力してください'
                ),
                onChanged: (value){
                  _inputPw = value;
                },
              ),
              OutlinedButton(
                child: const Text('ログイン'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  side: const BorderSide(),
                ),
                onPressed: _isDisabled ? null : () async {
                  // キーボードのフォーカスを外す。
                  FocusScope.of(context).unfocus();
                  // 警告（showSnackBar）が滞留しないように登録ボタンを無効にする。
                  setState(() => _isDisabled = true);
                  // 入力されたパスワードが正しいか比較する。
                  if ( _inputPw == _nowPw){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/home"),
                        builder: (BuildContext context) => PwListPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('パスワードが違います'),
                        )
                    );
                  }
                  // 登録ボタンを無効にする時間を設定
                  await Future.delayed(
                    const Duration(milliseconds: 3500),
                  );
                  // 登録ボタンを有効にする
                  setState(() => _isDisabled = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

