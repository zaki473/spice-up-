import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'gameplay_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

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
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                    const Text("Spice Up!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Icon(Icons.notifications_active, color: Colors.red),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Row(
                  children: [
                    // Timeline Sidebar
                    _buildTimeline(),
                    // Recipe List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(right: 16, top: 10),
                        children: [
                          _buildRecipeCard("MI GOMAK", "Batak Spicy Noodles", 4, true, context),
                          _buildRecipeCard("IKAN KUAH KUNING", "Yellow Turmeric Fish Soup", 3, true, context),
                          _buildRecipeCard("AYAM TALIWANG", "Lombok Spicy Grilled Chicken", 4, true, context),
                          _buildRecipeCard("TINUTUAN", "Manado Vegetable Porridge", 0, true, context),
                          _buildRecipeCard("PAPEDA", "Sago Porridge", 0, false, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Nav
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      width: 70,
      child: Column(
        children: [
          const Icon(Icons.eco, color: Colors.orange, size: 30),
          Expanded(
            child: Container(width: 3, color: Colors.orange.withOpacity(0.5)),
          ),
          const Icon(Icons.soup_kitchen, color: Colors.blue, size: 30),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String title, String desc, int stars, bool isUnlocked, BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GameplayScreen())) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundColor: Colors.orange.shade50, child: const Icon(Icons.restaurant, color: Colors.orange)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < stars ? Colors.orange : Colors.grey))),
                ],
              ),
            ),
            Icon(Icons.play_circle_fill, size: 40, color: isUnlocked ? Colors.orange : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [Icon(Icons.home), Text(" Home")]),
          ),
          const Icon(Icons.play_arrow, color: Colors.grey),
          const Icon(Icons.menu_book, color: Colors.grey),
          const Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}