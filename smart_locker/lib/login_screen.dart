import 'dart:convert';
import 'config.dart';
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
  bool isLoading = false;
  final storage = FlutterSecureStorage();


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 253, 145, 145),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    // Đặt isLoading thành true để hiển thị nút xoay tròn
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('$endpoint/api/Users/authenticate'),
      body: jsonEncode({'phone': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    // Sau khi hoàn thành yêu cầu, đặt isLoading lại thành false
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final token = jsonDecode(response.body)['token'];
      await storage.write(key: 'token', value: token);
      final user = User(
        userData['id'],
        userData['name'],
        userData['mail'],
        userData['phone'],
        userData['role'],
      );
      final authStatus = AuthStatus(true, user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(authStatus: authStatus),
        ),
      );
      _showSnackBar("Đăng nhập thành công");
    } else {
      print('Đăng nhập thất bại');
      _showSnackBar("Đăng nhập thất bại");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        backgroundColor: Color.fromARGB(255, 253, 145, 145),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Đặt màu nền của nút là màu đỏ
                onPrimary: Colors.white, // Đặt màu chữ trên nút là màu trắng
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      login(context);
                    },
              child: Text('Đăng nhập'),
            ),
            // Hiển thị vòng xoay loading khi isLoading là true
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
