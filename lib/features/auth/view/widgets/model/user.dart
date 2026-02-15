class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;

  const UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
  });

  UserModel copyWith({String? name, String? email, String? id, String? token}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      token: json['token'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token)';
  }
}
