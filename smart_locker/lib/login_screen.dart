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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    final url = Uri.parse('login'); // Thay đổi URL của máy chủ của bạn

    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'roleID': '2'
      },
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi từ máy chủ ở đây
      print('Đăng nhập thành công!');
    } else {
      // Xử lý lỗi ở đây
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
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
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