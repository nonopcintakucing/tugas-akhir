
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserServis {
  // Untuk Android Emulator dengan Laragon di laptop.
  static const String baseUrl =
      'http://10.0.2.2/apk_guru_api';

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final userData = data['user'];

      return User(
        id: int.parse(userData['id'].toString()),
        name: userData['name']?.toString() ??
            userData['username'].toString(),
        email: userData['email']?.toString() ??
            userData['username'].toString(),
        password: '',
      );
    }

    throw Exception(
      data['message'] ?? 'Login gagal',
    );
  }
}
