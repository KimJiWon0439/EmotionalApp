import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TodoListScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  String _getTodoKey(DateTime date) {
    return 'todo_${DateFormat('yyyy-MM-dd').format(date)}';
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getTodoKey(widget.selectedDate);
    final String? savedJson = prefs.getString(key);
    if (savedJson != null) {
      final List<dynamic> decoded = jsonDecode(savedJson);
      _todoList = decoded.cast<Map<String, dynamic>>();
      setState(() {});
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getTodoKey(widget.selectedDate);
    final String jsonString = jsonEncode(_todoList);
    await prefs.setString(key, jsonString);
  }

  void _addTodo(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add({'task': task, 'done': false});
        _controller.clear();
      });
      _saveTodos();
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _todoList[index]['done'] = !_todoList[index]['done'];
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('체크리스트')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '오늘의 할 일을 입력해보세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTodo(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  final item = _todoList[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item['done'],
                      onChanged: (_) => _toggleDone(index),
                    ),
                    title: Text(
                      item['task'],
                      style: TextStyle(
                        decoration: item['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
