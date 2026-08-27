import 'package:flight_board/board/board_service.dart';
import 'package:flight_board/board/flight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = BoardService();
  final noon = DateTime(2026, 9, 1, 12);

  Flight flight({
    String code = 'PS 902',
    Duration after = const Duration(hours: 1),
    Duration delay = Duration.zero,
    bool cancelled = false,
  }) => Flight(
    code: code,
    city: 'Варшава',
    scheduled: noon.add(after),
    gate: 'A3',
    delay: delay,
    cancelled: cancelled,
  );

  group('статус рейсу', () {
    test('за годину до вильоту рейс просто в розкладі', () {
      expect(service.statusOf(flight(), noon), FlightStatus.scheduled);
    });

    test('за 30 хвилин уже посадка, межа включно', () {
      final f = flight(after: const Duration(minutes: 30));
      expect(service.statusOf(f, noon), FlightStatus.boarding);
    });

    test('за 31 хвилину посадки ще немає', () {
      final f = flight(after: const Duration(minutes: 31));
      expect(service.statusOf(f, noon), FlightStatus.scheduled);
    });

    test('посадка рахується від фактичного часу, а не від розкладу', () {
      final f = flight(
        after: const Duration(minutes: 10),
        delay: const Duration(minutes: 40),
      );
      expect(service.statusOf(f, noon), FlightStatus.scheduled);
    });

    test('скасований рейс лишається скасованим навіть після часу вильоту', () {
      final f = flight(after: const Duration(minutes: -5), cancelled: true);
      expect(service.statusOf(f, noon), FlightStatus.cancelled);
    });
  });

  group('час до вильоту', () {
    test('рахується від фактичного часу', () {
      final f = flight(
        after: const Duration(minutes: 20),
        delay: const Duration(minutes: 25),
      );
      expect(service.timeToDeparture(f, noon), const Duration(minutes: 45));
    });

    test('для рейсу, що вилетів, повертається null', () {
      final f = flight(after: const Duration(minutes: -1));
      expect(service.timeToDeparture(f, noon), isNull);
    });

    test('для скасованого повертається null', () {
      expect(service.timeToDeparture(flight(cancelled: true), noon), isNull);
    });
  });

  group('склад табло', () {
    test('рейс зникає через 15 хвилин після фактичного вильоту', () {
      final f = flight(after: const Duration(minutes: -15));
      expect(service.isVisible(f, noon), isFalse);
      expect(
        service.isVisible(f, noon.subtract(const Duration(minutes: 1))),
        isTrue,
      );
    });

    test('затримка продовжує життя рейсу на табло', () {
      final f = flight(
        after: const Duration(minutes: -20),
        delay: const Duration(minutes: 30),
      );
      expect(service.isVisible(f, noon), isTrue);
    });

    test('скасований рейс висить годину від розкладу', () {
      final f = flight(after: const Duration(minutes: -59), cancelled: true);
      expect(service.isVisible(f, noon), isTrue);
      expect(
        service.isVisible(f, noon.add(const Duration(minutes: 2))),
        isFalse,
      );
    });

    test('табло сортується за фактичним часом, а не за розкладом', () {
      final early = flight(
        code: 'W6 771',
        after: const Duration(minutes: 10),
        delay: const Duration(minutes: 90),
      );
      final late = flight(code: 'LO 752', after: const Duration(minutes: 40));
      final rows = service.board([early, late], noon);
      expect(rows.map((f) => f.code), ['LO 752', 'W6 771']);
    });
  });
}
