import 'package:app_lorry/models/test/TireModeltest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "rotationProvider.g.dart";

@Riverpod()
class TireList extends _$TireList {
  @override
  List<TireTest> build() => [
        TireTest(position: 1, id: 1),
        TireTest(position: 2, id: 2),
        TireTest(position: 3, id: 3),
        TireTest(position: 4, id: 4),
        TireTest(position: 5, id: 5),
        TireTest(position: 6, id: 6),
        TireTest(position: 7, id: 7),
        TireTest(position: 8, id: 8),
        TireTest(position: 9, id: 9),
        TireTest(position: 10, id: 10),
        TireTest(position: 11, id: 11),
        TireTest(position: 12, id: 12),
        TireTest(position: 13, id: 13),
        TireTest(position: 14, id: 14),
      ];
  // Map<String, String> build() =>{"email": "finceelian9@gmail.com", "password": "SDPi8AR8#"};
  void setposition(key, value) {
    for (var i = 0; i < state.length; i++) {
      if (state[i].id == key) {
        state[i].newPosition = value;
        state[i].ismoved = true;
      }
    }
  }

  void restore() {
    for (var i = 0; i < state.length; i++) {
      state[i].newPosition = null;
      state[i].ismoved = false;
    }
  }

  void setaction(key, value) {
    state[key].action = value;
  }
}

@Riverpod()
class TireListDiv extends _$TireListDiv {
  @override
  List<List<TireTest>> build() => [];
  // Map<String, String> build() =>{"email": "finceelian9@gmail.com", "password": "SDPi8AR8#"};
  void setDiv(tires) {
    state.clear();
    for (var i = 0; i < tires.length; i += 6) {
      state.add(tires.sublist(i, i + 6 > tires.length ? tires.length : i + 6));
    }
  }
}

@Riverpod()
class TireMovedPositions extends _$TireMovedPositions {
  @override
  List<int> build() => [];
  // Map<String, String> build() =>{"email": "finceelian9@gmail.com", "password": "SDPi8AR8#"};
  void setposition(key) {
    state.add(key);
  }

    void clear() {
    state.clear();
  }
}
