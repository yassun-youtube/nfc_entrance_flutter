import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_entrance_flutter/loading_overlay.dart';
import 'dart:convert';

import 'package:nfc_entrance_flutter/utils/show_alert_dialog.dart';

class UserRegistration extends StatefulWidget {
  final String suicaId;

  const UserRegistration({super.key, required this.suicaId});

  @override
  State<UserRegistration> createState() => _UserRegistrationState(suicaId);
}

class _UserRegistrationState extends State<UserRegistration> {
  final String suicaId;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool isLoading = false;

  _UserRegistrationState(this.suicaId);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> _create() async {
    final name = _nameController.text;
    final email = _emailController.text;

    print('SuicaId: $suicaId');
    print('Name: $name');
    print('Email: $email');

    if (!(name == null || name.isEmpty) && !(email == null || email.isEmpty)) {
      final url = Uri.parse(
          'https://wu40c9u3t9.execute-api.ap-northeast-1.amazonaws.com/users');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer shared_key"
      };
      final body =
          json.encode({"suicaId": suicaId, "name": name, "email": email});

      setIsLoading(true);
      final response = await http.post(url, headers: headers, body: body);
      setIsLoading(false);

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

    return false;
  }

  void setIsLoading(bool isLoadingTo) {
    setState(() {
      this.isLoading = isLoadingTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('ユーザ登録'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (await _create()) {
                      await showAlertDialog(context, '成功', 'ユーザ登録が完了しました。');
                      Navigator.pop(context);
                    } else {
                      showAlertDialog(context, '失敗', 'ユーザ登録に失敗しました。');
                    }
                  },
                  child: Text('作成')),
            ],
          ),
        ),
      ),
    );
  }
}
