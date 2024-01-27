import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc/data/todo_model.dart';
import 'package:todo_bloc/presentation/home/bloc/todo_bloc.dart';

class TodoTaskList extends StatelessWidget {
  const TodoTaskList({
    super.key,
    required this.todos,
  });

  final List<TodoModel> todos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            leading: IconButton(
                              icon: const Icon(
                                size: 28,
                                Icons.delete_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                context
                                    .read<TodoBloc>()
                                    .add(DeleteTodo(deleteTodo: todos[index]));
                              },
                            ),
                            title: Text(
                              maxLines: 1,
                              todos[index].title,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            subtitle:
                                Text(maxLines: 1, todos[index].description),
                            trailing: Transform.scale(
                              scale: 1.6,
                              child: Checkbox(
                                shape: const CircleBorder(),
                                onChanged: (value) {
                                  context
                                      .read<TodoBloc>()
                                      .add(DoneTodo(doneTodo: todos[index]));
                                },
                                value: todos[index].completed,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Divider(
                              height: 1.8,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(DateFormat('MMM d, h:mm a')
                                  .format(todos[index].dateTime)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
