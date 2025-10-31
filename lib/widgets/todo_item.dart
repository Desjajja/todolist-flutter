import 'package:flutter/material.dart';
import '../models/todo.dart';

typedef EditCallback = Future<String?> Function(String initial);

class TodoItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;
  final EditCallback onEdit;

  const TodoItem({super.key, required this.todo, required this.onChanged, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Use ListTile + trailing Checkbox so tapping text does not toggle the checkbox.
    return ListTile(
      title: GestureDetector(
        onTap: () async {
          final result = await onEdit(todo.content);
          // onEdit is expected to return the new content or null
          if (result != null && result.trim().isNotEmpty && result != todo.content) {
            // The parent will update the item content in its state.
          }
        },
        child: Text(
          todo.content,
          style: TextStyle(
            color: todo.checked ? Colors.grey : null,
            decoration: todo.checked ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // if (todo.checked && todo.secondsLeft != null)
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Text(
          //       '${todo.secondsLeft}s',
          //       style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          Checkbox(value: todo.checked, onChanged: onChanged),
        ],
      ),
    );
  }
}
