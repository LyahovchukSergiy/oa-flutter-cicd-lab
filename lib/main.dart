// Демо лекції 10: «Табло вильотів».
//
// Застосунок сам по собі нецікавий і саме тому підходить: він потрібен,
// щоб було що проганяти через пайплайн. Уся суть демо лежить у
// .github/workflows, а не тут.
//
// Локальний запуск:
//   cp define.example.json define.json
//   flutter pub get
//   flutter run --dart-define-from-file=define.json
//
// Ті самі перевірки, що робить CI:
//   dart format --output=none --set-exit-if-changed .
//   flutter analyze --fatal-infos
//   flutter test
//
// Релізна збірка так, як її збирає пайплайн:
//   flutter build apk --release --dart-define-from-file=define.json
//
// define.json у .gitignore. У пайплайні той самий файл збирається
// з GitHub Secrets на кроці збірки.

import 'package:flutter/material.dart';

import 'board/board_screen.dart';
import 'board/sample_flights.dart';

void main() => runApp(const BoardApp());

class BoardApp extends StatelessWidget {
  const BoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return MaterialApp(
      title: 'Табло вильотів',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF00579E),
        useMaterial3: true,
      ),
      home: BoardScreen(flights: sampleFlights(now), now: now),
    );
  }
}
