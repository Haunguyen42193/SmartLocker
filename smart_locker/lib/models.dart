class AuthStatus {
  bool isLoggedIn;
  User user;

  AuthStatus(this.isLoggedIn, this.user);

  // Thêm phương thức logout
  void logout() {
    isLoggedIn = false;
    user = User("defaultId", "defaultName", "defaultEmail", "defaultPhone", "defaultRole");
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  User(this.id, this.name, this.email, this.phone, this.role);
}
