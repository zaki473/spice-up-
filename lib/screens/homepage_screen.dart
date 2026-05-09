import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import 'levels_screen.dart';
import 'multiplayer_lobby_screen.dart';
import 'spice_journal_screen.dart';
import 'profile_screen.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
import 'gameplay_screen.dart';

class HomepageScreen extends StatefulWidget {
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

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Helper untuk render part avatar
  Widget _renderPart(String path, double size) {
    if (path.isEmpty) return const SizedBox();
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: size, fit: BoxFit.contain);
    } else {
      return Image.asset(path, width: size, fit: BoxFit.contain);
    }
  }

  void _goToProfile(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsivitas
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9A84D), Color(0xFFFFE39C)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context, screenWidth),
                  _buildProfileCard(context, screenWidth),
                  _buildSearchBar(screenWidth),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 
                      screenHeight * 0.02, 
                      screenWidth * 0.05, 
                      screenHeight * 0.01
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _searchQuery.isEmpty ? 'Recently Played' : 'Search Results',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD35400),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Recipe> displayRecipes = [];
                          List<Recipe> recentRecipes = [];

                          if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                            List<dynamic> recentTitles = data['recently_played'] is List ? data['recently_played'] : [];
                            for (var title in recentTitles) {
                              try {
                                recentRecipes.add(listResep.firstWhere((r) => r.title == title));
                              } catch (e) { /* Ignore */ }
                            }
                          }

                          displayRecipes = _searchQuery.isEmpty 
                              ? recentRecipes 
                              : recentRecipes.where((recipe) => recipe.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                          if (displayRecipes.isEmpty) {
                            return _buildEmptyState(screenWidth);
                          }

                          return GridView.builder(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.12),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isTablet ? 3 : 2, // 3 kolom di tablet
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.75, // Disesuaikan agar pas di berbagai rasio layar
                            ),
                            itemCount: displayRecipes.length,
                            itemBuilder: (context, index) {
                              final resep = displayRecipes[index];
                              int resepStars = 0;

                              if (snapshot.hasData && snapshot.data!.exists) {
                                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                Map<String, dynamic> progress = data['progress'] is Map ? Map<String, dynamic>.from(data['progress']) : {};
                                resepStars = progress[resep.title] ?? 0;
                              }

                              return GestureDetector(
                                onTap: () => Navigator.push(
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
                                ),
                                child: _buildRecipeCard(context, resep.title, resep.subtitle, resepStars, resep.imagePath, screenWidth),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomNav(context, screenWidth, screenHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_esports, size: screenWidth * 0.15, color: Colors.orange.shade300),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isEmpty ? "Belum ada resep yang dimainkan" : "Resep tidak ditemukan",
            style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _goToProfile(context),
            child: CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange, size: screenWidth * 0.06),
            ),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: screenWidth * 0.25,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, double screenWidth) {
    double avatarBaseSize = 350; // Standar koordinat aset Anda

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      child: InkWell(
        onTap: () => _goToProfile(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.shade200, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              // Avatar Container Responsive
              Container(
                width: screenWidth * 0.2, // Lebar proporsional
                height: screenWidth * 0.25, // Tinggi proporsional
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: avatarBaseSize,
                      height: avatarBaseSize,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          _renderPart(widget.skinPath, avatarBaseSize),
                          Positioned(
                            top: -avatarBaseSize * 0.15,
                            left: avatarBaseSize * -0.11,
                            child: _renderPart(widget.hairPath, avatarBaseSize * 1.24),
                          ),
                          Positioned(top: avatarBaseSize * 0.25, child: _renderPart(widget.browsPath, avatarBaseSize * 0.31)),
                          Positioned(top: avatarBaseSize * 0.29, child: _renderPart(widget.eyePath, avatarBaseSize * 0.39)),
                          Positioned(top: avatarBaseSize * 0.45, child: _renderPart(widget.nosePath, avatarBaseSize * 0.055)),
                          Positioned(top: avatarBaseSize * 0.5, child: _renderPart(widget.mouthPath, avatarBaseSize * 0.13)),
                          Positioned(top: -avatarBaseSize * -0.03, child: _renderPart(widget.bangsPath, avatarBaseSize * 0.53)),
                          Positioned(
                            left: 0, right: 0,
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(4, -10),
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: _renderPart(widget.shirtPath, avatarBaseSize * 3.33),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String fullNameFromDb = 'LOADING...';
                    String nickNameFromDb = '';
                    Map<String, dynamic>? data;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null) {
                        fullNameFromDb = data['display_name'] ?? 'USER';
                        nickNameFromDb = data['display_name'] ?? '';
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullNameFromDb.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05, // Font size responsive
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          "${FirebaseAuth.instance.currentUser?.email ?? ''}",
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMiniInfo('School', data?['school'] ?? '-', screenWidth),
                            _buildMiniInfo('Birthday', data?['birthday'] ?? '-', screenWidth, isRight: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildBadgesRow(data?['unlocked_badges'], screenWidth),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value, double screenWidth, {bool isRight = false}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: screenWidth * 0.025, color: Colors.grey.shade500)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesRow(dynamic badgesData, double screenWidth) {
    List<dynamic> unlockedBadges = badgesData is List ? badgesData : [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Badges", style: TextStyle(fontSize: screenWidth * 0.025, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        if (unlockedBadges.isEmpty)
          Text("No badges yet", style: TextStyle(fontSize: screenWidth * 0.025, color: Colors.grey, fontStyle: FontStyle.italic)),
        if (unlockedBadges.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (unlockedBadges.contains("SPICE SPROUT"))
                  Padding(padding: const EdgeInsets.only(right: 6), child: _buildSvgBadge('assets/badges/SU_BADGES_01.svg', Colors.orange.shade800, screenWidth)),
                if (unlockedBadges.contains("LITTLE MORTAR"))
                  Padding(padding: const EdgeInsets.only(right: 6), child: _buildSvgBadge('assets/badges/SU_BADGES_02.svg', Colors.cyan.shade600, screenWidth)),
                if (unlockedBadges.contains("BUMBU BUDDY"))
                  Padding(padding: const EdgeInsets.only(right: 6), child: _buildSvgBadge('assets/badges/SU_BADGES_03.svg', Colors.pinkAccent, screenWidth)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSvgBadge(String path, Color color, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: SvgPicture.asset(path, width: screenWidth * 0.045, height: screenWidth * 0.045),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search Recipes...',
            prefixIcon: const Icon(Icons.search, color: Colors.orange),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                  })
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, String title, String subtitle, int stars, String imagePath, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFFFEBD2), borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood, color: Colors.orange)),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035, color: const Color(0xFF3E2723)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: List.generate(5, (i) => Icon(Icons.star, size: screenWidth * 0.03, color: i < stars ? Colors.orange : Colors.grey.shade300))),
                      Icon(Icons.play_circle_fill, color: Colors.orange, size: screenWidth * 0.07),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, screenHeight * 0.02),
      height: screenHeight * 0.08,
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: Colors.orange, size: screenWidth * 0.08),
          _navIcon(context, Icons.play_circle_outline, LevelsScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle), screenWidth),
          _navIcon(context, Icons.menu_book, SpiceJournalScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle), screenWidth),
          _navIcon(context, Icons.person_outline, MultiplayerLobbyScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor), screenWidth),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, Widget screen, double screenWidth) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey, size: screenWidth * 0.07),
      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => screen)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}