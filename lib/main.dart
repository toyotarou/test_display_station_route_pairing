import 'package:flutter/material.dart';

import 'service/route_pairing_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ルートのペアリング表示',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- サンプルデータ ---
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
      ], // ← 0 とペア
      [
        const StationLatLng(stationName: 'D', lat: '3', lng: '3'),
        const StationLatLng(stationName: 'E', lat: '4', lng: '4'),
        const StationLatLng(stationName: 'F', lat: '5', lng: '5'),
      ],
      [
        const StationLatLng(stationName: 'F', lat: '5', lng: '5'),
        const StationLatLng(stationName: 'D', lat: '3', lng: '3'),
        const StationLatLng(stationName: 'E', lat: '4', lng: '4'),
      ], // ← 2 とペア
      [
        const StationLatLng(stationName: 'G', lat: '6', lng: '6'),
        const StationLatLng(stationName: 'H', lat: '7', lng: '7'),
      ], // ← ペア無し
    ];

    // --- ペアリング実行 ---
    final result = RoutePairingService.pairRoutes(routes);

    return Scaffold(
      appBar: AppBar(title: const Text('ルート一覧 & ペアリング')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== ペア一覧 =====
            if (result.pairs.isNotEmpty) ...[
              Text('相殺ペア (${result.pairs.length} 組)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var p in result.pairs)
                    Chip(
                      avatar: const Icon(Icons.link, size: 18),
                      label: Text('${p[0]} と ${p[1]}'),
                    ),
                ],
              ),
              const Divider(height: 32),
            ] else
              const Text('相殺されるペアはありません 🎉'),

            // ===== ペア無し一覧 =====
            if (result.unpairedIndexes.isNotEmpty) ...[
              Text('ペア無し (${result.unpairedIndexes.length} 件)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var idx in result.unpairedIndexes)
                    Chip(
                      avatar: const Icon(Icons.info_outline, size: 18),
                      label: Text('index $idx'),
                    ),
                ],
              ),
              const Divider(height: 32),
            ],

            // ===== ルート一覧 =====
            Expanded(
              child: ListView.separated(
                itemCount: routes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final route = routes[index];
                  final display = route.map((e) => e.stationName).join(' → ');
                  final pairId = result.pairIdOfIndex[index];
                  final unpaired = pairId == -1;

                  return ListTile(
                    leading: Icon(
                      unpaired ? Icons.info_outline : Icons.link_off,
                      color: unpaired ? Colors.blue : Colors.red,
                    ),
                    title: Text(display),
                    subtitle: Text('index: $index'
                        '${unpaired ? '   (ペア無し)' : '   (ペアID: $pairId)'}'),
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
