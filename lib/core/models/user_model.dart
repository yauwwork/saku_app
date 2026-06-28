class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['Password']?.toString() ?? json['password']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'Password': password,
      'avatar': avatar,
    };
  }
}
