class User {
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatar,
  });

  final int? id;
  final String name;
  final String email;
  final String password;
  final String? avatar;

  static String table = "users";

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "avatar": avatar,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
    );
  }
}
