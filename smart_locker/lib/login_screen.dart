// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đăng nhập'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               decoration: InputDecoration(labelText: 'Số điện thoại'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Mật khẩu'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Xử lý đăng nhập ở đây
//               },
//               child: Text('Đăng nhập'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController usernameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  // Future<void> login() async {
  //   // final String username = usernameController.text;
  //   // final String password = passwordController.text;
  //   // final url = Uri.parse('https://dd9e-116-110-42-229.ngrok-free.app/api/Users/authenticate'); // Thay đổi URL của máy chủ của bạn

  //   // final response = await http.post(
  //   //   url,
  //   //   body: {
  //   //     'phone': username,
  //   //     'password': password,
  //   //     'roleID': '2'
  //   //   },
  //   // );

  //   // if (response.statusCode == 200) {
  //   //   // Xử lý phản hồi từ máy chủ ở đây
  //   //   print('Đăng nhập thành công!');
  //   // } else {
  //   //   // Xử lý lỗi ở đây
  //   //   print('Đăng nhập thất bại');
  //   // }
  // }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future<void> login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse(
          'https://cb5a-116-110-42-229.ngrok-free.app/api/Users/authenticate'),
      body: jsonEncode({'phone': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      // Lưu token vào bộ nhớ an toàn để sử dụng sau này
      await storage.write(key: 'token', value: token);
      // Điều hướng đến màn hình chính sau khi đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
                login();
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
