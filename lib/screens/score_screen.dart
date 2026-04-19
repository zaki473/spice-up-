import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [Colors.white, AppColors.backgroundBottom], radius: 1.2),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => Icon(Icons.star, color: Colors.orange, size: i == 2 ? 80 : 50)),
              ),
              const SizedBox(height: 20),
              // Big Image
              const CircleAvatar(radius: 120, backgroundColor: Colors.white, child: Icon(Icons.flatware, size: 100, color: Colors.orange)),
              const SizedBox(height: 30),
              const Text("GOOD JOB!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.orange)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text("You've mastered this recipe! You can now view it in your Spice Journal.", 
                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleIconBtn(Icons.refresh),
                  const SizedBox(width: 20),
                  _circleIconBtn(Icons.share),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text("BACK TO HOME", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}