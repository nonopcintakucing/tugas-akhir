
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_guru/pages/page_edit.dart';
import 'package:apk_guru/pages/page_input.dart';

class PageLihatData extends StatefulWidget {
  const PageLihatData({super.key});

  @override
  State<PageLihatData> createState() => _PageLihatDataState();
}

class _PageLihatDataState extends State<PageLihatData> {
  static const Color primaryColor = Color(0xFF5968E8);
  static const Color backgroundColor = Color(0xFFF4F5FF);
  static const Color textColor = Color(0xFF252B48);

  final String apiUrl = 'http://localhost:3000/siswa';
  final TextEditingController cariController = TextEditingController();

  List<dynamic> daftarSiswa = [];
  bool sedangMemuat = true;
  String? pesanError;

  List<dynamic> get siswaTersaring {
    final kataKunci = cariController.text.toLowerCase();

    return daftarSiswa.where((data) {
      final nama =
          data['nama_lengkap']?.toString().toLowerCase() ?? '';
      final nipd = data['nipd']?.toString().toLowerCase() ?? '';

      return nama.contains(kataKunci) ||
          nipd.contains(kataKunci);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    ambilData();
    cariController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    cariController.dispose();
    super.dispose();
  }

  Future<void> ambilData() async {
    if (!mounted) return;

    setState(() {
      sedangMemuat = true;
      pesanError = null;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Server memberikan kode ${response.statusCode}');
      }

      final hasil = jsonDecode(response.body);

      if (hasil is! List) {
        throw Exception('Format data siswa tidak sesuai.');
      }

      if (!mounted) return;

      setState(() {
        daftarSiswa = hasil;
        sedangMemuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sedangMemuat = false;
        pesanError = e.toString();
      });
    }
  }

  Future<void> bukaEdit(Map<String, dynamic> siswa) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PageEdit(siswa: siswa),
      ),
    );

    if (!mounted) return;

    if (hasil == true) {
      ambilData();
    }
  }

  Future<void> bukaInput() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PageInput(),
      ),
    );

    if (!mounted) return;

    ambilData();
  }

  Future<void> hapusData(String id, String nama) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Hapus Data Siswa?',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Apakah kamu yakin ingin menghapus data $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );

      if (!mounted) return;

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data siswa berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );

        ambilData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus data: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Widget informasiSiswa(String label, String nilai, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 9),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kartuSiswa(Map<String, dynamic> siswa) {
    final id = siswa['id']?.toString() ?? '';
    final nipd = siswa['nipd']?.toString() ?? '-';
    final nama = siswa['nama_lengkap']?.toString() ?? '-';
    final jenisKelamin =
        siswa['jenis_kelamin']?.toString() ?? '-';
    final alamat = siswa['alamat']?.toString() ?? '-';
    final kelas = siswa['kelas']?.toString() ?? '-';
    final jurusan = siswa['jurusan']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EAFE)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5968E8),
                      Color(0xFF929BFA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIPD: $nipd',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  kelas,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Divider(color: Color(0xFFEEEEF5)),
          const SizedBox(height: 12),
          informasiSiswa('Jenis Kelamin', jenisKelamin, Icons.wc_rounded),
          informasiSiswa('Jurusan', jurusan, Icons.school_rounded),
          informasiSiswa('Alamat', alamat, Icons.location_on_outlined),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => bukaEdit(siswa),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: id.isEmpty ? null : () => hapusData(id, nama),
                  icon: const Icon(Icons.delete_outline, size: 17),
                  label: const Text('Hapus Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEEEE),
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        title: const Text(
          'Data Siswa',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            onPressed: sedangMemuat ? null : ambilData,
            icon: const Icon(
              Icons.refresh_rounded,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: sedangMemuat
          ? const Center(
        child: CircularProgressIndicator(color: primaryColor),
      )
          : pesanError != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 55,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal mengambil data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pesanError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: ambilData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: ambilData,
        color: primaryColor,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5968E8),
                    Color(0xFF8993F5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Data Siswa',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${daftarSiswa.length} Siswa',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Siswa',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: bukaInput,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: cariController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau NIPD...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: cariController.text.isNotEmpty
                    ? IconButton(
                  onPressed: cariController.clear,
                  icon: const Icon(Icons.close),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 18),
            if (siswaTersaring.isEmpty)
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      daftarSiswa.isEmpty
                          ? 'Belum ada data siswa'
                          : 'Data siswa tidak ditemukan',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ...siswaTersaring.map((data) {
              final siswa = Map<String, dynamic>.from(data);
              return kartuSiswa(siswa);
            }),
          ],
        ),
      ),
    );
  }
}
