import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'score_screen.dart';
import 'levels_screen.dart';

class GameplayScreen extends StatefulWidget {
  final Recipe resep;
  const GameplayScreen({super.key, required this.resep});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int currentIndex = 0;
  int score = 0;

  Widget _buildQuizImage(String path) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        placeholderBuilder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 80,
          color: Colors.grey,
        ),
      );
    }
  }

  void _answer(int selectedIndex) {
    if (selectedIndex == widget.resep.questions[currentIndex].correctAnswerIndex) {
      score += 10;
    }

    bool gameFinished = false;

    setState(() {
      if (currentIndex < widget.resep.questions.length - 1) {
        currentIndex++;
      } else {
        int totalSoal = widget.resep.questions.length;
        int maxScore = totalSoal * 10;
        double starCalculation = (score / maxScore) * 5;
        int finalStars = starCalculation.round();

        if (score > 0 && finalStars == 0) finalStars = 1;

        widget.resep.stars = finalStars;
        gameFinished = true;
      }
    });

    if (gameFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreScreen(score: score, resep: widget.resep),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.resep.questions[currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomHeader(),
              
              const SizedBox(height: 10),

              Text(
                "QUESTION ${currentIndex + 1}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                  shadows: [Shadow(color: Colors.black12, blurRadius: 2, offset: Offset(2, 2))]
                ),
              ),

              const SizedBox(height: 5),

              // --- CLIPBOARD AREA (Area Utama Gambar) ---
              Expanded(
                flex: 4, // Memberi prioritas ruang paling besar untuk gambar
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Papan Cokelat
                    Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      margin: const EdgeInsets.only(top: 25, bottom: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBCAAA4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8D6E63), width: 8),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]
                      ),
                      // Kertas Putih
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentQuestion.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4E342E),
                              ),
                            ),
                            const Divider(color: Colors.orange, thickness: 2, height: 12),
                            
                            // AREA GAMBAR: Sekarang sangat luas karena tombol dikecilkan dan panah dihapus
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: _buildQuizImage(currentQuestion.imagePath ?? widget.resep.imagePath),
                              ),
                            ),
                            
                            const SizedBox(height: 5),
                            const Row(
                              children: [
                                Text("????", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "HINT: Perhatikan tekstur dan warna pada gambar!",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Penjepit Clipboard Merah
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 85,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD84315),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
                        ),
                        child: Center(
                          child: Container(
                            width: 16, height: 16,
                            decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- PILIHAN JAWABAN (Dibuat Ramping/Tipis) ---
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3.2, // Nilai 3.2 membuat tombol lebih gepeng/tipis
                  ),
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _answer(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Color(0xFFFFB74D)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))],
                        ),
                        child: Center(
                          child: Text(
                            currentQuestion.options[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              _buildBottomNav(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.orange)),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg', 
            width: 80,
            placeholderBuilder: (context) => const Text("SpiceUp!", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Icon(Icons.notifications, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const LevelsScreen()), 
                (route) => false
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Colors.white, size: 20),
                    SizedBox(width: 5),
                    Text("Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.play_circle_fill, color: Colors.orange, size: 35),
          const SizedBox(width: 15),
          Icon(Icons.menu_book_rounded, color: Colors.grey.shade400),
          const SizedBox(width: 15),
          Icon(Icons.person, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}