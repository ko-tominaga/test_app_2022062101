///起動時に開く画面。
///パスワード認証を行う。
import 'package:flutter/material.dart';
import '../components/login_pw_store.dart';
import '../components/validation.dart';

class ChangePassword extends StatefulWidget {

  @override
  _ChangePassword createState() => _ChangePassword();
}

/// ログインパスワードの変更画面のクラス。
///
/// ログインパスワードの変更が可能。
class _ChangePassword extends State<ChangePassword> {

  /// ストアのインスタンス
  final LoginPwStore _store = LoginPwStore();

  /// 現在登録されているパスワード
  String _nowPw = '';

  /// 現在のパスワードに入力された値
  String _pw = '';

  /// 変更後パスワードの値
  String _firstPw = '';

  /// 変更後パスワード再入力の値
  String _secondPw = '';

  /// パスワードを変更するボタンの活性と非活性を管理
  bool _isDisabled = false;

  // 現在登録されているパスワードを取得している。
  void initState() {
    super.initState();
    Future(() async {
      _nowPw = await _store.getPassword();
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ログインパスワードの変更'),
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
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidateText.password,
                    decoration: const InputDecoration(
                      labelText: "現在のパスワード",
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
                      _pw = value;
                    },
                  ),
                  //　パスワードのテキストフィールド。
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidateText.password,
                    decoration: const InputDecoration(
                      labelText: "変更後のパスワード",
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
                  const SizedBox(height: 30),
                  //　パスワード再入力のテキストフィールド。
                  TextFormField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidateText.password,
                    decoration: const InputDecoration(
                      labelText: "変更後のパスワード再入力",
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
                  OutlinedButton(
                    child: const Text('パスワードを変更する'),
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
                      // 元々登録されてるパスワードと、現在のパスワードに入力された値が正しいかチェックする。
                      if ( _nowPw == _pw){
                        // 変更後のパスワードが正しいかチェックする。
                        if ( _firstPw == _secondPw) {
                          // 正しい場合ローカルストレージに書き込む
                          _store.setPassword(_firstPw);
                          _nowPw = _firstPw;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('パスワードの変更が完了しました。'),
                              )
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('変更後のパスワードが異なります。'),
                              )
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('現在のパスワードが異なります。'),
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
                ]
            )
        ),
      ),
    );
  }
}

