import 'package:collection/collection.dart';

/// 駅の情報
class StationLatLng {
  const StationLatLng({
    required this.stationName,
    required this.lat,
    required this.lng,
  });

  final String stationName;
  final String lat;
  final String lng;
}

/// ペアリング結果モデル
class PairingResult {
  const PairingResult({
    required this.pairs,
    required this.pairIdOfIndex,
    required this.unpairedIndexes,
    required this.unpairedRoutes,
  });

  /// [[0,1], [3,4], …] のように相殺ペアを保持
  final List<List<int>> pairs;

  /// 各 index が何番目のペアか（ペア無しは -1）
  final List<int> pairIdOfIndex;

  /// ペアリングできなかった index の一覧（昇順）
  final List<int> unpairedIndexes;

  /// 上記 index に対応するルート
  final List<List<StationLatLng>> unpairedRoutes;
}

/// ルート評価サービス
class RoutePairingService {
  /// ルートキー生成（駅名をソート→連結）
  static String _routeKey(List<StationLatLng> route) {
    final names = route.map((e) => e.stationName).toList()..sort();
    return names.join('|');
  }

  /// ルートをペアリング
  static PairingResult pairRoutes(List<List<StationLatLng>> routes) {
    final waiting = <String, int>{};               // キー → 最初の index
    final pairs = <List<int>>[];
    final pairIdOfIndex = List<int>.filled(routes.length, -1);

    for (var i = 0; i < routes.length; i++) {
      final key = _routeKey(routes[i]);

      if (waiting.containsKey(key)) {
        final j = waiting.remove(key)!;            // ペア確定
        final pairId = pairs.length;
        pairs.add([j, i]);
        pairIdOfIndex[j] = pairId;
        pairIdOfIndex[i] = pairId;
      } else {
        waiting[key] = i;                          // まだペアなし
      }
    }

    // waiting に残ったものが “ペア無し”
    final unpairedIndexes = waiting.values.toList()..sort();
    final unpairedRoutes = [for (var i in unpairedIndexes) routes[i]];

    return PairingResult(
      pairs: pairs,
      pairIdOfIndex: pairIdOfIndex,
      unpairedIndexes: unpairedIndexes,
      unpairedRoutes: unpairedRoutes,
    );
  }
}
