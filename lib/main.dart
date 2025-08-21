import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_main.dart';
import 'pages/todo_list_page.dart';

import 'pages/todo_setting_page.dart';

void main() {
  runApp(BlocProvider(create: (_) => TodoCubit(), child: const TodoApp()));
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.themeMode,
          home: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: const [
                TodoListPage(),
                SettingPage(), // 不要 const，如果页面需要 context.read<TodoCubit>()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Setting",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
