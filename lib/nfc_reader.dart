import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_entrance_flutter/user_registration.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'test.dart';

class NFCReader extends StatefulWidget {
  final String recordType;
  final Function setIsLoading;

  NFCReader({ required this.recordType, required this.setIsLoading });

  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  @override
  void initState() {
    super.initState();
    print('Logはここに出ますよ');
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  String uint8ListToHexString(Uint8List data) {
    // 各バイトを16進数に変換し、ゼロ埋めして2桁にする
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  Future<bool> postData(String suicaId) async {
    final url = Uri.parse('https://wu40c9u3t9.execute-api.ap-northeast-1.amazonaws.com/records');
    final headers = {"Content-Type": "application/json", "Authorization": "Bearer shared_key"};
    final body =
    json.encode({"suicaId": suicaId, "recordType": widget.recordType });

    widget.setIsLoading(true);
    final response = await http.post(url, headers: headers, body: body);
    widget.setIsLoading(false);

    if (response.statusCode == 201) {
      print('Post successful');
      print('Response body: ${response.body}');
      return true;
    } else {
      print('Failed to post data');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> getUser(String suicaId) async {
    final url = Uri.parse('https://wu40c9u3t9.execute-api.ap-northeast-1.amazonaws.com/users/' + suicaId);
    final headers = {"Content-Type": "application/json", "Authorization": "Bearer shared_key"};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('User found');
      return true;
    } else {
      print('User not found');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // タグが検出されたときの処理
      print('NFCタグが検出されました: ${tag.data}');
      var tagData = tag.data["isodep"] ?? tag.data["nfcf"];
      Uint8List identifier = Uint8List.fromList(tagData["identifier"]);
      String hexString = uint8ListToHexString(identifier);
      print(hexString);
      // ユーザ登録があるかチェック
      if (await getUser(hexString)) {
        // ユーザ登録がすでにされているのでAPIを叩く
        bool postDataSucceeded = await postData(hexString);
        Navigator.pop(context, postDataSucceeded);
      } else {
        // ユーザ登録がないなら作成画面へ
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => UserRegistration(suicaId: hexString)));
      }
    });
    return Center(
      child: ElevatedButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
          },
          child: Text('NFCタグをスキャンしてください')
      ),
    );
  }
}
