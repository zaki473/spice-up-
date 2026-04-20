import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'mutuals_screen.dart';

class SpiceJournalScreen extends StatelessWidget {
  // Parameter avatar agar data karakter tetap terjaga
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

  const SpiceJournalScreen({
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
          gradient: LinearGradient(colors: [AppColors.backgroundTop, AppColors.backgroundBottom]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryLabel("Spice Journal"),
              const Spacer(),
              // Clipboard
              _buildClipboardContent(),
              const Spacer(),
              // Pagination Arrows
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.orange, size: 30),
                    Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 30),
                  ],
                ),
              ),
              _buildBottomNav(context), // Navbar gaya baru
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20, color: Colors.grey)),
          Text("Spice Up!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Icon(Icons.notifications, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
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
        margin: const EdgeInsets.only(left: 20),
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

  Widget _buildClipboardContent() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.brown.shade400, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(height: 15, width: 80, decoration: BoxDecoration(color: Colors.brown.shade800, borderRadius: BorderRadius.circular(5))),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              children: [
                const Text("ANDALIMAN", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 20),
                const Icon(Icons.eco, size: 120, color: Colors.green), 
                const SizedBox(height: 20),
                const Text(
                  "This spice creates a tingling, numbing sensation on your tongue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UPDATE: Navbar Gaya LevelsScreen (Tinggi 70, Floating, Ikon Besar)
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), // Floating margin
      height: 70,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
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

          // Levels / Play
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

          // Menu Book / Journal (AKTIF - Oranye)
          const Icon(Icons.menu_book, color: Colors.orange, size: 35),

          // Person / Profile
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MutualsScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
                hairStyle: hairStyle,
              )),
            ),
          ),
        ],
      ),
    );
  }
}