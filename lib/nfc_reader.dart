import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class NFCReader extends StatefulWidget {
  final String recordType;

  NFCReader({ required this.recordType });

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



  Future<void> postData(String suicaId) async {
    final url = Uri.parse('https://wu40c9u3t9.execute-api.ap-northeast-1.amazonaws.com/records');
    final headers = {"Content-Type": "application/json", "Authorization": "Bearer shared_key"};
    final body =
    json.encode({"suicaId": suicaId, "recordType": widget.recordType });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Post successful');
      print('Response body: ${response.body}');
    } else {
      print('Failed to post data');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
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
      await postData(hexString);
      Navigator.pop(context);
    });
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('NFCタグをスキャンしてください')
      ),
    );
  }
}
