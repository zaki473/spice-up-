import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MultiplayerScoreScreen extends StatelessWidget {
  const MultiplayerScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              const Text("YOU PLACED", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.orange)),
              const Text("#2!", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.orange)),
              const Spacer(),
              // Bar Chart Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBar(height: 100, label: "Player 5", color: Colors.cyan.shade200),
                    _buildBar(height: 140, label: "Player 4", color: Colors.cyan.shade300),
                    _buildBar(height: 180, label: "Player 2", color: Colors.cyan.shade400, isMain: true),
                    _buildBar(height: 220, label: "Player 1", color: Colors.cyan.shade600, hasCrown: true),
                    _buildBar(height: 120, label: "Player 3", color: Colors.cyan.shade200),
                  ],
                ),
              ),
              const Spacer(),
              _buildActionButtons(),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar({required double height, required String label, required Color color, bool isMain = false, bool hasCrown = false}) {
    return Column(
      children: [
        if (hasCrown) const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
        const CircleAvatar(radius: 15, backgroundColor: Colors.white, child: Icon(Icons.person, size: 20)),
        const SizedBox(height: 8),
        Container(
          width: 45,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color, color.withOpacity(0.5)]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white),
          Text("Spice Up!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Icon(Icons.notifications, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconBtn(Icons.refresh),
        const SizedBox(width: 20),
        _iconBtn(Icons.share),
      ],
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildBottomNav(context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(children: [Icon(Icons.home, color: Colors.grey), Text(" Home")]),
          Icon(Icons.play_circle_fill, color: Colors.orange.shade400, size: 35),
          const Icon(Icons.menu_book, color: Colors.grey),
          const Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}