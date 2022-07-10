import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app_2022062101/screen/pw_insert_page.dart';
import 'package:test_app_2022062101/screen/change_password_page.dart';
import '../components/database_helper.dart';
import '../components/pw_list_store.dart';
import '../model/pw_list.dart';
import 'main.dart';

class PwListPage extends StatefulWidget {
  @override
  _PwListPage createState() => _PwListPage();
}

///パスワード認証を通過したら開く画面のクラス。
///
///登録したパスワード一覧を表示する。
///追加、編集、削除が可能。
class _PwListPage extends State<PwListPage> with WidgetsBindingObserver {

  /// database_helperのインスタンス
  final _dbHelper = DatabaseHelper();

  /// _storeのインスタンス
  final PwListStore _store = PwListStore();

  /// アプリの状態をセットする
  AppLifecycleState? _state;

  // プラスボタンが押されたら、PwListの追加、編集画面に遷移する。
  void _pwInsert([Map? row]) async {
    PwList? _pwList = row == null ? null : PwList.fromMap(row);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PwInsertPage(pwList: _pwList);
        },
      ),
    );
    // 追加/更新を行う場合があるため、画面を更新する
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 状態監視を開始
    WidgetsBinding.instance.addObserver(this);
    // データをロードし、画面を更新する
    // setState(() => {});
  }

  @override
  void dispose() {
    super.dispose();
    // 状態監視のオブザーバーを破棄
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 状態変化を変数に格納
    setState(() {_state = state;});

    // 非アクティブになったら、ログイン画面に強制的に遷移する
    if (_state == AppLifecycleState.inactive){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/home"),
          builder: (BuildContext context) => const MyHomePage(),
        ),
      );
    }
  }

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
            const DrawerHeader(
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
                leading: const Icon(Icons.password),
                title: const Text('ログインパスワードの変更'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChangePassword()
                  ));
                }
            ),
          ],
        )
      ),
      body: Center(
        child: FutureBuilder(
            future: _store.load(),
          builder: (context, snapshot) {
              //　DBからデータを取得できたらウェジットを生成する。
              if(snapshot.connectionState == ConnectionState.done){
                return ListView.builder(
                  // PwListの件数をリストの件数としている
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
                              setState(() => {_dbHelper.delete(item['id'])});
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
                          title: Text(item['title']),
                          // タップしたら編集画面に移動する。
                          onTap: (){
                            _pwInsert(item);
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
          }
        ),
      ),
      // PW追加画面に遷移するボタン
      floatingActionButton: FloatingActionButton(
        onPressed: _pwInsert,
        child: const Icon(Icons.add),
      ),
    );
  }
}