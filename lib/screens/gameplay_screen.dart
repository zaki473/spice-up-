import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'score_screen.dart';
import 'levels_screen.dart';
import 'profile_screen.dart'; // pastikan import ini ada

class GameplayScreen extends StatefulWidget {
  final Recipe resep;
  const GameplayScreen({super.key, required this.resep});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int currentIndex = 0;
  int score = 0;
  
  // Variable baru untuk mengontrol feedback jawaban
  int? selectedAnswerIndex;
  bool isAnswering = false;

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
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
      );
    }
  }

  // Fungsi Logika Jawaban yang Diperbarui
  void _answer(int index) async {
    if (isAnswering) return; // Mencegah klik ganda saat animasi jeda

    setState(() {
      isAnswering = true;
      selectedAnswerIndex = index;
    });

    // Cek jika benar
    if (index == widget.resep.questions[currentIndex].correctAnswerIndex) {
      score += 10;
    }

    // Beri jeda 1.5 detik agar user bisa melihat jawaban yang benar/salah
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (currentIndex < widget.resep.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswerIndex = null;
        isAnswering = false;
      });
    } else {
      // Game Selesai
      int totalSoal = widget.resep.questions.length;
      int maxScore = totalSoal * 10;
      double starCalculation = (score / maxScore) * 5;
      int finalStars = starCalculation.round();
      if (score > 0 && finalStars == 0) finalStars = 1;
      widget.resep.stars = finalStars;

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
                ),
              ),
              const SizedBox(height: 5),

              // --- CLIPBOARD AREA ---
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      margin: const EdgeInsets.only(top: 25, bottom: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBCAAA4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8D6E63), width: 8),
                      ),
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
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF4E342E)),
                            ),
                            const Divider(color: Colors.orange, thickness: 2),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: _buildQuizImage(currentQuestion.imagePath ?? widget.resep.imagePath),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("????", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "HINT: ${currentQuestion.hint ?? 'Perhatikan tekstur dan warna pada gambar!'}",
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Penjepit Clipboard
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 85, height: 45,
                        decoration: BoxDecoration(color: const Color(0xFFD84315), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle))),
                      ),
                    ),
                  ],
                ),
              ),

              // --- PILIHAN JAWABAN DENGAN LOGIKA WARNA ---
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3.2,
                  ),
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    // Logika Penentuan Warna
                    Color btnColorStart = Colors.orange;
                    Color btnColorEnd = const Color(0xFFFFB74D);

                    if (selectedAnswerIndex != null) {
                      if (index == currentQuestion.correctAnswerIndex) {
                        // Jawaban yang benar selalu hijau
                        btnColorStart = Colors.green;
                        btnColorEnd = Colors.greenAccent;
                      } else if (index == selectedAnswerIndex) {
                        // Jawaban yang dipilih salah menjadi merah
                        btnColorStart = Colors.red;
                        btnColorEnd = Colors.redAccent;
                      } else {
                        // Sisanya menjadi abu-abu transparan
                        btnColorStart = Colors.grey.shade400;
                        btnColorEnd = Colors.grey.shade300;
                      }
                    }

                    return GestureDetector(
                      onTap: () => _answer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [btnColorStart, btnColorEnd],
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

  // --- HEADER DENGAN NAVIGASI KE PROFILE ---
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingPage(
                  skinPath: 'assets/images/skin/SU_AVATAR_SKIN01.svg',
                  eyePath: 'assets/images/eye/SU_AVATAR_EYE1.svg',
                  mouthPath: 'assets/images/mouth/SU_AVATAR_MOUTH1.svg',
                  nosePath: 'assets/images/nose/SU_AVATAR_NOSE1.svg',
                  browsPath: 'assets/images/brows/SU_AVATAR_BROWS1.svg',
                  hairPath: 'assets/images/hair/SU_AVATAR_HAIR1.png',
                  bangsPath: 'assets/images/bangs/SU_AVATAR_BANGS1.svg',
                  shirtPath: 'assets/images/top/SU_AVATAR_TOP1.png',
                  shirtColor: Colors.orange,
                  hairStyle: Icons.person,
                )),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange),
            ),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 80,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LevelsScreen()),
                (route) => false,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
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
          // Icon Profile di Bottom Nav juga bisa diarahkan ke ProfileScreen
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingPage(
              skinPath: 'assets/images/skin/SU_AVATAR_SKIN01.svg',
              eyePath: 'assets/images/eye/SU_AVATAR_EYE1.svg',
              mouthPath: 'assets/images/mouth/SU_AVATAR_MOUTH1.svg',
              nosePath: 'assets/images/nose/SU_AVATAR_NOSE1.svg',
              browsPath: 'assets/images/brows/SU_AVATAR_BROWS1.svg',
              hairPath: 'assets/images/hair/SU_AVATAR_HAIR1.png',
              bangsPath: 'assets/images/bangs/SU_AVATAR_BANGS1.svg',
              shirtPath: 'assets/images/top/SU_AVATAR_TOP1.png',
              shirtColor: Colors.orange,
              hairStyle: Icons.person,
            ))),
            child: Icon(Icons.person, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}