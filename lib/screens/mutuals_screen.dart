import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MutualsScreen extends StatelessWidget {
  const MutualsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryLabel("Friends"),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFriendCard("SASMITA KURNIA SARI", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                    _buildFriendCard("GIBRAN RAKABUMING", [Icons.workspace_premium]),
                    _buildFriendCard("RIDWAN PRAYOGA", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                    _buildFriendCard("ANITA GABRIEL", [Icons.eco, Icons.soup_kitchen, Icons.workspace_premium]),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white),
          Text("Spice Up!", style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.notifications, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search UID...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(String name, List<IconData> badges) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyan.shade100, width: 2),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 5),
                Row(children: badges.map((icon) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: Icon(icon, size: 12)),
                )).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.home, color: Colors.grey),
          Icon(Icons.play_circle, color: Colors.grey),
          Icon(Icons.menu_book, color: Colors.grey),
          CircleAvatar(radius: 15, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 18, color: Colors.white)),
        ],
      ),
    );
  }
}