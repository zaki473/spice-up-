import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'levels_screen.dart';
import 'homepage_screen.dart';
import 'spice_journal_screen.dart';
import 'mutuals_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final Recipe resep;

  // Tambahkan parameter avatar agar data tetap terjaga saat ke Home
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

  const ScoreScreen({
    super.key, 
    required this.score, 
    required this.resep,
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
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Color(0xFFFFFDE7), Color(0xFFFFD54F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              // Tombol Back menuju Levels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LevelsScreen(
                        skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
                        nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
                        bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
                        hairStyle: hairStyle,
                      )),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF4E342E)),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              _buildLargeStarRow(context, resep.stars),

              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 50, spreadRadius: 20)],
                      ),
                    ),
                    Image.asset(resep.imagePath, width: 250, fit: BoxFit.contain),
                  ],
                ),
              ),

              const Text(
                "GOOD JOB!",
                style: TextStyle(
                  fontSize: 48, fontWeight: FontWeight.w900, color: Colors.orange,
                  fontStyle: FontStyle.italic, letterSpacing: 2,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(3, 3), blurRadius: 5)],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "You've mastered this recipe! You can now view it in your Spice Journal.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4E342E)),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(Icons.replay_rounded),
                  const SizedBox(width: 20),
                  _buildCircleButton(Icons.share_rounded),
                ],
              ),

              const SizedBox(height: 30),
              // UPDATE: Navbar gaya LevelsScreen
              _buildBottomNav(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // UPDATE: Navbar Gaya LevelsScreen (Floating, Tinggi 70)
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

          // Play / Levels (AKTIF - Oranye)
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Colors.orange, size: 35),
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

          // Spice Journal
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

          // Person
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

  Widget _buildLargeStarRow(BuildContext context, int starCount) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: List.generate(5, (index) {
          double size = (index == 2) ? 85 : (index == 1 || index == 3) ? 65 : 50;
          double xOffset = (index - 2) * 55.0;
          double yOffset = 0;
          if (index == 2) yOffset = 35;
          if (index == 1 || index == 3) yOffset = 18;

          return Positioned(
            bottom: yOffset,
            left: (MediaQuery.of(context).size.width / 2) + xOffset - (size / 2),
            child: Opacity(
              opacity: index < starCount ? 1.0 : 0.3,
              child: SvgPicture.asset(
                index < starCount ? 'assets/stars/SU_ICONS_01.SVG' : 'assets/stars/SU_ICONS_02.SVG',
                width: size, height: size, fit: BoxFit.contain,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.orange, width: 3)),
      child: Icon(icon, color: Colors.orange, size: 32),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.orange)),
          SvgPicture.asset('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: 130),
          const Icon(Icons.notifications, color: Colors.orange),
        ],
      ),
    );
  }
}