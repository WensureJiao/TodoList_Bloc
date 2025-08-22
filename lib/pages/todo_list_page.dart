import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../todo_cubit.dart';
import '../models/todo.dart';
import 'todo_edit_page.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();

    return Scaffold(
      appBar: AppBar(
        //blockbuilder 监听状态变化
        title: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) =>
              Text('TODO List - Sort: ${state.sortType.name}'),
        ),
        actions: [
          BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              if (state.todos.isEmpty) return const SizedBox.shrink();
              return PopupMenuButton<SortType>(
                onSelected: (type) => cubit.changeSort(type),
                itemBuilder: (context) => SortType.values.map((type) {
                  return PopupMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        if (state.sortType == type)
                          const Icon(Icons.check, size: 18),
                        const SizedBox(width: 4),
                        Text(type.name),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          final todos = state.todos;
          if (todos.isEmpty) return const Center(child: Text("No TODOs yet"));

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todoId = todos[index].id;

              return BlocSelector<TodoCubit, TodoState, Todo?>(
                //
                selector: (state) {
                  final list = state.todos
                      .where((t) => t.id == todoId)
                      .toList();
                  return list.isEmpty ? null : list.first;
                },
                builder: (context, todo) {
                  if (todo == null) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(
                        todo.status,
                        Theme.of(context).brightness,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.subtitle != null &&
                              todo.subtitle!.isNotEmpty)
                            Text(
                              todo.subtitle!,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          if (todo.description != null &&
                              todo.description!.isNotEmpty)
                            Text(
                              todo.description!,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            'Start: ${todo.startTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(todo.startTime!) : '-'}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                          Text(
                            'End: ${todo.endTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(todo.endTime!) : '-'}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<TodoStatus>(
                            value: todo.status,
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                cubit.updateTodoById(
                                  todo.id,
                                  todo.copyWith(status: newStatus),
                                );
                              }
                            },
                            items: TodoStatus.values
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.name),
                                  ),
                                )
                                .toList(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final edited = await Navigator.push<Todo>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TodoEditPage(
                                    todo: todo,
                                    onSave: (t) => Navigator.pop(context, t),
                                  ),
                                ),
                              );
                              if (edited != null)
                                cubit.updateTodoById(todo.id, edited);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to delete this task?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                // 用 Bloc 删除
                                context.read<TodoCubit>().deleteTodoById(
                                  todo.id,
                                );

                                // 给个提示
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task deleted!'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  TodoEditPage(onSave: (t) => Navigator.pop(context, t)),
            ),
          );
          if (newTodo != null) cubit.addTodo(newTodo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _statusColor(TodoStatus status, Brightness brightness) {
    switch (status) {
      case TodoStatus.waiting:
        return brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade300;
      case TodoStatus.progress:
        return brightness == Brightness.dark
            ? Colors.blue.shade700
            : Colors.blue.shade300;
      case TodoStatus.done:
        return brightness == Brightness.dark
            ? Colors.green.shade700
            : Colors.green.shade300;
    }
  }
}
