import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderLocker extends StatefulWidget {
  @override
  _OrderLockerState createState() => _OrderLockerState();
}

class _OrderLockerState extends State<OrderLocker> {
  String selectedRecipient =
      "Người nhận số 0"; // Biến để lưu người nhận được chọn

  TextEditingController txtOtp = TextEditingController();
  String otp = '';
  final storage = FlutterSecureStorage();
  bool _isOtpSent = false;
  //Tạo otp
  Future<void> sendOTPRequest() async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(
          'https://12fa-116-110-42-229.ngrok-free.app/api/Otps/generatedotp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Gửi token trong tiêu đề "Authorization"
      },
    );


    if (response.statusCode == 200) {
      otp = jsonDecode(response.body)['otp'];
      _isOtpSent = true;
      print('Thành công');
      print(otp);
    } else if (response.statusCode == 400) {
      // Xử lý lỗi đăng nhập
      print('Hết tủ');
    } else if (response.statusCode == 401) {
      print('Chưa đăng nhập');
    }else{
      print("Lỗi Server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt tủ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hộp xổ xuống
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: selectedRecipient,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRecipient = newValue!;
                  });
                },
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem<String>(
                    value: 'Người nhận số $index',
                    child: Text('Người nhận số $index'),
                  ),
                ),
              ),
            ),
          ),

          // Nút xác nhận
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Thực hiện xác nhận đặt tủ ở đây, có thể sử dụng selectedRecipient
                  sendOTPRequest();
                },
                child: Padding(
                  padding: const EdgeInsets.all(
                      12.0), // Tùy chỉnh khoảng cách xung quanh nút
                  child: Text(
                    'Xác nhận đặt tủ',
                    style:
                        TextStyle(fontSize: 16), // Tùy chỉnh kích thước văn bản
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
