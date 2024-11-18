import 'dart:async';

/// StateNotifier class for managing state updates and notifying listeners.
class StateNotifier<T> {
  T _value;
  final List<void Function(T)> _listeners = [];
  bool _isDisposed = false;

  /// Constructor with initial value.
  StateNotifier(this._value);

  /// Get the current state value.
  T get value => _value;

  /// Update the state using a synchronous updater function.
  void update(T Function(T current) updater) {
    _checkDisposed();
    _value = updater(_value);
    _notifyListeners();
  }

  /// Set the state to a new value directly.
  void set(T value) {
    _checkDisposed();
    _value = value;
    _notifyListeners();
  }

  /// Reset the state to a default value.
  void reset(T defaultValue) {
    _checkDisposed();
    _value = defaultValue;
    _notifyListeners();
  }

  /// Add a listener to state changes.
  void addListener(void Function(T) listener) {
    _checkDisposed();
    _listeners.add(listener);
  }

  /// Remove a listener from state changes.
  void removeListener(void Function(T) listener) {
    _checkDisposed();
    _listeners.remove(listener);
  }

  /// Dispose the notifier and clear listeners to avoid memory leaks.
  void dispose() {
    _isDisposed = true;
    _listeners.clear();
  }

  /// Notify all listeners about the current state.
  void _notifyListeners() {
    if (_isDisposed) return;
    for (var listener in _listeners) {
      listener(_value);
    }
    _logPerformance('State updated to: $_value');
  }

  /// Ensure the notifier is not used after disposal.
  void _checkDisposed() {
    if (_isDisposed) {
      throw StateError('Cannot use StateNotifier after it has been disposed.');
    }
  }

  /// Log performance or debug information.
  void _logPerformance(String message) {
    print('[StateNotifier]: $message');
  }
}

/// AsyncStateNotifier class for managing asynchronous state updates and streams.
class AsyncStateNotifier<T> extends StateNotifier<T> {
  StreamSubscription<T>? _subscription;

  /// Constructor with initial value.
  AsyncStateNotifier(T initialValue) : super(initialValue);

  /// Update the state asynchronously using a Future updater function.
  Future<void> updateAsync(Future<T> Function(T current) updater) async {
    _checkDisposed();
    final newValue = await updater(value);
    set(newValue);
  }

  /// Listen to a Stream and update the state whenever a new value is emitted.
  void listenToStream(Stream<T> stream) {
    _checkDisposed();
    _subscription?.cancel(); // Cancel any existing subscription
    _subscription = stream.listen((newValue) {
      set(newValue);
    });
  }

  /// Dispose the notifier and cancel the stream subscription.
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
