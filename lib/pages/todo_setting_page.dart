import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc_main.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void addBatch() {
      context.read<TodoCubit>().addRandomTodos(5);
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
      context.read<TodoCubit>().toggleTheme();
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
