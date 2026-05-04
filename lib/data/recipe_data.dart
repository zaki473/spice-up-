import 'package:flutter/material.dart';
import '../models/recipe_model.dart'; // Pastikan model sudah sesuai

final List<Recipe> listResep = [
  // no 1
  Recipe(
    title: "MI GOMAK",
    subtitle: "Batak Spicy Noodles",
    imagePath: 'assets/food/SU_FOOD_01_MI_GOMAK.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.spice,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "This spice creates a tingling, numbing sensation on your tongue.",
        options: ["Black Pepper", "Sichuan Pepper", "Andaliman", "Coriander"],
        correctAnswerIndex: 2,
        imagePath: 'assets/quiz/SPC_ANDALIMAN.png', // Gambar Spesifik Soal
        hint: "Native to North Sumatra",
      ),
      Question(
        text: "Which spice gives the dish its strong pungent base aroma?",
        options: ["Garlic", "Cinnamon", "Nutmeg", "Clove"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png',
        hint: "Common in almost every savory dish",
      ),
      Question(
        text: "This spice is usually small, purple, and sweeter than onions.",
        options: ["Leek", "Shallot", "Ginger", "Basil"],
        correctAnswerIndex: 2,
        imagePath: 'assets/quiz/SPC_SHALLOT.png', // Gambar Spesifik Soal
        hint: "Indonesian “bawang merah”",
      ),
      Question(
        text: "Which spice gives the dish its spicy heat?",
        options: ["Paprika", "Chili", "Turmeric", "Lemongrass"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_CHILI.png', // Gambar Spesifik Soal
        hint: "Obvious one",
      ),
      Question(
        text: "Which spice adds a yellow color and earthy flavor?",
        options: ["Turmeric", "Ginger", "Galangal", "Mustard"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
        hint: "often stains your hands yellow",
      ),
    ],
  ),

  // no 2
  Recipe(
    title: "IKAN KUAH KUNING",
    subtitle: "Yellow Turmeric Fish Soup",
    imagePath: 'assets/food/SU_FOOD_01_IKAN_KUAH_KUNING.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.spice,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "This spice is responsible for the bright yellow broth.",
        options: ["Saffron", "Turmeric", "Curry Leaf", "Paprika"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
      ),
      Question(
        text: "Which ingredient gives a fresh citrus aroma (not sour like lemon)?",
        options: ["Lemongrass", "Mint", "Basil", "Pandan"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_LEMONGRASS.png',
      ),
      Question(
        text: "Which adds spicy heat?",
        options: ["Ginger", "Chili", "Pepper", "Clove"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_CHILI.png', // Gambar Spesifik Soal
      ),
      Question(
        text: "Which ingredient adds sour freshness to balance the dish?",
        options: ["Vinegar", "Lime", "Tamarind", "Yogurt"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_LIME.png', // Gambar Spesifik Soal
      ),
      Question(
        text: "Which spice builds the savory base flavor?",
        options: ["Garlic", "Cinnamon", "Nutmeg", "Star Anise"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
      ),
    ],
  ),

  // no 3
  Recipe(
    title: "Ayam Taliwang",
    subtitle: " Lombok Spicy Grilled Chicken ",
    imagePath: 'assets/food/SU_FOOD_02_AYAM_TALIWANG.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.bumbu,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "This ingredient gives a deep umami, slightly funky aroma.",
        options: ["Soy Sauce", "Shrimp Paste", "Fish Sauce", "Cheese"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_SHRIMPPASTE.png', // Gambar Spesifik Soal
        hint: " A fermented seafood product widely used in sambal",
      ),
      Question(
        text: "Which spice provides main spiciness?",
        options: ["Pepper", "Chili", "Ginger", "Turmeric"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_CHILI.png',
        hint: "The hotter the dish, the more of this is used",
      ),
      Question(
        text: "Which ingredient adds sweet balance?",
        options: ["Honey", "Palm Sugar", "Brown Sugar", "Maple Syrup"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_PALMSUGAR.png', // Gambar Spesifik Soal
        hint: "Traditional Indonesian sweetener made from palm sap",
      ),
      Question(
        text: "Which ingredient adds sour freshness to balance the dish?",
        options: ["Shallots", "Cinnamon", "Basil", "Lemongrass"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_SHALLOT.png',
         // Gambar Spesifik Soal
        hint: "Often paired with garlic as a basic seasoning duo"
      ),
      Question(
        text: "Which spice gives a sharp savory kick?",
        options: ["Garlic", "Vanilla", "Clove", "Nutmeg"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png', // Gambar Spesifik Soal
        hint: "A must-have in almost every savory dish worldwide",
      ),
    ],
  ),

  // no 4
  Recipe(
    title: "Tinutuan",
    subtitle: " Manado Vegetable Porridge",
    imagePath: 'assets/food/SU_FOOD_02_TINUTUAN.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.bumbu,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "Which spice gives a yellow tint?",
        options: ["Turmeric", "Ginger", "Pepper", "Coriander"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
        hint: "Known for its strong natural coloring",
      ),
      Question(
        text: "Which has a fresh citrusy aroma (not sour)?",
        options: ["Lemongrass", "Lime", "Mint", "Pandan"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_LEMONGRASS.png',
        hint: "Commonly used to add fragrance to soups",
      ),
      Question(
        text: "Which is often used in soups as a fragrant leaf?",
        options: ["Bay leaves", "Spinach", "Lettuce", "Kale"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_BAYLEAVES.png', // Gambar Spesifik Soal
        hint: "Usually added whole, not eaten directly",
      ),
      Question(
        text: "Which herb smells fresh and slightly sweet?",
        options: ["Basil", "Chili", "Clove", "Nutmeg"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_BASIL.png', // Gambar Spesifik Soal
        hint: "Often used fresh as a garnish"
      ),
      Question(
        text: "Which builds the savory base?",
        options: ["Garlic", "Sugar", "Milk", "Vanilla"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png', // Gambar Spesifik Soal
        hint: "A key ingredient in many sautéed dishes",
      ),
    ],
  ),

  // no 5
  Recipe(
    title: "Papeda",
    subtitle: "Sago Porridge",
    imagePath: 'assets/food/SU_FOOD_02_PAPEDA.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.bumbu,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "Which spice gives yellow color to the broth?",
        options: ["Turmeric", "Pepper", "Ginger", "Basil"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
        hint: "A root spice that leaves a strong color stain",
      ),
      Question(
        text: "Which adds spicy heat?",
        options: ["Chili", "Sugar", "Milk", "Cinnamon"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_CHILI.png',
        hint: "Used fresh or dried for different heat levels",
      ),
      Question(
        text: "Which gives fresh sourness?",
        options: ["Lime", "Salt", "Garlic", "Coriander"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_LIME.png', // Gambar Spesifik Soal
        hint: "Usually squeezed right before eating",
      ),
      Question(
        text: "Which gives savory base flavor?",
        options: ["Garlic", "Vanilla", "Chocolate", "Honey"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png', // Gambar Spesifik Soal
        hint: "One of the most essential cooking ingredients worldwide"
      ),
      Question(
        text: "Which has a citrus aroma but not sour?",
        options: ["Lemongrass", "Lemon", "Tamarind", "Vinegar"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_LEMONGRASS.png', // Gambar Spesifik Soal
        hint: "Adds fragrance rather than taste",
      ),
    ],
  ),

  // no 6
  Recipe(
    title: "Coto Makassar",
    subtitle: "Makassar Beef Soup",
    imagePath: 'assets/food/SU_FOOD_03_COTOMAKASSAR.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.litle,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "This spice has a warm, slightly citrusy and nutty flavor.",
        options: ["Coriander", "Clove", "Nutmeg", "Pepper"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_CORIANDER.png', // Gambar Spesifik Soal
        hint: "Often used in powdered form for meat dishes",
      ),
      Question(
        text: "Which spice has a strong, earthy, slightly bitter taste?",
        options: ["Cumin", "Basil", "Cinnamon", "Pandan"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_CUMIN.png',
        hint: "Common in Middle Eastern and Indian cuisine too",
      ),
      Question(
        text: "Which root spice tastes sharp and more intense than ginger?",
        options: ["Turmeric", "Galangal", "Ginger", "Mustard"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_GALANGAL.png', // Gambar Spesifik Soal
        hint: "Often sliced, not grated",
      ),
      Question(
        text: "Which gives a fresh citrus aroma without sourness?",
        options: ["Lime", "Lemongrass", "Vinegar", "Tamarind"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_LEMONGRASS.png', // Gambar Spesifik Soal
        hint: "Usually crushed before cooking",
      ),
      Question(
        text: "Which is a fragrant leaf used in soups?",
        options: ["Lettuce", "Bay leaves", "Spinach", "Kale"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_BAY_LEAVES.png', // Gambar Spesifik Soal
        hint: "Added whole and removed before serving",
      ),
    ],
  ),

  // no 7
  Recipe(
    title: "Arsik",
    subtitle: "Batak Spiced Fish",
    imagePath: 'assets/food/SU_FOOD_03_ARSIK.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.litle,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "This spice gives a numbing, tingling sensation.",
        options: ["Pepper", "Andaliman", "Chili", "Coriander"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_ANDALIMAN.png', // Gambar Spesifik Soal
        hint: "Common in Batak cuisine",
      ),
      Question(
        text: "Which ingredient has a floral, slightly sour aroma?",
        options: ["Basil", "Torch ginger flower", "Mint", "Pandan"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_TORCHGINGERFLOWER.png',
        hint: "Bright pink and often used in Indonesian salads",
      ),
      Question(
        text: "Which builds the savory base flavor? ",
        options: ["Garlic", "Sugar", "Milk", "Vanilla"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png', // Gambar Spesifik Soal
        hint: "Usually sautéed at the start",
      ),
      Question(
        text: "Which is small, aromatic, and slightly sweet? ",
        options: ["Onion", "Shallot", "Leek", "Ginger"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_SHALLOT.png', // Gambar Spesifik Soal
        hint: " Common in Indonesian spice paste",
      ),
      Question(
        text: "Which spice gives a yellow color?",
        options: ["Turmeric", "Pepper", "Basil", "Clove"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TURMERIC.png', // Gambar Spesifik Soal
        hint: "A root that stains easily",
      ),
    ],
  ),

  // no 8
  Recipe(
    title: "Ayam Betutu",
    subtitle: "Balinese Spiced Chicken",
    imagePath: 'assets/food/SU_FOOD_03_AYAMBETUTU.png',
    stars: 0,
    isLocked: false,
    difficulty: Difficulty.litle,
    sunburstColor: const Color(0xFFFFEBD2),
    questions: [
      Question(
        text: "Which spice gives yellow color?",
        options: ["Turmeric", "Ginger", "Pepper", "Basil"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_ANDALIMAN.png', // Gambar Spesifik Soal
        hint: "Widely used in Indonesian spice blends",
      ),
      Question(
        text: "Which spice has a warm, slightly spicy and fresh taste?",
        options: ["Ginger", "Cinnamon", "Clove", "Nutmeg"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_TORCHGINGERFLOWER.png',
        hint: "Bright pink and often used in Indonesian salads",
      ),
      Question(
        text: "Which spice is similar to ginger but stronger?",
        options: ["Galangal", "Turmeric", "Pepper", "Coriander"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_GARLIC.png', // Gambar Spesifik Soal
        hint: "Harder texture and sharper aroma",
      ),
      Question(
        text: "Which ingredient adds creamy texture to spice paste? ",
        options: ["Almond", "Candlenut", "Peanut", "Soybean"],
        correctAnswerIndex: 1,
        imagePath: 'assets/quiz/SPC_CANDLENUT.png', // Gambar Spesifik Soal
        hint: "Ground into paste for thickness",
      ),
      Question(
        text: "Which provides spicy heat?",
        options: ["Chili", "Sugar", "Milk", "Vanilla"],
        correctAnswerIndex: 0,
        imagePath: 'assets/quiz/SPC_CHILI.png', // Gambar Spesifik Soal
        hint: "Key ingredient for heat in sambal",
      ),
    ],
  ),
];