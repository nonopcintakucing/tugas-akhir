
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageEdit extends StatefulWidget {
  final Map<String, dynamic> siswa;

  const PageEdit({
    super.key,
    required this.siswa,
  });

  @override
  State<PageEdit> createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  static const Color primaryColor = Color(0xFF5968E8);
  static const Color backgroundColor = Color(0xFFF4F5FF);
  static const Color textColor = Color(0xFF252B48);

  final String apiUrl = 'http://localhost:3000/siswa';

  final nipdController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final kelasController = TextEditingController();
  final jurusanController = TextEditingController();

  String? jenisKelamin;
  bool sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();

    nipdController.text =
        widget.siswa['nipd']?.toString() ?? '';

    namaController.text =
        widget.siswa['nama_lengkap']?.toString() ?? '';

    alamatController.text =
        widget.siswa['alamat']?.toString() ?? '';

    kelasController.text =
        widget.siswa['kelas']?.toString() ?? '';

    jurusanController.text =
        widget.siswa['jurusan']?.toString() ?? '';

    final jk = widget.siswa['jenis_kelamin']
        ?.toString()
        .trim()
        .toUpperCase();

    if (jk == 'L' || jk == 'LAKI-LAKI') {
      jenisKelamin = 'L';
    } else if (jk == 'P' || jk == 'PEREMPUAN') {
      jenisKelamin = 'P';
    }
  }

  Future<void> simpanPerubahan() async {
    if (nipdController.text.trim().isEmpty ||
        namaController.text.trim().isEmpty ||
        alamatController.text.trim().isEmpty ||
        kelasController.text.trim().isEmpty ||
        jurusanController.text.trim().isEmpty ||
        jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi'),
        ),
      );
      return;
    }

    final id = widget.siswa['id'];

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID siswa tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nipd': nipdController.text.trim(),
          'nama_lengkap': namaController.text.trim(),
          'jenis_kelamin': jenisKelamin,
          'alamat': alamatController.text.trim(),
          'kelas': kelasController.text.trim(),
          'jurusan': jurusanController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data siswa berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memperbarui data: ${response.body}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
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

  Widget inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: primaryColor,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            hintText: 'Masukkan $label',
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  void dispose() {
    nipdController.dispose();
    namaController.dispose();
    alamatController.dispose();
    kelasController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: textColor,
        ),
        title: const Text(
          'Edit Data Siswa',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perbarui Informasi Siswa',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 22),

                  inputField(
                    label: 'NIPD',
                    controller: nipdController,
                    icon: Icons.badge_outlined,
                  ),

                  inputField(
                    label: 'Nama Lengkap',
                    controller: namaController,
                    icon: Icons.person_outline,
                  ),

                  const Text(
                    'Jenis Kelamin',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: jenisKelamin,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
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

                  const SizedBox(height: 18),

                  inputField(
                    label: 'Alamat',
                    controller: alamatController,
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),

                  inputField(
                    label: 'Kelas',
                    controller: kelasController,
                    icon: Icons.school_outlined,
                  ),

                  inputField(
                    label: 'Jurusan',
                    controller: jurusanController,
                    icon: Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: sedangMenyimpan
                          ? null
                          : simpanPerubahan,
                      icon: sedangMenyimpan
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        sedangMenyimpan
                            ? 'Menyimpan...'
                            : 'Simpan Perubahan',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: sedangMenyimpan
                          ? null
                          : () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
