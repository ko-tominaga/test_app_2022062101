import 'package:intl/intl.dart';
import 'database_helper.dart';

/// PwListストアのクラス
///
/// ※当クラスはシングルトンとなる
///
/// PwListを取得/追加/更新/削除/保存/読込する
class PwListStore {

  /// PwListリスト
  List<Map<String, dynamic>> _list = [];

  /// DBHelperのインスタンス
  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
  Map<String, dynamic> findByIndex(int index) {
    return _list[index];
  }

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// PwListを読込む
  Future load() async {
    _list = await _databaseHelper.queryAllRows();
  }

}