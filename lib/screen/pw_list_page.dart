import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app_2022062101/screen/pw_insert_page.dart';
import 'package:test_app_2022062101/screen/change_password.dart';
import '../components/pw_list_store.dart';
import '../model/pw_list.dart';

class PwListPage extends StatefulWidget {
  @override
  _PwListPage createState() => _PwListPage();
}

///パスワード認証を通過したら開く画面のクラス。
///
///登録したパスワード一覧を表示する。
///追加、編集、削除が可能。
class _PwListPage extends State<PwListPage> {
  final PwListStore _store = PwListStore();

  // プラスボタンが押されたら、PwListの追加か編集画面に遷移する。
  // コンストラクタにPwListが設定されれば編集と判断している。
  void _pwInsert([PwList? pwList]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PwInsertPage(pwList: pwList);
        },
      ),
    );
    // 追加/更新を行う場合があるため、画面を更新する
    setState(() {});
  }

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();
    Future(
          () async {
        // データをロードし、画面を更新する
        setState(() => _store.load());
      },
    );
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('パスワード管理画面'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '設定',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.password),
                title: Text('ログインパスワードの変更'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChangePassword()
                  ));
                }
            ),
          ],
        )
      ),
      body: ListView.builder(
        // PwListの件数をリストの件数としている。
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するPwListを取得する
          var item = _store.findByIndex(index);
          return Slidable(
            // 左方向にリストアイテムをスライドした場合のアクション
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // PwListを削除して画面を更新する
                    setState(() => {_store.delete(item)});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.edit,
                  label: '削除',
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              child: ListTile(
                // タイトルを表示する。
                title: Text(item.title),
                // タップしたら編集画面に移動する。
                onTap: (){
                  _pwInsert(item);
                },
              ),
            ),
          );
        },
      ),
      // PW追加画面に遷移するボタン
      floatingActionButton: FloatingActionButton(
        // PW追加画面に遷移する
        onPressed: _pwInsert,
        child: const Icon(Icons.add),
      ),
    );
  }
}