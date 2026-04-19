import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

final List<Recipe> listResep = [
  Recipe(
    title: "MI GOMAK",
    subtitle: "Batak Spicy Noodles",
    imagePath: 'assets/badges/SU_FOOD_01_MI_GOMAK.png', // Pastikan path benar
    stars: 3,
    isLocked: false,
    difficulty: Difficulty.spice,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(text: "Apa bahan utama Mi Gomak?", options: ["Mie Lidi", "Kwetiau", "Soun", "Penne"], correctAnswerIndex: 0),
      Question(text: "Rempah apa yang memberi rasa getir?", options: ["Jahe", "Andaliman", "Kunyit", "Lengkuas"], correctAnswerIndex: 1),
      // ... Tambahkan hingga 10 soal
    ],
  ),
  Recipe(
    title: "IKAN KUAH KUNING",
    subtitle: "Yellow Turmeric Fish Soup",
    imagePath: 'assets/images/food/ikan_kuning.png',
    stars: 5,
    isLocked: false,
    difficulty: Difficulty.bumbu,
    sunburstColor: const Color(0xFFE0F7FA),
    questions: [
      Question(text: "Ikan apa yang biasanya digunakan?", options: ["Tongkol", "Lele", "Mas", "Mujair"], correctAnswerIndex: 0),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
    ],
  ),

  Recipe(
    title: "IKAN KUAH KUNING",
    subtitle: "Yellow Turmeric Fish Soup",
    imagePath: 'assets/images/food/ikan_kuning.png',
    stars: 0,
    isLocked: true,
    difficulty: Difficulty.spice,
    sunburstColor: const Color(0xFFE0F7FA),
    questions: [
      Question(text: "Ikan apa yang biasanya digunakan?", options: ["Tongkol", "Lele", "Mas", "Mujair"], correctAnswerIndex: 0),
      Question(text: "Warna kuning berasal dari?", options: ["Cabai", "Kunyit", "Kemiri", "Merica"], correctAnswerIndex: 1),
    ],
  ),

  Recipe(
    title: "AYAM TALIWANG",
    subtitle: "Lombok Spicy Grilled Chicken",
    imagePath: 'assets/images/food/taliwang.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.litle, // Masuk kategori Little
    sunburstColor: const Color(0xFFFBE9E7),
    questions: [
      Question(text: "Dari daerah mana Ayam Taliwang?", options: ["Bali", "Lombok", "Medan", "Papua"], correctAnswerIndex: 1),
    ],
  ),
];