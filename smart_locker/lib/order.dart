import 'package:flutter/material.dart';
import 'models.dart';
class OrderList extends StatefulWidget {
  final AuthStatus authStatus;
  OrderList({required this.authStatus});
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    // Đây là nơi bạn sẽ hiển thị danh sách các đơn hàng
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          // Tạo giao diện cho từng đơn hàng dựa vào index
          return ListTile(
            title: Text('Đơn hàng số $index'),
            // ... Thêm thông tin và giao diện cho từng đơn hàng ở đây
          );
        },
      ),
    );
  }
}
