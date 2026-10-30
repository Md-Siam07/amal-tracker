import 'dart:math';

final _rng = Random();

/// Client-generated unique id (ready for future cloud sync).
String newId() =>
    '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
    '${_rng.nextInt(0x7fffffff).toRadixString(36)}';
