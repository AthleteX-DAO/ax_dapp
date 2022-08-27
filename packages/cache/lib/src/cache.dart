/// {@template cache_client}
/// An in-memory cache client.
/// {@endtemplate}
class CacheClient {
  /// {@macro cache_client}
  CacheClient() : _cache = <String, Object>{};

  final Map<String, Object> _cache;

  /// Writes a [key]-[value] pair to the in-memory cache.
  void write<T extends Object>({required String key, required T value}) {
    print('before inserting cache key -> $key');
    print('before inserting cache value -> $value');
    _cache[key] = value;
    print('after inserting chache memory -> ${_cache[key]}');
  }

  /// Looks up the value for the given [key].
  /// Defaults to `null` if no value exists for the [key].
  T? read<T extends Object>({required String key}) {
    final value = _cache[key];
    print('value from cache when extracted -> $value');
    if (value is T) return value;
    return null;
  }
}
