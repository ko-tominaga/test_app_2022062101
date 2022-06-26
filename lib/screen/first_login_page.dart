import 'package:flutter/material.dart';
import 'package:test_app_2022062101/screen/pw_list_page.dart';
import '../components/login_pw_store.dart';
import '../components/validation.dart';

class FirstLoginPage extends StatefulWidget {
  /// PW入力画面の状態を生成する
  @override
  State<FirstLoginPage> createState() => _FirstLoginPage();
}

class _FirstLoginPage extends State<FirstLoginPage> {

  /// ストアのインスタンス
  final LoginPwStore _store = LoginPwStore();

  /// パスワードの値を管理する。
  String _firstPw = '';

  /// パスワード再入力の値を管理する。
  String _secondPw = '';

  /// ログインボタンの活性と非活性を管理する。
  bool _isDisabled = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインパスワード登録画面'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const Text('ログイン用パスワードを登録してください'),
              const SizedBox(height: 30),
              //　パスワードのテキストフィールド。
              TextFormField(
                autofocus: true,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidateText.password,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "パスワード",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onChanged: (value){
                  _firstPw = value;
                },
              ),
              const SizedBox(height: 50),
              //　パスワード再入力のテキストフィールド。
              TextFormField(
                autofocus: true,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidateText.password,
                decoration: const InputDecoration(
                  labelText: "パスワード再入力",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onChanged: (value){
                  _secondPw = value;
                },
              ),
              //　登録ボタン。
              OutlinedButton(
                child: const Text('ログイン'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black, // ヒント文字の色。
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  side: const BorderSide(),
                ),
                onPressed: _isDisabled ? null : () async {
                  // 警告（showSnackBar）が滞留しないように登録ボタンを無効にする。
                  setState(() => _isDisabled = true);
                  if ( _firstPw == _secondPw){
                    _store.setPassword(_firstPw);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/home"),
                        builder: (BuildContext context) => PwListPage(),
                      ),
                    );
                  } else {
                    // パスワードが違う場合に警告を出す。
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('パスワードが異なります。'),
                        )
                    );
                  }
                  await Future.delayed(
                    const Duration(milliseconds: 3500), //ボタンを無効にする時間を設定
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