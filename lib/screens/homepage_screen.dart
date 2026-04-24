import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import 'levels_screen.dart'; 
import 'multiplayer_score_screen.dart';
import 'mutuals_screen.dart';
import 'spice_journal_screen.dart';
import 'profile_screen.dart'; // Pastikan import ini ada

class HomepageScreen extends StatelessWidget {
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

  const HomepageScreen({
    super.key,
    required this.skinPath,
    required this.eyePath,
    required this.mouthPath,
    required this.nosePath,
    required this.browsPath,
    required this.hairPath,
    required this.bangsPath,
    required this.shirtPath,
    required this.shirtColor,
    required this.hairStyle,
  });

  // Fungsi navigasi agar kode lebih bersih
  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSettingPage(
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
        ),
      ),
    );
  }

  Widget _renderPart(String path, double size) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: size, fit: BoxFit.contain);
    } else {
      return Image.asset(path, width: size, fit: BoxFit.contain);
    }
  }

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
          child: Stack(
            children: [
              Column(
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: SizedBox(
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                // 1. PROFIL BULAT BISA DIKLIK
                                InkWell(
                                  onTap: () => _goToProfile(context),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.black, 
                                    radius: 16, 
                                    child: Icon(Icons.person, color: Colors.white, size: 20)
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Hi, Anggun!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                              ]),
                              const Icon(Icons.notifications, color: AppColors.orangePrimary),
                            ],
                          ),
                          SvgPicture.asset(
                            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
                            width: 100, 
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- PROFILE CARD ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      // 2. KARTU PROFIL BISA DIKLIK
                      onTap: () => _goToProfile(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.orangeLight, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80, height: 100,
                              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _renderPart(skinPath, 70),
                                    Positioned(top: 30, child: _renderPart(browsPath, 35)),
                                    Positioned(top: 35, child: _renderPart(eyePath, 40)),
                                    Positioned(top: 50, child: _renderPart(nosePath, 10)),
                                    Positioned(top: 58, child: _renderPart(mouthPath, 15)),
                                    Positioned(top: 5, child: _renderPart(hairPath, 70)),
                                    Positioned(top: 10, child: _renderPart(bangsPath, 60)),
                                    Positioned(bottom: -5, child: _renderPart(shirtPath, 70)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('ANGGUN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.orangePrimary)),
                                  const Text('Anggun Natasha Simanjuntak', style: TextStyle(fontSize: 10)),
                                  const Divider(color: Colors.grey),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('School', style: TextStyle(fontSize: 8, color: Colors.grey)), Text('SMK Kota Blitar 1', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Birthday', style: TextStyle(fontSize: 8, color: Colors.grey)), Text('23/DEC/2006', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- SEARCH BAR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                      child: const TextField(decoration: InputDecoration(hintText: 'More Recipes...', prefixIcon: Icon(Icons.search, color: AppColors.orangePrimary), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12))),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.all(16.0), child: Align(alignment: Alignment.centerLeft, child: Text('Recently Played', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.orangePrimary)))),

                  // --- GRID RECIPES ---
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                        children: [
                          _buildRecipeCard(context, 'Mi Gomak', 'Batak Spicy Noodles', 3, 'Nice!', 'assets/images/mi_gomak.png'),
                          _buildRecipeCard(context, 'Ikan Kuah Kuning', 'Yellow Turmeric Fish Soup', 4, 'Excellent!', 'assets/images/ikan_kuning.png'),
                          _buildRecipeCard(context, 'Ayam Betutu', 'Balinese Spiced Chicken', 4, 'Great!', 'assets/images/ayam_betutu.png'),
                          _buildRecipeCard(context, 'Soto Ayam', 'Indonesian Chicken Soup', 5, 'Perfect!', 'assets/images/soto_ayam.png'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),

              // --- BOTTOM NAVIGATION BAR ---
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomNav(context),
              )
            ],
          ),
        ),
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
          const Icon(Icons.home_filled, color: Colors.orange, size: 30),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey, size: 30), 
            onPressed: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LevelsScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, 
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, 
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, 
                hairStyle: hairStyle,
              ))
            )
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.grey, size: 30), 
            onPressed: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => SpiceJournalScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, 
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, 
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, 
                hairStyle: hairStyle,
              ))
            )
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey, size: 30), 
            onPressed: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => MutualsScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, 
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, 
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, 
                hairStyle: hairStyle,
              ))
            )
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, String title, String subtitle, int stars, String label, String imagePath) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MultiplayerScoreScreen(
                skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath, 
                nosePath: nosePath, browsPath: browsPath, hairPath: hairPath, 
                bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, 
                hairStyle: hairStyle,
      ))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Color(0xFFFFEBD2), 
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(imagePath, fit: BoxFit.contain), 
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF3E2723))),
                  Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            Icons.star,
                            color: index < stars ? Colors.orange : Colors.grey.shade300,
                            size: 12,
                          )),
                        ],
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFE65100)]),
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}