
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_guru/pages/page_input.dart';
import 'package:apk_guru/pages/page_login.dart';
import 'package:apk_guru/pages/page_edit.dart';

class PageDashboard extends StatefulWidget {
  const PageDashboard({super.key});

  @override
  State<PageDashboard> createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {
  static const Color primaryColor = Color(0xFF5968E8);
  static const Color backgroundColor = Color(0xFFF4F5FF);
  static const Color textColor = Color(0xFF252B48);

  final String apiUrl = 'http://localhost:3000/siswa';
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> dataSiswa = [];
  bool loading = true;
  String? errorMessage;
  String kataPencarian = '';

  @override
  void initState() {
    super.initState();
    ambilDataSiswa();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // AMBIL DATA DARI API
  Future<void> ambilDataSiswa() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> hasil = jsonDecode(response.body);

        setState(() {
          dataSiswa = hasil
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = 'Gagal mengambil data siswa.';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'Tidak dapat terhubung ke server.';
      });
    }
  }

  // BUKA HALAMAN INPUT
  Future<void> bukaInput() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PageInput(),
      ),
    );

    ambilDataSiswa();
  }

  // BUKA HALAMAN EDIT
  Future<void> bukaEdit(Map<String, dynamic> siswa) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PageEdit(siswa: siswa),
      ),
    );

    ambilDataSiswa();
  }

  // HAPUS DATA SISWA
  Future<void> hapusData(Map<String, dynamic> siswa) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: Text(
          'Apakah kamu yakin ingin menghapus data ${siswa['nama_lengkap']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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
        Uri.parse('$apiUrl/${siswa['id']}'),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        tampilkanPesan('Data siswa berhasil dihapus.');
        ambilDataSiswa();
      } else {
        tampilkanPesan('Gagal menghapus data siswa.');
      }
    } catch (e) {
      tampilkanPesan('Tidak dapat terhubung ke server.');
    }
  }

  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  void keluarAplikasi() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const PageLogin(),
      ),
          (route) => false,
    );
  }

  // DATA YANG SUDAH DIFILTER
  List<Map<String, dynamic>> get dataTerfilter {
    return dataSiswa.where((siswa) {
      final nama = (siswa['nama_lengkap'] ?? '')
          .toString()
          .toLowerCase();

      final nipd = (siswa['nipd'] ?? '')
          .toString()
          .toLowerCase();

      final pencarian = kataPencarian.toLowerCase();

      return nama.contains(pencarian) ||
          nipd.contains(pencarian);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool desktop = constraints.maxWidth >= 850;

        return Scaffold(
          backgroundColor: backgroundColor,
          drawer: desktop
              ? null
              : Drawer(
            child: sidebarContent(context),
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (desktop) sidebar(context),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          children: [
                            if (!desktop) ...[
                              Builder(
                                builder: (context) => IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: const Icon(Icons.menu),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dashboard',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Selamat datang di Manajemen Data Siswa',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.school_outlined,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // KARTU SELAMAT DATANG
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF5968E8),
                                Color(0xFF7885F4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Halo, Selamat Datang!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Kelola seluruh data siswa dengan mudah '
                                          'melalui halaman dashboard ini.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (constraints.maxWidth >= 500)
                                const Icon(
                                  Icons.dashboard_customize_rounded,
                                  color: Color(0x77FFFFFF),
                                  size: 75,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // JUDUL DATA SISWA
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Data Siswa',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Kelola informasi seluruh siswa.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton.icon(
                              onPressed: bukaInput,
                              icon: const Icon(
                                Icons.add,
                                size: 19,
                              ),
                              label: const Text('Tambah Siswa'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // JUMLAH SISWA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF0FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.people_alt_outlined,
                                  color: primaryColor,
                                  size: 27,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Data Siswa',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${dataSiswa.length} Siswa',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // PENCARIAN
                        TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              kataPencarian = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari nama atau NIPD siswa...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DAFTAR DATA SISWA
                        if (loading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          )
                        else if (errorMessage != null)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: ambilDataSiswa,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
                        else if (dataTerfilter.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.folder_open_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Data siswa belum tersedia.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...dataTerfilter.map((siswa) {
                              return kartuSiswa(siswa);
                            }),

                        const SizedBox(height: 25),

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
              ],
            ),
          ),
        );
      },
    );
  }

  // KARTU DATA SISWA
  Widget kartuSiswa(Map<String, dynamic> siswa) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFEBECF5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: primaryColor,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siswa['nama_lengkap']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'NIPD: ${siswa['nipd'] ?? '-'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          informasiSiswa(
            Icons.wc_outlined,
            'Jenis Kelamin',
            siswa['jenis_kelamin']?.toString() ?? '-',
          ),

          const SizedBox(height: 10),

          informasiSiswa(
            Icons.class_outlined,
            'Kelas',
            siswa['kelas']?.toString() ?? '-',
          ),

          const SizedBox(height: 10),

          informasiSiswa(
            Icons.computer_outlined,
            'Jurusan',
            siswa['jurusan']?.toString() ?? '-',
          ),

          const SizedBox(height: 10),

          informasiSiswa(
            Icons.location_on_outlined,
            'Alamat',
            siswa['alamat']?.toString() ?? '-',
          ),

          const SizedBox(height: 18),

          // TOMBOL EDIT DAN HAPUS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => bukaEdit(siswa),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => hapusData(siswa),
                  icon: const Icon(Icons.delete_outline, size: 17),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76878),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // INFORMASI SISWA
  Widget informasiSiswa(
      IconData icon,
      String judul,
      String isi,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 105,
          child: Text(
            judul,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            isi,
            style: const TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // SIDEBAR DESKTOP
  Widget sidebar(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: sidebarContent(context),
    );
  }

  // ISI SIDEBAR
  Widget sidebarContent(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 16, 30),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'SiswaKu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'MENU UTAMA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 12),

          sidebarItem(
            icon: Icons.dashboard_rounded,
            title: 'Dashboard',
            selected: true,
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              ambilDataSiswa();
            },
          ),

          const Spacer(),

          sidebarItem(
            icon: Icons.logout_rounded,
            title: 'Keluar Aplikasi',
            onTap: keluarAplikasi,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ITEM SIDEBAR
  Widget sidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Material(
        color: selected
            ? const Color(0xFFEEF0FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: selected
                  ? const Border(
                left: BorderSide(
                  color: primaryColor,
                  width: 3,
                ),
              )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? primaryColor
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selected
                          ? primaryColor
                          : Colors.grey.shade700,
                    ),
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
