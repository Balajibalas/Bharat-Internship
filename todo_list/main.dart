import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  String title;
  String description;
  DateTime dateTime;
  bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  void addTodo() {
    String todoTitle = _titleController.text.trim();
    String todoDescription = _descriptionController.text.trim();

    if (todoTitle.isNotEmpty && _dateController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      DateTime dateTime = DateTime.parse('${_dateController.text} ${_timeController.text}');

      setState(() {
        todos.add(Todo(
          title: todoTitle,
          description: todoDescription,
          dateTime: dateTime,
        ));
        _titleController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _timeController.clear();
      });

      Navigator.pop(context); // Close the dialog
    }
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void toggleComplete(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  Future<void> _showAddTodoDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add task', style: TextStyle(color: Colors.deepPurpleAccent)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Write a task',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Write a description',
                ),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'Enter date (yyyy-MM-dd)',
                ),
              ),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'Enter time (HH:mm)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.deepPurpleAccent)),
            ),
            TextButton(
              onPressed: addTodo,
              child: Text('Add', style: TextStyle(color: Colors.deepPurpleAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List App'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: todos.isEmpty
          ? Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 150.0,
                color: Colors.grey,
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    todos[index].title,
                    style: TextStyle(
                      decoration: todos[index].isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${todos[index].description}'),
                      Text('Date & Time: ${todos[index].dateTime.toString()}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => toggleComplete(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTodo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
