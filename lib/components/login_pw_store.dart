import 'package:shared_preferences/shared_preferences.dart';

/// アプリのログインパスワードを管理するクラス。
///
/// パスワードの取得と更新をする。
class LoginPwStore {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ストアのインスタンス
  static final LoginPwStore _instance = LoginPwStore._internal();

  /// プライベートコンストラクタ
  LoginPwStore._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory LoginPwStore() {
    return _instance;
  }

  final String _saveKey = "LoginPassword";

  /// 現在登録しているパスワードの取得をする
  getPassword() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString(_saveKey) ?? '';
  }

  /// パスワードを登録する。
  setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_saveKey, password);
  }
}
