
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageInput extends StatefulWidget {
  const PageInput({super.key});

  @override
  State<PageInput> createState() => _PageInputState();
}

class _PageInputState extends State<PageInput> {
  final nipdController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();

  String? jenisKelamin;
  String? kelas;
  String? jurusan;

  bool sedangMenyimpan = false;

  static const Color primaryColor = Color(0xFF5968E8);
  static const Color backgroundColor = Color(0xFFF4F5FF);
  static const Color textColor = Color(0xFF252B48);

  final String apiUrl = 'http://localhost:3000/siswa';

  void batalInput() {
    nipdController.clear();
    namaController.clear();
    alamatController.clear();

    setState(() {
      jenisKelamin = null;
      kelas = null;
      jurusan = null;
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form berhasil dikosongkan'),
      ),
    );
  }

  Future<void> simpanData() async {
    if (nipdController.text.trim().isEmpty ||
        namaController.text.trim().isEmpty ||
        jenisKelamin == null ||
        alamatController.text.trim().isEmpty ||
        kelas == null ||
        jurusan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi'),
        ),
      );
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nipd': nipdController.text.trim(),
          'nama_lengkap': namaController.text.trim(),
          'jenis_kelamin': jenisKelamin,
          'alamat': alamatController.text.trim(),
          'kelas': kelas,
          'jurusan': jurusan,
        }),
      );

      dynamic hasil;

      try {
        hasil = jsonDecode(response.body);
      } catch (_) {
        throw Exception('Respons server tidak dapat dibaca');
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (!mounted) return;

        nipdController.clear();
        namaController.clear();
        alamatController.clear();

        setState(() {
          jenisKelamin = null;
          kelas = null;
          jurusan = null;
        });

        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasil is Map
                  ? hasil['message']?.toString() ??
                  'Data siswa berhasil ditambahkan'
                  : 'Data siswa berhasil ditambahkan',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final pesan = hasil is Map
            ? hasil['message']?.toString() ??
            'Gagal menambahkan data siswa'
            : 'Gagal menambahkan data siswa';

        throw Exception(pesan);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nipdController.dispose();
    namaController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Input Data',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tambahkan siswa baru ke sistem',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF0FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KARTU JUDUL
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF5968E8),
                                Color(0xFF7885F4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tambah Siswa Baru',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Lengkapi informasi siswa pada formulir di bawah ini.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.school_rounded,
                                size: 65,
                                color: Color(0x77FFFFFF),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Informasi Siswa',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Masukkan data sesuai informasi siswa.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // FORM PUTIH
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFEBECF5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.03,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // NIPD
                              const Text(
                                'NIPD',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              TextField(
                                controller: nipdController,
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration(
                                  label: 'Masukkan NIPD',
                                  icon: Icons.badge_outlined,
                                ),
                              ),

                              const SizedBox(height: 22),

                              // NAMA LENGKAP
                              const Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              TextField(
                                controller: namaController,
                                textCapitalization:
                                TextCapitalization.words,
                                decoration: inputDecoration(
                                  label: 'Masukkan nama lengkap',
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),

                              const SizedBox(height: 22),

                              // JENIS KELAMIN
                              const Text(
                                'Jenis Kelamin',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              DropdownButtonFormField<String>(
                                value: jenisKelamin,
                                decoration: inputDecoration(
                                  label: 'Pilih jenis kelamin',
                                  icon: Icons.wc_rounded,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'L',
                                    child: Text('Laki-laki'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'P',
                                    child: Text('Perempuan'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    jenisKelamin = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 22),

                              // ALAMAT
                              const Text(
                                'Alamat',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              TextField(
                                controller: alamatController,
                                maxLines: 3,
                                decoration: inputDecoration(
                                  label: 'Masukkan alamat',
                                  icon: Icons.location_on_outlined,
                                ),
                              ),

                              const SizedBox(height: 22),

                              // KELAS
                              const Text(
                                'Kelas',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              DropdownButtonFormField<String>(
                                value: kelas,
                                decoration: inputDecoration(
                                  label: 'Pilih kelas',
                                  icon: Icons.class_outlined,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: '10',
                                    child: Text('10'),
                                  ),
                                  DropdownMenuItem(
                                    value: '11',
                                    child: Text('11'),
                                  ),
                                  DropdownMenuItem(
                                    value: '12',
                                    child: Text('12'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    kelas = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 22),

                              // JURUSAN
                              const Text(
                                'Jurusan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 9),
                              DropdownButtonFormField<String>(
                                value: jurusan,
                                decoration: inputDecoration(
                                  label: 'Pilih jurusan',
                                  icon: Icons.computer_rounded,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'RPL',
                                    child: Text('RPL'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'DKV',
                                    child: Text('DKV'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'TKJ 1',
                                    child: Text('TKJ 1'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'TKJ 2',
                                    child: Text('TKJ 2'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BIDI 1',
                                    child: Text('BIDI 1'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BIDI 2',
                                    child: Text('BIDI 2'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BIDI 3',
                                    child: Text('BIDI 3'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    jurusan = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 30),

                              const Divider(
                                color: Color(0xFFEBECF5),
                              ),

                              const SizedBox(height: 20),

                              // TOMBOL
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  if (constraints.maxWidth < 400) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: sedangMenyimpan
                                              ? null
                                              : batalInput,
                                          icon: const Icon(
                                            Icons.close_rounded,
                                          ),
                                          label: const Text('Batal'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: primaryColor,
                                            side: const BorderSide(
                                              color: primaryColor,
                                            ),
                                            minimumSize:
                                            const Size.fromHeight(48),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton.icon(
                                          onPressed: sedangMenyimpan
                                              ? null
                                              : simpanData,
                                          icon: sedangMenyimpan
                                              ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                              : const Icon(
                                            Icons.save_outlined,
                                          ),
                                          label: Text(
                                            sedangMenyimpan
                                                ? 'Menyimpan...'
                                                : 'Simpan Data',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            minimumSize:
                                            const Size.fromHeight(48),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: sedangMenyimpan
                                              ? null
                                              : batalInput,
                                          icon: const Icon(
                                            Icons.close_rounded,
                                          ),
                                          label: const Text('Batal'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: primaryColor,
                                            side: const BorderSide(
                                              color: primaryColor,
                                            ),
                                            minimumSize:
                                            const Size.fromHeight(52),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: sedangMenyimpan
                                              ? null
                                              : simpanData,
                                          icon: sedangMenyimpan
                                              ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                              : const Icon(
                                            Icons.save_outlined,
                                          ),
                                          label: Text(
                                            sedangMenyimpan
                                                ? 'Menyimpan...'
                                                : 'Simpan Data',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            minimumSize:
                                            const Size.fromHeight(52),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: Text(
                            'Manajemen Data Siswa • XII RPL',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: primaryColor,
        size: 21,
      ),
      filled: true,
      fillColor: const Color(0xFFF9F9FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEBECF5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEBECF5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}
