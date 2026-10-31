
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_guru/pages/page_dashboard.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordTersembunyi = true;
  bool sedangLogin = false;

  static const Color babyBlue = Color(0xFFB9E5FF);
  static const Color darkBlue = Color(0xFF0058A1);

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password wajib diisi'),
        ),
      );
      return;
    }

    setState(() {
      sedangLogin = true;
    });

    try {
      final response = await http
          .post(
        Uri.parse('http://localhost:3000/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> hasil = {};

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          hasil = decoded;
        }
      } catch (_) {
        // Respons server bukan JSON.
      }

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageDashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasil['message']?.toString() ??
                  'Email atau password salah',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server. Periksa koneksi API.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangLogin = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: babyBlue.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_outlined,
                    size: 48,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Login untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                ),

                const SizedBox(height: 32),

                // Input Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !sedangLogin,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: darkBlue,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4FAFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Input Password
                TextField(
                  controller: passwordController,
                  obscureText: passwordTersembunyi,
                  enabled: !sedangLogin,
                  onSubmitted: (_) {
                    if (!sedangLogin) login();
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: darkBlue,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordTersembunyi =
                          !passwordTersembunyi;
                        });
                      },
                      icon: Icon(
                        passwordTersembunyi
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: darkBlue,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4FAFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: sedangLogin ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: babyBlue,
                      foregroundColor: darkBlue,
                      disabledBackgroundColor:
                      babyBlue.withOpacity(0.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: sedangLogin
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: darkBlue,
                      ),
                    )
                        : const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  '✦  Simple • Soft • Productive  ✦',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8AAFC8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
