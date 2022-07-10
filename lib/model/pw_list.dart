import 'package:intl/intl.dart';

/// PwListモデルのクラス
class PwList {
  /// ID
  int? id;

  /// タイトル
  late String title;

  /// UserID
  late String userID;

  /// パスワード
  late String password;

  /// メモ
  late String memo;

  /// 作成日時
  late String createDate;

  /// 更新日時
  late String updateDate;

  /// コンストラクタ
  PwList(
      this.id,
      this.title,
      this.userID,
      this.password,
      this.memo,
      this.createDate,
      this.updateDate,
      );

  /// コンストラクタ、Mapから初期化する。
  PwList.fromMap(Map map){
    id = map['id'];
    title = map['title'];
    userID = map['userID'];
    password = map['password'];
    memo = map['memo'];
    createDate = map['createDate'];
    updateDate = map['updateDate'];
  }

  PwList.createNew(){
    id;
    title = '';
    userID = '';
    password = '';
    memo = '';
    createDate = getDateTime();
    updateDate = '';
  }

  /// Mapに変換する
  Map<String, dynamic> toMap() => {
      'id': id,
      'title': title,
      'userID': userID,
      'passWord': password,
      'memo': memo,
      'createDate': createDate,
      'updateDate': updateDate
  };

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

}