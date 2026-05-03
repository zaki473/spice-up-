import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import '../data/recipe_data.dart';
import 'gameplay_screen.dart';
import 'homepage_screen.dart';
import 'spice_journal_screen.dart';
import 'multiplayer_lobby_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/size_config.dart'; // Asumsi Anda menggunakan extension .w, .h, .sp

class LevelsScreen extends StatefulWidget {
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

  const LevelsScreen({
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
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSettingPage(
          skinPath: widget.skinPath,
          eyePath: widget.eyePath,
          mouthPath: widget.mouthPath,
          nosePath: widget.nosePath,
          browsPath: widget.browsPath,
          hairPath: widget.hairPath,
          bangsPath: widget.bangsPath,
          shirtPath: widget.shirtPath,
          shirtColor: widget.shirtColor,
          hairStyle: widget.hairStyle,
        ),
      ),
    );
  }

  Widget _loader() => const Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
    ),
  );

  Widget _optimizedImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  Widget _optimizedSvg(String path, {double? width}) {
    return SvgPicture.asset(
      path,
      width: width,
      placeholderBuilder: (context) => _loader(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD15B),
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    Map<String, dynamic> progress = {};
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      progress = data['progress'] is Map
                          ? Map<String, dynamic>.from(data['progress'])
                          : {};
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: listResep.length,
                      itemBuilder: (context, index) {
                        final resep = listResep[index];
                        int currentStars = progress[resep.title] ?? 0;

                        bool isLocked = false;
                        if (index > 0) {
                          int prevStars =
                              progress[listResep[index - 1].title] ?? 0;
                          if (prevStars == 0) isLocked = true;
                        }

                        Widget? badge;
                        if (index == 0) {
                          badge = _buildTimelineBadge(
                            "SPICE SPROUT",
                            Colors.orange.shade800,
                            'assets/badges/SU_BADGES_01.svg',
                          );
                        } else if (index > 0 &&
                            resep.difficulty !=
                                listResep[index - 1].difficulty) {
                          if (resep.difficulty == Difficulty.litle) {
                            badge = _buildTimelineBadge(
                              "LITTLE MORTAR",
                              Colors.cyan.shade600,
                              'assets/badges/SU_BADGES_02.svg',
                            );
                          } else if (resep.difficulty == Difficulty.bumbu) {
                            badge = _buildTimelineBadge(
                              "BUMBU BUDDY",
                              Colors.pinkAccent,
                              'assets/badges/SU_BADGES_03.svg',
                            );
                          }
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BAGIAN TIMELINE (KIRI)
                            SizedBox(
                              width: 80,
                              child: Column(
                                children: [
                                  if (badge != null) badge,
                                  _buildDashedLine(index, isLocked),
                                ],
                              ),
                            ),
                            // BAGIAN KARTU (KANAN)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _buildLevelCard(
                                  context,
                                  resep,
                                  isLocked,
                                  currentStars,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedLine(int index, bool isLocked) {
    Color lineColor = Colors.orange.shade700;
    switch (listResep[index].difficulty) {
      case Difficulty.spice:
        lineColor = Colors.orange.shade700;
        break;
      case Difficulty.bumbu:
        lineColor = Colors.pinkAccent;
        break;
      case Difficulty.litle:
        lineColor = Colors.cyan.shade600;
        break;
    }

    return Column(
      children: List.generate(
        8,
        (i) => Container(
          width: 3,
          height: 10,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isLocked
                ? Colors.grey.withOpacity(0.3)
                : lineColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineBadge(String text, Color color, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _optimizedSvg(imagePath, width: 45),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    Recipe resep,
    bool isLocked,
    int stars,
  ) {
    return GestureDetector(
      onTap: !isLocked
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameplayScreen(
                    resep: resep,
                    skinPath: widget.skinPath,
                    eyePath: widget.eyePath,
                    mouthPath: widget.mouthPath,
                    nosePath: widget.nosePath,
                    browsPath: widget.browsPath,
                    hairPath: widget.hairPath,
                    bangsPath: widget.bangsPath,
                    shirtPath: widget.shirtPath,
                    shirtColor: widget.shirtColor,
                    hairStyle: widget.hairStyle,
                  ),
                ),
              );
              setState(() {});
            }
          : null,
      child: Container(
        // Menggunakan minHeight agar kartu punya tinggi standar tapi bisa melar jika teks panjang
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: isLocked ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          // Memastikan Row kiri, tengah, dan kanan memiliki tinggi yang sama
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Gambar Resep ---
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.shade200
                      : resep.sunburstColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(24),
                  ),
                  child: isLocked
                      ? Icon(
                          Icons.lock_rounded,
                          color: Colors.grey.shade400,
                          size: 30,
                        )
                      : _optimizedImage(resep.imagePath, fit: BoxFit.cover),
                ),
              ),

              // --- Informasi Resep (Judul, Subtitle, Star) ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resep.title,
                        maxLines:
                            2, // Mengizinkan 2 baris agar judul tidak terpotong (ellipsis)
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize:
                              16, // Ukuran sedikit dikecilkan agar proporsional jika 2 baris
                          fontWeight: FontWeight.bold,
                          height: 1.1, // Merapatkan jarak antar baris teks
                          color: isLocked
                              ? Colors.grey
                              : const Color(0xFF4E342E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resep.subtitle.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Row Bintang
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: i < stars
                                  ? Colors.orange
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Tombol Play / Lock ---
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: isLocked
                      ? Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade400,
                          size: 24,
                        )
                      : Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.orangeAccent, Colors.deepOrange],
                            ),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _goToProfile,
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange),
            ),
          ),
          _optimizedSvg(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 100,
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(
            Icons.home_filled,
            false,
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomepageScreen(
                  skinPath: widget.skinPath,
                  eyePath: widget.eyePath,
                  mouthPath: widget.mouthPath,
                  nosePath: widget.nosePath,
                  browsPath: widget.browsPath,
                  hairPath: widget.hairPath,
                  bangsPath: widget.bangsPath,
                  shirtPath: widget.shirtPath,
                  shirtColor: widget.shirtColor,
                  hairStyle: widget.hairStyle,
                ),
              ),
            ),
          ),
          _navIcon(Icons.play_circle_filled, true, null),
          _navIcon(
            Icons.menu_book,
            false,
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SpiceJournalScreen(
                  skinPath: widget.skinPath,
                  eyePath: widget.eyePath,
                  mouthPath: widget.mouthPath,
                  nosePath: widget.nosePath,
                  browsPath: widget.browsPath,
                  hairPath: widget.hairPath,
                  bangsPath: widget.bangsPath,
                  shirtPath: widget.shirtPath,
                  shirtColor: widget.shirtColor,
                  hairStyle: widget.hairStyle,
                ),
              ),
            ),
          ),
          _navIcon(
            Icons.person_outline,
            false,
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MultiplayerLobbyScreen(
                  skinPath: widget.skinPath,
                  eyePath: widget.eyePath,
                  mouthPath: widget.mouthPath,
                  nosePath: widget.nosePath,
                  browsPath: widget.browsPath,
                  hairPath: widget.hairPath,
                  bangsPath: widget.bangsPath,
                  shirtPath: widget.shirtPath,
                  shirtColor: widget.shirtColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, bool isActive, VoidCallback? onTap) {
    return IconButton(
      icon: Icon(icon, color: isActive ? Colors.orange : Colors.grey, size: 30),
      onPressed: onTap,
    );
  }
}
