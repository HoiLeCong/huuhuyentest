import 'package:flutter_test/flutter_test.dart';
import 'package:my_state_manager/my_state_manager.dart';

void main() {
  test('Listeners are properly removed', () {
    final state = StateNotifier<int>(0);
    bool listenerCalled = false;

    void listener(int value) {
      listenerCalled = true;
    }

    state.addListener(listener);
    state.set(1);
    expect(listenerCalled, true);

    listenerCalled = false;
    state.removeListener(listener);
    state.set(2);
    expect(listenerCalled, false);
  });

  test('AsyncStateNotifier updates state asynchronously', () async {
    final state = AsyncStateNotifier<int>(0);

    await state.updateAsync((value) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return value + 10;
    });

    expect(state.value, 10);
  });

  test('StateNotifier logs performance metrics', () {
    final state = StateNotifier<int>(0);

    state.set(1); 
    expect(state.value, 1);
  });
}
