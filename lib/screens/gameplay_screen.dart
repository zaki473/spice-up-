import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'score_screen.dart';
import 'multiplayer_score_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/recipe_data.dart';

class GameplayScreen extends StatefulWidget {
  final Recipe resep;
  final bool isMultiplayer;
  final String? roomCode;
  final String? playerId;
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

  const GameplayScreen({
    super.key, 
    required this.resep, 
    this.isMultiplayer = false,
    this.roomCode,
    this.playerId,
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
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> with WidgetsBindingObserver {
  int currentIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswering = false;
  int _timeLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isMultiplayer) {
      _startTimer();
    }
  }

  // --- LOGIKA TIMER & AFK (TETAP SAMA) ---
  void _startTimer() async {
    if (widget.isMultiplayer && widget.roomCode != null) {
      try {
        var roomSnap = await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).get();
        if (roomSnap.exists && mounted) {
          var data = roomSnap.data()!;
          Timestamp? startedAt = data['startedAt'];
          int duration = data['durationSeconds'] ?? 60;
          if (startedAt != null) {
            int elapsed = DateTime.now().difference(startedAt.toDate()).inSeconds;
            setState(() {
              _timeLeft = duration - elapsed;
              if (_timeLeft < 0) _timeLeft = 0;
            });
          }
        }
      } catch (e) {
        debugPrint("Error fetching timer: $e");
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        _endGame();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    if (widget.isMultiplayer && widget.roomCode != null && widget.playerId != null) {
      _markAsAfk(true);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.isMultiplayer && widget.roomCode != null && widget.playerId != null) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
        _markAsAfk(true);
      } else if (state == AppLifecycleState.resumed) {
        _markAsAfk(false);
      }
    }
  }

  Future<void> _markAsAfk(bool isAfk) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('players')
          .doc(widget.playerId)
          .update({'isAfk': isAfk});
    } catch (e) {
      debugPrint("Error updating AFK state: $e");
    }
  }

  // --- LOGIKA SELESAI GAME (TETAP SAMA) ---
  void _endGame() async {
    if (widget.isMultiplayer && widget.roomCode != null && widget.playerId != null) {
      try {
        await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode)
           .collection('players').doc(widget.playerId).update({
           'isFinished': true,
           'finishedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint("Error updating finished state: $e");
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerScoreScreen(
            score: score,
            roomCode: widget.roomCode!,
            playerId: widget.playerId!,
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
      return;
    }

    // Update Progress Single Player
    int totalSoal = widget.resep.questions.length;
    int maxScore = totalSoal * 10;
    double starCalculation = (score / maxScore) * 5;
    int finalStars = starCalculation.round();
    if (score > 0 && finalStars == 0) finalStars = 1;
    widget.resep.stars = finalStars;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);
          if (!snapshot.exists) return;
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> progress = data['progress'] is Map ? Map<String, dynamic>.from(data['progress']) : {};
          if (finalStars > (progress[widget.resep.title] ?? 0)) {
            progress[widget.resep.title] = finalStars;
          }
          List<dynamic> recent = data['recently_played'] is List ? List<dynamic>.from(data['recently_played']) : [];
          recent.remove(widget.resep.title);
          recent.insert(0, widget.resep.title);
          if (recent.length > 4) recent = recent.sublist(0, 4);

          // Evaluasi Ulang Badges
          List<String> unlockedBadges = [];
          if (progress.isNotEmpty) unlockedBadges.add("SPICE SPROUT");

          bool allLitleFinished = true;
          bool allBumbuFinished = true;
          for (var r in listResep) {
            if (r.difficulty == Difficulty.litle && (progress[r.title] ?? 0) == 0) {
              allLitleFinished = false;
            }
            if (r.difficulty == Difficulty.bumbu && (progress[r.title] ?? 0) == 0) {
              allBumbuFinished = false;
            }
          }

          if (allLitleFinished) unlockedBadges.add("LITTLE MORTAR");
          if (allBumbuFinished) unlockedBadges.add("BUMBU BUDDY");

          transaction.set(userRef, {
            'progress': progress,
            'recently_played': recent,
            'unlocked_badges': unlockedBadges,
          }, SetOptions(merge: true));
        });
      } catch (e) { debugPrint("Failed update: $e"); }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(
          score: score, 
          resep: widget.resep,
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

  void _answer(int index) async {
    if (isAnswering) return;
    setState(() {
      isAnswering = true;
      selectedAnswerIndex = index;
    });

    if (index == widget.resep.questions[currentIndex].correctAnswerIndex) {
      score += 10;
      if (widget.isMultiplayer && widget.roomCode != null) {
        double progress = ((currentIndex + 1) / widget.resep.questions.length) * 100;
        FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode)
           .collection('players').doc(widget.playerId).update({
           'score': FieldValue.increment(10),
           'progress': progress,
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    if (currentIndex < widget.resep.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswerIndex = null;
        isAnswering = false;
      });
    } else {
      _timer?.cancel();
      _endGame();
    }
  }

  // --- UI RESPONSIVE ---
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;
    
    final currentQuestion = widget.resep.questions[currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(screenWidth),
              
              if (widget.isMultiplayer) _buildTimer(screenWidth),

              Text(
                "QUESTION ${currentIndex + 1}",
                style: TextStyle(
                  fontSize: screenWidth * 0.06, 
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              // --- CLIPBOARD AREA (RESPONSIVE) ---
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 25, bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBCAAA4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF8D6E63), width: screenWidth * 0.02),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                currentQuestion.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 24 : 18, 
                                  fontWeight: FontWeight.w800, 
                                  color: const Color(0xFF4E342E)
                                ),
                              ),
                              const Divider(color: Colors.orange, thickness: 2),
                              Expanded(
                                child: _buildQuizImage(currentQuestion.imagePath ?? widget.resep.imagePath),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("????", style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.orange)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "HINT: ${currentQuestion.hint ?? 'Perhatikan tekstur dan warna pada gambar!'}",
                                      style: TextStyle(fontSize: isTablet ? 14 : 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Clip Penjepit Clipboard
                      Positioned(
                        top: 5,
                        child: Container(
                          width: screenWidth * 0.2, 
                          height: 40,
                          decoration: BoxDecoration(color: const Color(0xFFD84315), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- PILIHAN JAWABAN (GRID RESPONSIVE) ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: isTablet ? 4.0 : 2.8, // Aspect ratio disesuaikan tablet vs hp
                  ),
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    return _buildOptionButton(index, currentQuestion.options[index], currentQuestion.correctAnswerIndex, screenWidth);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, String text, int correctIndex, double screenWidth) {
    Color btnColorStart = Colors.orange;
    Color btnColorEnd = const Color(0xFFFFB74D);

    if (selectedAnswerIndex != null) {
      if (index == correctIndex) {
        btnColorStart = Colors.green;
        btnColorEnd = Colors.greenAccent;
      } else if (index == selectedAnswerIndex) {
        btnColorStart = Colors.red;
        btnColorEnd = Colors.redAccent;
      } else {
        btnColorStart = Colors.grey.shade400;
        btnColorEnd = Colors.grey.shade300;
      }
    }

    return GestureDetector(
      onTap: () => _answer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [btnColorStart, btnColorEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(double screenWidth) {
    bool isDanger = _timeLeft <= 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 8),
      decoration: BoxDecoration(
        color: isDanger ? Colors.red : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$_timeLeft s", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingPage(
              skinPath: widget.skinPath, eyePath: widget.eyePath, mouthPath: widget.mouthPath,
              nosePath: widget.nosePath, browsPath: widget.browsPath, hairPath: widget.hairPath,
              bangsPath: widget.bangsPath, shirtPath: widget.shirtPath, shirtColor: widget.shirtColor,
              hairStyle: widget.hairStyle,
            ))),
            child: CircleAvatar(radius: screenWidth * 0.05, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.orange, size: screenWidth * 0.06)),
          ),
          SvgPicture.asset('assets/images/logo_dan_bg/SU_TYPEFACE.svg', width: screenWidth * 0.2),
        ],
      ),
    );
  }

  Widget _buildQuizImage(String path) {
    return path.endsWith('.svg') 
      ? SvgPicture.asset(path, fit: BoxFit.contain) 
      : Image.asset(path, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50));
  }
}