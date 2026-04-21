import 'package:flutter/material.dart';

enum Difficulty { spice, bumbu, litle }

class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imagePath;
  final String? hint;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.imagePath,
    this.hint,
  });
}

class Recipe {
  final String title;
  final String subtitle;
  final String imagePath;
  int stars;
  final bool isLocked;
  final Color sunburstColor;
  final Difficulty difficulty;
  final List<Question> questions;

  Recipe({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.stars,
    required this.isLocked,
    required this.sunburstColor,
    required this.difficulty,
    required this.questions,
  });
}
