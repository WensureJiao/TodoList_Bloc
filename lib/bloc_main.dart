import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/todo.dart';
import 'dart:math';

enum SortType { title, startTime, status }
// ---------- TODO 状态和事件 ----------

class TodoState {
  final List<Todo> todos;
  final SortType sortType;
  final ThemeMode themeMode;

  TodoState({
    required this.todos,
    this.sortType = SortType.title,
    this.themeMode = ThemeMode.light,
  });
  // 复制当前状态
  // 以便在更新时使用
  TodoState copyWith({
    List<Todo>? todos,
    SortType? sortType,
    ThemeMode? themeMode,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      sortType: sortType ?? this.sortType,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoState(todos: []));

  // ---------- TODO 管理 ----------
  void addTodo(Todo todo) {
    final updated = List<Todo>.from(state.todos)..add(todo);
    //List<Todo>.from(state.todos) 是为了创建一个新的列表
    // ..add(todo) 是为了添加新的 todo
    emit(state.copyWith(todos: updated));
  }

  void updateTodoById(String id, Todo newTodo) {
    final updated = state.todos.map((t) => t.id == id ? newTodo : t).toList();
    emit(state.copyWith(todos: updated));
  }

  void deleteTodoById(String id) {
    final updated = state.todos.where((t) => t.id != id).toList();
    emit(state.copyWith(todos: updated));
  }

  /// 新增：修改排序方式
  void changeSort(SortType sortType) {
    final sorted = List<Todo>.from(state.todos);

    switch (sortType) {
      case SortType.title:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.startTime:
        sorted.sort((a, b) => a.startTime!.compareTo(b.startTime!));
        break;
      case SortType.status:
        sorted.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
    }

    emit(state.copyWith(todos: sorted, sortType: sortType));
  }

  void cleanAll() {
    emit(state.copyWith(todos: []));
  }

  void addRandomTodos(int count) {
    final random = Random();
    final newTodos = List.generate(count, (i) {
      final status =
          TodoStatus.values[random.nextInt(TodoStatus.values.length)];
      return Todo(
        id: DateTime.now().toIso8601String() + random.nextInt(1000).toString(),
        title: 'Random Todo ${random.nextInt(1000)}',
        status: status,
      );
    });
    emit(state.copyWith(todos: List<Todo>.from(state.todos)..addAll(newTodos)));
  }

  // ---------- 主题 ----------
  void toggleTheme() {
    emit(
      state.copyWith(
        themeMode: state.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }
}
