
class User {
  int id;
  String name;
  String email;
  String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
