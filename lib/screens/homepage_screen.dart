import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import 'levels_screen.dart';
import 'multiplayer_lobby_screen.dart';
import 'spice_journal_screen.dart';
import 'profile_screen.dart';

class HomepageScreen extends StatelessWidget {
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

  const HomepageScreen({
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

  // Fungsi Helper Render Gambar (SVG atau PNG)
  Widget _renderPart(String path, double size) {
    if (path.isEmpty) return const SizedBox();
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: size, fit: BoxFit.contain);
    } else {
      return Image.asset(path, width: size, fit: BoxFit.contain);
    }
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSettingPage(
          skinPath: skinPath,
          eyePath: eyePath,
          mouthPath: mouthPath,
          nosePath: nosePath,
          browsPath: browsPath,
          hairPath: hairPath,
          bangsPath: bangsPath,
          shirtPath: shirtPath,
          shirtColor: shirtColor,
          hairStyle: hairStyle,
        ),
      ),
    );
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
          child: Stack(
            children: [
              Column(
                children: [
                  // --- HEADER ---
                  _buildHeader(context),

                  // --- PROFILE CARD (FIXED AVATAR POSITIONS) ---
                  _buildProfileCard(context),

                  // --- SEARCH BAR ---
                  _buildSearchBar(),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recently Played',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD35400)),
                      ),
                    ),
                  ),

                  // --- RECIPE GRID (FIXED IMAGE SIZE) ---
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78, // Diperpanjang sedikit ke bawah
                        children: [
                          _buildRecipeCard(context, 'Mi Gomak', 'Batak Spicy Noodles', 3, 'assets/food/SU_FOOD_01_MI_GOMAK.png'),
                          _buildRecipeCard(context, 'Ikan Kuah Kuning', 'Yellow Turmeric Fish Soup', 4, 'assets/food/SU_FOOD_01_IKAN_KUAH_KUNING.png'),
                          _buildRecipeCard(context, 'Ayam Betutu', 'Balinese Spiced Chicken', 4, 'assets/food/SU_FOOD_03_AYAMBETUTU.png'),
                          _buildRecipeCard(context, 'Coto Makassar', 'Sulawesi Beef Soup', 5, 'assets/food/SU_FOOD_03_COTOMAKASSAR.png'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),

              // --- FLOATING BOTTOM NAV ---
              Align(alignment: Alignment.bottomCenter, child: _buildBottomNav(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _goToProfile(context),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange),
            ),
          ),
          SvgPicture.asset('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: 100),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => _goToProfile(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.shade200, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              // AVATAR AREA (FIXED POSITIONS)
              Container(
                width: 80, height: 100,
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 350,
                      height: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // BASE
                          _renderPart(skinPath, 350),

                          // RAMBUT BELAKANG
                          Positioned(
                            top: -350 * 0.14,
                            child: _renderPart(hairPath, 350 * 1.14),
                          ),

                          // ALIS
                          Positioned(
                            top: 350 * 0.20,
                            child: _renderPart(browsPath, 350 * 0.26),
                          ),

                          // MATA
                          Positioned(
                            top: 350 * 0.25,
                            child: _renderPart(eyePath, 350 * 0.36),
                          ),

                          // HIDUNG
                          Positioned(
                            top: 350 * 0.41,
                            child: _renderPart(nosePath, 350 * 0.055),
                          ),

                          // MULUT
                          Positioned(
                            top: 350 * 0.50,
                            child: _renderPart(mouthPath, 350 * 0.13),
                          ),

                          // PONI
                          Positioned(
                            top: -350 * 0.01,
                            child: _renderPart(bangsPath, 350 * 0.48),
                          ),

                          // BAJU
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(0, -16),
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: _renderPart(shirtPath, 350 * 3.30),
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
              const SizedBox(width: 15),
              // INFO AREA
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                    String displayName = 'Full Name';
                    Map<String, dynamic>? data;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null && data['full_name'] != null && data['full_name'] != '') {
                        displayName = data['full_name'];
                      } else if (data != null && data['display_name'] != null && data['display_name'] != '') {
                        displayName = data['display_name']; // Fallback jika belum punya full_name
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                        Text(FirebaseAuth.instance.currentUser?.email ?? '-', style: const TextStyle(fontSize: 11, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const Divider(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMiniInfo('School', data != null && data['school'] != null && data['school'] != '' ? data['school'] : '-'),
                            _buildMiniInfo('Birthday', data != null && data['birthday'] != null && data['birthday'] != '' ? data['birthday'] : '-'),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search Recipes...',
            prefixIcon: Icon(Icons.search, color: Colors.orange),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, String title, String subtitle, int stars, String imagePath) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.orange.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Column(
      children: [
        // 1. BAGIAN GAMBAR (DIBUAT PRESISI & LEBIH BESAR)
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(6), // Margin tipis agar ada list putih di luar
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBD2), 
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Memotong gambar agar melengkung pas dengan kotak
              child: Image.asset(
                imagePath, 
                fit: BoxFit.cover, // Membuat gambar memenuhi kotak secara presisi
                errorBuilder: (c, e, s) => const Icon(Icons.fastfood, color: Colors.orange, size: 40),
              ),
            ),
          ),
        ),
        
        // 2. BAGIAN TEKS
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF3E2723)), 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle, 
                  style: const TextStyle(fontSize: 10, color: Colors.grey), 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (i) => Icon(
                        Icons.star, 
                        size: 12, 
                        color: i < stars ? Colors.orange : Colors.grey.shade300
                      )),
                    ),
                    const Icon(Icons.play_circle_fill, color: Colors.orange, size: 24),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(35), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.home, color: Colors.orange, size: 30),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LevelsScreen(skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle)))
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.grey), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SpiceJournalScreen(skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle)))
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MultiplayerLobbyScreen(skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor))),
          ),
        ],
      ),
    );
  }
}