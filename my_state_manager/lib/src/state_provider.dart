import 'package:flutter/widgets.dart';
import 'package:my_state_manager/src/state_notifier.dart';

class StateProvider<T> extends StatefulWidget {
  final StateNotifier<T> stateNotifier;
  final Widget Function(BuildContext context, T value) builder;

  const StateProvider({
    required this.stateNotifier,
    required this.builder,
    super.key,
  });

  @override
  _StateProviderState<T> createState() => _StateProviderState<T>();
}

class _StateProviderState<T> extends State<StateProvider<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.stateNotifier.value;
    widget.stateNotifier.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.stateNotifier.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange(T newValue) {
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}
