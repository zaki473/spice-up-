import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/recipe_model.dart';
import 'score_screen.dart';
import 'multiplayer_score_screen.dart';
import 'levels_screen.dart';
import 'profile_screen.dart'; // pastikan import ini ada
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
  
  // Variable baru untuk mengontrol feedback jawaban
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
        setState(() {
          _timeLeft--;
        });
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

    // ORIGINAL SINGLE-PLAYER LOGIC
    int totalSoal = widget.resep.questions.length;
    int maxScore = totalSoal * 10;
    double starCalculation = (score / maxScore) * 5;
    int finalStars = starCalculation.round();
    if (score > 0 && finalStars == 0) finalStars = 1;
    widget.resep.stars = finalStars;

    // UPDATE TO FIRESTORE
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      
      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);
          if (!snapshot.exists) return;
          
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          
          // Update Progress
          Map<String, dynamic> progress = data['progress'] is Map ? Map<String, dynamic>.from(data['progress']) : {};
          int currentStars = progress[widget.resep.title] ?? 0;
          if (finalStars > currentStars) {
            progress[widget.resep.title] = finalStars;
          }

          // Update Recently Played
          List<dynamic> recent = data['recently_played'] is List ? List<dynamic>.from(data['recently_played']) : [];
          recent.remove(widget.resep.title);
          recent.insert(0, widget.resep.title);
          if (recent.length > 4) recent = recent.sublist(0, 4);

          // Update Badges
          List<dynamic> badges = data['unlocked_badges'] is List ? List<dynamic>.from(data['unlocked_badges']) : [];
          int recipeIndex = listResep.indexOf(widget.resep);
          
          if (finalStars > 0) {
            if (recipeIndex == 0 && !badges.contains("SPICE SPROUT")) {
              badges.add("SPICE SPROUT");
            } else if (recipeIndex > 0 && widget.resep.difficulty != listResep[recipeIndex - 1].difficulty) {
              if (widget.resep.difficulty == Difficulty.litle && !badges.contains("LITTLE MORTAR")) {
                badges.add("LITTLE MORTAR");
              } else if (widget.resep.difficulty == Difficulty.bumbu && !badges.contains("BUMBU BUDDY")) {
                badges.add("BUMBU BUDDY");
              }
            }
          }

          transaction.set(userRef, {
            'progress': progress,
            'recently_played': recent,
            'unlocked_badges': badges,
          }, SetOptions(merge: true));
        });
      } catch (e) {
        debugPrint("Failed to update progress: $e");
      }
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

  Widget _buildQuizImage(String path) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        placeholderBuilder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
      );
    }
  }

  // Fungsi Logika Jawaban yang Diperbarui
  void _answer(int index) async {
    if (isAnswering) return; // Mencegah klik ganda saat animasi jeda

    setState(() {
      isAnswering = true;
      selectedAnswerIndex = index;
    });

    // Cek jika benar
    if (index == widget.resep.questions[currentIndex].correctAnswerIndex) {
      score += 10;
      if (widget.isMultiplayer && widget.roomCode != null && widget.playerId != null) {
        double progress = ((currentIndex + 1) / widget.resep.questions.length) * 100;
        FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode)
           .collection('players').doc(widget.playerId).update({
           'score': FieldValue.increment(10),
           'progress': progress,
        });
      }
    } else {
      if (widget.isMultiplayer && widget.roomCode != null && widget.playerId != null) {
        double progress = ((currentIndex + 1) / widget.resep.questions.length) * 100;
        FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode)
           .collection('players').doc(widget.playerId).update({
           'progress': progress,
        });
      }
    }

    // Beri jeda 1.5 detik agar user bisa melihat jawaban yang benar/salah
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (currentIndex < widget.resep.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswerIndex = null;
        isAnswering = false;
      });
    } else {
      // Game Selesai
      _timer?.cancel();
      _endGame();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildCustomHeader(),
              const SizedBox(height: 10),
              if (widget.isMultiplayer) _buildTimer(),
              Text(
                "QUESTION ${currentIndex + 1}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 5),

              // --- CLIPBOARD AREA ---
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      margin: const EdgeInsets.only(top: 25, bottom: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBCAAA4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8D6E63), width: 8),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentQuestion.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF4E342E)),
                            ),
                            const Divider(color: Colors.orange, thickness: 2),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: _buildQuizImage(currentQuestion.imagePath ?? widget.resep.imagePath),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text("????", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "HINT: ${currentQuestion.hint ?? 'Perhatikan tekstur dan warna pada gambar!'}",
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Penjepit Clipboard
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 85, height: 45,
                        decoration: BoxDecoration(color: const Color(0xFFD84315), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle))),
                      ),
                    ),
                  ],
                ),
              ),

              // --- PILIHAN JAWABAN DENGAN LOGIKA WARNA ---
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3.2,
                  ),
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    // Logika Penentuan Warna
                    Color btnColorStart = Colors.orange;
                    Color btnColorEnd = const Color(0xFFFFB74D);

                    if (selectedAnswerIndex != null) {
                      if (index == currentQuestion.correctAnswerIndex) {
                        // Jawaban yang benar selalu hijau
                        btnColorStart = Colors.green;
                        btnColorEnd = Colors.greenAccent;
                      } else if (index == selectedAnswerIndex) {
                        // Jawaban yang dipilih salah menjadi merah
                        btnColorStart = Colors.red;
                        btnColorEnd = Colors.redAccent;
                      } else {
                        // Sisanya menjadi abu-abu transparan
                        btnColorStart = Colors.grey.shade400;
                        btnColorEnd = Colors.grey.shade300;
                      }
                    }

                    return GestureDetector(
                      onTap: () => _answer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [btnColorStart, btnColorEnd],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))],
                        ),
                        child: Center(
                          child: Text(
                            currentQuestion.options[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    );
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

  Widget _buildTimer() {
    bool isDanger = _timeLeft <= 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDanger ? Colors.red : Colors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Text(
        "$_timeLeft s",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // --- HEADER DENGAN NAVIGASI KE PROFILE ---
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingPage(
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
                )),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.orange),
            ),
          ),
          SvgPicture.asset(
            'assets/images/logo_dan_bg/SU_TYPEFACE.svg',
            width: 80,
          ),
        ],
      ),
    );
  }
}