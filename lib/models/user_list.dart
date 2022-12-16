

class UserList{
  final String userName;
  final String name;
  final String surName;
  final String phone;
  final String country;
  final String password;
  final String registerDate;
  final bool blocked;
  final String userId;
  final String userStatus;
  final String userRole;

  UserList({required this.userName, required this.name, required this.surName, required this.phone, required this.country, required this.password, required this.registerDate, required this.blocked, required this.userId, required this.userStatus, required this.userRole});

  factory UserList.fromJson(Map<String, dynamic> json){
    return UserList(
      userName: json['username'],
      name: json['name'],
      surName: json['surname'],
      phone: json['phone'],
      country: json['country'],
      password: json['password'],
      registerDate: json['register_date'],
      blocked: json['blocked'],
      userId: json['user_id'],
      userStatus: json['user_status'],
      userRole: json['user_role'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'username': userName,
      'name': name,
      'surname': surName,
      'phone': phone,
      'country': country,
      'password': password,
      'register_date': registerDate,
      'blocked': blocked,
      'user_id': userId,
      'user_status': userStatus,
      'user_role': userRole,
    };
  }
}