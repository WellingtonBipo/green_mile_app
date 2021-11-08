extension IntExtension on int {
  String toStringHundredsDivider([String pointDivider = '.']) {
    List<String> intList = toString().split('').reversed.toList();
    final countParts = (intList.length - 1) ~/ 3;

    if (countParts > 0) {
      for (var i = countParts; i > 0; i--) {
        intList.insert(i * 3, pointDivider);
      }
    }
    return intList.reversed.join();
  }
}

extension MapExtension on Map {
  dynamic doIfNotNull(dynamic key, dynamic Function(dynamic) func) {
    if (this[key] == null) {
      return this[key];
    } else {
      return func(this[key]);
    }
  }
}
