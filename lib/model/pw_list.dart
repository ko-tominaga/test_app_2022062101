/// PwListモデルのクラス
class PwList {
  /// ID
  late int id;

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

  /// Mapに変換する(保存時に使用)
  /// Mapは辞書型
  Map toJson() {
    return {
      'id': id,
      'title': title,
      'userID': userID,
      'passWord': password,
      'memo': memo,
      'createDate': createDate,
      'updateDate': updateDate
    };
  }

  /// MapをPwListモデルに変換する(読込時に使用)
  PwList.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    userID = json['userID'];
    password = json['password'];
    memo = json['memo'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }
}