import 'package:flutter/material.dart';
import '../models/recipe_model.dart'; // Pastikan model sudah sesuai

final List<Recipe> listResep = [
  Recipe(
    title: "MI GOMAK",
    subtitle: "Batak Spicy Noodles",
    imagePath: 'assets/badges/SU_FOOD_01_MI_GOMAK.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.spice,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "Apa bahan utama Mi Gomak?",
        options: ["Mie Lidi", "Kwetiau", "Soun", "Penne"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_ANDALIMAN.png', // Gambar Spesifik Soal
      ),
      Question(
        text: "Rempah apa yang memberi rasa getir?",
        options: ["Jahe", "Andaliman", "Kunyit", "Lengkuas"],
        correctAnswerIndex: 1,
      ),
      Question(
        text: "Bagaimana tekstur mie lidi setelah direbus?",
        options: ["Lembek", "Kenyal Padat", "Rapuh", "Cair"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_GINGER.png', // Gambar Spesifik Soal
      ),
    ],
  ),
  Recipe(
    title: "IKAN KUAH KUNING",
    subtitle: "Yellow Turmeric Fish Soup",
    imagePath: 'assets/badges/ikan_kuning.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.bumbu,
    sunburstColor: const Color(0xFFE0F7FA),
    questions: [
      Question(
        text: "Ikan apa yang biasanya digunakan?",
        options: ["Tongkol", "Lele", "Mas", "Mujair"],
        correctAnswerIndex: 0,
      ),
      Question(
        text: "Warna kuning berasal dari?",
        options: ["Cabai", "Kunyit", "Kemiri", "Merica"],
        correctAnswerIndex: 1,
      ),
    ],
  ),
];