class StationLatLng {
  const StationLatLng({required this.stationName, required this.lat, required this.lng});

  final String stationName;
  final String lat;
  final String lng;
}

class PairingResult {
  const PairingResult({
    required this.pairs,
    required this.pairIdOfIndex,
  });

  final List<List<int>> pairs;

  final List<int> pairIdOfIndex;
}

class RoutePairingService {
  static String _routeKey(List<StationLatLng> route) {
    final names = route.map((e) => e.stationName).toList()..sort();
    return names.join('|');
  }

  static PairingResult pairRoutes(List<List<StationLatLng>> routes) {
    final waiting = <String, int>{};

    final pairs = <List<int>>[];

    final pairIdOfIndex = List<int>.filled(routes.length, -1);

    for (var i = 0; i < routes.length; i++) {
      final key = _routeKey(routes[i]);

      if (waiting.containsKey(key)) {
        final j = waiting.remove(key)!;

        final pairId = pairs.length;

        pairs.add([j, i]);

        pairIdOfIndex[j] = pairId;

        pairIdOfIndex[i] = pairId;
      } else {
        waiting[key] = i;
      }
    }

    return PairingResult(pairs: pairs, pairIdOfIndex: pairIdOfIndex);
  }
}
