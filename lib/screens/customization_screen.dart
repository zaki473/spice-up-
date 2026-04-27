import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import 'homepage_screen.dart';

class CharacterCustomizationScreen extends StatefulWidget {
  const CharacterCustomizationScreen({super.key});

  @override
  State<CharacterCustomizationScreen> createState() =>
      _CharacterCustomizationScreenState();
}

class _CharacterCustomizationScreenState
    extends State<CharacterCustomizationScreen> {
  int selectedCategoryIndex = 0;

  // 1. State Pilihan User (Default)
  String selectedSkinPath = 'assets/images/skin/SU_AVATAR_SKIN01.svg';
  String selectedEyePath = 'assets/images/eye/SU_AVATAR_EYE1.svg';
  String selectedMouthPath = 'assets/images/mouth/SU_AVATAR_MOUTH1.svg';
  String selectedNosePath = 'assets/images/nose/SU_AVATAR_NOSE1.svg';
  String selectedBrowsPath = 'assets/images/brows/SU_AVATAR_BROWS1.svg';
  String selectedHairPath = 'assets/images/hair/SU_AVATAR_HAIR1.png';
  String selectedBangsPath = 'assets/images/bangs/SU_AVATAR_BANGS1.svg';
  String selectedTopPath = 'assets/images/top/SU_AVATAR_TOP1.png';

  // 2. Daftar Aset per Kategori
  final List<String> skinAssets = List.generate(
    6,
    (i) => 'assets/images/skin/SU_AVATAR_SKIN0${i + 1}.svg',
  );
  final List<String> eyeAssets = List.generate(
    4,
    (i) => 'assets/images/eye/SU_AVATAR_EYE${i + 1}.svg',
  );
  final List<String> mouthAssets = List.generate(
    4,
    (i) => 'assets/images/mouth/SU_AVATAR_MOUTH${i + 1}.svg',
  );
  final List<String> noseAssets = List.generate(
    4,
    (i) => 'assets/images/nose/SU_AVATAR_NOSE${i + 1}.svg',
  );
  final List<String> browsAssets = List.generate(
    4,
    (i) => 'assets/images/brows/SU_AVATAR_BROWS${i + 1}.svg',
  );
  final List<String> hairAssets = List.generate(
    6,
    (i) => 'assets/images/hair/SU_AVATAR_HAIR${i + 1}.png',
  );
  final List<String> bangsAssets = List.generate(
    4,
    (i) => 'assets/images/bangs/SU_AVATAR_BANGS${i + 1}.svg',
  );
  final List<String> topAssets = List.generate(
    4,
    (i) => 'assets/images/top/SU_AVATAR_TOP${i + 1}.png',
  );

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.palette, 'name': 'Skin'},
    {'icon': Icons.visibility, 'name': 'Eye'},
    {'icon': Icons.sentiment_satisfied, 'name': 'Mouth'},
    {'icon': Icons.theater_comedy, 'name': 'Nose'},
    {'icon': Icons.face, 'name': 'Brows'},
    {'icon': Icons.perm_identity, 'name': 'Hair'},
    {'icon': Icons.border_all, 'name': 'Bangs'},
    {'icon': Icons.shopping_basket, 'name': 'Top'},
  ];

  @override
  Widget build(BuildContext context) {
    const double avatarSize =
        350.0; // Ukuran sedikit diperbesar agar detail terlihat

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/logo_dan_bg/SU_MAIN_BG01.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // BASE
                          _renderPart(selectedSkinPath, avatarSize),

                          // RAMBUT BELAKANG
                          Positioned(
                            top: -avatarSize * 0.14,
                            child: _renderPart(selectedHairPath, avatarSize * 1.14),
                          ),

                          // ALIS
                          Positioned(
                            top: avatarSize * 0.20,
                            child: _renderPart(selectedBrowsPath, avatarSize * 0.26),
                          ),

                          // MATA
                          Positioned(
                            top: avatarSize * 0.25,
                            child: _renderPart(selectedEyePath, avatarSize * 0.36),
                          ),

                          // HIDUNG
                          Positioned(
                            top: avatarSize * 0.41,
                            child: _renderPart(selectedNosePath, avatarSize * 0.055),
                          ),

                          // MULUT
                          Positioned(
                            top: avatarSize * 0.50,
                            child: _renderPart(selectedMouthPath, avatarSize * 0.13),
                          ),

                          // PONI
                          Positioned(
                            top: -avatarSize * 0.01,
                            child: _renderPart(selectedBangsPath, avatarSize * 0.48),
                          ),

                          // BAJU
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(0, -16),
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: _renderPart(selectedTopPath, avatarSize * 3.30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ... (bagian bawah code tetap sama)
                Container(
                  height: 70,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryTab(
                        index,
                        categories[index]['icon'],
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: AppColors.cardColor,
                    padding: const EdgeInsets.all(16),
                    child: _buildOptionsGrid(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderPart(String path, double width) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: width, fit: BoxFit.contain);
    } else {
      return Image.asset(path, width: width, fit: BoxFit.contain);
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 120,
            fit: BoxFit.contain,
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context, 
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.orangePrimary))
              );

              // 1. Simpan Pilihan Avatar ke Firestore
              var user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  'avatar_settings': {
                    'skin': selectedSkinPath,
                    'eyes': selectedEyePath,
                    'mouth': selectedMouthPath,
                    'nose': selectedNosePath,
                    'brows': selectedBrowsPath,
                    'hair': selectedHairPath,
                    'bangs': selectedBangsPath,
                    'top': selectedTopPath,
                  }
                }, SetOptions(merge: true));
              }

              if (!mounted) return;
              Navigator.pop(context); // Tutup Loading

              // 2. Teruskan pengguna ke Homepage membawa Avatarnya
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomepageScreen(
                    skinPath: selectedSkinPath,
                    eyePath: selectedEyePath,
                    mouthPath: selectedMouthPath,
                    nosePath: selectedNosePath,
                    browsPath: selectedBrowsPath,
                    hairPath: selectedHairPath,
                    bangsPath: selectedBangsPath,
                    shirtPath: selectedTopPath,
                    shirtColor: Colors.white,
                    hairStyle: Icons.face,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Save & Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid() {
    List<String> currentAssets = [];
    String currentSelected = "";

    switch (selectedCategoryIndex) {
      case 0:
        currentAssets = skinAssets;
        currentSelected = selectedSkinPath;
        break;
      case 1:
        currentAssets = eyeAssets;
        currentSelected = selectedEyePath;
        break;
      case 2:
        currentAssets = mouthAssets;
        currentSelected = selectedMouthPath;
        break;
      case 3:
        currentAssets = noseAssets;
        currentSelected = selectedNosePath;
        break;
      case 4:
        currentAssets = browsAssets;
        currentSelected = selectedBrowsPath;
        break;
      case 5:
        currentAssets = hairAssets;
        currentSelected = selectedHairPath;
        break;
      case 6:
        currentAssets = bangsAssets;
        currentSelected = selectedBangsPath;
        break;
      case 7:
        currentAssets = topAssets;
        currentSelected = selectedTopPath;
        break;
    }

    return GridView.builder(
      itemCount: currentAssets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        String path = currentAssets[index];
        bool isSelected = currentSelected == path;
        return GestureDetector(
          onTap: () => setState(() {
            if (selectedCategoryIndex == 0)
              selectedSkinPath = path;
            else if (selectedCategoryIndex == 1)
              selectedEyePath = path;
            else if (selectedCategoryIndex == 2)
              selectedMouthPath = path;
            else if (selectedCategoryIndex == 3)
              selectedNosePath = path;
            else if (selectedCategoryIndex == 4)
              selectedBrowsPath = path;
            else if (selectedCategoryIndex == 5)
              selectedHairPath = path;
            else if (selectedCategoryIndex == 6)
              selectedBangsPath = path;
            else if (selectedCategoryIndex == 7)
              selectedTopPath = path;
          }),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.orangePrimary
                    : Colors.grey.shade200,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: _renderPart(path, 50),
          ),
        );
      },
    );
  }

  Widget _buildCategoryTab(int index, IconData icon) {
    bool isSelected = selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedCategoryIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.orangePrimary,
          size: 28,
        ),
      ),
    );
  }
}
