import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // IMPORT INI
import '../models/recipe_model.dart';
import '../data/recipe_data.dart';
import 'gameplay_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD15B), Color(0xFFFFE18B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: listResep.length,
                  itemBuilder: (context, index) {
                    final resep = listResep[index];
                    
                    // --- LOGIKA BADGE DINAMIS ---
                    Widget? badge;
                    if (index == 0) {
                      badge = _buildTimelineBadge(
                        "SPICE SPROUT", 
                        Colors.orange.shade800, 
                        'assets/badges/SU_BADGES_01.SVG' 
                      );
                    } else if (index > 0 && resep.difficulty != listResep[index - 1].difficulty) {
                      if (resep.difficulty == Difficulty.litle) {
                        badge = _buildTimelineBadge(
                          "LITTLE MORTAR", 
                          Colors.cyan.shade600, 
                          'assets/badges/SU_BADGES_02.SVG'
                        );
                      } else if (resep.difficulty == Difficulty.bumbu) {
                        badge = _buildTimelineBadge(
                          "BUMBU BUDDY", 
                          Colors.pinkAccent, 
                          'assets/badges/SU_BADGES_03.SVG'
                        );
                      }
                    }

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- KOLOM TIMELINE ---
                          SizedBox(
                            width: 75, // Dilebarkan sedikit agar badge tidak sesak
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                _buildDashedLine(index),
                                if (badge != null) badge,
                              ],
                            ),
                          ),
                          // --- KOLOM KARTU MENU ---
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: badge != null ? 80 : 0, // Ditinggikan agar kartu tidak menabrak badge
                                bottom: 20
                              ),
                              child: _buildLevelCard(context, resep),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // Desain Garis yang berubah warna sesuai kesulitan
  Widget _buildDashedLine(int index) {
    Color lineColor;
    switch (listResep[index].difficulty) {
      case Difficulty.spice: lineColor = Colors.orange.shade700; break;
      case Difficulty.bumbu: lineColor = Colors.cyan.shade600; break;
      case Difficulty.litle: lineColor = Colors.pinkAccent; break;
    }

    return Column(
      children: List.generate(15, (i) => Container(
        width: 3, height: 8, margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: lineColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      )),
    );
  }

  // --- WIDGET BADGE DENGAN SVG DAN UKURAN TERKONTROL ---
  Widget _buildTimelineBadge(String text, Color color, String imagePath) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Menghapus Container putih, langsung menggunakan SizedBox untuk mengatur ukuran
      SizedBox(
        width: 55,  // Kamu bisa perbesar ukurannya di sini karena lingkarannya sudah hilang
        height: 55, 
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(height: 4), // Jarak kecil antara gambar dan label teks
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color, 
          borderRadius: BorderRadius.circular(6),
          // Tambahkan sedikit shadow pada label agar tetap terbaca jelas
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
          ]
        ),
        child: Text(
          text, 
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 7, 
            fontWeight: FontWeight.bold
          )
        ),
      ),
    ],
  );
}

  Widget _buildLevelCard(BuildContext context, Recipe resep) {
    return GestureDetector(
      onTap: !resep.isLocked 
          ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(resep: resep))) 
          : null,
      child: Container(
        height: 115,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 105,
              decoration: BoxDecoration(
                color: resep.isLocked ? Colors.grey.shade200 : resep.sunburstColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_menu, 
                  size: 45, 
                  color: resep.isLocked ? Colors.grey : Colors.orangeAccent
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resep.title, 
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w900, 
                        color: resep.isLocked ? Colors.grey : const Color(0xFF4E342E)
                      )
                    ),
                    Text(
                      resep.subtitle.toUpperCase(), 
                      style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        Icons.star_rounded, 
                        size: 18, 
                        color: i < resep.stars ? Colors.orange : Colors.grey.shade300
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: resep.isLocked 
                ? const Icon(Icons.lock_outline, color: Colors.grey, size: 28)
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER & NAV ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(radius: 22, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.orange)),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
              width: 100, 
              fit: BoxFit.contain,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Color(0xFF4E342E))),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)]
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_filled, color: Colors.orange, size: 30),
          Icon(Icons.play_circle_outline, color: Colors.grey, size: 30),
          Icon(Icons.menu_book, color: Colors.grey, size: 30),
          Icon(Icons.person_outline, color: Colors.grey, size: 30),
        ],
      ),
    );
  }
}