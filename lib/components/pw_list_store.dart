/// PwListストアのクラス
///
/// ※当クラスはシングルトンとなる
///
/// 以下の責務を持つ
/// ・PwListを取得/追加/更新/削除/保存/読込する

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../model/pw_list.dart';

class PwListStore {
  /// 保存時のキー
  final String _saveKey = "PwList";

  /// PwListリスト
  List<PwList> _list = [];

  /// ストアのインスタンス
  static final PwListStore _instance = PwListStore._internal();

  /// プライベートコンストラクタ
  PwListStore._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory PwListStore() {
    return _instance;
  }

  /// PwListの件数を取得する
  int count() {
    return _list.length;
  }

  /// 指定したインデックスのPwListを取得する
  PwList findByIndex(int index) {
    return _list[index];
  }

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// PwListを追加する
  void add(String title, String userID, String password, String memo) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var dateTime = getDateTime();
    var pwList = PwList(id, title, userID, password, memo, dateTime, dateTime);
    _list.add(pwList);
    save();
  }

  /// PwListを更新する
  void update(PwList pwList, [String? title, String? userID, String? password, String? memo]) {
    if (title != null) {
      pwList.title = title;
    }
    if (userID != null) {
      pwList.userID = userID;
    }
    if (password != null) {
      pwList.userID = password;
    }
    if (memo != null) {
      pwList.userID = memo;
    }
    pwList.updateDate = getDateTime();
    save();
  }

  /// PwListを削除する
  void delete(PwList pwList) {
    _list.remove(pwList);
    save();
  }

  /// PwListを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // PwList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  /// PwListを読込む
  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → PwList形式
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => PwList.fromJson(json.decode(a))).toList();
  }
}