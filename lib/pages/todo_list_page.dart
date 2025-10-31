import 'dart:async';

import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Todo> todos = [
    Todo(content: 'Buy groceries'),
    Todo(content: 'Walk the dog'),
    Todo(content: 'Read a book'),
  ];

  static const int countdownSeconds = 3;

  // void _sortTodos() {
  //   todos.sort((a, b) {
  //     if (a.checked == b.checked) return 0;
  //     return a.checked ? 1 : -1;
  //   });
  // }

  void toggleTodo(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
      if (todo.checked) {
        // start countdown on this todo
        todo.secondsLeft = countdownSeconds;
        // if there was an existing timer, cancel it first
        todo.timer?.cancel();
        todo.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) return;
          setState(() {
            todo.secondsLeft = (todo.secondsLeft ?? 0) - 1;
            if ((todo.secondsLeft ?? 0) <= 0) {
              timer.cancel();
              todo.timer = null;
              todos.remove(todo);
            }
          });
        });
      } else {
        // cancel countdown
        todo.timer?.cancel();
        todo.timer = null;
        todo.secondsLeft = null;
      }
      // _sortTodos();
    });
  }

  void addTodo(String content) {
    setState(() {
      todos.add(Todo(content: content));
      // _sortTodos();
    });
  }

  Future<String?> _showEditDialog(String initial) async {
    final controller = TextEditingController(text: initial);
    String? errorText;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Todo'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(errorText: errorText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    setState(() => errorText = 'Content cannot be empty');
                    return;
                  }
                  Navigator.of(context).pop(controller.text.trim());
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Todo'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter todo content', errorText: errorText),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    setState(() => errorText = 'Content cannot be empty');
                    return;
                  }
                  addTodo(controller.text.trim());
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  void dispose() {
    for (var t in todos) {
      t.timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the Todo List Page'),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoItem(
                    todo: todo,
                    onChanged: (v) => toggleTodo(todo),
                    onEdit: (initial) async {
                      final result = await _showEditDialog(initial);
                      if (result != null && result.trim().isNotEmpty) {
                        setState(() {
                          todo.content = result.trim();
                        });
                      }
                      return result;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
