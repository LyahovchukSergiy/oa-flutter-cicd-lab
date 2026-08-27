import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Значення, які застосунок отримує на збірці, а не в рантаймі.
///
/// Локально вони приходять з `--dart-define-from-file=define.json`,
/// у пайплайні з GitHub Secrets. Файл `define.json` у `.gitignore`,
/// поруч лежить `define.example.json` з безпечними значеннями.
class AppConfig {
  const AppConfig._();

  /// Назва середовища. Видно в шапці застосунку, щоб на скріншоті
  /// одразу було зрозуміло, яка це збірка.
  static const String environment = String.fromEnvironment(
    'BUILD_ENV',
    defaultValue: 'local',
  );

  /// Токен доступу до табло. У демо він нікуди не ходить: нам важливо
  /// довести, що значення доїхало до збірки, а не що воно робить.
  static const String boardToken = String.fromEnvironment('BOARD_TOKEN');

  static bool get hasToken => boardToken.isNotEmpty;

  /// Відбиток токена: вісім символів SHA-256.
  ///
  /// Саме значення не показуємо ніде і ніколи. Відбиток дозволяє
  /// звірити, що в збірку потрапив той самий токен, що ми клали
  /// в секрет, і при цьому сам токен з відбитка не дістати.
  static String get tokenFingerprint {
    if (!hasToken) return 'немає';
    return sha256.convert(utf8.encode(boardToken)).toString().substring(0, 8);
  }
}
