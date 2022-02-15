class User {
  int userId;
  String userName;
  String userRole;
  String userPass;
  User({
    this.userId,
    this.userName,
    this.userRole,
    this.userPass,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (userId != null) {
      data["user_id"] = userId;
    }
    data["user_name"] = userName;
    data["user_role"] = userRole;
    data["user_pass"] = userPass;
    return data;
  }

  User.fromMap(Map<String, dynamic> map) {
    userId = map["user_id"];
    userName = map["user_name"];
    userRole = map["user_role"];
    userPass = map["user_pass"];
  }
}
