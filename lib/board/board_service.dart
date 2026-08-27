import 'dart:math';

import 'flight.dart';

/// Правила табло вильотів.
///
/// Тут немає ані мережі, ані годинника: поточний час приходить
/// параметром. Завдяки цьому кожне правило перевіряється тестом
/// за мілісекунди і однаково поводиться на ноутбуці та на ранері.
class BoardService {
  const BoardService();

  /// За скільки до вильоту починається посадка.
  static const Duration boardingWindow = Duration(minutes: 30);

  /// Скільки рейс висить на табло після вильоту.
  static const Duration afterDeparture = Duration(minutes: 15);

  /// Скільки скасований рейс висить на табло.
  static const Duration afterCancellation = Duration(hours: 1);

  FlightStatus statusOf(Flight flight,DateTime now){
    if (flight.cancelled) return FlightStatus.cancelled;
    if (!now.isBefore(flight.expected)) return FlightStatus.departed;
    if (flight.expected.difference(now) <= boardingWindow) {
      return FlightStatus.boarding;
    }
    return FlightStatus.scheduled;
  }

  /// Скільки лишилося до вильоту. Для рейсу, що вже вилетів,
  /// або скасованого повертає null.
  Duration? timeToDeparture(Flight flight, DateTime now) {
    if (flight.cancelled) return null;
    final left = flight.expected.difference(now);
    return left.isNegative ? null : left;
  }

  /// Чи рейс ще показується на табло.
  bool isVisible(Flight flight, DateTime now) {
    if (flight.cancelled) {
      return now.isBefore(flight.scheduled.add(afterCancellation));
    }
    return now.isBefore(flight.expected.add(afterDeparture));
  }

  /// Табло: тільки видимі рейси, впорядковані за **фактичним** часом
  /// вильоту. Саме тут ховається помилка, яку легко зробити: сортувати
  /// за розкладом, а не за очікуваним часом, і тоді затриманий рейс
  /// висить угорі табло ще годину після того, як його вікно минуло.
  List<Flight> board(List<Flight> flights, DateTime now) {
    final visible = flights.where((f) => isVisible(f, now)).toList()
      ..sort((a, b) => a.expected.compareTo(b.expected));
    return visible;
  }
}
