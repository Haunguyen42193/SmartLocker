import 'package:flutter/material.dart';
import 'models.dart';
import 'login_screen.dart';
import 'account.dart';
import 'order-locker.dart';
void main() => runApp(MyApp(authStatus: null));

class MyApp extends StatelessWidget {
  final AuthStatus? authStatus; // Sử dụng '?' để cho phép giá trị null

  MyApp({this.authStatus});

  @override
  Widget build(BuildContext context) {
    final effectiveAuthStatus = authStatus ??
        AuthStatus(
            false,
            User("defaultId", "defaultName", "defaultEmail", "defaultPhone",
                "defaultRole"));

    return MaterialApp(
      home: HomeScreen(authStatus: effectiveAuthStatus),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final AuthStatus authStatus; // Thêm tham số authStatus

  HomeScreen(
      {required this.authStatus}); // Sử dụng {} để đặt tham số là optional

  @override
  _HomeScreenState createState() => _HomeScreenState(authStatus: authStatus);
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0; // Sử dụng để theo dõi mục đang được chọn trong menu
  bool _showBackButton = false; // Để ẩn/hiện nút quay về
  final AuthStatus authStatus; // Thêm tham số authStatus
  final List<Widget> _children;

  _HomeScreenState({required this.authStatus})
      : _children = [
          Home(), // Trang chủ
          Reserve(
              authStatus: authStatus), // Đặt tủ và truyền authStatus vào đây
          Login(), // Đăng nhập
        ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _showBackButton = false; // Ẩn nút quay về khi chuyển tab
    });
  }

  void onLoginSuccess() {
    // Xử lý khi đăng nhập thành công
    setState(() {
      _showBackButton =
          true; // Hiển thị nút quay về sau khi đăng nhập thành công
    });
  }

  void onLogout() {
    // Xử lý khi đăng xuất
    widget.authStatus.logout(); // Đăng xuất người dùng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(authStatus: widget.authStatus),
      ),
    );
    setState(() {
      _showBackButton = false; // Ẩn nút quay về sau khi đăng xuất
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tủ để đồ thông minh'),
        automaticallyImplyLeading: _showBackButton, // Ẩn/hiện nút quay về
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 2 && widget.authStatus.isLoggedIn) {
            // Chuyển đến trang giao diện tài khoản và truyền đối tượng User
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreen(
                  user: widget.authStatus.user,
                  onLogout: onLogout, // Truyền hàm callback onLogout
                ),
              ),
            ).then((_) {});
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Đặt tủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: widget.authStatus.isLoggedIn ? 'Tài khoản' : 'Đăng nhập',
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Trang chủ'),
    );
  }
}

class Reserve extends StatelessWidget {
  final AuthStatus authStatus; // Thêm tham số authStatus

  Reserve({required this.authStatus}); // Sử dụng {} để đặt tham số là optional

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (authStatus.isLoggedIn) {
                // Đã đăng nhập, chuyển đến OrderLocker
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderLocker(authStatus: authStatus),
                  ),
                );
              } else {
                // Chưa đăng nhập, chuyển đến LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            child: Text('Bắt đầu đăng ký tủ'),
          ),
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Điều hướng đến màn hình đăng nhập khi nút được nhấn
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text('Bắt đầu đăng nhập'),
          ),
        ],
      ),
    );
  }
}
