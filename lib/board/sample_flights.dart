import 'flight.dart';

/// Розклад будується від переданого моменту, щоб табло було живим
/// на будь-якому запуску, а тести лишалися детермінованими.
List<Flight> sampleFlights(DateTime from) {
  final base = DateTime(from.year, from.month, from.day, from.hour);
  return [
    Flight(
      code: 'PS 902',
      city: 'Варшава',
      scheduled: base.add(const Duration(minutes: 20)),
      gate: 'A3',
    ),
    Flight(
      code: 'W6 771',
      city: 'Краків',
      scheduled: base.add(const Duration(minutes: 45)),
      gate: 'B1',
      delay: const Duration(minutes: 50),
    ),
    Flight(
      code: 'LO 752',
      city: 'Гданськ',
      scheduled: base.add(const Duration(hours: 1, minutes: 10)),
      gate: 'A7',
    ),
    Flight(
      code: 'FR 318',
      city: 'Вроцлав',
      scheduled: base.add(const Duration(hours: 2)),
      gate: 'C2',
      cancelled: true,
    ),
    Flight(
      code: 'KL 1348',
      city: 'Амстердам',
      scheduled: base.add(const Duration(hours: 3, minutes: 25)),
      gate: 'A1',
    ),
  ];
}
