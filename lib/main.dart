import 'package:flutter/material.dart';
import 'package:my_state_manager/my_state_manager.dart'; 


void main() {
  runApp(MyApp());
}

/// Ứng dụng chính.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'State Management Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StateManagementDemo(),
    );
  }
}

/// Màn hình minh họa quản lý trạng thái.
class StateManagementDemo extends StatefulWidget {
  @override
  _StateManagementDemoState createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  // Quản lý trạng thái dạng biến đơn giản
  final counterNotifier = StateNotifier<int>(0);

  // Quản lý trạng thái dạng danh sách
  final listNotifier = StateNotifier<List<String>>([]);

  // Quản lý trạng thái bất đồng bộ
  final asyncNotifier = AsyncStateNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    // Lắng nghe thay đổi trạng thái của counter
    counterNotifier.addListener((value) {
      print('Counter value updated: $value');
      setState(() {}); // Cập nhật giao diện khi trạng thái thay đổi
    });

    // Lắng nghe thay đổi trạng thái của danh sách
    listNotifier.addListener((list) {
      print('List updated: $list');
      setState(() {});
    });

    // Lắng nghe trạng thái bất đồng bộ từ Stream
    asyncNotifier.listenToStream(Stream<int>.periodic(Duration(seconds: 2), (count) => count).take(10));
  }

  @override
  void dispose() {
    // Hủy các notifier để tránh rò rỉ bộ nhớ
    counterNotifier.dispose();
    listNotifier.dispose();
    asyncNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý trạng thái'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị trạng thái biến đơn giản
            _buildCounterSection(),

            const SizedBox(height: 20),

            // Hiển thị trạng thái danh sách
            _buildListSection(),

            const SizedBox(height: 20),

            // Hiển thị trạng thái bất đồng bộ
            _buildAsyncSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Counter State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Giá trị hiện tại: ${counterNotifier.value}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => counterNotifier.update((current) => current + 1),
                  child: Text('Tăng'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => counterNotifier.reset(0),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Danh sách hiện tại: ${listNotifier.value.join(', ')}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => listNotifier.update((current) => [...current, 'Item ${current.length + 1}']),
                  child: Text('Thêm Item'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => listNotifier.reset([]),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsyncSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Async State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Giá trị từ Stream: ${asyncNotifier.value}'),
            ElevatedButton(
              onPressed: () async {
                await asyncNotifier.updateAsync((current) async {
                  await Future.delayed(Duration(seconds: 2));
                  return current + 5;
                });
              },
              child: Text('Tăng 5 (Async)'),
            ),
          ],
        ),
      ),
    );
  }
}
