import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../constants/app_colors.dart';
import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';
import 'multiplayer_lobby_screen.dart';
import '../utils/size_config.dart';

class MultiplayerScoreScreen extends StatelessWidget {
  final int score;
  final String roomCode;
  final String playerId;
  
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

  const MultiplayerScoreScreen({
    super.key,
    this.score = 0,
    required this.roomCode,
    required this.playerId,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: roomCode.isNotEmpty 
                ? FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(roomCode)
                    .collection('players')
                    .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> players = [];
              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  players.add({
                    'id': doc.id,
                    'label': doc.id == playerId ? 'You' : (data['name'] ?? 'Player'),
                    'score': data['score'] ?? 0,
                    'isMain': doc.id == playerId,
                  });
                }
              }

              // Fallback jika stream belum masuk
              if (players.isEmpty) {
                players = [{'label': 'You', 'score': score, 'isMain': true}];
              }

              // Urutkan berdasarkan skor tertinggi
              players.sort((a, b) => b['score'].compareTo(a['score']));
              
              int myRank = players.indexWhere((p) => p['isMain']) + 1;
              // Cari skor tertinggi untuk skala bar chart (minimal 1 agar tidak bagi nol)
              int topScore = players.isNotEmpty ? (players.first['score'] as int) : 1;
              if (topScore == 0) topScore = 1;

              return Column(
                children: [
                  SizedBox(height: 30.h),
                  Text("YOUR SCORE", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white70)),
                  Text("$score", style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w900, color: Colors.white, shadows: const [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))])),
                  
                  SizedBox(height: 20.h),
                  Text("YOU PLACED", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white70)),
                  Text(myRank > 0 ? "#$myRank!" : "-", style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.w900, color: Colors.white, shadows: const [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))])),
                  
                  const Spacer(),
                  
                  // Leaderboard Bar Chart
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(players.length, (index) {
                        var p = players[index];
                        // Hitung tinggi bar secara proporsional (maksimal 200.h)
                        double h = (p['score'] / topScore) * 180.0.h;
                        if (h < 45.h) h = 45.h; 
                        
                        return _buildBar(
                          height: h, 
                          label: p['label'], 
                          color: p['isMain'] ? Colors.white : Colors.white.withOpacity(0.4), 
                          isMain: p['isMain'], 
                          hasCrown: index == 0 && p['score'] > 0 // Mahkota untuk nomor 1
                        );
                      }),
                    ),
                  ),
                  
                  const Spacer(),
                  _buildReturnButton(context),
                  SizedBox(height: 15.h),
                  _buildBottomNav(context),
                  SizedBox(height: 10.h),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildBar({required double height, required String label, required Color color, bool isMain = false, bool hasCrown = false}) {
    return Column(
      children: [
        if (hasCrown) 
          Icon(Icons.emoji_events, color: Colors.amber, size: 35.sp)
        else 
          SizedBox(height: 35.sp), // Placeholder agar bar sejajar jika tidak ada mahkota
        
        CircleAvatar(
          radius: 18.w, 
          backgroundColor: Colors.white, 
          child: Icon(Icons.person, size: 22.sp, color: isMain ? Colors.orange : Colors.grey)
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 60.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 45.w,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              colors: [color, color.withOpacity(0.1)]
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.w)),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Center(
            child: isMain ? Icon(Icons.star, color: Colors.orange, size: 20.sp) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Keluar dari room dan kembali ke Lobby
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MultiplayerLobbyScreen(
            skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
            nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
            bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor,
            hairStyle: hairStyle,
          )),
        );
      },
      icon: const Icon(Icons.logout_rounded, color: Colors.white),
      label: const Text("LEAVE ROOM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w)),
        elevation: 5,
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(35.w),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(context, Icons.home_outlined, HomepageScreen(
            skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
            nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
            bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle,
          )),
          _navIcon(context, Icons.play_circle_outline, LevelsScreen(
            skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
            nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
            bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle,
          )),
          _navIcon(context, Icons.menu_book_outlined, SpiceJournalScreen(
            skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
            nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
            bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle,
          )),
          // FIX: Tambahkan parameter avatar di sini
          _navIcon(context, Icons.person, MultiplayerLobbyScreen(
            skinPath: skinPath, eyePath: eyePath, mouthPath: mouthPath,
            nosePath: nosePath, browsPath: browsPath, hairPath: hairPath,
            bangsPath: bangsPath, shirtPath: shirtPath, shirtColor: shirtColor, hairStyle: hairStyle,
          ), isSelected: true),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, Widget target, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => target)),
      child: Icon(icon, color: isSelected ? Colors.orange : Colors.grey, size: 28.sp),
    );
  }
}