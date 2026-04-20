import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';
import 'mutuals_screen.dart';

class MultiplayerScoreScreen extends StatelessWidget {
  // Tambahkan parameter avatar agar data tidak hilang saat navigasi
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

  const MultiplayerScoreScreen({
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              const Text("YOU PLACED", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.orange)),
              const Text("#2!", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.orange)),
              const Spacer(),
              // Bar Chart Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBar(height: 100, label: "Player 5", color: Colors.cyan.shade200),
                    _buildBar(height: 140, label: "Player 4", color: Colors.cyan.shade300),
                    _buildBar(height: 180, label: "Player 2", color: Colors.cyan.shade400, isMain: true),
                    _buildBar(height: 220, label: "Player 1", color: Colors.cyan.shade600, hasCrown: true),
                    _buildBar(height: 120, label: "Player 3", color: Colors.cyan.shade200),
                  ],
                ),
              ),
              const Spacer(),
              _buildActionButtons(),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar({required double height, required String label, required Color color, bool isMain = false, bool hasCrown = false}) {
    return Column(
      children: [
        if (hasCrown) const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
        const CircleAvatar(radius: 15, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20)),
        const SizedBox(height: 8),
        Container(
          width: 45,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color, color.withOpacity(0.5)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconBtn(Icons.refresh),
        const SizedBox(width: 20),
        _iconBtn(Icons.share),
      ],
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Navigasi ke Home
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageScreen(
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
            ),
            child: Row(children: const [Icon(Icons.home, color: Colors.grey), Text(" Home", style: TextStyle(color: Colors.grey))]),
          ),
          
          // Navigasi ke Levels / Play
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LevelsScreen(
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
            ),
            child: Icon(Icons.play_circle_fill, color: Colors.orange.shade400, size: 35),
          ),

          // Navigasi ke Spice Journal
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SpiceJournalScreen(
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
            ),
            child: const Icon(Icons.menu_book, color: Colors.grey),
          ),

          // Navigasi ke Mutuals / Profile
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MutualsScreen()),
            ),
            child: const Icon(Icons.person, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}