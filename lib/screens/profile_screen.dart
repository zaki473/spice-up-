import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart'; // Pastikan file login_screen.dart sudah diimport

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

  // Fungsi untuk menampilkan Pop-up About App
  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("About App", style: TextStyle(color: Color(0xFFD35400), fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            "Spice Up! is a mobile-based educational game designed to help culinary students learn and master ingredient vocabulary in English, especially those related to Indonesian local cuisine. By combining interactive quizzes with engaging gameplay, the app provides a fun and practical way to build language skills that are directly applicable in real-world culinary settings.\n\n"
            "This application was developed by Team LUCK from Universitas Negeri Malang (UM) as part of an innovation project addressing the gap between academic English learning and contextual culinary communication. Spice Up! aims to support students in becoming more confident when interacting in international environments, such as the hospitality and tourism industries.\n\n"
            "Credits\nDeveloped by:\n• Aldila Nisa’\n• Nimas Ayu Sekar Lintang\n• Muhammad Zaki Athallah",
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close", style: TextStyle(color: Colors.orange))),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan Pop-up Terms & Conditions
  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Terms & Conditions", style: TextStyle(color: Color(0xFFD35400), fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Welcome to Spice Up!, a mobile educational game developed by Team LUCK from Universitas Negeri Malang (UM). By accessing or using this application, you agree to the following Terms and Conditions.\n", style: TextStyle(fontSize: 13)),
                Text("1. User Account", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("To access certain features, users may be required to create an account using a valid email address. You are responsible for maintaining the confidentiality of your account information.\n", style: TextStyle(fontSize: 13)),
                Text("2. Use of Email", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("By registering, you agree that Spice Up! may use your email for authentication, important updates, and security notices.\n", style: TextStyle(fontSize: 13)),
                Text("3. User Data & Privacy", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("We collect limited data like email, username, and gameplay progress to improve user experience and enable leaderboards.\n", style: TextStyle(fontSize: 13)),
                Text("4. Acceptable Use", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("You agree not to use the app for unlawful activities, hacking, or cheating.\n", style: TextStyle(fontSize: 13)),
                Text("5. Multiplayer", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Users are expected to maintain respectful behavior in shared environments.\n", style: TextStyle(fontSize: 13)),
                Text("6. Intellectual Property", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("All content is the property of Team LUCK and Universitas Negeri Malang.\n", style: TextStyle(fontSize: 13)),
                Text("7. Updates", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Terms may be modified at any time. Continued use indicates acceptance.\n", style: TextStyle(fontSize: 13)),
                Text("8. Limitation of Liability", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("The app is provided 'as is' without warranties.\n", style: TextStyle(fontSize: 13)),
                Text("9. Termination", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("We may suspend accounts that violate these terms.\n", style: TextStyle(fontSize: 13)),
                Text("10. Contact", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Questions? 📧 niamsfrog@gmail.com", style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("I Understand", style: TextStyle(color: Colors.orange))),
        ],
      ),
    );
  }

  Widget _renderPart(String path, double size) {
    if (path.isEmpty) return const SizedBox();
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
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      SvgPicture.asset('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: 100),
                      const Icon(Icons.notifications, color: Color(0xFFD35400), size: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Profile Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE67E22),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text('Profile', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
                                  width: 100, height: 120,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        _renderPart(skinPath, 90),
                                        Positioned(top: 35, child: _renderPart(browsPath, 40)),
                                        Positioned(top: 40, child: _renderPart(eyePath, 45)),
                                        Positioned(top: 55, child: _renderPart(nosePath, 12)),
                                        Positioned(top: 65, child: _renderPart(mouthPath, 18)),
                                        Positioned(top: 5, child: _renderPart(hairPath, 80)),
                                        Positioned(top: 12, child: _renderPart(bangsPath, 70)),
                                        Positioned(bottom: -5, child: _renderPart(shirtPath, 80)),
                                      ],
                                    ),
                                  ),
                                ),
                                const Positioned(top: 0, right: 0, child: Icon(Icons.edit_note, color: Colors.deepOrange)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text("UID: @AnggunNat", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        const SizedBox(width: 15),
                        // Info Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("ANGGUN", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFE67E22))),
                                  const Icon(Icons.edit_note, color: Colors.deepOrange),
                                ],
                              ),
                              const Text("Anggun Natasha Simanjuntak", style: TextStyle(fontSize: 12)),
                              const Divider(color: Colors.black54),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSmallInfo("School", "SMK Kota Blitar 1"),
                                  _buildSmallInfo("Birthday", "23/DEC/2006"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text("Badges", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                _buildMenuItem(Icons.vpn_key, "Change Password", () {}),

                const SizedBox(height: 20),

                _buildSectionHeader("Information"),
                _buildMenuItem(Icons.phone_android, "About App", () => _showAboutApp(context)),
                _buildMenuItem(Icons.description, "Terms & Conditions", () => _showTerms(context)),
                _buildMenuItem(Icons.exit_to_app, "Log out", () {
                  // Logout dan pindah ke halaman Login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFFFF4D2), borderRadius: BorderRadius.circular(20)),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD35400))),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD35400)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 18, color: Color(0xFFD35400), fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFD35400), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: color)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}