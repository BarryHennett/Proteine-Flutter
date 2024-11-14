extension OnMap on Map<String, dynamic> {
  T opt<T>(String key, T fallback) {
    if (!containsKey(key)) {
      return fallback;
    } else {
      try {
        final value = this[key];
        if (value == null) {
          return fallback;
        }
        return value as T;
      } catch (e) {
        return fallback;
      }
    }
  }

  Map<String, dynamic> child<T>(String key,
      [Map<String, dynamic> fallback = const {}]) {
    if (!containsKey(key)) {
      return fallback;
    } else {
      try {
        final value = this[key];
        if (value == null) {
          return fallback;
        }
        return value as Map<String, dynamic>;
      } catch (e) {
        print("Error casting to map");
        print(e);
        return fallback;
      }
    }
  }

  List optArray(String key) {
    if (!containsKey(key)) {
      return [];
    } else {
      try {
        return this[key];
      } catch (e) {
        print("$key is not a json array (${this[key].runtimeType})");
        return [];
      }
    }
  }

  Iterable<T> mapJsonArray<T>(
      String key, T Function(Map<String, dynamic> json) transform) {
    return optArray(key).map((json) => transform(json as Map<String, dynamic>));
  }
}