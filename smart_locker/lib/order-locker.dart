// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_locker/models.dart';

// class OrderLocker extends StatefulWidget {
//   final AuthStatus authStatus;
//   OrderLocker({required this.authStatus});
//   @override
//   _OrderLockerState createState() => _OrderLockerState();
// }

// class _OrderLockerState extends State<OrderLocker> {
//   String selectedRecipient =
//       "Người nhận số 0"; // Biến để lưu người nhận được chọn

//   List<Map<String, dynamic>> users = [];
//   TextEditingController txtOtp = TextEditingController();
//   String otp = '';
//   final storage = FlutterSecureStorage();
//   bool _isOtpSent = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers(); // Gọi hàm _loadUsers để lấy danh sách người dùng
//   }

//   //Render người nhận
//   Future<void> _loadUsers() async {
//     final userIdLoggin = widget.authStatus.user.id;
//     final token = await storage.read(key: 'token');
//     final response = await http.get(
//       Uri.parse('https://12fa-116-110-42-229.ngrok-free.app/api/Users'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<Map<String, dynamic>> userList =
//           List<Map<String, dynamic>>.from(jsonDecode(response.body));

//       // Lọc bỏ người dùng có userId trùng với userIdLoggin
//       final filteredUsers =
//           userList.where((user) => user['userId'] != userIdLoggin).toList();

//       setState(() {
//         users = filteredUsers;
//         selectedRecipient = users.isNotEmpty ? users[0]['name'] : '';
//       });
//     } else if (response.statusCode == 401) {
//       print('Chưa đăng nhập');
//     } else {
//       print("Lỗi Server");
//     }
//   }

//   List<DropdownMenuItem<String>> _buildRecipientItems() {
//     return users.map((user) {
//       final String name = user['name'] ?? '';
//       final String phone = user['phone'] ?? ''; // Lấy số điện thoại
//       return DropdownMenuItem<String>(
//         value: name,
//         child: Text('$name - $phone'), // Hiển thị tên và số điện thoại
//       );
//     }).toList();
//   }

//   Future<void> sendOTPRequest() async {
//     final token = await storage.read(key: 'token');
//     final userId = widget.authStatus.user.id;
//     final response = await http.post(
//       Uri.parse(
//           'https://12fa-116-110-42-229.ngrok-free.app/api/Otps/generatedotp'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             'Bearer $token', // Gửi token trong tiêu đề "Authorization"
//       },
//     );

//     if (response.statusCode == 200) {
//       otp = jsonDecode(response.body)['otp'];
//       final response2 = await http.post(
//         Uri.parse(
//             'https://12fa-116-110-42-229.ngrok-free.app/api/Otps/sendmail'),
//         body: jsonEncode({'userId': userId, 'otp': otp}),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'Bearer $token', // Gửi token trong tiêu đề "Authorization"
//         },
//       );
//       print('Kiểm tra gmail của bạn');
//     } else if (response.statusCode == 400) {
//       // Xử lý lỗi đăng nhập
//       print('Hết tủ');
//     } else if (response.statusCode == 401) {
//       print('Chưa đăng nhập');
//     } else {
//       print("Lỗi Server");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đặt tủ'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // DropdownButton hiển thị danh sách người dùng
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: DropdownButton<String>(
//                 value: selectedRecipient,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedRecipient = newValue!;
//                   });
//                 },
//                 items: _buildRecipientItems(),
//               ),
//             ),
//           ),

//           // Nút xác nhận
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // if (selectedRecipient.isNotEmpty) {
//                   //   sendOTPRequest();
//                   // }
//                   sendOTPRequest();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     'Xác nhận đặt tủ',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_locker/models.dart';

class OrderLocker extends StatefulWidget {
  final AuthStatus authStatus;
  OrderLocker({required this.authStatus});
  @override
  _OrderLockerState createState() => _OrderLockerState();
}

class _OrderLockerState extends State<OrderLocker> {
  String selectedRecipient =
      "Người nhận số 0"; // Biến để lưu người nhận được chọn

  List<Map<String, dynamic>> users = [];
  TextEditingController txtOtp = TextEditingController();
  String otp = '';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Gọi hàm _loadUsers để lấy danh sách người dùng
  }

  //Render người nhận
  Future<void> _loadUsers() async {
    final userIdLoggin = widget.authStatus.user.id;
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('https://12fa-116-110-42-229.ngrok-free.app/api/Users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> userList =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      // Lọc bỏ người dùng có userId trùng với userIdLoggin
      final filteredUsers =
          userList.where((user) => user['userId'] != userIdLoggin).toList();

      setState(() {
        users = filteredUsers;
        selectedRecipient = users.isNotEmpty ? users[0]['name'] : '';
      });
    } else if (response.statusCode == 401) {
      print('Chưa đăng nhập');
    } else {
      print("Lỗi Server");
    }
  }

  List<DropdownMenuItem<String>> _buildRecipientItems() {
    return users.map((user) {
      final String name = user['name'] ?? '';
      final String phone = user['phone'] ?? ''; // Lấy số điện thoại
      return DropdownMenuItem<String>(
        value: name,
        child: Text('$name - $phone'), // Hiển thị tên và số điện thoại
      );
    }).toList();
  }

  // Hàm hiển thị thông báo
  void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white), // Đặt màu chữ xanh
      ),
      backgroundColor: Colors.blue, // Đặt màu nền là màu xanh
      behavior: SnackBarBehavior.floating, // Đặt hành vi của SnackBar
    ),
  );
}

  Future<void> sendOTPRequest() async {
    final token = await storage.read(key: 'token');
    final userId = widget.authStatus.user.id;
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
      final response2 = await http.post(
        Uri.parse(
            'https://12fa-116-110-42-229.ngrok-free.app/api/Otps/sendmail'),
        body: jsonEncode({'userId': userId, 'otp': otp}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Gửi token trong tiêu đề "Authorization"
        },
      );
      _showSnackBar('Đã gửi mã OTP qua gmail. Hãy kiểm tra email của bạn.');
    } else if (response.statusCode == 400) {
      // Xử lý lỗi đăng nhập
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
        title: Text('Đặt tủ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // DropdownButton hiển thị danh sách người dùng
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
                items: _buildRecipientItems(),
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
                  sendOTPRequest();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Xác nhận đặt tủ',
                    style: TextStyle(fontSize: 16),
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
