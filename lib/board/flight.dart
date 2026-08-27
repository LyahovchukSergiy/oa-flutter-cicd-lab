/// Стан рейсу на табло.
enum FlightStatus { scheduled, boarding, departed, cancelled }

/// Рядок табло вильотів.
class Flight {
  const Flight({
    required this.code,
    required this.city,
    required this.scheduled,
    required this.gate,
    this.delay = Duration.zero,
    this.cancelled = false,
  });

  final String code;
  final String city;
  final DateTime scheduled;
  final String gate;
  final Duration delay;
  final bool cancelled;

  /// Час, о якому рейс вилетить насправді.
  DateTime get expected => scheduled.add(delay);

  bool get isDelayed => delay > Duration.zero;
}
