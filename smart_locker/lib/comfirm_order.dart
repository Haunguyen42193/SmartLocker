import 'package:flutter/material.dart';
import 'package:smart_locker/models.dart'; // Import AuthStatus từ models.dart

class ConfirmOrderScreen extends StatelessWidget {
  final AuthStatus authStatus; // Thêm authStatus vào constructor

  ConfirmOrderScreen({required this.authStatus}); // Cập nhật constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác nhận đặt tủ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nút xác nhận được nhấn
                // Đặt tủ ở đây và sử dụng authStatus nếu cần
              },
              child: Text('Xác nhận đặt tủ'),
            ),
          ],
        ),
      ),
    );
  }
}
