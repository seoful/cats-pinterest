import 'package:flutter/cupertino.dart';

class KeyHolder<T extends State> {
  final GlobalKey<T> key;

  KeyHolder(this.key);

  KeyHolder<T>? previous;

  KeyHolder<T> push(GlobalKey<T> key) {
    final keyHolder = KeyHolder<T>(key);
    keyHolder.previous = this;

    return keyHolder;
  }

  KeyHolder<T>? pop() {
    if (!mayPop) return null;

    final prev = previous!;

    previous = null;

    return prev;
  }

  bool get mayPop => previous != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyHolder &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          previous == other.previous;

  @override
  int get hashCode => key.hashCode;
}
