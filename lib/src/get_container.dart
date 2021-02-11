import 'package:meta/meta.dart';

typedef T TBuilder<T>();

mixin GetContainer {
  final _providers = Map<String, Map<Type, _Provider<Object>>>();
  bool silent = false;

  void registerInstance<S>(S instance, {String name}) {
    _setProvider(name, _Provider<S>.instance(instance));
  }

  void registerFactory<S>(TBuilder<S> builder, {String name}) {
    _setProvider(name, _Provider<S>.factory(builder));
  }

  void registerSingleton<S>(TBuilder<S> factory, {String name}) {
    _setProvider(name, _Provider<S>.singleton(factory));
  }

  void unregister<T>([String name]) {
    var provider = _getProvider<T>(name);
    if (provider == null) {
      var msg = _errorMessage('not registered', 'unregister', [T], [name]);
      if (silent) return;
      throw GetException(msg);
    }
    _providers[name].remove(T);
  }

  T resolve<T>([String name]) {
    var provider = _getProvider<T>(name);
    if (provider == null) {
      var msg = _errorMessage('not registered', 'resolve', [T], [name]);
      if (silent) return null;
      throw GetException(msg);
    }

    return provider?.get(this);
  }

  @visibleForTesting
  T resolveAs<S, T extends S>([String name]) {
    final obj = resolve<S>(name);

    if (obj is! T) {
      var msg = _errorMessage('not a $T instance', 'resolveAs', [S, T], [name]);
      if (silent) return null;
      throw GetException(msg);
    }
    return obj;
  }

  T call<T>([String name]) => resolve<T>(name);

  void clear() {
    _providers.clear();
  }

  _Provider<T> _getProvider<T>([String name]) {
    return _providers[name] ?? [T];
  }

  String _errorMessage(
    String message, [
    String method,
    List<Type> types,
    List params,
  ]) {
    var result = message + ', ' + method;
    if (types != null && types.length > 0) {
      result += '<' + types.join(',') + '>';
    }
    if (params != null) {
      result += '(' + params.join(',') + ')';
    } else {
      result += '()';
    }
    return result;
  }

  void _setProvider<T>(String name, _Provider<T> provider) {
    var old = _getProvider<T>(name);
    if (old != null) {
      var msg = _errorMessage(
          'already registered', '_setProvider', [T], [name, provider]);
      if (silent) return null;
      throw GetException(msg);
    }

    _providers.putIfAbsent(name, () => Map<Type, _Provider<Object>>())[T] =
        provider;
  }
}

class _Provider<T> {
  final String kind;
  final TBuilder<T> builder;
  T obj;

  _Provider.instance(this.obj)
      : kind = 'instance',
        builder = null;

  _Provider.factory(this.builder) : kind = 'factory';

  _Provider.singleton(this.builder) : kind = 'singleton';

  T get(GetContainer container) {
    switch (kind) {
      case 'instance':
        return obj;
      case 'factory':
        return builder();
      case 'singleton':
        if (obj == null) {
          obj = builder();
        }
        return obj;
      default:
        throw StateError('Bug! code should never reached, kind=$kind');
    }
  }

  @override
  String toString() {
    var str = 'Provider: $kind, obj=$obj, builder=';
    if (builder != null) {
      str += 'null';
    } else {
      str += builder.runtimeType.toString();
    }
    return str;
  }
}

class GetException implements Exception {
  final String message;

  GetException([this.message]);

  String toString() {
    return "GetException: $message";
  }
}
