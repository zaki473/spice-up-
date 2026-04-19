import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SpiceJournalScreen extends StatelessWidget {
  const SpiceJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.backgroundTop, AppColors.backgroundBottom]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryLabel("Spice Journal"),
              const Spacer(),
              // Clipboard
              _buildClipboardContent(),
              const Spacer(),
              // Pagination Arrows
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.orange, size: 30),
                    Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 30),
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
          hintText: "Search...",
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
        margin: const EdgeInsets.only(left: 20),
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

  Widget _buildClipboardContent() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.brown.shade400, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(height: 15, width: 80, decoration: BoxDecoration(color: Colors.brown.shade800, borderRadius: BorderRadius.circular(5))),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              children: [
                const Text("ANDALIMAN", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 20),
                const Icon(Icons.eco, size: 120, color: Colors.green), // Ganti dengan Image.asset
                const SizedBox(height: 20),
                const Text(
                  "This spice creates a tingling, numbing sensation on your tongue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
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
          Icon(Icons.menu_book, color: Colors.orange),
          Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}