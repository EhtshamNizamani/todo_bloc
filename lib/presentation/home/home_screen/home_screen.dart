import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/presentation/home/bloc/todo_bloc.dart';
import 'package:todo_bloc/presentation/home/widget/todo_task_list.dart';
import 'package:uuid/uuid.dart';

import '../bloc/todo_state.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _addTodo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const TaskAddScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Todo Add'),
        actions: [
          IconButton(
              onPressed: () =>
                  BlocProvider.of<TodoBloc>(context).add(LogoutRequested()),
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Today\'s Tasks'),
                        // subtitle: Text('Today\'s Tasks'),
                        trailing: GestureDetector(
                          onTap: () {
                            _addTodo(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              '+ New task',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 500,
                          child: TodoTaskList(todos: state.todoList)),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({
    super.key,
  });

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: titleController,
            decoration: const InputDecoration(
                label: Text('Title'), border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autofocus: true,
            controller: descriptionController,
            decoration: const InputDecoration(
                label: Text('Description'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop,
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final todoId = Uuid().v4();
                    final TodoModel todo = TodoModel(
                        id: todoId,
                        title: titleController.text,
                        description: descriptionController.text,
                        dateTime: DateTime.now());

                    context.read<TodoBloc>().add(AddTodo(addTodo: todo));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'))
            ],
          )
        ],
      ),
    );
  }
}
