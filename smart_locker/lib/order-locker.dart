// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:smart_locker/models.dart';
// import 'config.dart';

// class OrderLocker extends StatefulWidget {
//   final AuthStatus authStatus;
//   OrderLocker({required this.authStatus});

//   @override
//   _OrderLockerState createState() => _OrderLockerState();
// }

// class _OrderLockerState extends State<OrderLocker> {
//   String selectedRecipient = "Người nhận số 0";
//   String selectedHour = '';
//   List<String> availableHours = [];

//   List<Map<String, dynamic>> users = [];
//   TextEditingController txtOtp = TextEditingController();
//   String otp = '';
//   final storage = FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//     _generateAvailableHours();
//     _setInitialHour();
//   }

//   Future<void> _loadUsers() async {
//     final userIdLoggin = widget.authStatus.user.id;
//     final token = await storage.read(key: 'token');
//     final response = await http.get(
//       Uri.parse('$endpoint/api/Users'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<Map<String, dynamic>> userList =
//           List<Map<String, dynamic>>.from(jsonDecode(response.body));

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

//   void _generateAvailableHours() {
//     final DateTime now = DateTime.now();
//     final int currentHour = now.hour;

//     availableHours = []; // Xóa danh sách cũ
//     for (int hour = 6; hour < 18; hour++) {
//       if (currentHour <= hour) {
//         final String endHour = (hour == 17) ? '18' : (hour + 1).toString();
//         final String hourRange = '$hour:00 - $endHour:00';
//         availableHours.add(hourRange);
//       }
//     }
//   }

//   void _setInitialHour() {
//     final DateTime now = DateTime.now();
//     final int currentHour = now.hour;

//     for (int hour = 6; hour < 18; hour++) {
//       if (currentHour <= hour) {
//         final String hourRange = '$hour:00 - ${(hour + 1) % 24}:00';

//         setState(() {
//           selectedHour = hourRange;
//         });
//         break;
//       }
//     }
//   }

//   List<DropdownMenuItem<String>> _buildRecipientItems() {
//     return users.map((user) {
//       final String name = user['name'] ?? '';
//       final String phone = user['phone'] ?? '';
//       return DropdownMenuItem<String>(
//         value: name,
//         child: Text('$name - $phone'),
//       );
//     }).toList();
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   String formatHourRange(String hour) {
//     final int startHour = int.parse(hour.split(':')[0]);
//     final int endHour = (startHour + 1) % 24; // Tính giờ kết thúc

//     return '$startHour:00 - $endHour:00';
//   }
//   // Future<void> sendOTPRequest() async {
//   //   final token = await storage.read(key: 'token');
//   //   final userId = widget.authStatus.user.id;

//   //   if (selectedHour.isEmpty) {
//   //     _showSnackBar('Vui lòng chọn giờ đặt tủ.');
//   //     return;
//   //   }

//   //   final response = await http.post(
//   //     Uri.parse('$endpoint/api/Otps/generatedotp'),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //       'Authorization': 'Bearer $token',
//   //     },
//   //   );

//   //   if (response.statusCode == 200) {
//   //     otp = jsonDecode(response.body)['otp'];
//   //     final response2 = await http.post(
//   //       Uri.parse('$endpoint/api/Otps/sendmail'),
//   //       body: jsonEncode({'userId': userId, 'otp': otp}),
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //         'Authorization': 'Bearer $token',
//   //       },
//   //     );
//   //     _showSnackBar('Đã gửi mã OTP qua gmail. Hãy kiểm tra email của bạn.');
//   //   } else if (response.statusCode == 400) {
//   //     print('Hết tủ');
//   //   } else if (response.statusCode == 401) {
//   //     print('Chưa đăng nhập');
//   //   } else {
//   //     print("Lỗi Server");
//   //   }
//   // }

//   Future<void> sendOTPRequest() async {
//     final token = await storage.read(key: 'token');
//     final userId = widget.authStatus.user.id;

//     if (selectedHour.isEmpty) {
//       _showSnackBar('Vui lòng chọn giờ đặt tủ.');
//       return;
//     }

//     // Chuyển đổi selectedHour thành định dạng "6h-7h"
//     final formattedHour = formatHourRange(selectedHour);

//     final response = await http.post(
//       Uri.parse('$endpoint/api/Otps/generatedotp'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'hour': formattedHour, 'userId': userId}),
//     );

//     if (response.statusCode == 200) {
//       otp = jsonDecode(response.body)['otp'];
//       final response2 = await http.post(
//         Uri.parse('$endpoint/api/Otps/sendmail'),
//         body: jsonEncode({'userId': userId, 'otp': otp}),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       _showSnackBar('Đã gửi mã OTP qua gmail. Hãy kiểm tra email của bạn.');
//     } else if (response.statusCode == 400) {
//       print('Hết tủ');
//     } else if (response.statusCode == 401) {
//       print('Chưa đăng nhập');
//     } else {
//       print("Lỗi Server");
//     }
//   }

//   void _showHourSelector() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return ListView(
//           children: availableHours.map((String hourRange) {
//             return ListTile(
//               title: Text(hourRange),
//               onTap: () {
//                 setState(() {
//                   selectedHour = hourRange;
//                 });
//                 Navigator.of(context).pop();
//               },
//             );
//           }).toList(),
//         );
//       },
//     );
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
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _showHourSelector();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     'Chọn giờ đặt tủ',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Giờ đã chọn: $selectedHour',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () {
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
import 'config.dart';

class OrderLocker extends StatefulWidget {
  final AuthStatus authStatus;
  OrderLocker({required this.authStatus});

  @override
  _OrderLockerState createState() => _OrderLockerState();
}

class _OrderLockerState extends State<OrderLocker> {
  String selectedRecipient = "Người nhận số 0";
  String selectedHour = '';
  String selectedLocation1 = "Location1"; // Điểm gửi mặc định
  String selectedLocation2 = "Location2"; // Điểm đến mặc định
  List<String> availableHours = [];
  // String selectedUserId = ''; // Thêm biến này để lưu trữ userId người được chọn
  List<Map<String, dynamic>> users = [];
  TextEditingController txtOtp = TextEditingController();
  String otp = '';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _generateAvailableHours();
    _setInitialHour();
  }

  Future<void> _loadUsers() async {
    final userIdLoggin = widget.authStatus.user.id;
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

      final filteredUsers =
          userList.where((user) => user['userId'] != userIdLoggin).toList();

      setState(() {
        users = filteredUsers;
        selectedRecipient = users.isNotEmpty ? users[0]['name'] : '';
        // selectedUserId = users.isNotEmpty ? users[0]['userId'] : '';
      });
    } else if (response.statusCode == 401) {
      print('Chưa đăng nhập');
    } else {
      print("Lỗi Server");
    }
  }

  void _generateAvailableHours() {
    final DateTime now = DateTime.now();
    final int currentHour = now.hour;

    availableHours = []; // Xóa danh sách cũ
    for (int hour = 6; hour < 18; hour++) {
      if (currentHour <= hour) {
        final String endHour = (hour == 17) ? '18' : (hour + 1).toString();
        final String hourRange = '$hour:00 - $endHour:00';
        availableHours.add(hourRange);
      }
    }
  }

  void _setInitialHour() {
    final DateTime now = DateTime.now();
    final int currentHour = now.hour;

    for (int hour = 6; hour < 18; hour++) {
      if (currentHour <= hour) {
        final String hourRange = '$hour:00 - ${(hour + 1) % 24}:00';

        setState(() {
          selectedHour = hourRange;
        });
        break;
      }
    }
  }

  List<DropdownMenuItem<String>> _buildRecipientItems() {
    return users.map((user) {
      final String name = user['name'] ?? '';
      final String phone = user['phone'] ?? '';
      return DropdownMenuItem<String>(
        value: name,
        child: Text('$name - $phone'),
      );
    }).toList();
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

  String formatHourRange(String hour) {
    final List<String> parts =
        hour.split('-'); // Tách thành 2 phần: "6h" và "7h"
    final String startHour = parts[0].trim();
    final String endHour = parts[1].trim();

    final formattedStartHour =
        startHour.padLeft(2, '0'); // Đảm bảo có 2 chữ số cho giờ
    final formattedEndHour =
        endHour.padLeft(2, '0'); // Đảm bảo có 2 chữ số cho giờ kết thúc

    return '$formattedStartHour - $formattedEndHour';
  }

  String getStartTime(String hourRange) {
    final List<String> parts = hourRange.split('-');
    if (parts.length == 2) {
      final String startTime = parts[0].trim();
      return startTime;
    }
    // Trả về một giá trị mặc định nếu định dạng không hợp lệ.
    return '';
  }

  Future<void> sendOTPRequest() async {
    final token = await storage.read(key: 'token');
    final userId = widget.authStatus.user.id;
    final userName = widget.authStatus.user.name;
    if (selectedHour.isEmpty) {
      _showSnackBar('Vui lòng chọn giờ đặt tủ.');
      return;
    }

    // Chuyển đổi selectedHour thành định dạng "6h-7h"
    final formattedHour = formatHourRange(selectedHour);

    // lấy được startTime
    final startTime = getStartTime(formattedHour);

    final response = await http.post(
      Uri.parse('$endpoint/api/Otps/generatedotp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'startTime': startTime,
        'userId': userId,
        'locationSend': selectedLocation1,
        'locationReceive': selectedLocation2,
      }),
    );

    if (response.statusCode == 200) {
      otp = jsonDecode(response.body)['otp'];
      String messageMail =
          "Hi $userName,\n\nYour OTP is $otp.\n\nUsing this for unlocked Smartlocker\n\nContact us: 0987654321";
          
      final response2 = await http.post(
        Uri.parse('$endpoint/api/Otps/sendmail'),
        body: jsonEncode({
          'userId': userId,
          'mailContent': messageMail
        }), // Sử dụng selectedUserId ở đây
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      _showSnackBar('Đã gửi mã OTP qua gmail. Hãy kiểm tra email của bạn.');
    } else if (response.statusCode == 400) {
      print('Hết tủ');
    } else if (response.statusCode == 401) {
      print('Chưa đăng nhập');
    } else {
      print("Lỗi Server");
    }
  }

  void _showHourSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: availableHours.map((String hourRange) {
            return ListTile(
              title: Text(hourRange),
              onTap: () {
                setState(() {
                  selectedHour = hourRange;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
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
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: selectedLocation1,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation1 = newValue!;
                    // Kiểm tra nếu selectedLocation2 giống selectedLocation1, cập nhật selectedLocation2
                    if (selectedLocation1 == selectedLocation2) {
                      selectedLocation2 = (selectedLocation1 == "Location1")
                          ? "Location2"
                          : "Location1";
                    }
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: "Location1",
                    child: Text("Điểm gửi: Location1"),
                  ),
                  DropdownMenuItem<String>(
                    value: "Location2",
                    child: Text("Điểm gửi: Location2"),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: selectedLocation2,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation2 = newValue!;
                    // Kiểm tra nếu selectedLocation1 giống selectedLocation2, cập nhật selectedLocation1
                    if (selectedLocation1 == selectedLocation2) {
                      selectedLocation1 = (selectedLocation2 == "Location1")
                          ? "Location2"
                          : "Location1";
                    }
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: "Location1",
                    child: Text("Điểm đến: Location1"),
                  ),
                  DropdownMenuItem<String>(
                    value: "Location2",
                    child: Text("Điểm đến: Location2"),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showHourSelector();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Chọn giờ đặt tủ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Giờ đã chọn: $selectedHour',
              style: TextStyle(fontSize: 16),
            ),
          ),
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
