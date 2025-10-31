import 'dart:async';

class Todo {
  bool checked;
  String content;
  Timer? timer;
  int? secondsLeft;

  Todo({required this.content, this.checked = false, this.timer, this.secondsLeft});

  Todo copyWith({bool? checked, String? content, Timer? timer, int? secondsLeft}) {
    return Todo(
      content: content ?? this.content,
      checked: checked ?? this.checked,
      timer: timer ?? this.timer,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }

  Map<String, dynamic> toMap() => {
        'checked': checked,
        'content': content,
        'secondsLeft': secondsLeft,
      };

  factory Todo.fromMap(Map<String, dynamic> m) => Todo(
        content: m['content'] as String,
        checked: m['checked'] as bool? ?? false,
        secondsLeft: m['secondsLeft'] as int?,
      );
}
