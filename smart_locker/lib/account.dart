import 'package:flutter/material.dart';
import 'models.dart';

class AccountScreen extends StatelessWidget {
  final User user; // Đối tượng User để hiển thị thông tin tài khoản
  final Function onLogout; // Callback để xử lý đăng xuất

  AccountScreen({required this.user, required this.onLogout});

  void handleLogout() {
    // Gọi callback để thông báo về việc đăng xuất
    onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Xin chào, ${user.name}'), // Hiển thị tên người dùng
            // Hiển thị các thông tin tài khoản khác ở đây
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng xuất khi nút Đăng xuất được bấm
                handleLogout();
              },
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
