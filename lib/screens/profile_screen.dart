import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'forgot_password_screen.dart';
import 'customization_screen.dart';

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

  void _editProfileData(
    BuildContext context,
    Map<String, dynamic> currentData,
  ) {
    TextEditingController fullNameCtrl = TextEditingController(
      text: currentData['full_name'] ?? '',
    );
    TextEditingController schoolCtrl = TextEditingController(
      text: currentData['school'] ?? '',
    );
    TextEditingController birthdayCtrl = TextEditingController(
      text: currentData['birthday'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Profile Info",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fullNameCtrl,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: schoolCtrl,
              decoration: const InputDecoration(labelText: "School"),
            ),
            TextField(
              controller: birthdayCtrl,
              decoration: const InputDecoration(
                labelText: "Birthday (DD/MM/YYYY)",
                hintText: "e.g., 23/12/2006",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                    'full_name': fullNameCtrl.text.trim(),
                    'school': schoolCtrl.text.trim(),
                    'birthday': birthdayCtrl.text.trim(),
                  }, SetOptions(merge: true));
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan Pop-up About App
  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "About App",
          style: TextStyle(
            color: Color(0xFFD35400),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Spice Up! is a mobile-based educational game designed to help culinary students learn and master ingredient vocabulary in English, especially those related to Indonesian local cuisine. By combining interactive quizzes with engaging gameplay, the app provides a fun and practical way to build language skills that are directly applicable in real-world culinary settings.\n\n"
            "This application was developed by Team LUCK from Universitas Negeri Malang (UM) as part of an innovation project addressing the gap between academic English learning and contextual culinary communication. Spice Up! aims to support students in becoming more confident when interacting in international environments, such as the hospitality and tourism industries.\n\n"
            "Credits\nDeveloped by:\n• Aldila Nisa’\n• Nimas Ayu Sekar Lintang\n• Muhammad Zaki Athallah",
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.orange)),
          ),
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
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Color(0xFFD35400),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome to Spice Up!, a mobile educational game developed by Team LUCK from Universitas Negeri Malang (UM). By accessing or using this application, you agree to the following Terms and Conditions.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "1. User Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "To access certain features, users may be required to create an account using a valid email address. You are responsible for maintaining the confidentiality of your account information.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "2. Use of Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "By registering, you agree that Spice Up! may use your email for authentication, important updates, and security notices.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "3. User Data & Privacy",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "We collect limited data like email, username, and gameplay progress to improve user experience and enable leaderboards.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "4. Acceptable Use",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "You agree not to use the app for unlawful activities, hacking, or cheating.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "5. Multiplayer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Users are expected to maintain respectful behavior in shared environments.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "6. Intellectual Property",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "All content is the property of Team LUCK and Universitas Negeri Malang.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "7. Updates",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Terms may be modified at any time. Continued use indicates acceptance.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "8. Limitation of Liability",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "The app is provided 'as is' without warranties.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "9. Termination",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "We may suspend accounts that violate these terms.\n",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "10. Contact",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Questions? 📧 niamsfrog@gmail.com",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "I Understand",
              style: TextStyle(color: Colors.orange),
            ),
          ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      SvgPicture.asset(
                        'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                        width: 100,
                      ),
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
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors
                                        .orange
                                        .shade50, // Tambahan warna bg agar manis
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      child: SizedBox(
                                        width: 350, // avatarSize dasar
                                        height: 350,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.none,
                                          children: [
                                            // BASE
                                            _renderPart(skinPath, 350),

                                            // RAMBUT BELAKANG
                                            Positioned(
                                              top: -350 * 0.15,
                                              left: 350 * -0.11,
                                              child: _renderPart(
                                                hairPath,
                                                350 * 1.24,
                                              ),
                                            ),

                                            // ALIS
                                            Positioned(
                                              top: 350 * 0.25,
                                              child: _renderPart(
                                                browsPath,
                                                350 * 0.31,
                                              ),
                                            ),

                                            // MATA
                                            Positioned(
                                              top: 350 * 0.29,
                                              child: _renderPart(
                                                eyePath,
                                                350 * 0.39,
                                              ),
                                            ),

                                            // HIDUNG
                                            Positioned(
                                              top: 350 * 0.45,
                                              child: _renderPart(
                                                nosePath,
                                                350 * 0.055,
                                              ),
                                            ),

                                            // MULUT
                                            Positioned(
                                              top: 350 * 0.5,
                                              child: _renderPart(
                                                mouthPath,
                                                350 * 0.13,
                                              ),
                                            ),

                                            // PONI
                                            Positioned(
                                              top: -350 * -0.03,
                                              child: _renderPart(
                                                bangsPath,
                                                350 * 0.53,
                                              ),
                                            ),

                                            // BAJU
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: Transform.translate(
                                                  offset: const Offset(
                                                    5,
                                                    -10,
                                                  ), // kanan & sedikit turun
                                                  child: Transform.scale(
                                                    scale: 1.2,
                                                    child: _renderPart(
                                                      shirtPath,
                                                      350 * 3.31,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CharacterCustomizationScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit_note,
                                        color: Colors.deepOrange,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                        const SizedBox(width: 15),
                        // Info Section
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              var data =
                                  snapshot.data!.data()
                                      as Map<String, dynamic>? ??
                                  {};
                              String displayName = data['full_name'] ?? '-';
                              String email =
                                  FirebaseAuth.instance.currentUser!.email ??
                                  '-';
                              String school = data['school'] ?? '-';
                              String birthday = data['birthday'] ?? '-';

                              List<dynamic> unlockedBadges =
                                  data['unlocked_badges'] is List
                                  ? data['unlocked_badges']
                                  : [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          displayName.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFFE67E22),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _editProfileData(context, data),
                                        child: const Icon(
                                          Icons.edit_note,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    email,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(color: Colors.black54),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildSmallInfo("School", school),
                                      _buildSmallInfo("Birthday", birthday),
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
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (unlockedBadges.isEmpty)
                                          const Text(
                                            "No badges yet",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        if (unlockedBadges.contains(
                                          "SPICE SPROUT",
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: _buildSvgBadge(
                                              'assets/badges/SU_BADGES_01.svg',
                                              Colors.orange.shade800,
                                              "SPICE SPROUT",
                                            ),
                                          ),
                                        if (unlockedBadges.contains(
                                          "LITTLE MORTAR",
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: _buildSvgBadge(
                                              'assets/badges/SU_BADGES_02.svg',
                                              Colors.cyan.shade600,
                                              "LITTLE MORTAR",
                                            ),
                                          ),
                                        if (unlockedBadges.contains(
                                          "BUMBU BUDDY",
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: _buildSvgBadge(
                                              'assets/badges/SU_BADGES_03.svg',
                                              Colors.pinkAccent,
                                              "BUMBU BUDDY",
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Menu Sections
                _buildSectionHeader("General Settings"),
                _buildMenuItem(Icons.vpn_key, "Change Password", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                _buildSectionHeader("Information"),
                _buildMenuItem(
                  Icons.phone_android,
                  "About App",
                  () => _showAboutApp(context),
                ),
                _buildMenuItem(
                  Icons.description,
                  "Terms & Conditions",
                  () => _showTerms(context),
                ),
                _buildMenuItem(Icons.exit_to_app, "Log out", () {
                  // Logout dan pindah ke halaman Login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
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
      ),
    );
  }

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

  Widget _buildSvgBadge(String path, Color color, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: SvgPicture.asset(
            path,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontSize: 8,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
