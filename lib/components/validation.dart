
/// バリエーションの定義をもつクラス。
class ValidateText {

  // パスワードのバリエーション
  static String? password(String? value) {
    if (value != null) {
      String pattern = r'^[a-zA-Z0-9]{6,10}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '6〜10文字の英数字を入力してください';
      }
    }
  }
}