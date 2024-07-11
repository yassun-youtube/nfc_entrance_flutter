import 'package:flutter/material.dart';
import 'package:nfc_entrance_flutter/loading_overlay.dart';
import 'nfc_reader.dart';
import 'utils/show_alert_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '入退室管理アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  void setIsLoading(bool isLoadingTo) {
    setState(() {
      this.isLoading = isLoadingTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    showModal(String recordType) async {
      final result = await showModalBottomSheet<bool>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              color: Colors.white,
              child: Center(
                child: NFCReader(recordType: recordType, setIsLoading: setIsLoading),
              ),
            );
          });
      if (result != null && result) {
        showAlertDialog(context, '成功', '登録が完了しました。');
      } else {
        showAlertDialog(context, '失敗', '登録が失敗しました。');
      }
    }

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                  width: double.infinity,
                  child: Text("出退勤", style: TextStyle(fontSize: 24), textAlign: TextAlign.center)),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => showModal('clock-in'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.blue,
                    // ボタンのテキスト色
                    shadowColor: Colors.blueAccent,
                    // 影の色
                    elevation: 5,
                    // ボタンの影の高さ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 角の丸み
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '出勤',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => showModal('clock-out'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.green,
                    // ボタンのテキスト色
                    shadowColor: Colors.blueAccent,
                    // 影の色
                    elevation: 5,
                    // ボタンの影の高さ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 角の丸み
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '退勤',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const SizedBox(
                  width: double.infinity,
                  child: Text("休憩", style: TextStyle(fontSize: 24), textAlign: TextAlign.center)),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => showModal('rest-in'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.cyan,
                    // ボタンのテキスト色
                    shadowColor: Colors.blueAccent,
                    // 影の色
                    elevation: 5,
                    // ボタンの影の高さ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 角の丸み
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '休憩開始',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => showModal('rest-out'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.indigo,
                    // ボタンのテキスト色
                    shadowColor: Colors.blueAccent,
                    // 影の色
                    elevation: 5,
                    // ボタンの影の高さ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 角の丸み
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    '休憩終了',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
