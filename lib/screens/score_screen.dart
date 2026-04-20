import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'levels_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final Recipe resep;

  const ScoreScreen({super.key, required this.score, required this.resep});

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

              // Tombol Back
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LevelsScreen(),
                      ),
                      (route) => false,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ),
              ),

              // --- BAGIAN BINTANG (UKURAN BESAR & MELENGKUNG) ---
              const SizedBox(height: 10),
              _buildLargeStarRow(context, resep.stars),

              // --- GAMBAR MAKANAN DINAMIS ---
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran cahaya di belakang makanan
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    // Gambar Makanan
                    Image.asset(
                      resep.imagePath,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              // --- TEKS SCORE ---
              const Text(
                "GOOD JOB!",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "You've mastered this recipe! You can now view it in your Spice Journal.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4E342E),
                  ),
                ),
              ),

              // Tombol Replay & Share
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(Icons.replay_rounded),
                  const SizedBox(width: 20),
                  _buildCircleButton(Icons.share_rounded),
                ],
              ),

              const SizedBox(height: 30),
              _buildBottomNav(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // LOGIKA BINTANG GEDE TANPA ERROR
  Widget _buildLargeStarRow(BuildContext context, int starCount) {
    return SizedBox(
      height: 120, // Saya kecilkan dari 170 ke 120
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: List.generate(5, (index) {
          // --- UKURAN BARU (LEBIH KECIL) ---
          // Tengah: 85 (tadinya 120)
          // Samping: 65 (tadinya 90)
          // Luar: 50 (tadinya 70)
          double size = (index == 2)
              ? 85
              : (index == 1 || index == 3)
              ? 65
              : 50;

          // Jarak antar bintang (dirapatkan sedikit)
          double xOffset = (index - 2) * 55.0;

          // Tinggi lengkungan (disesuaikan agar pas)
          double yOffset = 0;
          if (index == 2) yOffset = 35;
          if (index == 1 || index == 3) yOffset = 18;

          return Positioned(
            bottom: yOffset,
            left:
                (MediaQuery.of(context).size.width / 2) + xOffset - (size / 2),
            child: Opacity(
              // Jika index bintang belum didapat, buat agak transparan
              opacity: index < starCount ? 1.0 : 0.3,
              child: SvgPicture.asset(
                // PAKAI SvgPicture karena file kamu kemungkinan besar .svg
                index < starCount
                    ? 'assets/stars/SU_ICONS_01.SVG' // Pastikan ekstensinya .svg
                    : 'assets/stars/SU_ICONS_02.SVG',
                width: size,
                height: size,
                fit: BoxFit.contain,
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange, width: 3),
      ),
      child: Icon(icon, color: Colors.orange, size: 32),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.orange),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 130,
          ),
          const Icon(Icons.notifications, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LevelsScreen()),
                (route) => false,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Icon(Icons.play_circle_fill, color: Colors.orange, size: 40),
          const SizedBox(width: 15),
          Icon(Icons.menu_book_rounded, color: Colors.grey.shade400, size: 28),
          const SizedBox(width: 15),
          Icon(Icons.person, color: Colors.grey.shade400, size: 28),
        ],
      ),
    );
  }
}
