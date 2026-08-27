import 'package:flutter/material.dart';

import '../config/app_config.dart';
import 'board_service.dart';
import 'flight.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({
    required this.flights,
    required this.now,
    super.key,
    this.service = const BoardService(),
  });

  final List<Flight> flights;
  final DateTime now;
  final BoardService service;

  @override
  Widget build(BuildContext context) {
    final rows = service.board(flights, now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Табло вильотів'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                AppConfig.environment,
                key: const Key('env-badge'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: rows.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) =>
            _FlightRow(flight: rows[index], now: now, service: service),
      ),
      bottomNavigationBar: const _TokenBanner(),
    );
  }
}

class _FlightRow extends StatelessWidget {
  const _FlightRow({
    required this.flight,
    required this.now,
    required this.service,
  });

  final Flight flight;
  final DateTime now;
  final BoardService service;

  @override
  Widget build(BuildContext context) {
    final status = service.statusOf(flight, now);
    final left = service.timeToDeparture(flight, now);
    return ListTile(
      key: Key('flight-${flight.code}'),
      leading: SizedBox(
        width: 72,
        child: Text(_time(flight.expected), style: _timeStyle(context, flight)),
      ),
      title: Text(flight.city),
      subtitle: Text('${flight.code} · вихід ${flight.gate}'),
      trailing: Text(
        _label(status, left),
        key: Key('status-${flight.code}'),
        style: TextStyle(color: _color(context, status)),
      ),
    );
  }

  static String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  TextStyle? _timeStyle(BuildContext context, Flight flight) {
    final base = Theme.of(context).textTheme.titleMedium;
    if (!flight.isDelayed) return base;
    return base?.copyWith(color: Theme.of(context).colorScheme.error);
  }

  String _label(FlightStatus status, Duration? left) => switch (status) {
    FlightStatus.cancelled => 'скасовано',
    FlightStatus.departed => 'вилетів',
    FlightStatus.boarding => 'посадка',
    FlightStatus.scheduled => 'через ${left!.inMinutes} хв',
  };

  Color? _color(BuildContext context, FlightStatus status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      FlightStatus.cancelled => scheme.error,
      FlightStatus.boarding => scheme.primary,
      _ => null,
    };
  }
}

class _TokenBanner extends StatelessWidget {
  const _TokenBanner();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Токен табло: ${AppConfig.tokenFingerprint}',
          key: const Key('token-fingerprint'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
