import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'models.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse(
          'https://12fa-116-110-42-229.ngrok-free.app/api/Users/authenticate'),
      body: jsonEncode({'phone': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final token = jsonDecode(response.body)['token'];
      // Lưu token vào bộ nhớ an toàn để sử dụng sau này
      await storage.write(key: 'token', value: token);
      final user = User(
        userData['id'],
        userData['name'],
        userData['mail'],
        userData['phone'],
        userData['role'],
      );
      final authStatus = AuthStatus(true, user);
      // Điều hướng đến màn hình chính sau khi đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(authStatus: authStatus),
        ),
      );
    } else {
      print(response.statusCode);
      // Xử lý lỗi đăng nhập
      print('Đăng nhập thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
