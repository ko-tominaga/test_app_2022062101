import 'package:flutter/material.dart';
import 'package:test_app_2022062101/model/pw_list.dart';

import '../components/pw_list_store.dart';

class PwInsertPage extends StatefulWidget {

  /// PwListのモデル
  final PwList? pwList;

  /// コンストラクタ
  /// PwListを引数で受け取った場合は更新、受け取らない場合は追加画面となる
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
  /// ストア
  final PwListStore _store = PwListStore();

  /// 新規追加か判断
  /// Trueだと新規追加、Falseだと更新と判断している。
  late bool _isCreatePW;

  /// 画面項目：タイトル
  late String _title;

  /// 画面項目：ユーザID
  late String _userID;

  /// 画面項目：パスワード
  late String _password;

  /// 画面項目：メモ
  late String _memo;

  /// 画面項目：作成日時
  late String _createDate;

  /// 画面項目：更新日時
  late String _updateDate;

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();
    var pwList = widget.pwList;

    _isCreatePW = pwList == null;

    // A ?? B : AがnullじゃなければAを返し、AがnullならBを返す
    _title = pwList?.title ?? "";
    _userID = pwList?.userID ?? "";
    _password = pwList?.password ?? "";
    _memo = pwList?.memo ?? "";
    _createDate = pwList?.createDate ?? "";
    _updateDate = pwList?.updateDate ?? "";
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
                controller: TextEditingController(text: _title),
                onChanged: (String value) {
                  _title = value;
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
                controller: TextEditingController(text: _userID),
                onChanged: (String value) {
                  _userID = value;
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
                controller: TextEditingController(text: _password),
                onChanged: (String value) {
                  _password = value;
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
                controller: TextEditingController(text: _memo),
                onChanged: (String value) {
                  _memo = value;
                },
              ),
              const SizedBox(height: 20),
              // 追加/更新ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isCreatePW) {
                      // PwListを追加する
                      _store.add(_title, _userID, _password, _memo);
                    } else {
                      // PwListを更新する
                      _store.update(widget.pwList!, _title, _userID, _password, _memo);
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
              Text("作成日時 : $_createDate"),
              // 更新日時のテキストラベル
              Text("更新日時 : $_updateDate"),
            ],
          ),
        ),
      ),
    );
  }
}