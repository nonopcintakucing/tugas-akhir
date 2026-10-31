import 'package:flutter/material.dart';

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Siswa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 60,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Budi Santoso',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'XII RPL 1',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NIS: 12345'),
                    SizedBox(height: 10),
                    Text('Jurusan: Rekayasa Perangkat Lunak'),
                    SizedBox(height: 10),
                    Text('Tempat Lahir: Jakarta'),
                    SizedBox(height: 10),
                    Text('Tanggal Lahir: 10 Januari 2009'),
                    SizedBox(height: 10),
                    Text('Alamat: Jl. Merdeka No. 10, Jakarta'),
                    SizedBox(height: 10),
                    Text('No. HP: 081234567890'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}