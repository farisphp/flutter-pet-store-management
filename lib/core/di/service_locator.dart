class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception(
          'Service of type $T not found. Did you forget to register it?');
    }

    if (service is Function) {
      return service() as T;
    }

    return service as T;
  }

  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  void reset() {
    _services.clear();
  }

  void unregister<T>() {
    _services.remove(T);
  }
}

final sl = ServiceLocator();
