import 'package:flutter/material.dart';
import 'package:test_app_2022062101/screen/pw_list_page.dart';

import '../components/validation.dart';

class LoginPage extends StatefulWidget {

  /// ログインパスワード
  final String? password;

  /// コンストラクタでログインパスワードを設定する。
  const LoginPage(this.password);

  @override
  _LoginPage createState() => _LoginPage();
}

/// 起動時に呼び出される画面のクラス
///
/// 初めての起動：ログインパスワード入力画面に遷移。
/// 初めての起動意外：ログイン画面に遷移。
class _LoginPage extends State<LoginPage> with WidgetsBindingObserver {

  /// テキストフィールドパスワードのキー
  final _formKey = GlobalKey<FormState>();

  /// ユーザが入力したパスワード
  late String? _inputPw;

  /// 登録されているパスワード
  late String? _nowPw;

  /// ログインボタンの活性、非活性を管理する
  /// True：非活性　False：活性
  late bool _isDisabled = false;

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
        title: const Text('ログイン画面'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ValidateText.password,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'パスワードを入力してください'
                  ),
                  onChanged: (value){
                    _inputPw = value;
                  },
                ),
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
                  _PwCheck();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// ログインボタンを押下した時のチェック処理
  _PwCheck() async {
    //　キーボードを隠す
    FocusScope.of(context).unfocus();
    // ボタンを無効
    setState(() => _isDisabled = true);

    if (!_formKey.currentState!.validate()) { // 入力された値が入力規則を満たしているか確認する。
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正しい値を入力してください。'),
          )
      );
      // SnackBarが滞留しないように、ボタンを一時的に無効化する
      await Future.delayed(const Duration(milliseconds: 3500));
      setState(() => _isDisabled = false);
    } else if ( _inputPw == _nowPw) {  // 正しい値が入力されている場合
      // パスワード管理画面に遷移する。
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/home"),
          builder: (BuildContext context) => PwListPage(),
        ),
      );
    } else {  // 1つ目と2つ目のパスワードが違う場合
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('パスワードが異なります。'),
          )
      );
      // SnackBarが滞留しないように、ボタンを一時的に無効化する
      await Future.delayed(const Duration(milliseconds: 3500));
      setState(() => _isDisabled = false);
    }
  }
}

