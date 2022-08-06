abstract class Adapter<T> {
  Future<T?> load(String key, [Duration? ttl]);

  Future<void> save(String key, T data);

  Future<void> purge(String key);

  Future<void> close();
}
