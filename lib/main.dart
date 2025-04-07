import 'package:flutter/material.dart';
import 'package:test_display_not_duplicate_route/service/route_pairing_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      [
        const StationLatLng(stationName: 'A', lat: '0', lng: '0'),
        const StationLatLng(stationName: 'B', lat: '1', lng: '1'),
        const StationLatLng(stationName: 'C', lat: '2', lng: '2'),
      ],
      [
        const StationLatLng(stationName: 'C', lat: '2', lng: '2'),
        const StationLatLng(stationName: 'B', lat: '1', lng: '1'),
        const StationLatLng(stationName: 'A', lat: '0', lng: '0'),
      ],
      [
        const StationLatLng(stationName: 'D', lat: '3', lng: '3'),
        const StationLatLng(stationName: 'E', lat: '4', lng: '4'),
        const StationLatLng(stationName: 'F', lat: '5', lng: '5'),
      ],
      [
        const StationLatLng(stationName: 'G', lat: '6', lng: '6'),
        const StationLatLng(stationName: 'H', lat: '7', lng: '7'),
      ],
      [
        const StationLatLng(stationName: 'F', lat: '5', lng: '5'),
        const StationLatLng(stationName: 'D', lat: '3', lng: '3'),
        const StationLatLng(stationName: 'E', lat: '4', lng: '4'),
      ],
    ];

    final result = RoutePairingService.pairRoutes(routes);
    final pairs = result.pairs;
    final pairIdOfIndex = result.pairIdOfIndex;

    return Scaffold(
      appBar: AppBar(title: const Text('ルート一覧 & ペアリング')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.route),
            if (pairs.isNotEmpty) ...[
              Text('相殺ペア (${pairs.length} 組)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var i = 0; i < pairs.length; i++)
                    Chip(
                      avatar: const Icon(Icons.link, size: 18),
                      label: Text('${pairs[i][0]} と ${pairs[i][1]}'),
                    ),
                ],
              ),
              const Divider(height: 32),
            ] else
              const Text('相殺されるペアはありません 🎉'),
            Expanded(
              child: ListView.separated(
                itemCount: routes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final route = routes[index];
                  final display = route.map((e) => e.stationName).join(' → ');
                  final pairId = pairIdOfIndex[index];

                  return ListTile(
                    leading: Icon(
                      pairId >= 0 ? Icons.highlight_off : Icons.check_circle,
                      color: pairId >= 0 ? Colors.red : Colors.green,
                    ),
                    title: Text(display),
                    subtitle: Text('index: $index'
                        '${pairId >= 0 ? '   (ペアID: $pairId)' : ''}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
