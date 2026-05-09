import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:async';

import 'homepage_screen.dart';
import 'levels_screen.dart';
import 'spice_journal_screen.dart';
import 'gameplay_screen.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
import '../utils/size_config.dart';
import '../utils/app_dialogs.dart';

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

  final String? initialRoomCode;
  final String? initialPlayerId;
  final bool initialIsHost;
  final bool fromScoreScreen;

  const MultiplayerLobbyScreen({
    super.key,
    this.initialRoomCode,
    this.initialPlayerId,
    this.initialIsHost = false,
    this.fromScoreScreen = false,
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
  int _viewState = 0;
  String _roomCode = "";
  String _playerId = "";
  final TextEditingController _codeController = TextEditingController();

  bool _isHost = false;
  bool _isGachaShowing = false;
  bool _waitingForReset = false;
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

    if (widget.initialRoomCode != null && widget.initialPlayerId != null) {
      _roomCode = widget.initialRoomCode!;
      _playerId = widget.initialPlayerId!;
      _isHost = widget.initialIsHost;
      _viewState = 2;
      
      if (widget.fromScoreScreen) {
        _waitingForReset = true;
      }

      if (_isHost) {
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(_roomCode)
            .update({'status': 'waiting'}).catchError((_) {});
      }
      
      _listenToRoomStatus();
    }
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
          if (!snapshot.exists) {
            if (!_isHost && mounted && _viewState == 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Room telah ditutup oleh Host.")),
              );
              setState(() { _viewState = 0; });
            }
            return;
          }
          var data = snapshot.data() as Map<String, dynamic>;
          
          if (_waitingForReset && data['status'] == 'waiting') {
            _waitingForReset = false;
          }

          if (!_waitingForReset && data['status'] == 'playing') {
            int levelIndex = data['selectedLevelIndex'] ?? 0;
            _showGachaAnimation(listResep[levelIndex]);
          } else if (data['status'] == 'closed') {
            if (!_isHost && mounted && _viewState == 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Room telah ditutup oleh Host.")),
              );
              setState(() { _viewState = 0; });
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
      builder: (context) => const GachaAnimationDialog(),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pop(context);
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
    return String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void _createRoom() async {
    String generatedCode = _generateRoomCode();
    setState(() {
      _isHost = true;
      _roomCode = generatedCode;
      _playerId = 'host_id_1';
      _viewState = 2;
    });
    _listenToRoomStatus();

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('rooms').doc(generatedCode).set({
        'hostName': 'Tuan Rumah',
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });

      String myName = FirebaseAuth.instance.currentUser?.displayName ?? 'Kamu (Host)';

      await firestore.collection('rooms').doc(generatedCode).collection('players').doc('host_id_1').set({
            'name': myName,
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _joinRoom() async {
    if (_codeController.text.length < 3) return;
    FocusScope.of(context).unfocus();
    String enteredCode = _codeController.text.toUpperCase();

    try {
      final firestore = FirebaseFirestore.instance;
      var roomSnap = await firestore.collection('rooms').doc(enteredCode).get();
      if (!roomSnap.exists || roomSnap.data()?['status'] == 'playing') {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Room tidak tersedia!")));
        return;
      }

      String myGuestID = FirebaseAuth.instance.currentUser?.uid ?? "guest_${DateTime.now().millisecondsSinceEpoch}";
      String myName = FirebaseAuth.instance.currentUser?.displayName ?? 'Teman Baru';

      setState(() {
        _isHost = false;
        _roomCode = enteredCode;
        _playerId = myGuestID;
        _viewState = 2;
      });
      _listenToRoomStatus();

      await firestore.collection('rooms').doc(enteredCode).collection('players').doc(myGuestID).set({
            'name': myName,
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal join: $e")));
    }
  }

  Widget _renderAvatarPart(String path, double width) {
    if (path.endsWith('.svg')) return SvgPicture.asset(path, width: width, fit: BoxFit.contain);
    return Image.asset(path, width: width, fit: BoxFit.contain);
  }

  Widget _buildPlayerAvatar(Map<String, dynamic>? avatarData) {
    if (avatarData == null) return Container(color: Colors.grey.shade200, child: const Icon(Icons.person));
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
            _renderAvatarPart(avatarData['skinPath'] ?? widget.skinPath, baseSize),
            Positioned(top: -baseSize * 0.15, left: baseSize * -0.11, child: _renderAvatarPart(avatarData['hairPath'] ?? widget.hairPath, baseSize * 1.24)),
            Positioned(top: baseSize * 0.25, child: _renderAvatarPart(avatarData['browsPath'] ?? widget.browsPath, baseSize * 0.31)),
            Positioned(top: baseSize * 0.29, child: _renderAvatarPart(avatarData['eyePath'] ?? widget.eyePath, baseSize * 0.39)),
            Positioned(top: baseSize * 0.45, child: _renderAvatarPart(avatarData['nosePath'] ?? widget.nosePath, baseSize * 0.055)),
            Positioned(top: baseSize * 0.5, child: _renderAvatarPart(avatarData['mouthPath'] ?? widget.mouthPath, baseSize * 0.13)),
            Positioned(top: -baseSize * -0.03, child: _renderAvatarPart(avatarData['bangsPath'] ?? widget.bangsPath, baseSize * 0.53)),
            Positioned(
              left: 0, right: 0,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(4, -10),
                  child: Transform.scale(scale: 1.2, child: _renderAvatarPart(avatarData['shirtPath'] ?? widget.shirtPath, baseSize * 3.33)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_viewState == 2) {
      bool? confirm = await AppDialogs.showConfirmDialog(
        context,
        "Keluar Room?",
        "Apakah kamu yakin ingin keluar dari room ini?",
        confirmText: "Keluar",
        cancelText: "Batal",
      );
      if (confirm == true) {
        if (_isHost) {
          FirebaseFirestore.instance.collection('rooms').doc(_roomCode).update({'status': 'closed'});
        } else {
          FirebaseFirestore.instance.collection('rooms').doc(_roomCode).collection('players').doc(_playerId).delete();
        }
        setState(() => _viewState = 0);
      }
      return false;
    } else if (_viewState == 1) {
      setState(() => _viewState = 0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _viewState > 0
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () async { if (await _onWillPop()) Navigator.of(context).pop(); },
                ),
              )
            : null,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF9800), Color(0xFFFFCC80)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildCurrentView(isTablet),
                  ),
                ),
                if (_viewState == 0) _buildBottomNav(context, screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(bool isTablet) {
    switch (_viewState) {
      case 0: return _buildSelectionView(isTablet);
      case 1: return _buildJoinInputView();
      case 2: return _buildInsideLobbyView(isTablet);
      default: return const SizedBox();
    }
  }

  Widget _buildSelectionView(bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          Icon(Icons.sports_esports_rounded, size: isTablet ? 120.w : 100.w, color: Colors.white),
          SizedBox(height: 20.h),
          Text(
            "SPICE DUEL",
            style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
          ),
          Text("Tantang temanmu melihat siapa koki tercepat!", textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, color: Colors.white70)),
          SizedBox(height: 50.h),
          _buildBigButton(
            title: "CREATE ROOM",
            subtitle: "Bikin ruang baru dan jadi Host",
            icon: Icons.add_home_rounded,
            color: Colors.white,
            textColor: Colors.orange.shade800,
            onTap: _createRoom,
          ),
          SizedBox(height: 20.h),
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
    );
  }

  Widget _buildJoinInputView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("JOIN ROOM", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10.h),
          const Text("Masukkan 5 digit kode ruangan:", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 30.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              maxLength: 5,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.orange.shade900, letterSpacing: 10),
              decoration: const InputDecoration(border: InputBorder.none, counterText: "", hintText: "KODE"),
            ),
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            height: 60.h,
            child: ElevatedButton(
              onPressed: _joinRoom,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Text("MASUK SEKARANG", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsideLobbyView(bool isTablet) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        const Text("ROOM CODE", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 2)),
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(_roomCode, style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w900, color: Colors.orange.shade900, letterSpacing: 5)),
          ),
        ),
        const Text("Menunggu pemain lain...", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        SizedBox(height: 30.h),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
            padding: EdgeInsets.all(25.w),
            child: StreamBuilder<QuerySnapshot>(
              stream: _roomCode.isNotEmpty ? FirebaseFirestore.instance.collection('rooms').doc(_roomCode).collection('players').snapshots() : const Stream.empty(),
              builder: (context, snapshot) {
                int playerCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                var docs = snapshot.hasData ? snapshot.data!.docs : [];

                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("PLAYERS ($playerCount/4)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 4 : 2, // 4 kolom jika tablet
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: playerCount + (playerCount < 4 ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == playerCount) return _buildEmptyPlayerSlot();
                          var data = docs[index].data() as Map<String, dynamic>;
                          return _buildPlayerCard(data, docs[index].id == _playerId);
                        },
                      ),
                    ),
                    if (_isHost) _buildStartButton() else const Padding(padding: EdgeInsets.all(10), child: Text("Menunggu Host memulai...", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: () async {
          int randomLevelIndex = Random().nextInt(listResep.length);
          await FirebaseFirestore.instance.collection('rooms').doc(_roomCode).update({
            'status': 'playing',
            'selectedLevelIndex': randomLevelIndex,
            'startedAt': FieldValue.serverTimestamp(),
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: Text("START GAME", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: Colors.white)),
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> data, bool isMe) {
    return Container(
      decoration: BoxDecoration(
        color: isMe ? Colors.orange.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isMe ? Colors.orange : Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(10), child: ClipOval(child: _buildPlayerAvatar(data['avatar'])))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(data['name'] ?? 'Player', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlayerSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Center(
        child: Icon(Icons.person_add_alt_1, size: 40.w, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildBigButton({required String title, required String subtitle, required IconData icon, required Color color, required Color textColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
        child: Row(
          children: [
            Icon(icon, size: 45.w, color: textColor),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: textColor)),
                  Text(subtitle, style: TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, double screenWidth) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      height: 65.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(35), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(context, Icons.home_outlined, HomepageScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle), screenWidth),
          _navIcon(context, Icons.play_circle_outline, LevelsScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle), screenWidth),
          _navIcon(context, Icons.menu_book_outlined, SpiceJournalScreen(skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath, nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath, bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor, hairStyle: widget.hairStyle), screenWidth),
          Icon(Icons.person, color: Colors.orange, size: 30.w),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, Widget target, double screenWidth) {
    return IconButton(icon: Icon(icon, color: Colors.grey, size: 28.w), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target)));
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
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) => setState(() => _currentIndex = Random().nextInt(listResep.length)));
  }
  @override
  void dispose() { _timer.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    var resep = listResep[_currentIndex];
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Mengacak Level...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 20),
            Container(
              width: 120.w, height: 120.w,
              decoration: BoxDecoration(color: resep.sunburstColor, borderRadius: BorderRadius.circular(15)),
              child: Image.asset(resep.imagePath, fit: BoxFit.cover),
            ),
            const SizedBox(height: 15),
            Text(resep.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}