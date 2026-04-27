import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';// Pastikan import ini disesuaikan jika alamat path-nya salah
// import '../constants/app_colors.dart';

class MultiplayerLobbyScreen extends StatefulWidget {
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

  const MultiplayerLobbyScreen({
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
  State<MultiplayerLobbyScreen> createState() => _MultiplayerLobbyScreenState();
}

class _MultiplayerLobbyScreenState extends State<MultiplayerLobbyScreen> with SingleTickerProviderStateMixin {
  // States: 0 = Selection, 1 = Join Input, 2 = Inside Lobby
  int _viewState = 0;
  String _roomCode = "";
  final TextEditingController _codeController = TextEditingController();
  
  // Data simulasi pemain di room
  List<Map<String, dynamic>> _players = [];
  bool _isHost = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void _createRoom() async {
    String generatedCode = _generateRoomCode();
    
    setState(() {
      _isHost = true;
      _roomCode = generatedCode;
      _viewState = 2; // Pindah layar dengan cepat menghindari kesan hang
    });

    try {
      final firestore = FirebaseFirestore.instance;
      // 1. Induk Room
      await firestore.collection('rooms').doc(generatedCode).set({
        'hostName': 'Tuan Rumah',
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Buat profil player buat Diri Sendiri (Host) lengkap dengan Wajah
      await firestore.collection('rooms').doc(generatedCode).collection('players').doc('host_id_1').set({
        'name': 'Kamu (Host)',
        'isHost': true,
        'score': 0,
        'avatar': {
          'skinPath': widget.skinPath,
          'eyePath': widget.eyePath,
          'mouthPath': widget.mouthPath,
          'nosePath': widget.nosePath,
          'browsPath': widget.browsPath,
          'hairPath': widget.hairPath,
          'bangsPath': widget.bangsPath,
          'shirtPath': widget.shirtPath,
          'shirtColor': widget.shirtColor.value,
        }
      });
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _joinRoom() async {
    if (_codeController.text.length < 3) return;
    FocusScope.of(context).unfocus();
    String enteredCode = _codeController.text.toUpperCase();
    
    try {
      final firestore = FirebaseFirestore.instance;
      // Cek Validasi Kode
      var roomSnap = await firestore.collection('rooms').doc(enteredCode).get();
      if (!roomSnap.exists) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Room Code tidak ditemukan!")));
        return;
      }

      setState(() {
        _isHost = false;
        _roomCode = enteredCode;
        _viewState = 2;
      });

      // Join sebagai Guest lengkap dengan Wajah
      String myGuestID = "guest_${DateTime.now().millisecondsSinceEpoch}";
      await firestore.collection('rooms').doc(enteredCode).collection('players').doc(myGuestID).set({
        'name': 'Teman Baru',
        'isHost': false,
        'score': 0,
        'avatar': {
          'skinPath': widget.skinPath,
          'eyePath': widget.eyePath,
          'mouthPath': widget.mouthPath,
          'nosePath': widget.nosePath,
          'browsPath': widget.browsPath,
          'hairPath': widget.hairPath,
          'bangsPath': widget.bangsPath,
          'shirtPath': widget.shirtPath,
          'shirtColor': widget.shirtColor.value,
        }
      });

    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal joint: $e")));
    }
  }

  Widget _renderAvatarPart(String path, double width) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(path, width: width, fit: BoxFit.contain);
    }
    return Image.asset(path, width: width, fit: BoxFit.contain);
  }

  Widget _buildPlayerAvatar(Map<String, dynamic>? avatarData) {
    if (avatarData == null) return _buildDummyAvatar(Colors.teal, Icons.person);

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 350,
        height: 350,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _renderAvatarPart(avatarData['skinPath'] ?? widget.skinPath, 350),
            Positioned(top: -350 * 0.14, child: _renderAvatarPart(avatarData['hairPath'] ?? widget.hairPath, 350 * 1.14)),
            Positioned(top: 350 * 0.20, child: _renderAvatarPart(avatarData['browsPath'] ?? widget.browsPath, 350 * 0.26)),
            Positioned(top: 350 * 0.25, child: _renderAvatarPart(avatarData['eyePath'] ?? widget.eyePath, 350 * 0.36)),
            Positioned(top: 350 * 0.41, child: _renderAvatarPart(avatarData['nosePath'] ?? widget.nosePath, 350 * 0.055)),
            Positioned(top: 350 * 0.50, child: _renderAvatarPart(avatarData['mouthPath'] ?? widget.mouthPath, 350 * 0.13)),
            Positioned(top: -350 * 0.01, child: _renderAvatarPart(avatarData['bangsPath'] ?? widget.bangsPath, 350 * 0.48)),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -16),
                  child: Transform.scale(
                    scale: 1.2,
                    child: _renderAvatarPart(avatarData['shirtPath'] ?? widget.shirtPath, 350 * 3.30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummyAvatar(Color bgColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _viewState > 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () {
                  setState(() => _viewState = _viewState == 2 && _isHost ? 0 : 0);
                },
              ),
            )
          : null,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9800), Color(0xFFFFCC80)], // Gradasi Oranye Semangat
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildCurrentView(),
                ),
              ),
              if (_viewState == 0) _buildBottomNav(context),
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
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageScreen(
                skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath,
                nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath,
                bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor,
                hairStyle: widget.hairStyle,
              )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LevelsScreen(
                skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath,
                nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath,
                bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor,
                hairStyle: widget.hairStyle,
              )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: Colors.grey, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SpiceJournalScreen(
                skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath,
                nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath,
                bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor,
                hairStyle: widget.hairStyle,
              )),
            ),
          ),
          const Icon(Icons.person, color: Colors.orange, size: 32),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_viewState == 0) return _buildSelectionView();
    if (_viewState == 1) return _buildJoinInputView();
    return _buildInsideLobbyView();
  }

  // ================= VIEW 1 =================
  Widget _buildSelectionView() {
    return KeyedSubtree(
      key: const ValueKey(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_esports_rounded, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "SPICE DUEL",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const Text(
              "Tantang temanmu melihat siapa koki tercepat!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 60),
            _buildBigButton(
              title: "CREATE ROOM",
              subtitle: "Bikin ruang baru dan jadi Host",
              icon: Icons.add_home_rounded,
              color: Colors.white,
              textColor: Colors.orange.shade800,
              onTap: _createRoom,
            ),
            const SizedBox(height: 20),
            _buildBigButton(
              title: "JOIN ROOM",
              subtitle: "Masuk ke ruangan teman dengan kode",
              icon: Icons.login_rounded,
              color: Colors.orange.shade800,
              textColor: Colors.white,
              onTap: () => setState(() => _viewState = 1),
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIEW 2 =================
  Widget _buildJoinInputView() {
    return KeyedSubtree(
      key: const ValueKey(1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "JOIN ROOM",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Masukkan 5 digit kode ruangan temanmu:", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: TextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                maxLength: 5,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange.shade900, letterSpacing: 10),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "KODE",
                  hintStyle: TextStyle(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _joinRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
                child: const Text("MASUK SEKARANG", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIEW 3 =================
  Widget _buildInsideLobbyView() {
    return KeyedSubtree(
      key: const ValueKey(2),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("ROOM CODE", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2)),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
              ),
              child: Text(
                _roomCode,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.orange.shade900, letterSpacing: 8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Menunggu pemain lain...", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          
          const SizedBox(height: 40),
          
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _roomCode.isNotEmpty 
                      ? FirebaseFirestore.instance.collection('rooms').doc(_roomCode).collection('players').snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    int playerCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    var docs = snapshot.hasData ? snapshot.data!.docs : [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PLAYERS ($playerCount/4)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                        const SizedBox(height: 20),
                        Expanded(
                          child: snapshot.hasData 
                          ? GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, 
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                              itemCount: playerCount + (playerCount < 4 ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == playerCount) {
                                  return _buildEmptyPlayerSlot();
                                }
                                var data = docs[index].data() as Map<String, dynamic>;
                                // Identifikasi diri sendiri
                                bool isMeLocally = data['name'] == (_isHost ? 'Kamu (Host)' : 'Teman Baru');
                                var playerMap = {
                                  "name": data['name'] ?? 'Player', 
                                  "isMe": isMeLocally,
                                  "avatar": data['avatar'] // Lempar data muka ke widget
                                };
                                return _buildPlayerCard(playerMap);
                              },
                            )
                          : const Center(child: CircularProgressIndicator(color: Colors.orange))
                        ),
                        
                        // Action Buttons Base on Role
                        if (_isHost) ...[
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Ganti status database jd Playing
                                await FirebaseFirestore.instance.collection('rooms').doc(_roomCode).update({'status': 'playing'});
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Broommm! Memulai Game...")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 8,
                              ),
                              child: const Text("START GAME", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 15),
                          Center(
                            child: Text("Menunggu Host memulai...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
                          ),
                        ]
                      ],
                    );
                  }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    bool isMe = player["isMe"];
    return Container(
      decoration: BoxDecoration(
        color: isMe ? Colors.orange.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isMe ? Colors.orange : Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _buildPlayerAvatar(player["avatar"]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              player["name"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyPlayerSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled_rounded, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text("Waiting...", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({required String title, required String subtitle, required IconData icon, required Color color, required Color textColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 8), blurRadius: 15)]),
        child: Row(
          children: [
            Icon(icon, size: 50, color: textColor),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textColor)),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
