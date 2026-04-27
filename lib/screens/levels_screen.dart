import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import '../data/recipe_data.dart';
import '../constants/app_colors.dart';
import 'gameplay_screen.dart';
import 'homepage_screen.dart';
import 'spice_journal_screen.dart';
import 'multiplayer_lobby_screen.dart';
import 'profile_screen.dart';

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

  // MODIFIKASI: Menambahkan parameter BoxFit fit
  Widget _optimizedImage(String path, {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit, // Digunakan agar bisa BoxFit.cover
      cacheWidth: width != null ? (width * MediaQuery.of(context).devicePixelRatio).round() : null,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: frame == null ? _loader() : child,
        );
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _optimizedSvg(String path, {double width = 55}) {
    return SvgPicture.asset(
      path,
      width: width,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => _loader(),
    );
  }

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

                    bool isLocked = false;
                    if (index > 0 && listResep[index - 1].stars == 0) {
                      isLocked = true;
                    }

                    Widget? badge;
                    if (index == 0) {
                      badge = _buildTimelineBadge("SPICE SPROUT", Colors.orange.shade800, 'assets/badges/SU_BADGES_01.SVG');
                    } else if (index > 0 && resep.difficulty != listResep[index - 1].difficulty) {
                      if (resep.difficulty == Difficulty.litle) {
                        badge = _buildTimelineBadge("LITTLE MORTAR", Colors.cyan.shade600, 'assets/badges/SU_BADGES_02.SVG');
                      } else if (resep.difficulty == Difficulty.bumbu) {
                        badge = _buildTimelineBadge("BUMBU BUDDY", Colors.pinkAccent, 'assets/badges/SU_BADGES_03.SVG');
                      }
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 75,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              _buildDashedLine(index, isLocked),
                              if (badge != null) badge,
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: badge != null ? 80 : 0, bottom: 20),
                            child: _buildLevelCard(context, resep, isLocked),
                          ),
                        ),
                      ],
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
          color: isLocked ? Colors.grey.withOpacity(0.3) : lineColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      )),
    );
  }

  Widget _buildTimelineBadge(String text, Color color, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _optimizedSvg(imagePath, width: 55),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // MODIFIKASI UTAMA PADA KARTU LEVEL (SUPAYA PRESISI)
  Widget _buildLevelCard(BuildContext context, Recipe resep, bool isLocked) {
    return GestureDetector(
      onTap: !isLocked
          ? () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(resep: resep)));
              setState(() {});
            }
          : null,
      child: Opacity(
        opacity: isLocked ? 0.6 : 1.0,
        child: Container(
          height: 115,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [if (!isLocked) BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              // BAGIAN GAMBAR YANG DIPRESISI
              Container(
                width: 105,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.shade300 : resep.sunburstColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
                  child: isLocked
                      ? const Icon(Icons.lock_rounded, size: 40, color: Colors.white)
                      : _optimizedImage(
                          resep.imagePath, 
                          width: 105, 
                          height: 115, 
                          fit: BoxFit.cover // GAMBAR SEKARANG MEMENUHI KOTAK
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
                      Text(resep.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isLocked ? Colors.grey : const Color(0xFF4E342E))),
                      Text(resep.subtitle.toUpperCase(), style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (i) => Icon(
                          Icons.star_rounded, size: 18,
                          color: i < resep.stars ? Colors.orange : Colors.grey.shade200,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: isLocked
                    ? const Icon(Icons.lock_outline, color: Colors.grey, size: 24)
                    : Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange])),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _goToProfile,
            child: const CircleAvatar(
              radius: 22, 
              backgroundColor: Colors.white, 
              child: Icon(Icons.person, color: Colors.orange)
            ),
          ),
          _optimizedSvg('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: 100),
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
            icon: const Icon(Icons.home_filled, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageScreen(
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
              )),
            ),
          ),
          const Icon(Icons.play_circle_filled, color: Colors.orange, size: 30),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SpiceJournalScreen(
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
              )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MultiplayerLobbyScreen(
                skinPath: widget.skinPath,
                eyePath: widget.eyePath,
                mouthPath: widget.mouthPath,
                nosePath: widget.nosePath,
                browsPath: widget.browsPath,
                hairPath: widget.hairPath,
                bangsPath: widget.bangsPath,
                shirtPath: widget.shirtPath,
                shirtColor: widget.shirtColor,
              )),
            ),
          ),
        ],
      ),
    );
  }
}