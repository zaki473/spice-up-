import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import 'levels_screen.dart'; 
import 'multiplayer_score_screen.dart'; // Import halaman baru
import 'mutuals_screen.dart';           // Import halaman baru
import 'spice_journal_screen.dart';     // Import halaman baru

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          CircleAvatar(backgroundColor: Colors.black, radius: 16, child: Icon(Icons.person, color: Colors.white, size: 20)),
                          SizedBox(width: 8),
                          Text('Hi, Anggun!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                        ]),
                        const Text('Spice Up!', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orangePrimary, fontSize: 18)),
                        const Icon(Icons.notifications, color: AppColors.orangePrimary),
                      ],
                    ),
                  ),

                  // --- PROFILE CARD ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        childAspectRatio: 0.9,
                        children: [
                          _buildRecipeCard(context, 'Mi Gomak', 'Batak Spicy Noodles', 4),
                          _buildRecipeCard(context, 'Ikan Kuah Kuning', 'Yellow Turmeric Fish Soup', 5),
                          _buildRecipeCard(context, 'Ayam Betutu', 'Balinese Spiced Chicken', 4),
                          _buildRecipeCard(context, 'Soto Ayam', 'Indonesian Chicken Soup', 5),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),

              // --- BOTTOM NAVIGATION BAR (UPDATED) ---
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // HOME
                        GestureDetector(
                          onTap: () {}, // Sudah di Home
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(color: AppColors.orangePrimary, borderRadius: BorderRadius.circular(20)),
                            child: Row(children: const [Icon(Icons.home, color: Colors.white, size: 20), SizedBox(width: 4), Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
                          ),
                        ),
                        // PLAY -> Ke Levels
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Colors.grey, size: 28),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelsScreen())),
                        ),
                        // JOURNAL -> Ke Spice Journal
                        IconButton(
                          icon: const Icon(Icons.menu_book, color: Colors.grey, size: 28),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SpiceJournalScreen())),
                        ),
                        // PROFILE/FRIENDS -> Ke Mutuals
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.grey, size: 28),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MutualsScreen())),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, String title, String subtitle, int stars) {
    return GestureDetector(
      // Navigasi ke Multiplayer Score sebagai contoh saat klik kartu
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MultiplayerScoreScreen())),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(decoration: const BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.vertical(top: Radius.circular(16))), child: const Center(child: Icon(Icons.food_bank, size: 60, color: Colors.white)))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(subtitle, style: const TextStyle(fontSize: 8, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: List.generate(5, (index) => Icon(index < stars ? Icons.star : Icons.star_border, color: AppColors.orangePrimary, size: 10))),
                      const Icon(Icons.play_circle_fill, color: AppColors.orangePrimary, size: 20)
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