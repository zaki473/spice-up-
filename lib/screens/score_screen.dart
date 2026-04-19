import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  const ScoreScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("FINISHED!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text("Your Score: $score", style: const TextStyle(fontSize: 50, color: Colors.orange)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BACK TO LEVELS"),
            )
          ],
        ),
      ),
    );
  }
}