
/// バリデーションの定義をもつクラス。
class ValidateText {

  // パスワードのバリデーション
  static String? password(String? value) {
    if (value != null) {
      String pattern = r'^[a-zA-Z0-9]{6,10}$';
      RegExp regExp = RegExp(pattern);
      // 入力規則と一致しない場合、エラー文字を返す。
      if (!regExp.hasMatch(value)) return '6〜10文字の英数字を入力してください';
      // 何も入力されていない場合エラー文字を返す。
    } else {
      return '6〜10文字の英数字を入力してください';
    }
  }
}