import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/todo.dart';

enum SortType { title, startTime, status }
// ---------- TODO 状态和事件 ----------

class TodoState {
  final List<Todo> todos;
  final SortType sortType;

  const TodoState({required this.todos, this.sortType = SortType.title});
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
    );
  }
}

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoState(todos: []));

  // ---------- TODO 管理 ----------
  void addTodo(Todo todo) {
    final updated = List<Todo>.unmodifiable([...state.todos, todo]);
    // List<Todo>.unmodifiable([...state.todos, todo]) 是为了创建一个不可
    // 修改的列表
    // 这样可以确保状态的不可变性，符合 Bloc 的设计原则
    emit(state.copyWith(todos: updated));
  }

  void updateTodoById(String id, Todo newTodo) {
    bool found = false;
    final updated = List<Todo>.unmodifiable(
      state.todos.map((t) {
        if (t.id == id) {
          found = true;
          return newTodo;
        }
        return t;
      }),
    );

    if (found) {
      emit(state.copyWith(todos: updated));
    }
  }

  void deleteTodoById(String id) {
    final updated = state.todos.where((t) => t.id != id).toList();

    // 如果长度没变，说明没有匹配的 todo
    if (updated.length != state.todos.length) {
      emit(state.copyWith(todos: List.unmodifiable(updated)));
    }
  }

  /// 新增：修改排序方式
  void changeSort(SortType sortType) {
    final sorted = [...state.todos];

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

  // ---------- 批量添加 ----------
  void addTodos(List<Todo> newTodos) {
    final updated = List<Todo>.unmodifiable([...state.todos, ...newTodos]);
    emit(state.copyWith(todos: updated));
  }
}
