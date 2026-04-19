import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'score_screen.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.backgroundTop, AppColors.backgroundBottom]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("WHAT IS THIS\nSPICE CALLED?", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.orange)),
              ),
              // Clipboard Area
              _buildClipboard(),
              const Spacer(),
              // Options Grid
              _buildOptions(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
          const Text("Spice Up!", style: TextStyle(fontWeight: FontWeight.bold)),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Widget _buildClipboard() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.brown.shade400, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(height: 10, width: 60, decoration: BoxDecoration(color: Colors.brown.shade800, borderRadius: BorderRadius.circular(5))),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Icon(Icons.eco, size: 100, color: Colors.green), // Ganti dengan image rempah
                const Text("????", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                const Text("HINT: This spice creates a tingling, numbing sensation on your tongue.", 
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(context) {
    final List<String> options = ["Black Pepper", "Sichuan Pepper", "Andaliman", "Coriander"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScoreScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: Text(options[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}