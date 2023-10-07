class AuthStatus {
  bool isLoggedIn;
  User user;

  AuthStatus(this.isLoggedIn, this.user);

  // Thêm phương thức logout
  void logout() {
    isLoggedIn = false;
    user = User("defaultId", "defaultName", "defaultEmail", "defaultPhone",
        "defaultRole");
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

class Otp {
  final String otpId;
  final String otpCode;
  final String exe;
  final String userId;
  final String lockerId;
  Otp(this.otpId, this.otpCode, this.exe, this.userId, this.lockerId);
}

class History {
  final String historyId;
  final String userSend;
  final String lockerId;
  final String startTime;
  final String endTime;
  final String shipper;
  final String receiver;

  History({
    required this.historyId,
    required this.userSend,
    required this.lockerId,
    required this.startTime,
    required this.endTime,
    required this.shipper,
    required this.receiver,
  });
}

enum LockerStatus {
  on,
  off,
}

class Locker {
  final String lockerId;
  final String location;
  final LockerStatus status;

  Locker({
    required this.lockerId,
    required this.location,
    required this.status,
  });
}