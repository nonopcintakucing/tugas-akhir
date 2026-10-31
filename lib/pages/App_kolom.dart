import 'package:flutter/material.dart';

class AppKolom extends StatelessWidget{
  const AppKolom({super.key});

  @override
  Widget build (BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Flutter'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),

        body: Center(

        child: Column(
          children: [
            Text("Hallo...\n"),
            Text("Selamat Datang di Flutter\n"),
            Text("dan Selamat Bereksplorasi\n"),

            const TextField(
              decoration: InputDecoration(
                hintText: 'Masukan nama kamu',
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  print('Di tekan');
                }, child: Text('Simpan')
            ),

            const SizedBox(height: 30),

            ElevatedButton(
                onPressed: () {
                  print('Di tekan');
                }, child: Text('Batal')
            ),
          ],
        ),
    ),
    );
  }
}