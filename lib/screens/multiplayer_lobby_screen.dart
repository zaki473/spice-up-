import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:async';

import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';
import 'gameplay_screen.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
import '../utils/size_config.dart';

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

class _MultiplayerLobbyScreenState extends State<MultiplayerLobbyScreen>
    with SingleTickerProviderStateMixin {
  // States: 0 = Selection, 1 = Join Input, 2 = Inside Lobby
  int _viewState = 0;
  String _roomCode = "";
  String _playerId = "";
  final TextEditingController _codeController = TextEditingController();

  // Data simulasi pemain di room
  List<Map<String, dynamic>> _players = [];
  bool _isHost = false;
  bool _isGachaShowing = false;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;

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
    _roomSubscription?.cancel();
    _pulseController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _listenToRoomStatus() {
    _roomSubscription?.cancel();
    _roomSubscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(_roomCode)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            var data = snapshot.data() as Map<String, dynamic>;
            if (data['status'] == 'playing') {
              int levelIndex = data['selectedLevelIndex'] ?? 0;
              _showGachaAnimation(listResep[levelIndex]);
            }
          }
        });
  }

  void _showGachaAnimation(Recipe selectedRecipe) async {
    if (_isGachaShowing) return;
    _isGachaShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const GachaAnimationDialog();
      },
    );

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pop(context); // close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameplayScreen(
            resep: selectedRecipe,
            isMultiplayer: true,
            roomCode: _roomCode,
            playerId: _playerId,
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
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  void _createRoom() async {
    String generatedCode = _generateRoomCode();

    setState(() {
      _isHost = true;
      _roomCode = generatedCode;
      _playerId = 'host_id_1';
      _viewState = 2; // Pindah layar dengan cepat menghindari kesan hang
    });
    _listenToRoomStatus();

    try {
      final firestore = FirebaseFirestore.instance;
      // 1. Induk Room
      await firestore.collection('rooms').doc(generatedCode).set({
        'hostName': 'Tuan Rumah',
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Buat profil player buat Diri Sendiri (Host) lengkap dengan Wajah
      await firestore
          .collection('rooms')
          .doc(generatedCode)
          .collection('players')
          .doc('host_id_1')
          .set({
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
            },
          });
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
      if (roomSnap.data()?['status'] == 'playing') {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Room Code tidak ditemukan!")),
          );
        return;
      }

      String myGuestID = "guest_${DateTime.now().millisecondsSinceEpoch}";

      setState(() {
        _isHost = false;
        _roomCode = enteredCode;
        _playerId = myGuestID;
        _viewState = 2;
      });
      _listenToRoomStatus();

      // Join sebagai Guest lengkap dengan Wajah
      await firestore
          .collection('rooms')
          .doc(enteredCode)
          .collection('players')
          .doc(myGuestID)
          .set({
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
            },
          });
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal joint: $e")));
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

    // Gunakan ukuran dasar 350 agar perhitungan multiplier (0.15, 0.31, dll) akurat
    double baseSize = 350;

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: baseSize,
        height: baseSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // BASE
            _renderAvatarPart(
              avatarData['skinPath'] ?? widget.skinPath,
              baseSize,
            ),

            // RAMBUT BELAKANG
            Positioned(
              top: -baseSize * 0.15,
              left: baseSize * -0.11,
              child: _renderAvatarPart(
                avatarData['hairPath'] ?? widget.hairPath,
                baseSize * 1.24,
              ),
            ),

            // ALIS
            Positioned(
              top: baseSize * 0.25,
              child: _renderAvatarPart(
                avatarData['browsPath'] ?? widget.browsPath,
                baseSize * 0.31,
              ),
            ),

            // MATA
            Positioned(
              top: baseSize * 0.29,
              child: _renderAvatarPart(
                avatarData['eyePath'] ?? widget.eyePath,
                baseSize * 0.39,
              ),
            ),

            // HIDUNG
            Positioned(
              top: baseSize * 0.45,
              child: _renderAvatarPart(
                avatarData['nosePath'] ?? widget.nosePath,
                baseSize * 0.055,
              ),
            ),

            // MULUT
            Positioned(
              top: baseSize * 0.5,
              child: _renderAvatarPart(
                avatarData['mouthPath'] ?? widget.mouthPath,
                baseSize * 0.13,
              ),
            ),

            // PONI
            Positioned(
              top: -baseSize * -0.03,
              child: _renderAvatarPart(
                avatarData['bangsPath'] ?? widget.bangsPath,
                baseSize * 0.53,
              ),
            ),

            // BAJU
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(5, -10), // kanan & sedikit turun
                  child: Transform.scale(
                    scale: 1.2,
                    child: _renderAvatarPart(
                      avatarData['shirtPath'] ?? widget.shirtPath,
                      baseSize * 3.31,
                    ),
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
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 40.sp),
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                    () => _viewState = _viewState == 2 && _isHost ? 0 : 0,
                  );
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
            colors: [
              Color(0xFFFF9800),
              Color(0xFFFFCC80),
            ], // Gradasi Oranye Semangat
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.w),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.grey, size: 30.w),
            onPressed: () => Navigator.pushReplacement(
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
          IconButton(
            icon: Icon(
              Icons.play_circle_outline,
              color: Colors.grey,
              size: 30.w,
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LevelsScreen(
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
            icon: Icon(
              Icons.menu_book_outlined,
              color: Colors.grey,
              size: 30.w,
            ),
            onPressed: () => Navigator.pushReplacement(
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
          Icon(Icons.person, color: Colors.orange, size: 32.w),
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
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_rounded,
              size: 100.w,
              color: Colors.white,
            ),
            SizedBox(height: 20.h),
            Text(
              "SPICE DUEL",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.w,
              ),
            ),
            Text(
              "Tantang temanmu melihat siapa koki tercepat!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
            ),
            SizedBox(height: 60.h),
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
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "JOIN ROOM",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Masukkan 5 digit kode ruangan temanmu:",
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.w),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: TextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                maxLength: 5,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                  letterSpacing: 10.w,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "KODE",
                  hintStyle: TextStyle(color: Colors.black26),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 60.h,
              child: ElevatedButton(
                onPressed: _joinRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "MASUK SEKARANG",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
          SizedBox(height: 20.h),
          Text(
            "ROOM CODE",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.w,
            ),
          ),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.w),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                _roomCode,
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange.shade900,
                  letterSpacing: 8.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Menunggu pemain lain...",
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 40.h),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.w)),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _roomCode.isNotEmpty
                      ? FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(_roomCode)
                            .collection('players')
                            .snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    int playerCount = snapshot.hasData
                        ? snapshot.data!.docs.length
                        : 0;
                    var docs = snapshot.hasData ? snapshot.data!.docs : [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PLAYERS ($playerCount/4)",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: snapshot.hasData
                              ? GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.8,
                                        crossAxisSpacing: 15.w,
                                        mainAxisSpacing: 15.h,
                                      ),
                                  itemCount:
                                      playerCount + (playerCount < 4 ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == playerCount) {
                                      return _buildEmptyPlayerSlot();
                                    }
                                    var data =
                                        docs[index].data()
                                            as Map<String, dynamic>;
                                    // Identifikasi diri sendiri
                                    bool isMeLocally =
                                        data['name'] ==
                                        (_isHost
                                            ? 'Kamu (Host)'
                                            : 'Teman Baru');
                                    var playerMap = {
                                      "name": data['name'] ?? 'Player',
                                      "isMe": isMeLocally,
                                      "avatar":
                                          data['avatar'], // Lempar data muka ke widget
                                    };
                                    return _buildPlayerCard(playerMap);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                ),
                        ),

                        // Action Buttons Base on Role
                        if (_isHost) ...[
                          SizedBox(height: 15.h),
                          SizedBox(
                            width: double.infinity,
                            height: 65.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                int randomLevelIndex = Random().nextInt(
                                  listResep.length,
                                );
                                await FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc(_roomCode)
                                    .update({
                                      'status': 'playing',
                                      'selectedLevelIndex': randomLevelIndex,
                                      'startedAt': FieldValue.serverTimestamp(),
                                      'durationSeconds': 60,
                                    });
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Memilih level acak..."),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.w),
                                ),
                                elevation: 8,
                              ),
                              child: Text(
                                "START GAME",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5.w,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 15.h),
                          Center(
                            child: Text(
                              "Menunggu Host memulai...",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    bool isMe = player["isMe"];
    return Container(
      decoration: BoxDecoration(
        color: isMe ? Colors.orange.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: isMe ? Colors.orange : Colors.grey.shade300,
          width: 2.w,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: _buildPlayerAvatar(player["avatar"])),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Text(
              player["name"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.grey.shade800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlayerSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
          width: 2.w,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_disabled_rounded,
              size: 40.w,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 10.h),
            Text(
              "Waiting...",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 8),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 50.w, color: textColor),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GachaAnimationDialog extends StatefulWidget {
  const GachaAnimationDialog({super.key});

  @override
  State<GachaAnimationDialog> createState() => _GachaAnimationDialogState();
}

class _GachaAnimationDialogState extends State<GachaAnimationDialog> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentIndex = Random().nextInt(listResep.length);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var resep = listResep[_currentIndex];
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Mengacak Level...",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                color: resep.sunburstColor,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: Image.asset(resep.imagePath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              resep.title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
