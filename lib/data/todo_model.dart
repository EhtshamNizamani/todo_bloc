// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final String title;
  final String id;
  final String description;
  final DateTime dateTime;
  final bool completed;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.completed = false,
  });

  TodoModel copyWith({
    String? title,
    String? id,
    String? description,
    DateTime? dateTime,
    bool? completed,
  }) {
    return TodoModel(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
        title,
        id,
        description,
        dateTime,
        completed,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'completed': completed,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      completed: map['completed'] as bool,
    );
  }
}
