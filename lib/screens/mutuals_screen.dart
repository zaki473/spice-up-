import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';
import 'profile_screen.dart'; // <--- PASTIKAN IMPORT INI ADA

class MutualsScreen extends StatelessWidget {
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

  const MutualsScreen({
    super.key,
    this.skinPath = 'assets/images/avatar/skin/SKIN_01.svg',
    this.eyePath = 'assets/images/avatar/eyes/EYE_01.svg',
    this.mouthPath = 'assets/images/avatar/mouth/MOUTH_01.svg',
    this.nosePath = 'assets/images/avatar/nose/NOSE_01.svg',
    this.browsPath = 'assets/images/avatar/brows/BROW_01.svg',
    this.hairPath = 'assets/images/avatar/hair/HAIR_01.svg',
    this.bangsPath = 'assets/images/avatar/bangs/BANGS_01.svg',
    this.shirtPath = 'assets/images/avatar/shirt/SHIRT_01.svg',
    this.shirtColor = Colors.orange,
    this.hairStyle = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context), // <--- Tambahkan context di sini
              _buildSearchBar(),
              _buildCategoryLabel("Friends"),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFriendCard("SASMITA KURNIA SARI", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                    _buildFriendCard("GIBRAN RAKABUMING", [Icons.workspace_premium]),
                    _buildFriendCard("RIDWAN PRAYOGA", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                    _buildFriendCard("ANITA GABRIEL", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                  ],
                ),
              ),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  // UPDATE: Tambahkan Parameter BuildContext agar bisa navigasi
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // KLIK AVATAR KE PROFILE
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingPage(
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
                )),
              );
            },
            child: const CircleAvatar(
              radius: 18, 
              backgroundColor: Colors.white, 
              child: Icon(Icons.person, size: 20, color: Colors.grey)
            ),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                width: 100, 
                fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search UID...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategoryLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(String name, List<IconData> badges) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyan.shade100, width: 2),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 5),
                Row(children: badges.map((icon) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: Icon(icon, size: 12)),
                )).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
                hairStyle: hairStyle,
              )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LevelsScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
                hairStyle: hairStyle,
              )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SpiceJournalScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
                hairStyle: hairStyle,
              )),
            ),
          ),
          
          // ICON PROFILE DI NAV BAWAH (Sekarang bisa diklik juga)
          IconButton(
            icon: const Icon(Icons.person, color: Colors.orange, size: 35),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProfileSettingPage(
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
                ))
              );
            },
          ),
        ],
      ),
    );
  }
}