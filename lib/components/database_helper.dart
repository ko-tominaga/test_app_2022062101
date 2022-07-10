import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// DBとの接続をするクラス。
///
/// ※当クラスはシングルトンとなる
///
/// 以下機能がある。
/// ・DBが無い場合にDBを作成する
/// ・DBとの接続
/// ・DBの操作
class DatabaseHelper {

  /// DBの名前
  static const _databaseName = "PwList.db";

  /// DBのバージョン
  static const _databaseVersion = 1;

  /// パスワードリストを保持するテーブル名
  final String _pwTable = 'pw_list';

  /// ログインパスワードを保持するテーブル名
  final String _loginPwTable = 'login_pw';

  /// DatabaseHelperクラスをシングルトンにするためのコンストラクタ
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory DatabaseHelper() {
    return _instance;
  }

  /// DBにアクセスするためのメソッド
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // 最初の場合はDBを作成する
    _database = await _initDatabase();
    return _database!;
  }
  
  /// データベースを開く
  /// データベースがない場合は作る
  _initDatabase() async {
    String path = await getDbPath();
    // pathのDBを開く。なければonCreateの処理がよばれる。
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  /// DBの保存パスを取得する
  Future<String> getDbPath() async {
    var dbFilePath = '';
    if (Platform.isAndroid) {
      // Androidであれば「getDatabasesPath」を利用
      dbFilePath = await getDatabasesPath();
    } else if (Platform.isIOS) {
      // iOSであれば「getLibraryDirectory」を利用
      final dbDirectory = await getLibraryDirectory();
      dbFilePath = dbDirectory.path;
    } else {
      // プラットフォームが判別できない場合はExceptionをthrow
      throw Exception('Unable to determine platform.');
    }
    // 配置場所のパスを作成して返却
    final path = join(dbFilePath, _databaseName);
    return path;
  }
  /// テーブルを作成する
  Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $_pwTable(
        id INTEGER PRIMARY KEY ,
        title TEXT,
        userID TEXT,
        password TEXT,
        memo TEXT,
        createDate TEXT,
        updateDate TEXT
      )
    """);
    await db.execute("""
      CREATE TABLE $_loginPwTable(
        pw TEXT PRIMARY KEY 
        )
      """);
  }

  /// データの登録を行う
  Future insert(Map<String, dynamic> row) async {
    Database db = await _instance.database;
    await db.insert(_pwTable, row);
  }
  /// 全件取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await _instance.database;
    return await db.query(_pwTable);
  }
  /// データの件数を取得する
  Future<int> queryRowCount() async {
    Database db = await _instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_pwTable'))!;
  }
  /// データの更新を行う
  Future update(Map<String, dynamic> row) async {
    Database db = await _instance.database;
    await db.update(_pwTable, row, where: 'id = ${row['id']}');
  }
  /// 削除
  Future delete(int id) async {
    Database db = await _instance.database;
    await db.delete(_pwTable, where: 'id = $id');
  }

  /// ログインパスワードの取得
  Future<String?> getPw() async {
    Database db = await _instance.database;
    // テーブル全体を取得
    List<Map<String, dynamic>> _resultList = await db.query(_loginPwTable);
    // パスワードが登録されていない場合はNullを返却
    if (_resultList.isEmpty) return null;
    // 最初の値のみ抽出してMapに変換
    Map<String, dynamic> _resultMap = _resultList.first;
    return _resultMap['pw'];
  }
  /// ログインパスワードの登録
  Future insertPw(String pw) async {
    Database db = await _instance.database;
    await db.rawInsert('INSERT INTO $_loginPwTable(pw) VALUES (\'$pw\')');
  }
  /// ログインパスワードの更新
  Future updatePw(String pw) async {
    Database db = await _instance.database;
    await db.rawUpdate('UPDATE $_loginPwTable SET pw = \'$pw\'');
  }

}