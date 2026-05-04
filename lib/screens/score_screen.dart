import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart'; // Import package share
import '../models/recipe_model.dart';
import 'levels_screen.dart';
import 'homepage_screen.dart';
import 'spice_journal_screen.dart';
import 'multiplayer_lobby_screen.dart';
import 'gameplay_screen.dart'; 
import 'profile_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final Recipe resep;

  // Data Avatar agar tidak hilang saat berpindah halaman
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

  // FUNGSI SHARE JAWABAN
  void _shareScore() {
    final String text = "Hooray! I just finished ${resep.title} in SpiceUp! and got $score points! 🍳✨";
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo_dan_bg/SU_MAIN_BG02.png'), // Pastikan path benar
            fit: BoxFit.cover, // Agar gambar menutupi seluruh layar
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),

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
              
              // Barisan Bintang Besar
              _buildLargeStarRow(context, resep.stars),

              const SizedBox(height: 20),
              
              // Gambar Resep di dalam Glow
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5), 
                            blurRadius: 50, 
                            spreadRadius: 20
                          )
                        ],
                      ),
                    ),
                    // Jika path gambar resep menggunakan asset image biasa
                    Image.asset(resep.imagePath, width: 250, fit: BoxFit.contain),
                  ],
                ),
              ),

              Text(
                resep.stars < 2 ? "DON'T GIVE UP!" : "GOOD JOB!",
                style: const TextStyle(
                  fontSize: 48, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.orange,
                  fontStyle: FontStyle.italic, 
                  letterSpacing: 2,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(3, 3), blurRadius: 5)],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  resep.stars < 2 
                    ? "Keep trying! Practice makes perfect. You'll master ${resep.title} soon."
                    : "You've mastered ${resep.title}! You can now view it in your Spice Journal.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4E342E)),
                ),
              ),

              const SizedBox(height: 10),

              // TOMBOL REPLAY DAN SHARE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleActionButton(
                    icon: Icons.replay_rounded, 
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameplayScreen(
                          resep: resep,
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
                    }
                  ),
                  const SizedBox(width: 30),
                  _buildCircleActionButton(
                    icon: Icons.share_rounded, 
                    onTap: _shareScore
                  ),
                ],
              ),

              const SizedBox(height: 30),
              
              // Bottom Navigation bar
              _buildBottomNav(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Button Bulat
  Widget _buildCircleActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle, 
          border: Border.all(color: Colors.orange, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))]
        ),
        child: Icon(icon, color: Colors.orange, size: 35),
      ),
    );
  }

  // Header dengan link ke Profile
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingPage(
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
            ))),
            child: const CircleAvatar(
              backgroundColor: Colors.white, 
              child: Icon(Icons.person, color: Colors.orange)
            ),
          ),
          SvgPicture.asset('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: 110),
        ],
      ),
    );
  }

  // Widget Bintang melengkung
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
                index < starCount ? 'assets/stars/SU_ICONS_01.svg' : 'assets/stars/SU_ICONS_02.svg',
                width: size, height: size, fit: BoxFit.contain,
              ),
            ),
          );
        }),
      ),
    );
  }

  // Floating Bottom Navigation
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomepageScreen(
              skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
              nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
              bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
              hairStyle: hairStyle,
            ))),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Colors.orange, size: 38),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelsScreen(
              skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
              nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
              bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
              hairStyle: hairStyle,
            ))),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SpiceJournalScreen(
              skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
              nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
              bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
              hairStyle: hairStyle,
            ))),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MultiplayerLobbyScreen(
              skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
              nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
              bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
            ))),
          ),
        ],
      ),
    );
  }
}