import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_locker/main.dart';
import 'package:smart_locker/models.dart'; 
import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'order-locker.dart';


class ConfirmOrderScreen extends StatefulWidget {
  final AuthStatus authStatus;
  final String userReceive;
  final String startTime;
  final String locationSend;
  final String locationReceive;

  ConfirmOrderScreen({
    required this.authStatus,
    required this.userReceive,
    required this.startTime,
    required this.locationSend,
    required this.locationReceive,
  });

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  final storage = FlutterSecureStorage();

  String otp = '';
  String selectedUserId =
      'U000'; // Thêm biến này để lưu trữ userId người được chọn
  String selectedRecipient = "Người nhận số 0";
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Gọi hàm _loadUsers khi widget được khởi tạo
  }

  Future<void> _loadUsers() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$endpoint/api/Users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> userList =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      // Lọc danh sách user có roleId là 3
      final filteredUsers = userList.where((user) {
        final String roleIdStr = user['roleId'];

        // Kiểm tra xem roleId có thể được chuyển thành số nguyên hay không
        final int? roleId = int.tryParse(roleIdStr);

        return roleId == 3;
      }).toList();

      // Lấy một user ngẫu nhiên nếu danh sách không rỗng
      if (filteredUsers.isNotEmpty) {
        final random = Random();
        final randomUserIndex = random.nextInt(filteredUsers.length);
        final randomUser = filteredUsers[randomUserIndex];

        setState(() {
          selectedRecipient = randomUser['name'] ?? '';
          selectedUserId = randomUser['userId'] ?? '';
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> sendOTPRequest({
    required String userReceive,
    required String startTime,
    required String locationSend,
    required String locationReceive,
  }) async {
    final token = await storage.read(key: 'token');
    final userId = widget.authStatus.user.id;

    final response = await http.post(
      Uri.parse('$endpoint/api/Otps/generatedotp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "userIdSend": userId,
        "userIdReceive": selectedUserId,
        "startTime": startTime,
        "locationSend": locationSend,
        "locationReceive": locationReceive
      }),
    );

    if (response.statusCode == 200) {
      otp = jsonDecode(response.body)['otp'];
      String messageMail =
          "Hi $selectedRecipient,\n\nYour OTP is $otp.\n\nUsing this for unlocked Smartlocker to transport \n\nContact us: 0987654321";

      final response2 = await http.post(
        Uri.parse('$endpoint/api/Otps/sendmail'),
        body:
            jsonEncode({'userId': selectedUserId, 'mailContent': messageMail}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      _showSnackBar('Đã gửi mã OTP qua gmail của Shipper');
      Navigator.pop(context);
    } else if (response.statusCode == 400) {
      print('Hết tủ');
    } else if (response.statusCode == 401) {
      print('Chưa đăng nhập');
    } else {
      print("Lỗi Server");
    }
  }

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
                sendOTPRequest(
                  userReceive: widget.userReceive,
                  startTime: widget.startTime,
                  locationSend: widget.locationSend,
                  locationReceive: widget.locationReceive,
                );
              },
              child: Text('Xác nhận đặt tủ'),
            ),
            // Hiển thị thông báo
          ],
        ),
      ),
    );
  }
}
