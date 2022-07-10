import 'package:flutter/material.dart';
import 'package:test_app_2022062101/model/pw_list.dart';
import '../components/database_helper.dart';

class PwInsertPage extends StatefulWidget {

  /// PwListのモデル
  final PwList? pwList;

  /// コンストラクタ
  /// PwListを受け取る=更新：受け取らない=新規追加画面
  const PwInsertPage({Key? key, this.pwList}) : super(key: key);

  /// PW入力画面の状態を生成する
  @override
  State<PwInsertPage> createState() => _PwInsertPage();

}

/// PW入力画面の状態クラス
///
/// 以下機能を持つ
/// ・PWを追加/更新する
/// ・PWリスト画面へ戻る
class _PwInsertPage extends State<PwInsertPage> {

  /// database_helperのインスタンス
  final _dbHelper = DatabaseHelper();

  /// 新規追加か判断
  /// Trueだと新規追加、Falseだと更新と判断している。
  late bool _isCreatePW;

  /// パスワードリストのモデル
  PwList? _pwList;

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();

    if(widget.pwList == null){
      _pwList = PwList.createNew();
      _isCreatePW = true;
    } else {
      _isCreatePW = false;
      _pwList = widget.pwList;
    }
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // キーボードとテキストフィールドが被ってもエラーにならないようにする。
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isCreatePW ? 'パスワード追加' : '管理画面'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              // タイトルのテキストフィールド
              TextField(
                // 新規追加の時だけフォーカスする
                autofocus: _isCreatePW,
                decoration: const InputDecoration(
                  labelText: "タイトル",
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
                // TextEditingControllerを使用することで、setStateしなくても画面を更新してくれる
                controller: TextEditingController(text: _pwList?.title),
                onChanged: (String value) {
                  _pwList?.title = value;
                },
              ),

              const SizedBox(height: 20),
              // ユーザIDのテキストフィールド
              TextField(
                decoration: const InputDecoration(
                  labelText: "ユーザID",
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
                // TextEditingControllerを使用することで、setStateしなくても画面を更新してくれる
                controller: TextEditingController(text: _pwList?.userID),
                onChanged: (String value) {
                  _pwList?.userID = value;
                },
              ),
              const SizedBox(height: 20),
              // パスワードのテキストフィールド
              TextField(
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
                // TextEditingControllerを使用することで、setStateしなくても画面を更新してくれる
                controller: TextEditingController(text: _pwList?.password),
                onChanged: (String value) {
                  _pwList?.password = value;
                },
              ),
              const SizedBox(height: 20),
              // メモのテキストフィールド
              TextField(
                decoration: const InputDecoration(
                  labelText: "メモ",
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
                // TextEditingControllerを使用することで、setStateしなくても画面を更新してくれる
                controller: TextEditingController(text: _pwList?.memo),
                onChanged: (String value) {
                  _pwList?.memo = value;
                },
              ),
              const SizedBox(height: 20),
              // 追加/更新ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isCreatePW) { // 新規登録の場合
                      _dbHelper.insert(_pwList!.toMap());
                    } else { // 更新の場合
                      // 最終更新日時を更新する。
                      _pwList!.updateDate = _pwList!.getDateTime();
                      _dbHelper.update(_pwList!.toMap());
                    }
                    // PwListリスト画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    _isCreatePW ? '追加' : '更新',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // キャンセルボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // PwListリスト画面に戻る
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  child: const Text(
                    "キャンセル",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 作成日時のテキストラベル
              Text("作成日時 : ${_pwList?.createDate}"),
              // 更新日時のテキストラベル
              Text("更新日時 : ${_pwList?.updateDate}"),
            ],
          ),
        ),
      ),
    );
  }
}