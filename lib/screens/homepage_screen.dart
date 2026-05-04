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
                  _buildHeader(context),
                  _buildProfileCard(context),
                  _buildSearchBar(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Recently Played'
                            : 'Search Results',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD35400),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Recipe> displayRecipes = [];
                          List<Recipe> recentRecipes = [];

                          // Mengambil semua resep yang pernah dimainkan terlebih dahulu
                          if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            List<dynamic> recentTitles =
                                data['recently_played'] is List
                                ? data['recently_played']
                                : [];

                            for (var title in recentTitles) {
                              try {
                                recentRecipes.add(
                                  listResep.firstWhere((r) => r.title == title),
                                );
                              } catch (e) {
                                /* Ignore */
                              }
                            }
                          }

                          // Menerapkan logika: jika _searchQuery kosong, tampilkan semua recent.
                          // Jika berisi, lakukan filter dari resep yang sudah dimainkan (bukan dari keseluruhan listResep)
                          if (_searchQuery.isEmpty) {
                            displayRecipes = recentRecipes;
                          } else {
                            displayRecipes = recentRecipes.where((recipe) {
                              return recipe.title.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              );
                            }).toList();
                          }

                          if (displayRecipes.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchQuery.isEmpty
                                        ? Icons.sports_esports
                                        : Icons.search_off,
                                    size: 60,
                                    color: Colors.orange.shade300,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? "Belum ada resep yang dimainkan"
                                        : "Resep tidak ditemukan",
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_searchQuery.isEmpty)
                                    Text(
                                      "Ayo mainkan sekarang!",
                                      style: TextStyle(
                                        color: Colors.orange.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: displayRecipes.length,
                            itemBuilder: (context, index) {
                              final resep = displayRecipes[index];
                              int resepStars = 0;

                              if (snapshot.hasData && snapshot.data!.exists) {
                                Map<String, dynamic> data =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;
                                Map<String, dynamic> progress =
                                    data['progress'] is Map
                                    ? Map<String, dynamic>.from(
                                        data['progress'],
                                      )
                                    : {};
                                resepStars = progress[resep.title] ?? 0;
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
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
                                },
                                child: _buildRecipeCard(
                                  context,
                                  resep.title,
                                  resep.subtitle,
                                  resepStars,
                                  resep.imagePath,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomNav(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _goToProfile(context),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange),
            ),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => _goToProfile(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.shade200, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 100,
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
                      width: 350,
                      height: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          _renderPart(widget.skinPath, 350),
                          Positioned(
                            top: -350 * 0.14,
                            child: _renderPart(widget.hairPath, 350 * 1.14),
                          ),
                          Positioned(
                            top: 350 * 0.20,
                            child: _renderPart(widget.browsPath, 350 * 0.26),
                          ),
                          Positioned(
                            top: 350 * 0.25,
                            child: _renderPart(widget.eyePath, 350 * 0.36),
                          ),
                          Positioned(
                            top: 350 * 0.41,
                            child: _renderPart(widget.nosePath, 350 * 0.055),
                          ),
                          Positioned(
                            top: 350 * 0.50,
                            child: _renderPart(widget.mouthPath, 350 * 0.13),
                          ),
                          Positioned(
                            top: -350 * 0.01,
                            child: _renderPart(widget.bangsPath, 350 * 0.48),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(0, -16),
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: _renderPart(
                                    widget.shirtPath,
                                    350 * 3.30,
                                  ),
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
                    // 1. Nilai default jika data belum ditemukan/sedang loading
                    String fullNameFromDb = 'LOADING...'; 
                    String nickNameFromDb = '';
                    Map<String, dynamic>? data;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null) {
                        // 2. Ambil data full_name dari Firestore
                        // Jika full_name kosong di db, dia akan pakai default 'NAMA TIDAK ADA'
                        fullNameFromDb = data['display_name'] ?? 'NAMA TIDAK ADA';
                        nickNameFromDb = data['display_name'] ?? '';
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DI SINI PERUBAHANNYA: 
                        // Ganti teks "FULL NAME" manual dengan variabel fullNameFromDb
                        Text(
                          fullNameFromDb.toUpperCase(), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.orange,
                          ),
                        ),
                        
                        // Bagian Email dan Nickname (seperti di gambar Anda)
                        Text(
                          "${FirebaseAuth.instance.currentUser?.email ?? ''} | ($nickNameFromDb)", 
                          style: const TextStyle(fontSize: 11, color: Colors.black54), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const Divider(height: 15),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMiniInfo('School', data?['school'] ?? '-'),
                            _buildMiniInfo('Birthday', data?['birthday'] ?? '-'),
                          ],
                        ),
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

  Widget _buildMiniInfo(String label, String value, {bool isRight = false}) {
    return Column(
      crossAxisAlignment: isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search Recipes...',
            prefixIcon: const Icon(Icons.search, color: Colors.orange),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = "";
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    String title,
    String subtitle,
    int stars,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBD2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.fastfood,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF3E2723),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 12,
                            color: i < stars
                                ? Colors.orange
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.orange,
                        size: 24,
                      ),
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

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.home, color: Colors.orange, size: 30),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => LevelsScreen(
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
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.grey),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => SpiceJournalScreen(
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
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => MultiplayerLobbyScreen(
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
