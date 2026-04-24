import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileSettingPage(
        skinPath: '',
        eyePath: '',
        mouthPath: '',
        nosePath: '',
        browsPath: '',
        hairPath: '',
        bangsPath: '',
        shirtPath: '',
        shirtColor: Colors.blue,
        hairStyle: Icons.person,
      ),
    );
  }
}

class ProfileSettingPage extends StatelessWidget {
  final String skinPath;
  final String eyePath;
  final String mouthPath;
  final String nosePath;
  final String browsPath;
  final String hairPath;
  final String bangsPath;
  final String shirtPath;
  final Color shirtColor;
  final IconData hairStyle;

  const ProfileSettingPage({
    super.key,
    required this.skinPath,
    required this.eyePath,
    required this.mouthPath,
    required this.nosePath,
    required this.browsPath,
    required this.hairPath,
    required this.bangsPath,
    required this.shirtPath,
    required this.shirtColor,
    required this.hairStyle,
  });

  Widget _renderPart(String path, double size) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: size, fit: BoxFit.contain);
    } else {
      return Image.asset(path, width: size, fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9A84D), Color(0xFFFFE39C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Header (Logo & Bell)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // Spacer
                      SvgPicture.asset(
                        'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      const Icon(
                        Icons.notifications,
                        color: Color(0xFFD35400),
                        size: 30,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Profile Label Banner
                // Cari bagian Profile Label Banner di kode sebelumnya, lalu ubah menjadi seperti ini:
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // Fungsi untuk kembali ke halaman sebelumnya
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE67E22),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFCF0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Section
                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        _renderPart(skinPath, 90),
                                        Positioned(
                                          top: 35,
                                          child: _renderPart(browsPath, 40),
                                        ),
                                        Positioned(
                                          top: 40,
                                          child: _renderPart(eyePath, 45),
                                        ),
                                        Positioned(
                                          top: 55,
                                          child: _renderPart(nosePath, 12),
                                        ),
                                        Positioned(
                                          top: 65,
                                          child: _renderPart(mouthPath, 18),
                                        ),
                                        Positioned(
                                          top: 5,
                                          child: _renderPart(hairPath, 80),
                                        ),
                                        Positioned(
                                          top: 12,
                                          child: _renderPart(bangsPath, 70),
                                        ),
                                        Positioned(
                                          bottom: -5,
                                          child: _renderPart(shirtPath, 80),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: const Icon(
                                    Icons.edit_note,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "UID: @AnggunNat",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        // Info Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "ANGGUN",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFE67E22),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_note,
                                    color: Colors.deepOrange,
                                  ),
                                ],
                              ),
                              const Text(
                                "Anggun Natasha Simanjuntak",
                                style: TextStyle(fontSize: 12),
                              ),
                              const Divider(color: Colors.black54),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSmallInfo(
                                    "School",
                                    "SMK Kota Blitar 1",
                                  ),
                                  _buildSmallInfo("Birthday", "23/DEC/2006"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Badges",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  _buildBadge(Icons.eco, Colors.orange),
                                  const SizedBox(width: 10),
                                  _buildBadge(Icons.soup_kitchen, Colors.blue),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Menu Sections
                _buildSectionHeader("General Settings"),
                _buildMenuItem(Icons.vpn_key, "Change Password"),

                const SizedBox(height: 20),

                _buildSectionHeader("Information"),
                _buildMenuItem(Icons.phone_android, "About App"),
                _buildMenuItem(Icons.description, "Terms & Conditions"),
                _buildMenuItem(Icons.exit_to_app, "Log out"),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Header Section (General Settings / Information)
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4D2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD35400),
          ),
        ),
      ),
    );
  }

  // Widget untuk List Item Menu
  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD35400)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFD35400),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFD35400),
            size: 18,
          ),
        ],
      ),
    );
  }

  // Helper untuk info kecil di kartu
  Widget _buildSmallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Helper untuk Badge
  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
