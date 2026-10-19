import 'package:flutter/material.dart';

enum Mood {
  mutlu,
  sakin,
  notr,
  uzgun,
  stresli;

  String get label {
    switch (this) {
      case Mood.mutlu:
        return 'Mutlu';
      case Mood.sakin:
        return 'Sakin';
      case Mood.notr:
        return 'Nötr';
      case Mood.uzgun:
        return 'Üzgün';
      case Mood.stresli:
        return 'Stresli';
    }
  }

  Color get color {
    switch (this) {
      case Mood.mutlu:
        return const Color(0xFF66BB6A); // Pastel Yeşil
      case Mood.sakin:
        return const Color(0xFF4FC3F7); // Pastel Mavi
      case Mood.notr:
        return const Color(0xFFB0BEC5); // Nötr Gri
      case Mood.uzgun:
        return const Color(0xFFAB47BC); // Mor / Leylak
      case Mood.stresli:
        return const Color(0xFFEF5350); // Pastel Mercan Kırmızı
    }
  }

  IconData get icon {
    switch (this) {
      case Mood.mutlu:
        return Icons.sentiment_very_satisfied_rounded;
      case Mood.sakin:
        return Icons.sentiment_satisfied_rounded;
      case Mood.notr:
        return Icons.sentiment_neutral_rounded;
      case Mood.uzgun:
        return Icons.sentiment_dissatisfied_rounded;
      case Mood.stresli:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }
}
