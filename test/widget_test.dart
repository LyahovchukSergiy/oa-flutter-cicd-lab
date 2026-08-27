import 'package:flight_board/board/board_screen.dart';
import 'package:flight_board/board/flight.dart';
import 'package:flight_board/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final noon = DateTime(2026, 9, 1, 12);

  final flights = [
    Flight(
      code: 'PS 902',
      city: 'Варшава',
      scheduled: noon.add(const Duration(minutes: 15)),
      gate: 'A3',
    ),
    Flight(
      code: 'W6 771',
      city: 'Краків',
      scheduled: noon.add(const Duration(minutes: 5)),
      gate: 'B1',
      delay: const Duration(minutes: 90),
    ),
    Flight(
      code: 'FR 318',
      city: 'Вроцлав',
      scheduled: noon.add(const Duration(hours: 2)),
      gate: 'C2',
      cancelled: true,
    ),
  ];

  Future<void> pumpBoard(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: BoardScreen(flights: flights, now: noon),
    ),
  );

  testWidgets('табло показує рейси у порядку фактичного вильоту', (
    tester,
  ) async {
    await pumpBoard(tester);

    final codes = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.key! as ValueKey<String>).value)
        .toList();

    expect(codes, ['flight-PS 902', 'flight-W6 771', 'flight-FR 318']);
  });

  testWidgets('затриманий рейс показує час із затримкою', (tester) async {
    await pumpBoard(tester);
    expect(find.text('13:35'), findsOneWidget);
  });

  testWidgets('статуси підписані по-людськи', (tester) async {
    await pumpBoard(tester);

    expect(
      tester.widget<Text>(find.byKey(const Key('status-PS 902'))).data,
      'посадка',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('status-FR 318'))).data,
      'скасовано',
    );
  });

  testWidgets('шапка показує середовище збірки', (tester) async {
    await pumpBoard(tester);
    expect(
      tester.widget<Text>(find.byKey(const Key('env-badge'))).data,
      AppConfig.environment,
    );
  });
}
