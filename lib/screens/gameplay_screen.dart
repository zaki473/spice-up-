import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'score_screen.dart';

class GameplayScreen extends StatefulWidget {
  final Recipe resep;
  const GameplayScreen({super.key, required this.resep});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int currentIndex = 0;
  int score = 0;

  void _answer(int index) {
    if (index == widget.resep.questions[currentIndex].correctAnswerIndex) {
      score += 10;
    }

    setState(() {
      if (currentIndex < widget.resep.questions.length - 1) {
        currentIndex++;
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScoreScreen(score: score)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.resep.questions[currentIndex];
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(title: Text(widget.resep.title), backgroundColor: Colors.orange),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Question ${currentIndex + 1} of ${widget.resep.questions.length}"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(q.text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          const Spacer(),
          ...List.generate(q.options.length, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () => _answer(i),
                child: Text(q.options[i]),
              ),
            ),
          )),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}