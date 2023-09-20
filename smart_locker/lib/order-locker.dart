import 'package:flutter/material.dart';

class OrderLocker extends StatefulWidget {
  @override
  _OrderLockerState createState() => _OrderLockerState();
}

class _OrderLockerState extends State<OrderLocker> {
  String selectedRecipient = "Người nhận số 0"; // Biến để lưu người nhận được chọn

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
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Tùy chỉnh khoảng cách xung quanh nút
                  child: Text(
                    'Xác nhận đặt tủ',
                    style: TextStyle(fontSize: 16), // Tùy chỉnh kích thước văn bản
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
