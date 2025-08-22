import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/theme_cubit.dart';
import '../todo_cubit.dart';

import '../utils/random_list.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void addBatch() {
      final newTodos = TodoUtils.generateRandomTodos(5);
      context.read<TodoCubit>().addTodos(newTodos);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Added 5 random todos!")));
    }

    void cleanAll() {
      context.read<TodoCubit>().cleanAll();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All todos cleared!")));
    }

    void toggleTheme() {
      context.read<ThemeCubit>().toggleTheme();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Theme toggled!")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: addBatch,
              child: const Text("Add 5 Random Todos"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cleanAll,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clean All"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: toggleTheme,
              child: const Text("Toggle Theme (Light/Dark)"),
            ),
          ],
        ),
      ),
    );
  }
}
