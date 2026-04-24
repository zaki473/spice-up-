import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'mutuals_screen.dart';
import 'profile_screen.dart';

// Model Data untuk Bumbu
class SpiceInfo {
  final String name;
  final String imagePath;
  final String description;
  final String origin;

  SpiceInfo({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.origin,
  });
}

class SpiceJournalScreen extends StatefulWidget {
  // Parameter avatar agar data karakter tetap terjaga
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

  const SpiceJournalScreen({
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
  State<SpiceJournalScreen> createState() => _SpiceJournalScreenState();
}

class _SpiceJournalScreenState extends State<SpiceJournalScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // DATA BUMBU SESUAI GAMBAR ASSETS KAMU
  final List<SpiceInfo> journalData = [
    SpiceInfo(
      name: "ANDALIMAN", 
      imagePath: 'assets/quiz/SPC_ANDALIMAN.png', 
      description: "Known as 'Batak Pepper,' it provides a unique numbing and tingling sensation on the tongue.", 
      origin: "North Sumatra"
    ),
    SpiceInfo(
      name: "BAY LEAVES", 
      imagePath: 'assets/quiz/SPC_BAYLEAVES.png', 
      description: "Also known as 'Daun Salam,' these leaves add a subtle herbal aroma to stews and slow-cooked dishes.", 
      origin: "Asia & Mediterranean"
    ),
    SpiceInfo(
      name: "CANDLENUT", 
      imagePath: 'assets/quiz/SPC_CANDLENUT.png', 
      description: "Used to thicken sauces and add a rich, nutty, and savory texture to traditional spice pastes.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "CHILI", 
      imagePath: 'assets/quiz/SPC_CHILI.png', 
      description: "Provides a burning spicy heat and a vibrant red color that stimulates the appetite.", 
      origin: "Central & South America"
    ),
    SpiceInfo(
      name: "CORIANDER", 
      imagePath: 'assets/quiz/SPC_CORIANDER.png', 
      description: "Has a sweet citrusy aroma; its seeds are often toasted and ground with cumin for a deeper flavor.", 
      origin: "South Europe & North Africa"
    ),
    SpiceInfo(
      name: "CUMIN", 
      imagePath: 'assets/quiz/SPC_CUMIN.png', 
      description: "Provides a strong, earthy aroma and is an essential ingredient in various curry and meat dishes.", 
      origin: "West Asia"
    ),
    SpiceInfo(
      name: "GALANGAL", 
      imagePath: 'assets/quiz/SPC_GALANGAL.png', 
      description: "Known as 'Lengkuas,' it offers a sharp, fresh, pine-like aroma that is distinct from regular ginger.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "GARLIC", 
      imagePath: 'assets/quiz/SPC_GARLIC.png', 
      description: "One of the most popular base spices that adds a sharp, pungent, and savory flavor to almost any dish.", 
      origin: "Central Asia"
    ),
    SpiceInfo(
      name: "GINGER", 
      imagePath: 'assets/quiz/SPC_GINGER.png', 
      description: "Gives a warm, spicy heat and is frequently used to eliminate fishy odors in seafood recipes.", 
      origin: "Maritime Asia"
    ),
    SpiceInfo(
      name: "LEMONGRASS", 
      imagePath: 'assets/quiz/SPC_LEMONGRASS.png', 
      description: "Provides a powerful, fresh lemony scent that is perfect for stir-fries, soups, and aromatic broths.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "LIME", 
      imagePath: 'assets/quiz/SPC_LIME.png', 
      description: "Adds a fresh, acidic zest that helps balance flavors in rich and fatty traditional dishes.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "PALM SUGAR", 
      imagePath: 'assets/quiz/SPC_PALMSUGAR.png', 
      description: "A natural sweetener with a distinct caramel-like flavor, essential for traditional Indonesian bumbu.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "SHALLOT", 
      imagePath: 'assets/quiz/SPC_SHALLOT.png', 
      description: "A staple in Indonesian cooking that provides a sweet, savory, and aromatic base for most recipes.", 
      origin: "Central Asia"
    ),
    SpiceInfo(
      name: "SHRIMP PASTE", 
      imagePath: 'assets/quiz/SPC_SHRIMPPASTE.png', 
      description: "Known as 'Terasi,' it has a pungent aroma but provides a deep, savory umami flavor to sambals.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "TORCH GINGER", 
      imagePath: 'assets/quiz/SPC_TORCHGINGERFLOWER.png', 
      description: "Known as 'Kecombrang,' it has a unique floral fragrance and a fresh, citrusy sour taste.", 
      origin: "Southeast Asia"
    ),
    SpiceInfo(
      name: "TURMERIC", 
      imagePath: 'assets/quiz/SPC_TURMERIC.png', 
      description: "Responsible for the bright yellow color in dishes and provides a mild, earthy, and warm flavor.", 
      origin: "Southeast Asia"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryLabel("Spice Journal"),
              
              // AREA UTAMA CLIPBOARD
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemCount: journalData.length,
                      itemBuilder: (context, index) {
                        return _buildClipboardItem(journalData[index]);
                      },
                    ),
                    
                    // Tombol Panah Kiri
                    if (_currentPage > 0)
                      Positioned(
                        left: 15,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 40),
                          onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                        ),
                      ),
                    
                    // Tombol Panah Kanan
                    if (_currentPage < journalData.length - 1)
                      Positioned(
                        right: 15,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 40),
                          onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                        ),
                      ),
                  ],
                ),
              ),

              // Indikator Halaman (Dots)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("${_currentPage + 1} / ${journalData.length}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
              ),

              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClipboardItem(SpiceInfo spice) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Papan Cokelat (Background)
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.52,
            margin: const EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
              color: const Color(0xFFBCAAA4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF8D6E63), width: 8),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]
            ),
            // Kertas Putih
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    spice.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.orange),
                  ),
                  const Divider(color: Colors.orange, thickness: 2),
                  
                  // Area Gambar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        spice.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                  
                  // Deskripsi
                  Text(
                    spice.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  // Origin Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(15)),
                    child: Text("Origin: ${spice.origin}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown)),
                  ),
                ],
              ),
            ),
          ),
          // Penjepit Clipboard Merah (Sama dengan Gameplay)
          Positioned(
            top: 5,
            child: Container(
              width: 85,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFD84315),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]
              ),
              child: Center(
                child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PENDUKUNG ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tambahkan GestureDetector di sini
          GestureDetector(
            onTap: () {
              // Navigasi ke halaman profile
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
            },
            child: const CircleAvatar(
              radius: 18, 
              backgroundColor: Colors.white, 
              child: Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ),
          const Text("Spice Up!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Icon(Icons.notifications, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search spice...",
          prefixIcon: const Icon(Icons.search, color: Colors.orange),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategoryLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
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
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomepageScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle))),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelsScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle))),
          ),
          const Icon(Icons.menu_book, color: Colors.orange, size: 35),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MutualsScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle))),
          ),
        ],
      ),
    );
  }
}