import 'package:flutter/material.dart';
import '../components/validation.dart';
import '../components/database_helper.dart';

class ChangePassword extends StatefulWidget {

  @override
  _ChangePassword createState() => _ChangePassword();
}

/// ログインパスワードの変更画面のクラス。
///
/// ログインパスワードの変更が可能。
class _ChangePassword extends State<ChangePassword> {

  /// database_helperのインスタンス
  final _dbHelper = DatabaseHelper();

  /// 変更後パスワードのキー
  final _formKey1 = GlobalKey<FormState>();

  /// 変更後パスワード再入力のキー
  final _formKey2 = GlobalKey<FormState>();

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

  void initState() {
    super.initState();
    // 現在登録されているパスワードを取得する。
    Future(() async {
      _nowPw = (await _dbHelper.getPw())!;
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
                  Form(
                    key: _formKey1,
                    child: TextFormField(
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
                  ),
                  const SizedBox(height: 30),
                  //　パスワード再入力のテキストフィールド。
                  Form(
                    key: _formKey2,
                    child: TextFormField(
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
                      _PwCheck();
                    },
                  ),
                ]
            )
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

    // 入力された値が入力規則を満たしているか確認する。
    if (!_formKey1.currentState!.validate() || !_formKey2.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正しい値を入力してください'),
          )
      );
      // 現在のパスワード、変更後のパスワードが一致している。
    } else if ( _nowPw == _pw && _firstPw == _secondPw) {
      // パスワードの更新をする
      _dbHelper.updatePw(_firstPw);
      _nowPw =  _firstPw;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('パスワードの更新が完了しました。'),
          )
      );

    } else {  // 正しい値が入力されていない場合
      /// 警告文
      String _message = '現在のパスワードが異なります。';

      // 現在のパスワードが正しく入力されているかチェックする。
      if (_nowPw == _pw){_message = '変更後のパスワードが異なります。';}

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_message),
          )
      );
    }
    // SnackBarが滞留しないように、ボタンを一時的に無効化する
    await Future.delayed(const Duration(milliseconds: 3500));
    setState(() => _isDisabled = false);
  }
}

