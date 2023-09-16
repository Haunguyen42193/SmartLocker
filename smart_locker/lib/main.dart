import 'package:flutter/material.dart';
import 'login_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chính'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _navigateToLogin(context);
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}

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
//               decoration: InputDecoration(labelText: 'Tên đăng nhập'),
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