import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
      title: const Text('Aplikasi Flutter'),
      backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
      
      body: const Center(
        child: Text(
            'Hallo Selamat Datang di Aplikasi Mobile',
        style: TextStyle(color: Colors.lightBlue, fontSize: 30
        ),
      ),
      ),

    );
  }
}