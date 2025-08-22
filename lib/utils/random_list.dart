import 'dart:math';
import '../models/todo.dart';

class TodoUtils {
  /// 生成随机 Todo 列表
  static List<Todo> generateRandomTodos(int count) {
    final random = Random();
    final now = DateTime.now();

    return List.generate(count, (i) {
      final status =
          TodoStatus.values[random.nextInt(TodoStatus.values.length)];

      // 随机 startTime
      final startOffset = Duration(
        days: random.nextInt(30),
        hours: random.nextInt(24),
        minutes: random.nextInt(60),
      );
      final startTime = now.add(startOffset);

      // 确保 endTime 在 startTime 之后
      final endOffset = Duration(
        days: random.nextInt(5), // 最多 5 天差距
        hours: random.nextInt(24),
        minutes: random.nextInt(60),
      );
      final endTime = startTime.add(endOffset);

      return Todo(
        id: now.toIso8601String() + random.nextInt(1000).toString(),
        title: 'Random Todo ${random.nextInt(1000)}',
        status: status,
        startTime: startTime,
        endTime: endTime,
      );
    });
  }
}
