import 'package:flutter/material.dart';
import 'package:test_app_2022062101/screen/pw_list_page.dart';
import '../components/database_helper.dart';
import '../components/validation.dart';

class FirstLoginPage extends StatefulWidget {
  @override
  State<FirstLoginPage> createState() => _FirstLoginPage();
}

/// アプリ起動時に最初に呼び出されるクラス。
/// 以下機能がある。
///
/// ・初回起動時はパスワード登録画面に遷移する。
/// ・初回起動以外の場合はログイン画面に遷移する。
class _FirstLoginPage extends State<FirstLoginPage> {

  /// database_helperのインスタンス
  final _dbHelper = DatabaseHelper();

  /// テキストフィールドパスワードのキー
  final _formKey1 = GlobalKey<FormState>();

  /// テキストフィールドパスワード再入力のキー
  final _formKey2 = GlobalKey<FormState>();

  /// 入力されたパスワードの値を管理する
  String? _firstPw;

  /// 入力されたパスワード再入力の値を管理する
  String? _secondPw;

  /// ログインボタンの活性と非活性を管理する
  bool _isDisabled = false;

  @override
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
              Form(
                key: _formKey1,
                child: TextFormField(
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
              ),
              const SizedBox(height: 50),
              //　パスワード再入力のテキストフィールド。
              Form(
                key: _formKey2,
                child: TextFormField(
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
              ),
              //　パスワード登録ボタン。
              OutlinedButton(
                child: const Text('パスワード登録'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black, // ヒント文字の色。
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

  /// パスワード登録ボタンを押下した時のチェック処理
  _PwCheck() async {
    //　キーボードを隠す
    FocusScope.of(context).unfocus();
    // ボタンを無効
    setState(() => _isDisabled = true);

    if (!_formKey1.currentState!.validate() || !_formKey2.currentState!.validate()) { // 入力された値が入力規則を満たしているか確認する。
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正しい値を入力してください。'),
          )
      );
      // SnackBarが滞留しないように、ボタンを一時的に無効化する
      await Future.delayed(const Duration(milliseconds: 3500));
      setState(() => _isDisabled = false);
    } else if ( _firstPw == _secondPw) {  // 正しい値が入力されている場合
      // パスワードをDBに登録する
      _dbHelper.insertPw(_firstPw!);
      // パスワードリスト画面に移動する
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